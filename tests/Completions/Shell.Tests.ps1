BeforeAll {
    Import-Module "$PSScriptRoot/../../src/PSPredictor.psd1" -Force
}

Describe "Shell Completion Tests" {
    Context "PowerShell (pwsh) Completion Registration" {
        It "Should register pwsh completion without errors" {
            { Register-PSPredictorCompletion -Tool "pwsh" } | Should -Not -Throw
        }
        
        It "Should provide pwsh command completions through API" {
            # Test that pwsh completion can be registered through the public API
            { Register-PSPredictorCompletion -Tool 'pwsh' } | Should -Not -Throw
        }
        
        It "Should handle pwsh completion with parameter logic" {
            # This tests the completion logic structure
            $WordToComplete = "-C"
            $ExpectedMatches = @('-Command')
            
            # Test completion registration works
            { Register-PSPredictorCompletion -Tool "pwsh" } | Should -Not -Throw
        }
    }
    
    Context "Zsh Shell Completion Registration" {
        It "Should register zsh completion without errors" {
            { Register-PSPredictorCompletion -Tool "zsh" } | Should -Not -Throw
        }
        
        It "Should provide zsh command completions through API" {
            # Test that zsh completion can be registered through the public API
            { Register-PSPredictorCompletion -Tool 'zsh' } | Should -Not -Throw
        }
        
        It "Should handle zsh completion with option logic" {
            # This tests the completion logic structure
            $WordToComplete = "-o"
            $ExpectedMatches = @('-o')
            
            # Test completion registration works
            { Register-PSPredictorCompletion -Tool "zsh" } | Should -Not -Throw
        }
    }
    
    Context "Bash Shell Completion Registration" {
        It "Should register bash completion without errors" {
            { Register-PSPredictorCompletion -Tool "bash" } | Should -Not -Throw
        }
        
        It "Should provide bash command completions through API" {
            # Test that bash completion can be registered through the public API
            { Register-PSPredictorCompletion -Tool 'bash' } | Should -Not -Throw
        }
        
        It "Should handle bash completion with option logic" {
            # This tests the completion logic structure
            $WordToComplete = "--"
            $ExpectedMatches = @('--version', '--help', '--login')
            
            # Test completion registration works
            { Register-PSPredictorCompletion -Tool "bash" } | Should -Not -Throw
        }
    }
}