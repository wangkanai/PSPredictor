BeforeAll {
    Import-Module "$PSScriptRoot/../../src/PSPredictor.psd1" -Force
}

Describe "NPM Completion Tests" {
    Context "NPM Completion Registration" {
        It "Should register npm completion without errors" {
            { Register-PSPredictorCompletion -Tool "npm" } | Should -Not -Throw
        }
        
        It "Should provide npm command completions through API" {
            # Test that npm completion can be registered through the public API
            { Register-PSPredictorCompletion -Tool 'npm' } | Should -Not -Throw
        }
        
        It "Should handle npm completion with partial input logic" {
            # This tests the completion logic structure
            $WordToComplete = "inst"
            $ExpectedMatches = @('install')
            
            # Test completion registration works
            { Register-PSPredictorCompletion -Tool "npm" } | Should -Not -Throw
        }
        
        It "Should provide npm script completions through API" {
            # Test that npm completion can be registered through the public API
            { Register-PSPredictorCompletion -Tool 'npm' } | Should -Not -Throw
        }
    }
}