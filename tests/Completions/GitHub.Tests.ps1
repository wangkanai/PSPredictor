BeforeAll {
    Import-Module "$PSScriptRoot/../../src/PSPredictor.psd1" -Force
}

Describe "GitHub CLI Completion Tests" {
    Context "GitHub CLI Completion Registration" {
        It "Should register gh completion without errors" {
            { Register-PSPredictorCompletion -Tool "gh" } | Should -Not -Throw
        }
        
        It "Should provide gh command completions" {
            Register-PSPredictorCompletion -Tool "gh"
            $completions = TabExpansion2 "gh " 3
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
        
        It "Should handle gh completion with partial input" {
            Register-PSPredictorCompletion -Tool "gh"
            $completions = TabExpansion2 "gh repo " 8
            $completions.CompletionMatches.Count | Should -BeGreaterThan 0
        }
        
        It "Should provide gh workflow completions" {
            Register-PSPredictorCompletion -Tool "gh"
            $completions = TabExpansion2 "gh pr " 6
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
    }
}