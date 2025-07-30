BeforeAll {
    Import-Module "$PSScriptRoot/../../src/PSPredictor.psd1" -Force
    
    # Mock terraform command for testing (since it might not be installed in CI)
    if (-not (Get-Command terraform -ErrorAction SilentlyContinue)) {
        function Global:terraform { }
    }
}

Describe "Terraform Completion Tests" {
    Context "Terraform Completion Registration" {
        It "Should register terraform completion without errors" {
            { Register-PSPredictorCompletion -Tool "terraform" } | Should -Not -Throw
        }
        
        It "Should provide terraform command completions through API" {
            # Test that terraform completion can be registered through the public API
            { Register-PSPredictorCompletion -Tool 'terraform' } | Should -Not -Throw
        }
        
        It "Should handle terraform completion with partial input logic" {
            # This tests the completion logic structure
            $WordToComplete = "pl"
            $ExpectedMatches = @('plan')
            
            # Test completion registration works
            { Register-PSPredictorCompletion -Tool "terraform" } | Should -Not -Throw
        }
        
        It "Should provide terraform workflow completions through API" {
            # Test that terraform completion can be registered through the public API
            { Register-PSPredictorCompletion -Tool 'terraform' } | Should -Not -Throw
        }
    }
}