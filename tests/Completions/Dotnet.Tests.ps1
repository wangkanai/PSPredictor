BeforeAll {
    Import-Module "$PSScriptRoot/../../src/PSPredictor.psd1" -Force
}

Describe "Dotnet CLI Completion Tests" {
    Context "Dotnet CLI Completion Registration" {
        It "Should register dotnet completion without errors" {
            { Register-PSPredictorCompletion -Tool "dotnet" } | Should -Not -Throw
        }
        
        It "Should provide dotnet command completions" {
            Register-PSPredictorCompletion -Tool "dotnet"
            $completions = TabExpansion2 "dotnet " 7
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
        
        It "Should handle dotnet new completion with partial input" {
            Register-PSPredictorCompletion -Tool "dotnet"
            $completions = TabExpansion2 "dotnet new " 11
            $completions.CompletionMatches.Count | Should -BeGreaterThan 0
        }
        
        It "Should provide dotnet project template completions" {
            Register-PSPredictorCompletion -Tool "dotnet"
            $completions = TabExpansion2 "dotnet add " 11
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
    }
}