<#
.SYNOPSIS
    Homebrew package manager completion provider for PSPredictor
.DESCRIPTION
    Provides comprehensive tab completion for Homebrew commands and options
#>

function Register-BrewCompletion {
    $BrewScriptBlock = {
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
        
        $completions = @()
        
        # Get the full command line to understand context
        $commandLine = $commandAst.ToString()
        $words = $commandLine -split '\s+' | Where-Object { $_ -ne '' }
        
        # If we're at the first argument after 'brew'
        if ($words.Count -le 2) {
            # Main brew commands
            $mainCommands = @(
                'install', 'uninstall', 'update', 'upgrade', 'search', 'info', 'list',
                'services', 'tap', 'untap', 'doctor', 'cleanup', 'deps', 'uses',
                'outdated', 'pin', 'unpin', 'link', 'unlink', 'switch', 'prune',
                'audit', 'cat', 'create', 'edit', 'fetch', 'formula', 'home',
                'leaves', 'log', 'missing', 'options', 'postinstall', 'reinstall',
                'style', 'test', 'unpack', 'vendor-install', 'analytics', 'autoremove',
                'bundle', 'cask', 'commands', 'config', 'environment', 'gist-logs',
                'help', 'shellenv', 'tap-info', 'update-reset', 'which'
            )
            
            $completions += $mainCommands | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { 
                    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "brew $_")
                }
        }
        # Handle subcommands and options
        elseif ($words.Count -gt 2) {
            $subCommand = $words[1]
            
            switch ($subCommand) {
                'install' {
                    if ($wordToComplete -like '-*') {
                        $options = @('--cask', '--HEAD', '--build-from-source', '--force-bottle', '--include-test', '--devel', '--keep-tmp', '--debug', '--quiet', '--verbose')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'uninstall' {
                    if ($wordToComplete -like '-*') {
                        $options = @('--cask', '--force', '--zap', '--ignore-dependencies')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'search' {
                    if ($wordToComplete -like '-*') {
                        $options = @('--cask', '--desc', '--macports', '--fink', '--closed-source', '--fedora', '--opensuse', '--ubuntu', '--debian')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'info' {
                    if ($wordToComplete -like '-*') {
                        $options = @('--cask', '--github', '--json', '--installed', '--all', '--analytics')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'list' {
                    if ($wordToComplete -like '-*') {
                        $options = @('--cask', '--versions', '--multiple', '--pinned', '--formula')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'services' {
                    $serviceCommands = @('list', 'run', 'start', 'stop', 'restart', 'cleanup')
                    $completions += $serviceCommands | Where-Object { $_ -like "$wordToComplete*" } |
                        ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "services $_") }
                }
                'cask' {
                    $caskCommands = @('install', 'uninstall', 'search', 'info', 'list', 'outdated', 'upgrade', 'doctor', 'cleanup', 'home', 'audit', 'cat', 'create', 'edit', 'fetch', 'style', 'zap')
                    $completions += $caskCommands | Where-Object { $_ -like "$wordToComplete*" } |
                        ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "cask $_") }
                }
                'tap' {
                    if ($wordToComplete -like '-*') {
                        $options = @('--custom-remote', '--force-auto-update', '--repair')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'bundle' {
                    $bundleCommands = @('install', 'dump', 'cleanup', 'check', 'list', 'exec')
                    if ($wordToComplete -like '-*') {
                        $options = @('--file', '--global', '--system', '--no-lock', '--force', '--cleanup', '--no-upgrade')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    } else {
                        $completions += $bundleCommands | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "bundle $_") }
                    }
                }
            }
        }
        
        # Global options that work with most commands
        if ($wordToComplete -like '-*') {
            $globalOptions = @('--help', '--version', '--verbose', '--debug', '--quiet', '--cache', '--prefix')
            $completions += $globalOptions | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
        }
        
        return $completions
    }
    
    Register-ArgumentCompleter -CommandName 'brew' -ScriptBlock $BrewScriptBlock
}