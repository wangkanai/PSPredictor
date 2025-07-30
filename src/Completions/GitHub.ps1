<#
.SYNOPSIS
    GitHub CLI (gh) completion provider for PSPredictor
.DESCRIPTION
    Provides comprehensive tab completion for GitHub CLI commands and options
#>

function Register-GitHubCompletion {
    $GitHubScriptBlock = {
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
        
        $completions = @()
        
        # Get the full command line to understand context
        $commandLine = $commandAst.ToString()
        $words = $commandLine -split '\s+' | Where-Object { $_ -ne '' }
        
        # If we're at the first argument after 'gh'
        if ($words.Count -le 2) {
            # Main gh commands
            $mainCommands = @(
                'auth', 'browse', 'codespace', 'gist', 'issue', 'org', 'pr', 'project',
                'release', 'repo', 'run', 'secret', 'ssh-key', 'status', 'workflow',
                'alias', 'api', 'completion', 'config', 'extension', 'gpg-key', 'help', 'version'
            )
            
            $completions += $mainCommands | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { 
                    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "gh $_")
                }
        }
        # Handle subcommands and options
        elseif ($words.Count -gt 2) {
            $subCommand = $words[1]
            
            switch ($subCommand) {
                'auth' {
                    $authCommands = @('login', 'logout', 'refresh', 'status', 'token')
                    if ($wordToComplete -like '-*') {
                        $options = @('--hostname', '--scopes', '--web', '--with-token')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    } else {
                        $completions += $authCommands | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "auth $_") }
                    }
                }
                'repo' {
                    $repoCommands = @('create', 'clone', 'fork', 'view', 'list', 'delete', 'archive', 'sync', 'rename')
                    if ($wordToComplete -like '-*') {
                        $options = @('--public', '--private', '--clone', '--description', '--homepage', '--team', '--template')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    } else {
                        $completions += $repoCommands | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "repo $_") }
                    }
                }
                'issue' {
                    $issueCommands = @('create', 'list', 'view', 'close', 'reopen', 'edit', 'comment', 'delete', 'pin', 'unpin', 'transfer')
                    if ($wordToComplete -like '-*') {
                        $options = @('--title', '--body', '--assignee', '--label', '--milestone', '--project', '--state', '--author', '--mention')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    } else {
                        $completions += $issueCommands | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "issue $_") }
                    }
                }
                'pr' {
                    $prCommands = @('create', 'list', 'view', 'checkout', 'close', 'merge', 'ready', 'draft', 'reopen', 'review', 'edit', 'comment')
                    if ($wordToComplete -like '-*') {
                        $options = @('--title', '--body', '--base', '--head', '--draft', '--assignee', '--reviewer', '--label', '--milestone', '--project')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    } else {
                        $completions += $prCommands | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "pr $_") }
                    }
                }
                'release' {
                    $releaseCommands = @('create', 'delete', 'download', 'list', 'upload', 'view')
                    if ($wordToComplete -like '-*') {
                        $options = @('--tag', '--target', '--title', '--notes', '--draft', '--prerelease', '--generate-notes')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    } else {
                        $completions += $releaseCommands | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "release $_") }
                    }
                }
                'workflow' {
                    $workflowCommands = @('list', 'view', 'run', 'enable', 'disable')
                    if ($wordToComplete -like '-*') {
                        $options = @('--ref', '--raw', '--json', '--all')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    } else {
                        $completions += $workflowCommands | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "workflow $_") }
                    }
                }
                'run' {
                    $runCommands = @('list', 'view', 'rerun', 'cancel', 'download', 'delete', 'watch')
                    if ($wordToComplete -like '-*') {
                        $options = @('--workflow', '--branch', '--event', '--status', '--limit', '--json')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    } else {
                        $completions += $runCommands | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "run $_") }
                    }
                }
                'gist' {
                    $gistCommands = @('create', 'delete', 'edit', 'list', 'view', 'clone')
                    if ($wordToComplete -like '-*') {
                        $options = @('--public', '--secret', '--filename', '--description')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    } else {
                        $completions += $gistCommands | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "gist $_") }
                    }
                }
                'config' {
                    $configCommands = @('get', 'set', 'list')
                    if ($wordToComplete -like '-*') {
                        $options = @('--host')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    } else {
                        $completions += $configCommands | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "config $_") }
                    }
                }
                'extension' {
                    $extCommands = @('install', 'list', 'remove', 'upgrade', 'create', 'browse')
                    $completions += $extCommands | Where-Object { $_ -like "$wordToComplete*" } |
                        ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "extension $_") }
                }
            }
        }
        
        # Global options that work with most commands
        if ($wordToComplete -like '-*') {
            $globalOptions = @('--help', '--version', '--repo', '--hostname', '--json')
            $completions += $globalOptions | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
        }
        
        return $completions
    }
    
    Register-ArgumentCompleter -CommandName 'gh' -ScriptBlock $GitHubScriptBlock
}