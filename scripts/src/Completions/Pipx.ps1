<#
.SYNOPSIS
    Pipx Python application installer completion provider for PSPredictor
.DESCRIPTION
    Provides comprehensive tab completion for pipx commands and options
#>

function Register-PipxCompletion {
    $PipxScriptBlock = {
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
        
        $completions = @()
        
        # Get the full command line to understand context
        $commandLine = $commandAst.ToString()
        $words = $commandLine -split '\s+' | Where-Object { $_ -ne '' }
        
        # If we're at the first argument after 'pipx'
        if ($words.Count -le 2) {
            # Main pipx commands
            $mainCommands = @(
                'install', 'upgrade', 'upgrade-all', 'uninstall', 'uninstall-all',
                'reinstall', 'reinstall-all', 'list', 'run', 'runpip', 'ensurepath',
                'environment', 'completions'
            )
            
            $completions += $mainCommands | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { 
                    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "pipx $_")
                }
        }
        
        # Pipx options
        if ($wordToComplete -like '-*') {
            $options = @('--help', '--version', '--verbose', '--quiet', '--include-deps', '--force', '--python')
            $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
        }
        
        return $completions
    }
    
    Register-ArgumentCompleter -CommandName 'pipx' -ScriptBlock $PipxScriptBlock
}