<#
.SYNOPSIS
    Podman container tool completion provider for PSPredictor
.DESCRIPTION
    Provides comprehensive tab completion for Podman container commands and options
#>

function Register-PodmanCompletion {
    $PodmanScriptBlock = {
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
        
        $completions = @()
        
        # Get the full command line to understand context
        $commandLine = $commandAst.ToString()
        $words = $commandLine -split '\s+' | Where-Object { $_ -ne '' }
        
        # If we're at the first argument after 'podman'
        if ($words.Count -le 2) {
            # Main podman commands
            $mainCommands = @(
                'attach', 'build', 'commit', 'container', 'cp', 'create', 'diff', 'events',
                'exec', 'export', 'generate', 'healthcheck', 'history', 'image', 'images',
                'import', 'info', 'inspect', 'kill', 'load', 'login', 'logout', 'logs',
                'manifest', 'mount', 'network', 'pause', 'play', 'pod', 'port', 'ps',
                'pull', 'push', 'restart', 'rm', 'rmi', 'run', 'save', 'search',
                'secret', 'start', 'stats', 'stop', 'system', 'tag', 'top', 'unmount',
                'unpause', 'unshare', 'untag', 'update', 'version', 'volume', 'wait'
            )
            
            $completions += $mainCommands | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { 
                    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "podman $_")
                }
        }
        # Handle subcommands and options
        elseif ($words.Count -gt 2) {
            $subCommand = $words[1]
            
            switch ($subCommand) {
                'run' {
                    if ($wordToComplete -like '-*') {
                        $options = @('--interactive', '--tty', '--detach', '--rm', '--name', '--volume', '--port', '--env', '--workdir', '--user', '--privileged', '--network', '--restart')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'build' {
                    if ($wordToComplete -like '-*') {
                        $options = @('--tag', '--file', '--build-arg', '--target', '--platform', '--pull', '--no-cache', '--quiet', '--progress')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'ps' {
                    if ($wordToComplete -like '-*') {
                        $options = @('--all', '--filter', '--format', '--last', '--latest', '--no-trunc', '--quiet', '--size', '--sort')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'images' {
                    if ($wordToComplete -like '-*') {
                        $options = @('--all', '--digests', '--filter', '--format', '--no-trunc', '--quiet')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'exec' {
                    if ($wordToComplete -like '-*') {
                        $options = @('--interactive', '--tty', '--detach', '--env', '--user', '--workdir', '--privileged')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'logs' {
                    if ($wordToComplete -like '-*') {
                        $options = @('--follow', '--since', '--tail', '--timestamps', '--until')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'network' {
                    $networkCommands = @('create', 'connect', 'disconnect', 'inspect', 'ls', 'prune', 'rm')
                    $completions += $networkCommands | Where-Object { $_ -like "$wordToComplete*" } |
                        ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "network $_") }
                }
                'volume' {
                    $volumeCommands = @('create', 'inspect', 'ls', 'prune', 'rm')
                    $completions += $volumeCommands | Where-Object { $_ -like "$wordToComplete*" } |
                        ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "volume $_") }
                }
                'pod' {
                    $podCommands = @('create', 'inspect', 'kill', 'pause', 'ps', 'restart', 'rm', 'start', 'stats', 'stop', 'top', 'unpause')
                    $completions += $podCommands | Where-Object { $_ -like "$wordToComplete*" } |
                        ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "pod $_") }
                }
                'system' {
                    $systemCommands = @('df', 'events', 'info', 'prune', 'reset', 'service')
                    $completions += $systemCommands | Where-Object { $_ -like "$wordToComplete*" } |
                        ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "system $_") }
                }
            }
        }
        
        # Global options that work with most commands
        if ($wordToComplete -like '-*') {
            $globalOptions = @('--help', '--version', '--remote', '--connection', '--identity', '--log-level')
            $completions += $globalOptions | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
        }
        
        return $completions
    }
    
    Register-ArgumentCompleter -CommandName 'podman' -ScriptBlock $PodmanScriptBlock
}