BeforeAll {
    Import-Module "$PSScriptRoot/../../src/PSPredictor.psd1" -Force
}

Describe "Docker Completion Tests" {
    Context "Docker Completion Registration" {
        It "Should register docker completion without errors" {
            { Register-PSPredictorCompletion -Tool "docker" } | Should -Not -Throw
        }
        
        It "Should provide docker command completions" {
            Register-PSPredictorCompletion -Tool "docker"
            $completions = TabExpansion2 "docker " 7
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
        
        It "Should handle docker completion with partial input" {
            Register-PSPredictorCompletion -Tool "docker"
            $completions = TabExpansion2 "docker ru" 9
            $completions.CompletionMatches.Count | Should -BeGreaterThan 0
        }
    }
}