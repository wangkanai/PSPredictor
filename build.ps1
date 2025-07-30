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
    [ValidateSet('Build', 'Test', 'Package', 'Clean', 'Install', 'Publish', 'All')]
    [string]$Task = 'Build',
    
    [ValidateSet('Debug', 'Release')]
    [string]$Configuration = 'Release',
    
    [string]$OutputPath = './build',
    
    [switch]$Force,
    
    [string]$ApiKey,
    
    [string]$Repository = 'PSGallery'
)

# Script variables
$ModuleName = 'PSPredictor'
$ModuleVersion = '1.1.0'
$RootPath = $PSScriptRoot
$SourcePath = Join-Path $RootPath 'src'
$TestsPath = Join-Path $RootPath 'tests'
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
        
        # Copy module files from src directory
        $FilesToCopy = @(
            @{ Source = 'PSPredictor.psd1'; Destination = 'PSPredictor.psd1'; FromSrc = $true },
            @{ Source = 'PSPredictor.psm1'; Destination = 'PSPredictor.psm1'; FromSrc = $true },
            @{ Source = 'LICENSE'; Destination = 'LICENSE'; FromSrc = $false },
            @{ Source = 'README.md'; Destination = 'README.md'; FromSrc = $false }
        )
        
        # Modular directories are now part of the main PSPredictor module
        
        foreach ($file in $FilesToCopy) {
            $sourcePath = if ($file.FromSrc) { 
                Join-Path $SourcePath $file.Source 
            } else { 
                Join-Path $RootPath $file.Source 
            }
            $destPath = Join-Path $ModulePath $file.Destination
            
            if (Test-Path $sourcePath) {
                Copy-Item $sourcePath $destPath -Force
                Write-Verbose "Copied: $($file.Source) -> $($file.Destination)"
            } else {
                Write-Warning "File not found: $($file.Source) at $sourcePath"
            }
        }
        
        # Copy modular directories if they exist
        $ModularDirs = @('Public', 'Private', 'Completions')
        foreach ($dir in $ModularDirs) {
            $sourceDirPath = Join-Path $SourcePath $dir
            if (Test-Path $sourceDirPath) {
                $destDirPath = Join-Path $ModulePath $dir
                Write-Verbose "Copying modular directory: $dir"
                Copy-Item $sourceDirPath $destDirPath -Recurse -Force
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
        
        # Check if Pester is available
        try {
            $PesterModule = Get-Module Pester -ListAvailable | Sort-Object Version -Descending | Select-Object -First 1
            if (-not $PesterModule) {
                Write-Host "📦 Installing Pester..." -ForegroundColor Yellow
                Install-Module -Name Pester -Force -Scope CurrentUser -SkipPublisherCheck -WarningAction SilentlyContinue
            }
            Import-Module Pester -Force -WarningAction SilentlyContinue
        } catch {
            Write-Warning "Pester not available, falling back to basic tests"
        }
        
        # Run Pester tests if available
        if (Get-Module Pester -ErrorAction SilentlyContinue) {
            Write-Host "🧪 Running Pester tests..." -ForegroundColor Cyan
            
            $PesterConfig = @{
                Path = $TestsPath
                Output = 'Normal'
                PassThru = $true
                WarningAction = 'SilentlyContinue'
            }
            
            $TestResults = Invoke-Pester @PesterConfig
            
            if ($TestResults.FailedCount -gt 0) {
                Write-Error "❌ $($TestResults.FailedCount) test(s) failed"
                exit 1
            }
            
            Write-Host "✅ All $($TestResults.PassedCount) Pester tests passed" -ForegroundColor Green
        } else {
            # Fallback to basic tests
            Write-Host "🔧 Running basic module tests..." -ForegroundColor Yellow
            
            try {
                # Test source module directly
                $manifestPath = Join-Path $SourcePath 'PSPredictor.psd1'
                $modulePath = Join-Path $SourcePath 'PSPredictor.psm1'
                
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
                Import-Module $manifestPath -Force -Verbose:$false -WarningAction SilentlyContinue
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
        
        # Ensure we have a built module
        if (-not (Test-Path $ModulePath)) {
            Write-Host "🔨 Building module first..." -ForegroundColor Yellow
            & $Tasks.Build
        }
        
        # Install to user module directory (cross-platform)
        if ($IsWindows -or $env:OS -eq 'Windows_NT') {
            $userModulePath = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'PowerShell\Modules\PSPredictor'
        } else {
            $userModulePath = Join-Path $env:HOME '.local/share/powershell/Modules/PSPredictor'
        }
        
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
        try {
            Import-Module PSPredictor -Force
            $version = (Get-Module PSPredictor).Version
            Remove-Module PSPredictor -Force
        } catch {
            Write-Warning "Could not import installed module for testing: $_"
            $version = "unknown"
        }
        
        Write-Host "✅ PSPredictor $version installed successfully" -ForegroundColor Green
        Write-Host "💡 Run 'Import-Module PSPredictor' to use the module" -ForegroundColor Yellow
    }
    
    Publish = {
        Write-Host "📤 Publishing PSPredictor to PowerShell Gallery..." -ForegroundColor Cyan
        
        # Ensure we have a built module
        if (-not (Test-Path $ModulePath)) {
            Write-Host "🔨 Building module first..." -ForegroundColor Yellow
            & $Tasks.Build
        }
        
        # Check for API key
        $publishApiKey = $ApiKey
        if (-not $publishApiKey) {
            $publishApiKey = $env:PSGALLERY_API_KEY
        }
        
        if (-not $publishApiKey) {
            Write-Error "❌ PowerShell Gallery API key is required. Provide via -ApiKey parameter or PSGALLERY_API_KEY environment variable."
            Write-Host "💡 Get your API key from: https://www.powershellgallery.com/account/apikeys" -ForegroundColor Yellow
            return
        }
        
        try {
            # Validate the module before publishing
            Write-Host "🔍 Validating module..." -ForegroundColor Yellow
            $manifestPath = Join-Path $ModulePath 'PSPredictor.psd1'
            $manifest = Test-ModuleManifest $manifestPath -Verbose:$false
            
            Write-Host "📋 Module Details:" -ForegroundColor Cyan
            Write-Host "  Name: $($manifest.Name)" -ForegroundColor Gray
            Write-Host "  Version: $($manifest.Version)" -ForegroundColor Gray
            Write-Host "  Author: $($manifest.Author)" -ForegroundColor Gray
            Write-Host "  Description: $($manifest.Description)" -ForegroundColor Gray
            
            # Check if this version already exists
            try {
                $existingModule = Find-Module -Name $ModuleName -RequiredVersion $manifest.Version -Repository $Repository -ErrorAction SilentlyContinue
                if ($existingModule) {
                    if (-not $Force) {
                        Write-Error "❌ Version $($manifest.Version) already exists in $Repository. Use -Force to overwrite or update the version."
                        return
                    }
                    Write-Warning "⚠️ Version $($manifest.Version) already exists. Force publishing..."
                }
            } catch {
                # Module doesn't exist yet, which is fine for first publish
            }
            
            # Publish the module
            Write-Host "🚀 Publishing to $Repository..." -ForegroundColor Green
            Publish-Module -Path $ModulePath -NuGetApiKey $publishApiKey -Repository $Repository -Force:$Force -Verbose
            
            Write-Host "✅ PSPredictor $($manifest.Version) published successfully!" -ForegroundColor Green
            Write-Host "🔗 View at: https://www.powershellgallery.com/packages/$ModuleName/$($manifest.Version)" -ForegroundColor Yellow
            Write-Host "💡 Users can now install with: Install-Module -Name $ModuleName" -ForegroundColor Yellow
            
        } catch {
            Write-Error "❌ Publishing failed: $_"
            Write-Host "💡 Common issues:" -ForegroundColor Yellow
            Write-Host "  - Invalid API key" -ForegroundColor Gray
            Write-Host "  - Version already exists (use -Force or increment version)" -ForegroundColor Gray
            Write-Host "  - Module validation errors" -ForegroundColor Gray
            Write-Host "  - Network connectivity issues" -ForegroundColor Gray
        }
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