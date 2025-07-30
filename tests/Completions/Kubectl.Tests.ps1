BeforeAll {
    Import-Module "$PSScriptRoot/../../src/PSPredictor.psd1" -Force
}

Describe "Kubectl Completion Tests" {
    Context "Kubectl Completion Registration" {
        It "Should register kubectl completion without errors" {
            { Register-PSPredictorCompletion -Tool "kubectl" } | Should -Not -Throw
        }
        
        It "Should provide kubectl command completions" {
            Register-PSPredictorCompletion -Tool "kubectl"
            $completions = TabExpansion2 "kubectl " 8
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
        
        It "Should handle kubectl completion with partial input" {
            Register-PSPredictorCompletion -Tool "kubectl"
            $completions = TabExpansion2 "kubectl get " 11
            $completions.CompletionMatches.Count | Should -BeGreaterThan 0
        }
        
        It "Should provide kubectl resource completions" {
            Register-PSPredictorCompletion -Tool "kubectl"
            $completions = TabExpansion2 "kubectl apply " 14
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
    }
}