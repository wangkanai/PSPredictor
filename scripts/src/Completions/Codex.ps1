<#
.SYNOPSIS
    OpenAI Codex CLI completion provider for PSPredictor
.DESCRIPTION
    Provides comprehensive tab completion for Codex CLI commands and options
#>

function Register-CodexCompletion {
    $CodexScriptBlock = {
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
        
        $completions = @()
        
        # Get the full command line to understand context
        $commandLine = $commandAst.ToString()
        $words = $commandLine -split '\s+' | Where-Object { $_ -ne '' }
        
        # If we're at the first argument after 'codex'
        if ($words.Count -le 2) {
            # Main codex commands
            $mainCommands = @('complete', 'edit', 'models', 'config', 'auth', 'help', 'version')
            
            $completions += $mainCommands | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { 
                    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "codex $_")
                }
        }
        
        # Codex options
        if ($wordToComplete -like '-*') {
            $options = @('--model', '--temperature', '--max-tokens', '--stop', '--help', '--version')
            $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
        }
        
        return $completions
    }
    
    Register-ArgumentCompleter -CommandName 'codex' -ScriptBlock $CodexScriptBlock
}