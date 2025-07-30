BeforeAll {
    Import-Module "$PSScriptRoot/../../src/PSPredictor.psd1" -Force
}

Describe "Python Tools Completion Tests" {
    Context "Pip Completion Registration" {
        It "Should register pip completion without errors" {
            { Register-PSPredictorCompletion -Tool "pip" } | Should -Not -Throw
        }
        
        It "Should provide pip command completions" {
            Register-PSPredictorCompletion -Tool "pip"
            $completions = TabExpansion2 "pip " 4
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
        
        It "Should handle pip install completion" {
            Register-PSPredictorCompletion -Tool "pip"
            $completions = TabExpansion2 "pip install " 12
            $completions.CompletionMatches.Count | Should -BeGreaterThan 0
        }
    }
    
    Context "Pipx Completion Registration" {
        It "Should register pipx completion without errors" {
            { Register-PSPredictorCompletion -Tool "pipx" } | Should -Not -Throw
        }
        
        It "Should provide pipx command completions" {
            Register-PSPredictorCompletion -Tool "pipx"
            $completions = TabExpansion2 "pipx " 5
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
    }
    
    Context "Pyenv Completion Registration" {
        It "Should register pyenv completion without errors" {
            { Register-PSPredictorCompletion -Tool "pyenv" } | Should -Not -Throw
        }
        
        It "Should provide pyenv command completions" {
            Register-PSPredictorCompletion -Tool "pyenv"
            $completions = TabExpansion2 "pyenv " 6
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
    }
    
    Context "Python Interpreter Completion Registration" {
        It "Should register python completion without errors" {
            { Register-PSPredictorCompletion -Tool "python" } | Should -Not -Throw
        }
        
        It "Should provide python command completions" {
            Register-PSPredictorCompletion -Tool "python"
            $completions = TabExpansion2 "python " 7
            $completions.CompletionMatches | Should -Not -BeNullOrEmpty
        }
        
        It "Should handle python module completion" {
            Register-PSPredictorCompletion -Tool "python"
            $completions = TabExpansion2 "python -m " 10
            $completions.CompletionMatches.Count | Should -BeGreaterThan 0
        }
    }
}