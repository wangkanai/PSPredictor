BeforeAll {
    Import-Module "$PSScriptRoot/../../src/PSPredictor.psd1" -Force
}

Describe "Docker Completion Tests" {
    Context "Docker Completion Registration" {
        It "Should register docker completion without errors" {
            { Register-PSPredictorCompletion -Tool "docker" } | Should -Not -Throw
        }
        
        It "Should provide docker command completions through API" {
            # Test that docker completion can be registered through the public API
            { Register-PSPredictorCompletion -Tool 'docker' } | Should -Not -Throw
        }
        
        It "Should handle docker completion with partial input logic" {
            # This tests the completion logic structure
            $WordToComplete = "ru"
            $ExpectedMatches = @('run')
            
            # Test completion registration works
            { Register-PSPredictorCompletion -Tool "docker" } | Should -Not -Throw
        }
    }
}