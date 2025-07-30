BeforeAll {
    Import-Module "$PSScriptRoot/../../src/PSPredictor.psd1" -Force
}

Describe "Package Managers Completion Tests" {
    Context "Yarn Completion Registration" {
        It "Should register yarn completion without errors" {
            { Register-PSPredictorCompletion -Tool "yarn" } | Should -Not -Throw
        }
        
        It "Should provide yarn command completions" {
            Register-PSPredictorCompletion -Tool "yarn"
            $completions = TabExpansion2 "yarn " 5
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
    }
    
    Context "PNPM Completion Registration" {
        It "Should register pnpm completion without errors" {
            { Register-PSPredictorCompletion -Tool "pnpm" } | Should -Not -Throw
        }
        
        It "Should provide pnpm command completions" {
            Register-PSPredictorCompletion -Tool "pnpm"
            $completions = TabExpansion2 "pnpm " 5
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
    }
    
    Context "Homebrew Completion Registration" {
        It "Should register brew completion without errors" {
            { Register-PSPredictorCompletion -Tool "brew" } | Should -Not -Throw
        }
        
        It "Should provide brew command completions" {
            Register-PSPredictorCompletion -Tool "brew"
            $completions = TabExpansion2 "brew " 5
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
        
        It "Should handle brew completion with partial input" {
            Register-PSPredictorCompletion -Tool "brew"
            $completions = TabExpansion2 "brew install " 13
            $completions.CompletionMatches.Count | Should -BeGreaterThan 0
        }
    }
}