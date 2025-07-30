BeforeAll {
    Import-Module "$PSScriptRoot/../../src/PSPredictor.psd1" -Force
}

Describe "AWS CLI Completion Tests" {
    Context "AWS CLI Completion Registration" {
        It "Should register aws completion without errors" {
            { Register-PSPredictorCompletion -Tool "aws" } | Should -Not -Throw
        }
        
        It "Should provide aws command completions" {
            Register-PSPredictorCompletion -Tool "aws"
            $completions = TabExpansion2 "aws " 4
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
        
        It "Should handle aws completion with partial input" {
            Register-PSPredictorCompletion -Tool "aws"
            $completions = TabExpansion2 "aws s3 " 7
            $completions.CompletionMatches.Count | Should -BeGreaterThan 0
        }
        
        It "Should provide aws service completions" {
            Register-PSPredictorCompletion -Tool "aws"
            $completions = TabExpansion2 "aws ec2 " 8
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
    }
}