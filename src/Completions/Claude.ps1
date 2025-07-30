<#
.SYNOPSIS
    Claude AI CLI completion provider for PSPredictor
.DESCRIPTION
    Provides comprehensive tab completion for Claude CLI commands and options
#>

function Register-ClaudeCompletion {
    $ClaudeScriptBlock = {
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
        
        $completions = @()
        
        # Get the full command line to understand context
        $commandLine = $commandAst.ToString()
        $words = $commandLine -split '\s+' | Where-Object { $_ -ne '' }
        
        # If we're at the first argument after 'claude'
        if ($words.Count -le 2) {
            # Main claude commands
            $mainCommands = @(
                'chat', 'complete', 'config', 'auth', 'login', 'logout', 'models', 
                'history', 'conversations', 'help', 'version', 'update'
            )
            
            $completions += $mainCommands | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { 
                    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "claude $_")
                }
        }
        # Handle subcommands and options
        elseif ($words.Count -gt 2) {
            $subCommand = $words[1]
            
            switch ($subCommand) {
                'chat' {
                    if ($wordToComplete -like '-*') {
                        $options = @('--model', '--temperature', '--max-tokens', '--system', '--file', '--stream', '--json', '--verbose')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'complete' {
                    if ($wordToComplete -like '-*') {
                        $options = @('--model', '--temperature', '--max-tokens', '--stop', '--file', '--json', '--stream')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'config' {
                    $configCommands = @('get', 'set', 'list', 'reset', 'show')
                    $completions += $configCommands | Where-Object { $_ -like "$wordToComplete*" } |
                        ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "config $_") }
                }
                'auth' {
                    $authCommands = @('login', 'logout', 'status', 'refresh', 'token')
                    $completions += $authCommands | Where-Object { $_ -like "$wordToComplete*" } |
                        ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "auth $_") }
                }
                'models' {
                    if ($wordToComplete -like '-*') {
                        $options = @('--available', '--current', '--details', '--json')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    } else {
                        # Common Claude model names
                        $models = @(
                            'claude-3-sonnet', 'claude-3-haiku', 'claude-3-opus',
                            'claude-2.1', 'claude-2.0', 'claude-instant'
                        )
                        $completions += $models | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "Model: $_") }
                    }
                }
                'conversations' {
                    $convCommands = @('list', 'show', 'delete', 'export', 'search')
                    $completions += $convCommands | Where-Object { $_ -like "$wordToComplete*" } |
                        ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "conversations $_") }
                }
                'history' {
                    if ($wordToComplete -like '-*') {
                        $options = @('--limit', '--format', '--export', '--search', '--filter')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
            }
        }
        
        # Global options that work with most commands
        if ($wordToComplete -like '-*') {
            $globalOptions = @('--help', '--version', '--config', '--api-key', '--debug', '--quiet')
            $completions += $globalOptions | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
        }
        
        return $completions
    }
    
    Register-ArgumentCompleter -Native -CommandName 'claude' -ScriptBlock $ClaudeScriptBlock
}