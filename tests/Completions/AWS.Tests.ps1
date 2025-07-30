BeforeAll {
    Import-Module "$PSScriptRoot/../../src/PSPredictor.psd1" -Force
    
    # Mock aws command for testing (since it might not be installed in CI)
    if (-not (Get-Command aws -ErrorAction SilentlyContinue)) {
        function Global:aws { }
    }
}

Describe "AWS CLI Completion Tests" {
    Context "AWS CLI Completion Registration" {
        It "Should register aws completion without errors" {
            { Register-PSPredictorCompletion -Tool "aws" } | Should -Not -Throw
        }
        
        It "Should provide aws service completions" {
            Register-PSPredictorCompletion -Tool "aws"
            $completions = TabExpansion2 "aws " 4
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
            $completions.CompletionMatches.CompletionText | Should -Contain "s3"
            $completions.CompletionMatches.CompletionText | Should -Contain "ec2"
            $completions.CompletionMatches.CompletionText | Should -Contain "lambda"
        }
        
        It "Should provide s3 command completions" {
            Register-PSPredictorCompletion -Tool "aws"
            $completions = TabExpansion2 "aws s3 " 7
            $completions.CompletionMatches.Count | Should -BeGreaterThan 0
            $completions.CompletionMatches.CompletionText | Should -Contain "ls"
            $completions.CompletionMatches.CompletionText | Should -Contain "cp"
            $completions.CompletionMatches.CompletionText | Should -Contain "sync"
        }
        
        It "Should provide ec2 command completions" {
            Register-PSPredictorCompletion -Tool "aws"
            $completions = TabExpansion2 "aws ec2 " 8
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
            $completions.CompletionMatches.CompletionText | Should -Contain "describe-instances"
            $completions.CompletionMatches.CompletionText | Should -Contain "run-instances"
        }
        
        It "Should provide lambda command completions" {
            Register-PSPredictorCompletion -Tool "aws"
            $completions = TabExpansion2 "aws lambda " 11
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
            $completions.CompletionMatches.CompletionText | Should -Contain "list-functions"
            $completions.CompletionMatches.CompletionText | Should -Contain "create-function"
        }
        
        It "Should provide iam command completions" {
            Register-PSPredictorCompletion -Tool "aws"
            $completions = TabExpansion2 "aws iam " 8
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
            $completions.CompletionMatches.CompletionText | Should -Contain "list-users"
            $completions.CompletionMatches.CompletionText | Should -Contain "create-user"
        }
        
        It "Should filter services by prefix" {
            Register-PSPredictorCompletion -Tool "aws"
            $completions = TabExpansion2 "aws s" 5
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
            $completions.CompletionMatches.CompletionText | Should -Contain "s3"
            $completions.CompletionMatches.CompletionText | Should -Contain "sns"
            $completions.CompletionMatches.CompletionText | Should -Contain "sqs"
        }
    }
}