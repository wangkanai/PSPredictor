BeforeAll {
    Import-Module "$PSScriptRoot/../../src/PSPredictor.psd1" -Force
}

Describe "Terminal Tools Completion Tests" {
    Context "Tmux Completion Registration" {
        It "Should register tmux completion without errors" {
            { Register-PSPredictorCompletion -Tool "tmux" } | Should -Not -Throw
        }
        
        It "Should provide tmux command completions" {
            Register-PSPredictorCompletion -Tool "tmux"
            $completions = TabExpansion2 "tmux " 5
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
        
        It "Should handle tmux session completion" {
            Register-PSPredictorCompletion -Tool "tmux"
            $completions = TabExpansion2 "tmux new-session " 17
            $completions.CompletionMatches.Count | Should -BeGreaterThan 0
        }
    }
    
    Context "Hyper Terminal Completion Registration" {
        It "Should register hyper completion without errors" {
            { Register-PSPredictorCompletion -Tool "hyper" } | Should -Not -Throw
        }
        
        It "Should provide hyper command completions" {
            Register-PSPredictorCompletion -Tool "hyper"
            $completions = TabExpansion2 "hyper " 6
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
    }
    
    Context "Podman Container Completion Registration" {
        It "Should register podman completion without errors" {
            { Register-PSPredictorCompletion -Tool "podman" } | Should -Not -Throw
        }
        
        It "Should provide podman command completions" {
            Register-PSPredictorCompletion -Tool "podman"
            $completions = TabExpansion2 "podman " 7
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
        
        It "Should handle podman container completion" {
            Register-PSPredictorCompletion -Tool "podman"
            $completions = TabExpansion2 "podman run " 11
            $completions.CompletionMatches.Count | Should -BeGreaterThan 0
        }
    }
    
    Context "NPX Package Runner Completion Registration" {
        It "Should register npx completion without errors" {
            { Register-PSPredictorCompletion -Tool "npx" } | Should -Not -Throw
        }
        
        It "Should provide npx command completions" {
            Register-PSPredictorCompletion -Tool "npx"
            $completions = TabExpansion2 "npx " 4
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
    }
}