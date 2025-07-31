<#
.SYNOPSIS
    Google Gemini AI CLI completion provider for PSPredictor
.DESCRIPTION
    Provides comprehensive tab completion for Gemini CLI commands and options
#>

function Register-GeminiCompletion {
    $GeminiScriptBlock = {
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
        
        $completions = @()
        
        # Get the full command line to understand context
        $commandLine = $commandAst.ToString()
        $words = $commandLine -split '\s+' | Where-Object { $_ -ne '' }
        
        # If we're at the first argument after 'gemini'
        if ($words.Count -le 2) {
            # Main gemini commands
            $mainCommands = @(
                'generate', 'chat', 'models', 'config', 'auth', 'login', 'logout',
                'files', 'upload', 'delete', 'list', 'help', 'version', 'update'
            )
            
            $completions += $mainCommands | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { 
                    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "gemini $_")
                }
        }
        # Handle subcommands and options
        elseif ($words.Count -gt 2) {
            $subCommand = $words[1]
            
            switch ($subCommand) {
                'generate' {
                    if ($wordToComplete -like '-*') {
                        $options = @('--model', '--temperature', '--max-tokens', '--top-p', '--top-k', '--file', '--image', '--stream', '--json')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'chat' {
                    if ($wordToComplete -like '-*') {
                        $options = @('--model', '--temperature', '--max-tokens', '--system', '--history', '--stream', '--json')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'models' {
                    if ($wordToComplete -like '-*') {
                        $options = @('--available', '--details', '--json', '--filter')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    } else {
                        # Common Gemini model names
                        $models = @(
                            'gemini-pro', 'gemini-pro-vision', 'gemini-ultra', 'gemini-nano',
                            'gemini-1.5-pro', 'gemini-1.5-flash', 'gemini-1.0-pro'
                        )
                        $completions += $models | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "Model: $_") }
                    }
                }
                'config' {
                    $configCommands = @('get', 'set', 'list', 'reset', 'show', 'init')
                    if ($wordToComplete -like '-*') {
                        $options = @('--global', '--local', '--json', '--reset')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    } else {
                        $completions += $configCommands | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "config $_") }
                    }
                }
                'auth' {
                    $authCommands = @('login', 'logout', 'status', 'refresh', 'token', 'revoke')
                    $completions += $authCommands | Where-Object { $_ -like "$wordToComplete*" } |
                        ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "auth $_") }
                }
                'files' {
                    $fileCommands = @('list', 'upload', 'download', 'delete', 'info', 'search')
                    if ($wordToComplete -like '-*') {
                        $options = @('--format', '--filter', '--limit', '--recursive')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    } else {
                        $completions += $fileCommands | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "files $_") }
                    }
                }
                'upload' {
                    if ($wordToComplete -like '-*') {
                        $options = @('--name', '--description', '--mime-type', '--public', '--metadata')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'list' {
                    if ($wordToComplete -like '-*') {
                        $options = @('--format', '--filter', '--limit', '--sort', '--json')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
            }
        }
        
        # Global options that work with most commands
        if ($wordToComplete -like '-*') {
            $globalOptions = @('--help', '--version', '--api-key', '--project', '--debug', '--quiet', '--json')
            $completions += $globalOptions | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
        }
        
        return $completions
    }
    
    Register-ArgumentCompleter -CommandName 'gemini' -ScriptBlock $GeminiScriptBlock
}