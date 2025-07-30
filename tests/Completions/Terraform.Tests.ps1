BeforeAll {
    Import-Module "$PSScriptRoot/../../src/PSPredictor.psd1" -Force
}

Describe "Terraform Completion Tests" {
    Context "Terraform Completion Registration" {
        It "Should register terraform completion without errors" {
            { Register-PSPredictorCompletion -Tool "terraform" } | Should -Not -Throw
        }
        
        It "Should provide terraform command completions" {
            Register-PSPredictorCompletion -Tool "terraform"
            $completions = TabExpansion2 "terraform " 10
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
        
        It "Should handle terraform completion with partial input" {
            Register-PSPredictorCompletion -Tool "terraform"
            $completions = TabExpansion2 "terraform pl" 12
            $completions.CompletionMatches.Count | Should -BeGreaterThan 0
        }
        
        It "Should provide terraform workflow completions" {
            Register-PSPredictorCompletion -Tool "terraform"
            $completions = TabExpansion2 "terraform apply " 16
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
    }
}