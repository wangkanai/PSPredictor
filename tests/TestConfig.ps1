#Requires -Version 5.1

<#
.SYNOPSIS
    Test configuration and setup for PSPredictor tests

.DESCRIPTION
    Common test configuration, helper functions, and setup for PSPredictor testing
#>

# Test configuration
$script:TestConfig = @{
    ModuleRoot = Split-Path -Parent $PSScriptRoot
    SourcePath = Join-Path (Split-Path -Parent $PSScriptRoot) 'src'
    TestTimeout = 30 # seconds
    PerformanceThreshold = @{
        ModuleLoad = 2000  # milliseconds
        FunctionExecution = 500  # milliseconds
    }
}

# Helper functions for testing
function Get-TestModulePath {
    return Join-Path $script:TestConfig.SourcePath 'PSPredictor.psd1'
}

function Import-TestModule {
    param([switch]$Force)
    
    $ModulePath = Get-TestModulePath
    if ($Force) {
        Remove-Module PSPredictor -Force -ErrorAction SilentlyContinue
    }
    Import-Module $ModulePath -Force
}

function Remove-TestModule {
    Remove-Module PSPredictor -Force -ErrorAction SilentlyContinue
}

function Test-FunctionExists {
    param([string]$FunctionName)
    
    return (Get-Command $FunctionName -ErrorAction SilentlyContinue) -ne $null
}

function Test-ModulePerformance {
    param(
        [scriptblock]$ScriptBlock,
        [int]$ThresholdMs = 1000
    )
    
    $Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    & $ScriptBlock
    $Stopwatch.Stop()
    
    return @{
        ElapsedMs = $Stopwatch.ElapsedMilliseconds
        WithinThreshold = $Stopwatch.ElapsedMilliseconds -le $ThresholdMs
    }
}

# Mock CLI tools for testing (when actual tools aren't available)
function Mock-CLITools {
    # Create mock executables in a temporary path for testing
    $TempPath = Join-Path ([System.IO.Path]::GetTempPath()) 'PSPredictorTest'
    if (-not (Test-Path $TempPath)) {
        New-Item -Path $TempPath -ItemType Directory -Force | Out-Null
    }
    
    $MockTools = @('git', 'docker', 'npm', 'kubectl', 'az', 'aws', 'dotnet')
    foreach ($Tool in $MockTools) {
        $MockScript = @"
#!/bin/bash
echo "Mock $Tool tool for testing"
exit 0
"@
        $MockPath = Join-Path $TempPath "$Tool.sh"
        $MockScript | Set-Content -Path $MockPath -Encoding UTF8
        
        if ($IsLinux -or $IsMacOS) {
            chmod +x $MockPath
        }
    }
    
    return $TempPath
}

function Remove-MockCLITools {
    param([string]$MockPath)
    
    if (Test-Path $MockPath) {
        Remove-Item $MockPath -Recurse -Force
    }
}

# Export functions for use in tests
Export-ModuleMember -Function @(
    'Get-TestModulePath',
    'Import-TestModule', 
    'Remove-TestModule',
    'Test-FunctionExists',
    'Test-ModulePerformance',
    'Mock-CLITools',
    'Remove-MockCLITools'
) -Variable 'TestConfig'