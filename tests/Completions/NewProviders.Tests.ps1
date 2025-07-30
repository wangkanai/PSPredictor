BeforeAll {
    Import-Module "$PSScriptRoot/../../src/PSPredictor.psd1" -Force
}

Describe "New Completion Providers Tests" {
    Context "New CLI Tools Registration" {
        $newTools = @('podman', 'tmux', 'hyper', 'codex', 'brew', 'npx', 'pip', 'pipx', 'pyenv', 'python')
        
        foreach ($tool in $newTools) {
            It "Should register $tool completion without errors" {
                { Register-PSPredictorCompletion -Tool $tool } | Should -Not -Throw
            }
        }
    }
    
    Context "Completion Provider Functionality" {
        It "Should provide completions for brew commands" {
            Register-PSPredictorCompletion -Tool "brew"
            $completions = TabExpansion2 "brew " 5
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
        
        It "Should provide completions for pip commands" {
            Register-PSPredictorCompletion -Tool "pip"
            $completions = TabExpansion2 "pip " 4
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
        
        It "Should provide completions for python modules" {
            Register-PSPredictorCompletion -Tool "python"
            $completions = TabExpansion2 "python -m " 10
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
    }
}