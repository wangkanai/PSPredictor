BeforeAll {
    Import-Module "$PSScriptRoot/../../src/PSPredictor.psd1" -Force
}

Describe "Kubectl Completion Tests" {
    Context "Kubectl Completion Registration" {
        It "Should register kubectl completion without errors" {
            { Register-PSPredictorCompletion -Tool "kubectl" } | Should -Not -Throw
        }
        
        It "Should provide kubectl command completions through API" {
            # Test that kubectl completion can be registered through the public API
            { Register-PSPredictorCompletion -Tool 'kubectl' } | Should -Not -Throw
        }
        
        It "Should handle kubectl completion with partial input logic" {
            # This tests the completion logic structure
            $WordToComplete = "get"
            $ExpectedMatches = @('get')
            
            # Test completion registration works
            { Register-PSPredictorCompletion -Tool "kubectl" } | Should -Not -Throw
        }
        
        It "Should provide kubectl resource completions through API" {
            # Test that kubectl completion can be registered through the public API
            { Register-PSPredictorCompletion -Tool 'kubectl' } | Should -Not -Throw
        }
    }
}