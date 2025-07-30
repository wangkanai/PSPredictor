BeforeAll {
    Import-Module "$PSScriptRoot/../../src/PSPredictor.psd1" -Force
}

Describe "AI Tools Completion Tests" {
    Context "Claude AI Completion Registration" {
        It "Should register claude completion without errors" {
            { Register-PSPredictorCompletion -Tool "claude" } | Should -Not -Throw
        }
        
        It "Should provide claude command completions" {
            Register-PSPredictorCompletion -Tool "claude"
            $completions = TabExpansion2 "claude " 7
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
        
        It "Should handle claude completion with partial input" {
            Register-PSPredictorCompletion -Tool "claude"
            $completions = TabExpansion2 "claude chat " 12
            $completions.CompletionMatches.Count | Should -BeGreaterThan 0
        }
    }
    
    Context "Gemini AI Completion Registration" {
        It "Should register gemini completion without errors" {
            { Register-PSPredictorCompletion -Tool "gemini" } | Should -Not -Throw
        }
        
        It "Should provide gemini command completions" {
            Register-PSPredictorCompletion -Tool "gemini"
            $completions = TabExpansion2 "gemini " 7
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
        
        It "Should handle gemini completion with partial input" {
            Register-PSPredictorCompletion -Tool "gemini"
            $completions = TabExpansion2 "gemini generate " 16
            $completions.CompletionMatches.Count | Should -BeGreaterThan 0
        }
    }
    
    Context "Codex AI Completion Registration" {
        It "Should register codex completion without errors" {
            { Register-PSPredictorCompletion -Tool "codex" } | Should -Not -Throw
        }
        
        It "Should provide codex command completions" {
            Register-PSPredictorCompletion -Tool "codex"
            $completions = TabExpansion2 "codex " 6
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
    }
}