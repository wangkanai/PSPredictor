<#
.SYNOPSIS
    Hyper terminal completion provider for PSPredictor
.DESCRIPTION
    Provides comprehensive tab completion for Hyper terminal commands and options
#>

function Register-HyperCompletion {
    $HyperScriptBlock = {
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
        
        $completions = @()
        
        # Hyper command-line options
        if ($wordToComplete -like '-*') {
            $options = @('--help', '--version', '--verbose', '--dev')
            $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
        }
        
        return $completions
    }
    
    Register-ArgumentCompleter -CommandName 'hyper' -ScriptBlock $HyperScriptBlock
}