<#
.SYNOPSIS
    Pyenv Python version manager completion provider for PSPredictor
.DESCRIPTION
    Provides comprehensive tab completion for pyenv commands and options
#>

function Register-PyenvCompletion {
    $PyenvScriptBlock = {
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
        
        $completions = @()
        
        # Get the full command line to understand context
        $commandLine = $commandAst.ToString()
        $words = $commandLine -split '\s+' | Where-Object { $_ -ne '' }
        
        # If we're at the first argument after 'pyenv'
        if ($words.Count -le 2) {
            # Main pyenv commands
            $mainCommands = @(
                'commands', 'local', 'global', 'shell', 'install', 'uninstall',
                'rehash', 'version', 'versions', 'which', 'whence', 'completions',
                'exec', 'root', 'prefix', 'hooks', 'shims', 'init', 'doctor'
            )
            
            $completions += $mainCommands | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { 
                    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "pyenv $_")
                }
        }
        
        # Pyenv options
        if ($wordToComplete -like '-*') {
            $options = @('--help', '--version', '--list', '--force', '--skip-existing', '--keep', '--patch', '--verbose')
            $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
        }
        
        return $completions
    }
    
    Register-ArgumentCompleter -CommandName 'pyenv' -ScriptBlock $PyenvScriptBlock
}