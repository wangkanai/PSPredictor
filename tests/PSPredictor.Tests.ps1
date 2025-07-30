#Requires -Version 5.1
#Requires -Modules Pester

<#
.SYNOPSIS
    Pester tests for PSPredictor module

.DESCRIPTION
    Comprehensive tests for PSPredictor PowerShell module including:
    - Module manifest validation
    - Module import/export testing
    - Function testing
    - Configuration testing
    - Tool registration testing
#>

BeforeAll {
    # Import the module for testing
    $ModuleRoot = Split-Path -Parent $PSScriptRoot
    $ModulePath = Join-Path $ModuleRoot 'src'
    $ManifestPath = Join-Path $ModulePath 'PSPredictor.psd1'
    $ModuleFile = Join-Path $ModulePath 'PSPredictor.psm1'
    
    # Remove any existing module to ensure clean testing
    Remove-Module PSPredictor -Force -ErrorAction SilentlyContinue
    
    # Import the module
    Import-Module $ManifestPath -Force
}

AfterAll {
    # Clean up
    Remove-Module PSPredictor -Force -ErrorAction SilentlyContinue
}

Describe "PSPredictor Module Tests" {
    
    Context "Module Manifest" {
        BeforeAll {
            $ModuleRoot = Split-Path -Parent $PSScriptRoot
            $ManifestPath = Join-Path $ModuleRoot 'src/PSPredictor.psd1'
            $Manifest = Test-ModuleManifest -Path $ManifestPath
        }
        
        It "Should have a valid module manifest" {
            $ManifestPath | Should -Exist
            { Test-ModuleManifest -Path $ManifestPath } | Should -Not -Throw
        }
        
        It "Should have correct module properties" {
            $Manifest.Name | Should -Be 'PSPredictor'
            $Manifest.Author | Should -Be 'Sarin Na Wangkanai'
            $Manifest.CompanyName | Should -Be 'wangkanai'
            $Manifest.PowerShellVersion | Should -Be '5.1'
        }
        
        It "Should have required dependencies" {
            $Manifest.RequiredModules | Should -Contain 'PSReadLine'
        }
        
        It "Should export expected functions" {
            $ExpectedFunctions = @(
                'Install-PSPredictor',
                'Uninstall-PSPredictor',
                'Get-PSPredictorCompletion',
                'Set-PSPredictorConfig',
                'Register-PSPredictorCompletion',
                'Unregister-PSPredictorCompletion',
                'Update-PSPredictorCompletions',
                'Enable-PSPredictorTool',
                'Disable-PSPredictorTool',
                'Get-PSPredictorTools'
            )
            
            foreach ($Function in $ExpectedFunctions) {
                $Manifest.ExportedFunctions.Keys | Should -Contain $Function
            }
        }
        
        It "Should export expected aliases" {
            $ExpectedAliases = @('pspredict', 'psp')
            foreach ($Alias in $ExpectedAliases) {
                $Manifest.ExportedAliases.Keys | Should -Contain $Alias
            }
        }
    }
    
    Context "Module Import/Export" {
        It "Should import without errors" {
            { Import-Module PSPredictor -Force } | Should -Not -Throw
        }
        
        It "Should export all expected commands" {
            $ExportedCommands = Get-Command -Module PSPredictor
            $ExportedCommands.Count | Should -BeGreaterThan 0
        }
        
        It "Should have all functions available after import" {
            $Functions = @(
                'Install-PSPredictor',
                'Get-PSPredictorTools',
                'Set-PSPredictorConfig',
                'Register-PSPredictorCompletion'
            )
            
            foreach ($Function in $Functions) {
                Get-Command $Function -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
            }
        }
    }
    
    Context "Core Functionality" {
        BeforeEach {
            # Reset module state for each test
            Remove-Module PSPredictor -Force -ErrorAction SilentlyContinue
            Import-Module (Join-Path (Split-Path -Parent $PSScriptRoot) 'src/PSPredictor.psd1') -Force
        }
        
        It "Should get supported tools list" {
            $Tools = Get-PSPredictorTools
            $Tools | Should -Not -BeNullOrEmpty
            $Tools.Count | Should -BeGreaterThan 0
        }
        
        It "Should have expected CLI tools in supported list" {
            $Tools = Get-PSPredictorTools
            $ToolNames = $Tools.Tool
            
            $ExpectedTools = @('git', 'docker', 'npm', 'yarn', 'kubectl', 'az', 'aws', 'dotnet')
            foreach ($Tool in $ExpectedTools) {
                $ToolNames | Should -Contain $Tool
            }
        }
        
        It "Should indicate tool availability correctly" {
            $Tools = Get-PSPredictorTools
            foreach ($Tool in $Tools) {
                $Tool.Available | Should -BeOfType [bool]
            }
        }
        
        It "Should have proper tool properties" {
            $Tools = Get-PSPredictorTools
            foreach ($Tool in $Tools) {
                $Tool.Tool | Should -Not -BeNullOrEmpty
                $Tool.Description | Should -Not -BeNullOrEmpty
                $Tool.Enabled | Should -BeOfType [bool]
                $Tool.Available | Should -BeOfType [bool]
            }
        }
    }
    
    Context "Configuration Management" {
        BeforeEach {
            Remove-Module PSPredictor -Force -ErrorAction SilentlyContinue
            Import-Module (Join-Path (Split-Path -Parent $PSScriptRoot) 'src/PSPredictor.psd1') -Force
        }
        
        It "Should set MaxSuggestions configuration" {
            { Set-PSPredictorConfig -MaxSuggestions 20 } | Should -Not -Throw
        }
        
        It "Should set CaseSensitive configuration" {
            { Set-PSPredictorConfig -CaseSensitive $true } | Should -Not -Throw
            { Set-PSPredictorConfig -CaseSensitive $false } | Should -Not -Throw
        }
        
        It "Should set FuzzyMatching configuration" {
            { Set-PSPredictorConfig -FuzzyMatching $true } | Should -Not -Throw
            { Set-PSPredictorConfig -FuzzyMatching $false } | Should -Not -Throw
        }
        
        It "Should enable/disable specific tools" {
            { Set-PSPredictorConfig -Tool "git" -Enabled $true } | Should -Not -Throw
            { Set-PSPredictorConfig -Tool "git" -Enabled $false } | Should -Not -Throw
        }
        
        It "Should handle invalid tool names gracefully" {
            { Set-PSPredictorConfig -Tool "invalidtool" -Enabled $true } | Should -Not -Throw
        }
    }
    
    Context "Tool Management" {
        BeforeEach {
            Remove-Module PSPredictor -Force -ErrorAction SilentlyContinue
            Import-Module (Join-Path (Split-Path -Parent $PSScriptRoot) 'src/PSPredictor.psd1') -Force
        }
        
        It "Should enable tools without errors" {
            { Enable-PSPredictorTool -Tool "git" } | Should -Not -Throw
        }
        
        It "Should disable tools without errors" {
            { Disable-PSPredictorTool -Tool "git" } | Should -Not -Throw
        }
        
        It "Should register completions for supported tools" {
            { Register-PSPredictorCompletion -Tool "git" } | Should -Not -Throw
        }
        
        It "Should unregister completions for tools" {
            { Unregister-PSPredictorCompletion -Tool "git" } | Should -Not -Throw
        }
        
        It "Should handle unsupported tools gracefully" {
            { Register-PSPredictorCompletion -Tool "unsupportedtool" } | Should -Not -Throw
        }
        
        It "Should update completions without errors" {
            { Update-PSPredictorCompletions } | Should -Not -Throw
        }
    }
    
    Context "Installation and Setup" {
        BeforeEach {
            Remove-Module PSPredictor -Force -ErrorAction SilentlyContinue
            Import-Module (Join-Path (Split-Path -Parent $PSScriptRoot) 'src/PSPredictor.psd1') -Force
        }
        
        It "Should install PSPredictor without errors" {
            { Install-PSPredictor } | Should -Not -Throw
        }
        
        It "Should uninstall PSPredictor without errors" {
            { Uninstall-PSPredictor } | Should -Not -Throw
        }
    }
    
    Context "Completion Functions" {
        BeforeEach {
            Remove-Module PSPredictor -Force -ErrorAction SilentlyContinue
            Import-Module (Join-Path (Split-Path -Parent $PSScriptRoot) 'src/PSPredictor.psd1') -Force
        }
        
        It "Should have completion functions for major tools" {
            $CompletionFunctions = @(
                'Register-GitCompletion',
                'Register-DockerCompletion',
                'Register-NPMCompletion'
            )
            
            foreach ($Function in $CompletionFunctions) {
                # These are internal functions, so we test indirectly
                { Register-PSPredictorCompletion -Tool ($Function -replace 'Register-' -replace 'Completion').ToLower() } | Should -Not -Throw
            }
        }
    }
    
    Context "Error Handling" {
        BeforeEach {
            Remove-Module PSPredictor -Force -ErrorAction SilentlyContinue
            Import-Module (Join-Path (Split-Path -Parent $PSScriptRoot) 'src/PSPredictor.psd1') -Force
        }
        
        It "Should handle missing parameters gracefully" {
            { Register-PSPredictorCompletion } | Should -Throw
        }
        
        It "Should handle invalid tool names" {
            { Register-PSPredictorCompletion -Tool "" } | Should -Not -Throw
        }
        
        It "Should handle null/empty configurations" {
            { Set-PSPredictorConfig -Tool "" -Enabled $true } | Should -Not -Throw
        }
    }
    
    Context "Performance and Resource Usage" {
        BeforeEach {
            Remove-Module PSPredictor -Force -ErrorAction SilentlyContinue
            Import-Module (Join-Path (Split-Path -Parent $PSScriptRoot) 'src/PSPredictor.psd1') -Force
        }
        
        It "Should load module quickly" {
            $Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
            Remove-Module PSPredictor -Force -ErrorAction SilentlyContinue
            Import-Module (Join-Path (Split-Path -Parent $PSScriptRoot) 'src/PSPredictor.psd1') -Force
            $Stopwatch.Stop()
            
            # Module should load in less than 2 seconds
            $Stopwatch.ElapsedMilliseconds | Should -BeLessThan 2000
        }
        
        It "Should get tools list quickly" {
            $Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
            $Tools = Get-PSPredictorTools
            $Stopwatch.Stop()
            
            # Should complete in less than 500ms
            $Stopwatch.ElapsedMilliseconds | Should -BeLessThan 500
        }
    }
    
    Context "Aliases" {
        It "Should have 'pspredict' alias for Install-PSPredictor" {
            Get-Alias pspredict -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
            (Get-Alias pspredict).ResolvedCommand.Name | Should -Be 'Install-PSPredictor'
        }
        
        It "Should have 'psp' alias for Get-PSPredictorTools" {
            Get-Alias psp -ErrorAction SilentlyContinue | Should -Not -BeNullOrEmpty
            (Get-Alias psp).ResolvedCommand.Name | Should -Be 'Get-PSPredictorTools'
        }
    }
}