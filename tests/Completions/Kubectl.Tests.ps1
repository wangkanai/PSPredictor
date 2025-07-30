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
            $completions.CompletionMatches.CompletionText | Should -Contain "get"
            $completions.CompletionMatches.CompletionText | Should -Contain "describe"
            $completions.CompletionMatches.CompletionText | Should -Contain "create"
        }
        
        It "Should provide kubectl get resource completions" {
            Register-PSPredictorCompletion -Tool "kubectl"
            $completions = TabExpansion2 "kubectl get " 12
            $completions.CompletionMatches.Count | Should -BeGreaterThan 0
            $completions.CompletionMatches.CompletionText | Should -Contain "pods"
            $completions.CompletionMatches.CompletionText | Should -Contain "services"
            $completions.CompletionMatches.CompletionText | Should -Contain "deployments"
        }
        
        It "Should provide kubectl create subcommand completions" {
            Register-PSPredictorCompletion -Tool "kubectl"
            $completions = TabExpansion2 "kubectl create " 15
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
            $completions.CompletionMatches.CompletionText | Should -Contain "deployment"
            $completions.CompletionMatches.CompletionText | Should -Contain "service"
            $completions.CompletionMatches.CompletionText | Should -Contain "secret"
        }
        
        It "Should provide kubectl config subcommand completions" {
            Register-PSPredictorCompletion -Tool "kubectl"
            $completions = TabExpansion2 "kubectl config " 15
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
            $completions.CompletionMatches.CompletionText | Should -Contain "current-context"
            $completions.CompletionMatches.CompletionText | Should -Contain "get-contexts"
        }
        
        It "Should provide kubectl logs resource completions" {
            Register-PSPredictorCompletion -Tool "kubectl"
            $completions = TabExpansion2 "kubectl logs " 13
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
            $completions.CompletionMatches.CompletionText | Should -Contain "pods"
            $completions.CompletionMatches.CompletionText | Should -Contain "deployments"
        }
        
        It "Should filter resources by prefix" {
            Register-PSPredictorCompletion -Tool "kubectl"
            $completions = TabExpansion2 "kubectl get p" 13
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
            $completions.CompletionMatches.CompletionText | Should -Contain "pods"
            $completions.CompletionMatches.CompletionText | Should -Contain "po"
        }
        
        It "Should filter commands by prefix" {
            Register-PSPredictorCompletion -Tool "kubectl"
            $completions = TabExpansion2 "kubectl g" 9
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
            $completions.CompletionMatches.CompletionText | Should -Contain "get"
        }
    }
}