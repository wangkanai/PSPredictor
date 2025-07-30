<#
.SYNOPSIS
    .NET CLI completion provider for PSPredictor
.DESCRIPTION
    Provides comprehensive tab completion for .NET CLI commands and options
#>

function Register-DotnetCompletion {
    $DotnetScriptBlock = {
        param($wordToComplete, $commandAst, $cursorPosition)
        
        $completions = @()
        
        # Get the full command line to understand context
        $commandLine = $commandAst.ToString()
        $words = $commandLine -split '\s+' | Where-Object { $_ -ne '' }
        
        # If we're at the first argument after 'dotnet'
        if ($words.Count -le 2) {
            # Main dotnet commands
            $mainCommands = @(
                'new', 'restore', 'build', 'publish', 'run', 'test', 'pack', 'clean',
                'sln', 'add', 'remove', 'list', 'nuget', 'tool', 'store', 'help',
                'dev-certs', 'fsi', 'format', 'workload', 'sdk'
            )
            
            $completions += $mainCommands | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { 
                    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "dotnet $_")
                }
        }
        # Handle subcommands and options
        elseif ($words.Count -gt 2) {
            $subCommand = $words[1]
            
            switch ($subCommand) {
                'new' {
                    if ($wordToComplete -like '-*') {
                        $options = @('--dry-run', '--force', '--language', '--name', '--output', '--search', '--install', '--uninstall', '--update-check', '--update-apply')
                        $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    } else {
                        # Template names
                        $templates = @(
                            'console', 'classlib', 'wpf', 'wpflib', 'wpfcustomcontrollib', 'wpfusercontrollib',
                            'winforms', 'winformslib', 'worker', 'mstest', 'nunit', 'xunit', 'web', 'mvc',
                            'webapi', 'angular', 'react', 'reactredux', 'blazorserver', 'blazorwasm',
                            'grpc', 'gitignore', 'globaljson', 'nugetconfig', 'webconfig', 'sln'
                        )
                        $completions += $templates | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "Template: $_") }
                    }
                }
                'build' {
                    $options = @('--configuration', '--framework', '--runtime', '--output', '--verbosity', '--no-restore', '--no-dependencies')
                    $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                        ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                }
                'run' {
                    $options = @('--configuration', '--framework', '--runtime', '--project', '--launch-profile', '--no-build', '--no-restore')
                    $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                        ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                }
                'test' {
                    $options = @('--configuration', '--framework', '--runtime', '--output', '--settings', '--logger', '--filter', '--collect', '--results-directory')
                    $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                        ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                }
                'publish' {
                    $options = @('--configuration', '--framework', '--runtime', '--output', '--self-contained', '--no-build', '--no-restore')
                    $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                        ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                }
                'add' {
                    $subOptions = @('package', 'reference')
                    $completions += $subOptions | Where-Object { $_ -like "$wordToComplete*" } |
                        ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "add $_") }
                }
                'tool' {
                    $toolCommands = @('install', 'uninstall', 'update', 'list', 'restore', 'run')
                    $completions += $toolCommands | Where-Object { $_ -like "$wordToComplete*" } |
                        ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "tool $_") }
                }
                'workload' {
                    $workloadCommands = @('install', 'uninstall', 'update', 'restore', 'list', 'search', 'repair')
                    $completions += $workloadCommands | Where-Object { $_ -like "$wordToComplete*" } |
                        ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "workload $_") }
                }
            }
        }
        
        return $completions
    }
    
    Register-ArgumentCompleter -Native -CommandName 'dotnet' -ScriptBlock $DotnetScriptBlock
}