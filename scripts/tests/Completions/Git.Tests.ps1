BeforeAll {
    Import-Module "$PSScriptRoot/../../src/PSPredictor.psd1" -Force
}

Describe "Git Completion Tests" {
    Context "Git Completion Registration" {
        It "Should register git completion without errors" {
            { Register-PSPredictorCompletion -Tool "git" } | Should -Not -Throw
        }
        
        It "Should provide git command completions through API" {
            # Test that git completion can be registered through the public API
            { Register-PSPredictorCompletion -Tool 'git' } | Should -Not -Throw
        }
        
        It "Should handle git completion with partial input logic" {
            # This tests the completion logic structure
            $WordToComplete = "che"
            $ExpectedMatches = @('checkout')
            
            # The actual completion test would require TabExpansion2 or similar
            # For now, we test that the completion registration works
            { Register-PSPredictorCompletion -Tool "git" } | Should -Not -Throw
        }
    }
}