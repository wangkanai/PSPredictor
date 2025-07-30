<#
.SYNOPSIS
    Tmux terminal multiplexer completion provider for PSPredictor
.DESCRIPTION
    Provides comprehensive tab completion for tmux commands and options
#>

function Register-TmuxCompletion {
    $TmuxScriptBlock = {
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
        
        $completions = @()
        
        # Get the full command line to understand context
        $commandLine = $commandAst.ToString()
        $words = $commandLine -split '\s+' | Where-Object { $_ -ne '' }
        
        # If we're at the first argument after 'tmux'
        if ($words.Count -le 2) {
            # Main tmux commands
            $mainCommands = @(
                'attach-session', 'detach-client', 'has-session', 'kill-server', 'kill-session',
                'list-clients', 'list-commands', 'list-sessions', 'lock-client', 'lock-session',
                'new-session', 'refresh-client', 'rename-session', 'show-messages', 'source-file',
                'start-server', 'suspend-client', 'switch-client', 'bind-key', 'list-keys',
                'send-keys', 'send-prefix', 'unbind-key', 'capture-pane', 'choose-client',
                'choose-session', 'choose-window', 'copy-mode', 'display-message', 'display-panes',
                'find-window', 'join-pane', 'kill-pane', 'kill-window', 'last-pane', 'last-window',
                'link-window', 'list-panes', 'list-windows', 'move-pane', 'move-window',
                'new-window', 'next-layout', 'next-window', 'pipe-pane', 'previous-layout',
                'previous-window', 'rename-window', 'resize-pane', 'respawn-pane', 'respawn-window',
                'rotate-window', 'select-layout', 'select-pane', 'select-window', 'split-window',
                'swap-pane', 'swap-window', 'unlink-window'
            )
            
            # Also support short forms
            $shortCommands = @(
                'attach', 'detach', 'has', 'kill-server', 'kill-session', 'list-clients',
                'list-commands', 'list-sessions', 'new', 'refresh', 'rename', 'source',
                'start', 'suspend', 'switch', 'bind', 'list-keys', 'send', 'unbind',
                'capture', 'choose', 'copy', 'display', 'find', 'join', 'kill', 'last',
                'link', 'list', 'move', 'next', 'pipe', 'previous', 'rename', 'resize',
                'respawn', 'rotate', 'select', 'split', 'swap', 'unlink'
            )
            
            $allCommands = $mainCommands + $shortCommands
            $completions += $allCommands | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { 
                    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "tmux $_")
                }
        }
        # Handle subcommands and options
        elseif ($words.Count -gt 2) {
            $subCommand = $words[1]
            
            switch -Regex ($subCommand) {
                'new-session|new' {
                    if ($wordToComplete -like '-*') {
                        $options = @('-d', '-s', '-n', '-c', '-x', '-y', '-A', '-D', '-P', '-t')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'attach-session|attach' {
                    if ($wordToComplete -like '-*') {
                        $options = @('-d', '-r', '-t', '-c', '-E', '-f')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'split-window|split' {
                    if ($wordToComplete -like '-*') {
                        $options = @('-h', '-v', '-d', '-t', '-c', '-p', '-P', '-l', '-b', '-f')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'new-window|neww' {
                    if ($wordToComplete -like '-*') {
                        $options = @('-a', '-d', '-n', '-t', '-c', '-P', '-k')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'select-window|selectw' {
                    if ($wordToComplete -like '-*') {
                        $options = @('-l', '-n', '-p', '-t')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'send-keys|send' {
                    if ($wordToComplete -like '-*') {
                        $options = @('-l', '-H', '-M', '-R', '-t', '-N')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'list-sessions|ls' {
                    if ($wordToComplete -like '-*') {
                        $options = @('-F', '-f')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
            }
        }
        
        # Global options that work with most commands
        if ($wordToComplete -like '-*') {
            $globalOptions = @('-V', '-v', '-f', '-L', '-S', '-c')
            $completions += $globalOptions | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
        }
        
        return $completions
    }
    
    Register-ArgumentCompleter -CommandName 'tmux' -ScriptBlock $TmuxScriptBlock
}