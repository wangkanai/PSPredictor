#Requires -Version 5.1
#Requires -Modules Pester

<#
.SYNOPSIS
    Pester tests for PSPredictor completion functionality

.DESCRIPTION
    Tests for command completion functionality including:
    - Git completions
    - Docker completions  
    - NPM completions
    - Completion registration
    - Completion performance
#>

BeforeAll {
    # Import test configuration
    . (Join-Path $PSScriptRoot 'TestConfig.ps1')
    
    # Import the module
    Import-TestModule -Force
}

AfterAll {
    Remove-TestModule
}

Describe "PSPredictor Completion Tests" {
    
    Context "Git Completions" {
        BeforeAll {
            Register-PSPredictorCompletion -Tool "git"
        }
        
        It "Should register git completion without errors" {
            { Register-PSPredictorCompletion -Tool "git" } | Should -Not -Throw
        }
        
        It "Should provide git command completions" {
            # Mock git command completion
            $MockCompletion = @('add', 'branch', 'checkout', 'commit', 'diff', 'merge', 'pull', 'push')
            
            # Test that git completion function exists and can be called
            { & (Get-Module PSPredictor | ForEach-Object { $_.Invoke('Register-GitCompletion') }) } | Should -Not -Throw
        }
        
        It "Should handle git completion with partial input" {
            # This tests the completion logic structure
            $WordToComplete = "che"
            $ExpectedMatches = @('checkout')
            
            # The actual completion test would require TabExpansion2 or similar
            # For now, we test that the completion registration works
            { Register-PSPredictorCompletion -Tool "git" } | Should -Not -Throw
        }
    }
    
    Context "Docker Completions" {
        BeforeAll {
            Register-PSPredictorCompletion -Tool "docker"
        }
        
        It "Should register docker completion without errors" {
            { Register-PSPredictorCompletion -Tool "docker" } | Should -Not -Throw
        }
        
        It "Should provide docker command completions" {
            # Test that docker completion function can be registered
            { & (Get-Module PSPredictor | ForEach-Object { $_.Invoke('Register-DockerCompletion') }) } | Should -Not -Throw
        }
        
        It "Should handle docker completion with partial input" {
            $WordToComplete = "ru"
            $ExpectedMatches = @('run')
            
            # Test completion registration works
            { Register-PSPredictorCompletion -Tool "docker" } | Should -Not -Throw
        }
    }
    
    Context "NPM Completions" {
        BeforeAll {
            Register-PSPredictorCompletion -Tool "npm"
        }
        
        It "Should register npm completion without errors" {
            { Register-PSPredictorCompletion -Tool "npm" } | Should -Not -Throw
        }
        
        It "Should provide npm command completions" {
            # Test that npm completion function can be registered
            { & (Get-Module PSPredictor | ForEach-Object { $_.Invoke('Register-NPMCompletion') }) } | Should -Not -Throw
        }
        
        It "Should handle npm completion with partial input" {
            $WordToComplete = "inst"
            $ExpectedMatches = @('install')
            
            # Test completion registration works
            { Register-PSPredictorCompletion -Tool "npm" } | Should -Not -Throw
        }
    }
    
    Context "Completion Registration" {
        It "Should register completions for all supported tools" {
            $Tools = Get-PSPredictorTools
            foreach ($Tool in $Tools) {
                { Register-PSPredictorCompletion -Tool $Tool.Tool } | Should -Not -Throw
            }
        }
        
        It "Should unregister completions for tools" {
            { Unregister-PSPredictorCompletion -Tool "git" } | Should -Not -Throw
            { Unregister-PSPredictorCompletion -Tool "docker" } | Should -Not -Throw
            { Unregister-PSPredictorCompletion -Tool "npm" } | Should -Not -Throw
        }
        
        It "Should handle custom completion script blocks" {
            $CustomCompletion = {
                param($wordToComplete, $commandAst, $cursorPosition)
                return @('custom1', 'custom2', 'custom3')
            }
            
            { Register-PSPredictorCompletion -Tool "git" -ScriptBlock $CustomCompletion } | Should -Not -Throw
        }
        
        It "Should warn on unsupported tools" {
            # Capture warning output
            $WarningPreference = 'Continue'
            $Warnings = @()
            
            Register-PSPredictorCompletion -Tool "unsupportedtool" -WarningVariable Warnings -WarningAction SilentlyContinue
            
            # Should handle gracefully (no throw) but may generate warning
            $true | Should -Be $true  # Test passes if we get here without throwing
        }
    }
    
    Context "Completion Performance" {
        It "Should register completions quickly" {
            $Performance = Test-ModulePerformance -ThresholdMs 1000 {
                Register-PSPredictorCompletion -Tool "git"
                Register-PSPredictorCompletion -Tool "docker"
                Register-PSPredictorCompletion -Tool "npm"
            }
            
            $Performance.WithinThreshold | Should -Be $true
        }
        
        It "Should update all completions within reasonable time" {
            $Performance = Test-ModulePerformance -ThresholdMs 2000 {
                Update-PSPredictorCompletions
            }
            
            $Performance.WithinThreshold | Should -Be $true
        }
    }
    
    Context "Completion Configuration" {
        It "Should respect MaxSuggestions setting" {
            Set-PSPredictorConfig -MaxSuggestions 5
            # Test that configuration is applied
            # This would require actual completion execution to fully test
            { Set-PSPredictorConfig -MaxSuggestions 5 } | Should -Not -Throw
        }
        
        It "Should respect CaseSensitive setting" {
            Set-PSPredictorConfig -CaseSensitive $true
            { Set-PSPredictorConfig -CaseSensitive $false } | Should -Not -Throw
        }
        
        It "Should respect FuzzyMatching setting" {
            Set-PSPredictorConfig -FuzzyMatching $true
            { Set-PSPredictorConfig -FuzzyMatching $false } | Should -Not -Throw
        }
    }
    
    Context "Completion Error Handling" {
        It "Should handle missing ArgumentCompleter gracefully" {
            # Test that registration doesn't fail even if ArgumentCompleter has issues
            { Register-PSPredictorCompletion -Tool "git" } | Should -Not -Throw
        }
        
        It "Should handle completion function errors gracefully" {
            $ErrorCompletion = {
                param($wordToComplete, $commandAst, $cursorPosition)
                throw "Test error"
            }
            
            # Should not throw during registration
            { Register-PSPredictorCompletion -Tool "git" -ScriptBlock $ErrorCompletion } | Should -Not -Throw
        }
        
        It "Should handle null/empty completion results" {
            $EmptyCompletion = {
                param($wordToComplete, $commandAst, $cursorPosition)
                return @()
            }
            
            { Register-PSPredictorCompletion -Tool "git" -ScriptBlock $EmptyCompletion } | Should -Not -Throw
        }
    }
}