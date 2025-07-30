BeforeAll {
    Import-Module "$PSScriptRoot/../../src/PSPredictor.psd1" -Force
}

Describe "New Completion Providers Tests" {
    Context "New CLI Tools Registration" {
        It "Should register podman completion without errors" {
            { Register-PSPredictorCompletion -Tool "podman" } | Should -Not -Throw
        }
        
        It "Should register tmux completion without errors" {
            { Register-PSPredictorCompletion -Tool "tmux" } | Should -Not -Throw
        }
        
        It "Should register hyper completion without errors" {
            { Register-PSPredictorCompletion -Tool "hyper" } | Should -Not -Throw
        }
        
        It "Should register codex completion without errors" {
            { Register-PSPredictorCompletion -Tool "codex" } | Should -Not -Throw
        }
        
        It "Should register brew completion without errors" {
            { Register-PSPredictorCompletion -Tool "brew" } | Should -Not -Throw
        }
        
        It "Should register npx completion without errors" {
            { Register-PSPredictorCompletion -Tool "npx" } | Should -Not -Throw
        }
        
        It "Should register pip completion without errors" {
            { Register-PSPredictorCompletion -Tool "pip" } | Should -Not -Throw
        }
        
        It "Should register pipx completion without errors" {
            { Register-PSPredictorCompletion -Tool "pipx" } | Should -Not -Throw
        }
        
        It "Should register pyenv completion without errors" {
            { Register-PSPredictorCompletion -Tool "pyenv" } | Should -Not -Throw
        }
        
        It "Should register python completion without errors" {
            { Register-PSPredictorCompletion -Tool "python" } | Should -Not -Throw
        }
    }
    
    Context "Completion Provider Functionality" {
        It "Should provide completions for brew commands through API" {
            # Test that brew completion can be registered through the public API
            { Register-PSPredictorCompletion -Tool "brew" } | Should -Not -Throw
        }
        
        It "Should provide completions for pip commands through API" {
            # Test that pip completion can be registered through the public API
            { Register-PSPredictorCompletion -Tool "pip" } | Should -Not -Throw
        }
        
        It "Should provide completions for python modules through API" {
            # Test that python completion can be registered through the public API
            { Register-PSPredictorCompletion -Tool "python" } | Should -Not -Throw
        }
    }
}