BeforeAll {
    Import-Module "$PSScriptRoot/../../src/PSPredictor.psd1" -Force
}

Describe "Git Completion Tests" {
    Context "Git Completion Registration" {
        It "Should register git completion without errors" {
            { Register-PSPredictorCompletion -Tool "git" } | Should -Not -Throw
        }
        
        It "Should provide git command completions" {
            Register-PSPredictorCompletion -Tool "git"
            $completions = TabExpansion2 "git " 4
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
        
        It "Should handle git completion with partial input" {
            Register-PSPredictorCompletion -Tool "git"
            $completions = TabExpansion2 "git che" 7
            $completions.CompletionMatches.Count | Should -BeGreaterThan 0
        }
    }
}