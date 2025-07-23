#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Build script for PSPredictor module

.DESCRIPTION
    This script helps build, test, and package the PSPredictor module for distribution.

.PARAMETER Task
    The task to execute: Build, Test, Package, Clean, Install, or All

.PARAMETER Configuration
    Build configuration: Debug or Release (default: Release)

.PARAMETER OutputPath
    Output directory for build artifacts (default: ./build)

.EXAMPLE
    ./build.ps1 -Task Build
    ./build.ps1 -Task All -Configuration Debug
    ./build.ps1 -Task Package -OutputPath ./dist
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [ValidateSet('Build', 'Test', 'Package', 'Clean', 'Install', 'All')]
    [string]$Task = 'Build',
    
    [ValidateSet('Debug', 'Release')]
    [string]$Configuration = 'Release',
    
    [string]$OutputPath = './build',
    
    [switch]$Force
)

# Script variables
$ModuleName = 'PSPredictor'
$ModuleVersion = '1.0.0'
$RootPath = $PSScriptRoot
$SourcePath = $RootPath
$BuildPath = Join-Path $RootPath $OutputPath
$PackagePath = Join-Path $BuildPath 'package'
$ModulePath = Join-Path $PackagePath $ModuleName

# Build tasks
$Tasks = @{
    Clean = {
        Write-Host "🧹 Cleaning build directory..." -ForegroundColor Yellow
        
        if (Test-Path $BuildPath) {
            Remove-Item $BuildPath -Recurse -Force
        }
        
        Write-Host "✅ Clean completed" -ForegroundColor Green
    }
    
    Build = {
        Write-Host "🔨 Building PSPredictor module..." -ForegroundColor Cyan
        
        # Create build directory structure
        New-Item -Path $ModulePath -ItemType Directory -Force | Out-Null
        
        # Copy module files
        $FilesToCopy = @(
            'PSPredictor.psd1',
            'PSPredictor.psm1',
            'LICENSE',
            'README.md'
        )
        
        foreach ($file in $FilesToCopy) {
            $sourcePath = Join-Path $SourcePath $file
            $destPath = Join-Path $ModulePath $file
            
            if (Test-Path $sourcePath) {
                Copy-Item $sourcePath $destPath -Force
                Write-Verbose "Copied: $file"
            } else {
                Write-Warning "File not found: $file"
            }
        }
        
        # Update module version if Debug configuration
        if ($Configuration -eq 'Debug') {
            $manifestPath = Join-Path $ModulePath 'PSPredictor.psd1'
            $content = Get-Content $manifestPath -Raw
            $debugVersion = "$ModuleVersion-debug"
            $content = $content -replace "ModuleVersion = '$ModuleVersion'", "ModuleVersion = '$debugVersion'"
            $content | Set-Content $manifestPath -Encoding UTF8
        }
        
        Write-Host "✅ Build completed: $ModulePath" -ForegroundColor Green
    }
    
    Test = {
        Write-Host "🧪 Running tests..." -ForegroundColor Cyan
        
        # Basic module validation
        try {
            $manifestPath = Join-Path $ModulePath 'PSPredictor.psd1'
            $modulePath = Join-Path $ModulePath 'PSPredictor.psm1'
            
            if (-not (Test-Path $manifestPath)) {
                throw "Module manifest not found: $manifestPath"
            }
            
            if (-not (Test-Path $modulePath)) {
                throw "Module file not found: $modulePath"
            }
            
            # Test module manifest
            $manifest = Test-ModuleManifest $manifestPath -Verbose:$false
            Write-Host "✅ Module manifest is valid" -ForegroundColor Green
            
            # Test module import
            Import-Module $manifestPath -Force -Verbose:$false
            Write-Host "✅ Module imports successfully" -ForegroundColor Green
            
            # Test exported functions
            $exportedFunctions = Get-Command -Module PSPredictor
            Write-Host "✅ Exported $($exportedFunctions.Count) functions" -ForegroundColor Green
            
            # Basic functionality test
            $tools = Get-PSPredictorTools
            Write-Host "✅ Found $($tools.Count) supported tools" -ForegroundColor Green
            
        } catch {
            Write-Error "❌ Test failed: $_"
            exit 1
        } finally {
            # Clean up
            Remove-Module PSPredictor -Force -ErrorAction SilentlyContinue
        }
        
        Write-Host "✅ All tests passed" -ForegroundColor Green
    }
    
    Package = {
        Write-Host "📦 Creating package..." -ForegroundColor Cyan
        
        $packageFile = Join-Path $BuildPath "$ModuleName-$ModuleVersion.zip"
        
        # Create ZIP package
        if (Test-Path $packageFile) {
            Remove-Item $packageFile -Force
        }
        
        Compress-Archive -Path "$ModulePath/*" -DestinationPath $packageFile -Force
        
        # Create NuGet package structure for PowerShell Gallery
        $nugetPath = Join-Path $BuildPath 'nuget'
        New-Item -Path $nugetPath -ItemType Directory -Force | Out-Null
        Copy-Item "$ModulePath/*" $nugetPath -Recurse -Force
        
        Write-Host "✅ Package created: $packageFile" -ForegroundColor Green
        Write-Host "✅ NuGet structure: $nugetPath" -ForegroundColor Green
    }
    
    Install = {
        Write-Host "🚀 Installing PSPredictor module..." -ForegroundColor Cyan
        
        # Install to user module directory
        $userModulePath = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'PowerShell\Modules\PSPredictor'
        
        if (Test-Path $userModulePath) {
            if ($Force) {
                Remove-Item $userModulePath -Recurse -Force
            } else {
                $choice = Read-Host "Module already installed. Overwrite? (y/N)"
                if ($choice -ne 'y' -and $choice -ne 'Y') {
                    Write-Host "❌ Installation cancelled" -ForegroundColor Yellow
                    return
                }
                Remove-Item $userModulePath -Recurse -Force
            }
        }
        
        # Create directory and copy files
        New-Item -Path $userModulePath -ItemType Directory -Force | Out-Null
        Copy-Item "$ModulePath/*" $userModulePath -Recurse -Force
        
        # Test installation
        Import-Module PSPredictor -Force
        $version = (Get-Module PSPredictor).Version
        Remove-Module PSPredictor -Force
        
        Write-Host "✅ PSPredictor $version installed successfully" -ForegroundColor Green
        Write-Host "💡 Run 'Import-Module PSPredictor' to use the module" -ForegroundColor Yellow
    }
    
    All = {
        & $Tasks.Clean
        & $Tasks.Build
        & $Tasks.Test
        & $Tasks.Package
        Write-Host "🎉 All tasks completed successfully!" -ForegroundColor Magenta
    }
}

# Main execution
try {
    Write-Host "🚀 PSPredictor Build Script" -ForegroundColor Magenta
    Write-Host "Task: $Task | Configuration: $Configuration | Output: $OutputPath" -ForegroundColor Gray
    Write-Host ""
    
    if ($Tasks.ContainsKey($Task)) {
        & $Tasks[$Task]
    } else {
        Write-Error "Unknown task: $Task"
        exit 1
    }
    
} catch {
    Write-Error "❌ Build failed: $_"
    exit 1
}