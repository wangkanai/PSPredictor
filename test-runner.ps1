#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Simple test runner for PSPredictor module

.DESCRIPTION
    Runs basic functionality tests to verify the module works correctly
#>

[CmdletBinding()]
param()

Write-Host "🧪 PSPredictor Simple Test Runner" -ForegroundColor Magenta
Write-Host ""

$FailedTests = 0
$PassedTests = 0

function Test-Condition {
    param(
        [string]$Description,
        [scriptblock]$Test,
        [switch]$ShouldThrow
    )
    
    Write-Host "🔍 $Description..." -NoNewline
    
    try {
        $Result = & $Test
        if ($ShouldThrow) {
            Write-Host " ❌ FAIL (Expected exception)" -ForegroundColor Red
            $script:FailedTests++
        } else {
            Write-Host " ✅ PASS" -ForegroundColor Green
            $script:PassedTests++
        }
    } catch {
        if ($ShouldThrow) {
            Write-Host " ✅ PASS (Expected exception)" -ForegroundColor Green
            $script:PassedTests++
        } else {
            Write-Host " ❌ FAIL: $_" -ForegroundColor Red
            $script:FailedTests++
        }
    }
}

# Test module manifest (basic file check since Test-ModuleManifest has issues with profiles)
Test-Condition "Testing module manifest exists" {
    if (-not (Test-Path './src/PSPredictor.psd1')) { throw "Manifest file not found" }
    if (-not (Test-Path './src/PSPredictor.psm1')) { throw "Module file not found" }
}

# Test module import
Test-Condition "Testing module import" {
    Import-Module './src/PSPredictor.psm1' -Force
    $Module = Get-Module PSPredictor
    if (-not $Module) { throw "Module import failed" }
}

# Test basic functions
Test-Condition "Testing Get-PSPredictorTools" {
    $Tools = Get-PSPredictorTools
    if ($Tools.Count -eq 0) { throw "No tools found" }
}

Test-Condition "Testing configuration" {
    Set-PSPredictorConfig -MaxSuggestions 10
}

Test-Condition "Testing tool registration" {
    Register-PSPredictorCompletion -Tool "git"
}

Test-Condition "Testing empty tool parameter (should throw)" {
    Register-PSPredictorCompletion -Tool ""
} -ShouldThrow

Test-Condition "Testing tool enabling" {
    Enable-PSPredictorTool -Tool "git"
}

Test-Condition "Testing tool disabling" {
    Disable-PSPredictorTool -Tool "git"
}

# Clean up
Remove-Module PSPredictor -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "📊 Test Results:" -ForegroundColor Cyan
Write-Host "✅ Passed: $PassedTests" -ForegroundColor Green
Write-Host "❌ Failed: $FailedTests" -ForegroundColor Red

if ($FailedTests -gt 0) {
    Write-Host ""
    Write-Host "❌ Some tests failed!" -ForegroundColor Red
    exit 1
} else {
    Write-Host ""
    Write-Host "🎉 All tests passed!" -ForegroundColor Green
}