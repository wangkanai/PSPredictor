<#
.SYNOPSIS
    Python pip package installer completion provider for PSPredictor
.DESCRIPTION
    Provides comprehensive tab completion for pip commands and options
#>

function Register-PipCompletion {
    $PipScriptBlock = {
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
        
        $completions = @()
        
        # Get the full command line to understand context
        $commandLine = $commandAst.ToString()
        $words = $commandLine -split '\s+' | Where-Object { $_ -ne '' }
        
        # If we're at the first argument after 'pip'
        if ($words.Count -le 2) {
            # Main pip commands
            $mainCommands = @(
                'install', 'download', 'uninstall', 'freeze', 'list', 'show', 'check',
                'config', 'search', 'cache', 'index', 'wheel', 'hash', 'completion',
                'debug', 'help'
            )
            
            $completions += $mainCommands | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { 
                    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "pip $_")
                }
        }
        # Handle subcommands and options
        elseif ($words.Count -gt 2) {
            $subCommand = $words[1]
            
            switch ($subCommand) {
                'install' {
                    if ($wordToComplete -like '-*') {
                        $options = @('--requirement', '--constraint', '--no-deps', '--pre', '--editable', '--target', '--platform', '--user', '--root', '--prefix', '--upgrade', '--upgrade-strategy', '--force-reinstall', '--ignore-installed', '--ignore-requires-python', '--no-build-isolation', '--use-pep517', '--no-use-pep517', '--install-option', '--global-option', '--compile', '--no-compile', '--no-warn-script-location', '--no-warn-conflicts', '--no-binary', '--only-binary', '--prefer-binary', '--require-hashes', '--progress-bar', '--no-clean', '--no-cache-dir', '--cache-dir')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'uninstall' {
                    if ($wordToComplete -like '-*') {
                        $options = @('--requirement', '--yes', '--root-user-action')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'list' {
                    if ($wordToComplete -like '-*') {
                        $options = @('--outdated', '--uptodate', '--editable', '--local', '--user', '--path', '--pre', '--format', '--not-required', '--exclude-editable', '--include-editable')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'show' {
                    if ($wordToComplete -like '-*') {
                        $options = @('--files', '--verbose')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'freeze' {
                    if ($wordToComplete -like '-*') {
                        $options = @('--requirement', '--find-links', '--local', '--user', '--path', '--all', '--exclude-editable')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'config' {
                    $configCommands = @('list', 'edit', 'get', 'set', 'unset', 'debug')
                    if ($wordToComplete -like '-*') {
                        $options = @('--global', '--user', '--site', '--editor')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    } else {
                        $completions += $configCommands | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "config $_") }
                    }
                }
                'cache' {
                    $cacheCommands = @('dir', 'info', 'list', 'remove', 'purge')
                    $completions += $cacheCommands | Where-Object { $_ -like "$wordToComplete*" } |
                        ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "cache $_") }
                }
            }
        }
        
        # Global options that work with most commands
        if ($wordToComplete -like '-*') {
            $globalOptions = @('--help', '--isolated', '--require-virtualenv', '--verbose', '--version', '--quiet', '--log', '--no-input', '--proxy', '--retries', '--timeout', '--exists-action', '--trusted-host', '--cert', '--client-cert', '--cache-dir', '--no-cache-dir', '--disable-pip-version-check', '--no-color', '--no-python-version-warning', '--use-feature', '--use-deprecated')
            $completions += $globalOptions | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
        }
        
        return $completions
    }
    
    Register-ArgumentCompleter -CommandName 'pip' -ScriptBlock $PipScriptBlock
}