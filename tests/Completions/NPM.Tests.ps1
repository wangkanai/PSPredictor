BeforeAll {
    Import-Module "$PSScriptRoot/../../src/PSPredictor.psd1" -Force
}

Describe "NPM Completion Tests" {
    Context "NPM Completion Registration" {
        It "Should register npm completion without errors" {
            { Register-PSPredictorCompletion -Tool "npm" } | Should -Not -Throw
        }
        
        It "Should provide npm command completions" {
            Register-PSPredictorCompletion -Tool "npm"
            $completions = TabExpansion2 "npm " 4
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
        
        It "Should handle npm completion with partial input" {
            Register-PSPredictorCompletion -Tool "npm"
            $completions = TabExpansion2 "npm inst" 8
            $completions.CompletionMatches.Count | Should -BeGreaterThan 0
        }
        
        It "Should provide npm script completions" {
            Register-PSPredictorCompletion -Tool "npm"
            $completions = TabExpansion2 "npm run " 8
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
    }
}