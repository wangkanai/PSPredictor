BeforeAll {
    Import-Module "$PSScriptRoot/../../src/PSPredictor.psd1" -Force
    
    # Mock az command for testing (since it might not be installed in CI)
    if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
        function Global:az { }
    }
}

Describe "Azure CLI Completion Tests" {
    Context "Azure CLI Completion Registration" {
        It "Should register az completion without errors" {
            { Register-PSPredictorCompletion -Tool "az" } | Should -Not -Throw
        }
        
        It "Should provide azure command completions" {
            Register-PSPredictorCompletion -Tool "az"
            $completions = TabExpansion2 "az " 3
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
        
        It "Should handle azure completion with partial input" {
            Register-PSPredictorCompletion -Tool "az"
            $completions = TabExpansion2 "az vm " 6
            $completions.CompletionMatches.Count | Should -BeGreaterThan 0
        }
        
        It "Should provide azure group completions" {
            Register-PSPredictorCompletion -Tool "az"
            $completions = TabExpansion2 "az group " 9
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
    }
}