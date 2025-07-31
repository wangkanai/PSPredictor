<#
.SYNOPSIS
    Bash shell completion provider for PSPredictor

.DESCRIPTION
    Provides intelligent completion for Bash shell commands, options, and built-in functions
#>

function Register-BashCompletion {
    $BashCompletion = {
        param($wordToComplete, $commandAst, $cursorPosition)
        
        $completions = @()
        $command = $commandAst.CommandElements
        
        # If we're completing the first argument after bash
        if ($command.Count -eq 2) {
            $completions += @(
                # Common options
                [System.Management.Automation.CompletionResult]::new('-c', '-c', 'ParameterName', 'Execute command from string')
                [System.Management.Automation.CompletionResult]::new('-i', '-i', 'ParameterName', 'Interactive shell')
                [System.Management.Automation.CompletionResult]::new('-l', '-l', 'ParameterName', 'Login shell')
                [System.Management.Automation.CompletionResult]::new('-s', '-s', 'ParameterName', 'Read commands from stdin')
                [System.Management.Automation.CompletionResult]::new('-r', '-r', 'ParameterName', 'Restricted shell')
                [System.Management.Automation.CompletionResult]::new('-D', '-D', 'ParameterName', 'List double-quoted strings preceded by $')
                [System.Management.Automation.CompletionResult]::new('-v', '-v', 'ParameterName', 'Verbose mode - print shell input lines as they are read')
                [System.Management.Automation.CompletionResult]::new('-x', '-x', 'ParameterName', 'Print commands and their arguments as they are executed')
                [System.Management.Automation.CompletionResult]::new('-n', '-n', 'ParameterName', 'Read commands but do not execute them')
                
                # Long options
                [System.Management.Automation.CompletionResult]::new('--version', '--version', 'ParameterName', 'Display version information')
                [System.Management.Automation.CompletionResult]::new('--help', '--help', 'ParameterName', 'Display help information')
                [System.Management.Automation.CompletionResult]::new('--login', '--login', 'ParameterName', 'Make bash act as if invoked as login shell')
                [System.Management.Automation.CompletionResult]::new('--noprofile', '--noprofile', 'ParameterName', 'Do not read /etc/profile or personal initialization files')
                [System.Management.Automation.CompletionResult]::new('--norc', '--norc', 'ParameterName', 'Do not read ~/.bashrc')
                [System.Management.Automation.CompletionResult]::new('--posix', '--posix', 'ParameterName', 'Start bash in POSIX mode')
                [System.Management.Automation.CompletionResult]::new('--restricted', '--restricted', 'ParameterName', 'Start bash in restricted mode')
                [System.Management.Automation.CompletionResult]::new('--verbose', '--verbose', 'ParameterName', 'Print shell input lines as they are read')
                [System.Management.Automation.CompletionResult]::new('--rcfile', '--rcfile', 'ParameterName', 'Execute commands from file instead of ~/.bashrc')
                [System.Management.Automation.CompletionResult]::new('--init-file', '--init-file', 'ParameterName', 'Execute commands from file instead of ~/.bashrc')
                [System.Management.Automation.CompletionResult]::new('--debugger', '--debugger', 'ParameterName', 'Arrange for debugger profile to be executed before shell starts')
                [System.Management.Automation.CompletionResult]::new('--dump-po-strings', '--dump-po-strings', 'ParameterName', 'List all double-quoted strings preceded by $')
                [System.Management.Automation.CompletionResult]::new('--dump-strings', '--dump-strings', 'ParameterName', 'List all double-quoted strings')
                
                # Set options with -o
                [System.Management.Automation.CompletionResult]::new('-o', '-o', 'ParameterName', 'Set option')
                [System.Management.Automation.CompletionResult]::new('+o', '+o', 'ParameterName', 'Unset option')
                
                # Set options with --
                [System.Management.Automation.CompletionResult]::new('--', '--', 'ParameterName', 'End of options')
            )
        }
        
        # Handle specific parameter completions
        if ($command.Count -ge 3) {
            $previousParam = $command[-2].ToString()
            
            switch -Regex ($previousParam) {
                '-o|\+o' {
                    # Bash set options
                    $completions += @(
                        [System.Management.Automation.CompletionResult]::new('allexport', 'allexport', 'ParameterValue', 'Automatically export all variables')
                        [System.Management.Automation.CompletionResult]::new('braceexpand', 'braceexpand', 'ParameterValue', 'Enable brace expansion')
                        [System.Management.Automation.CompletionResult]::new('emacs', 'emacs', 'ParameterValue', 'Use emacs-style line editing interface')
                        [System.Management.Automation.CompletionResult]::new('errexit', 'errexit', 'ParameterValue', 'Exit immediately if a command returns non-zero status')
                        [System.Management.Automation.CompletionResult]::new('errtrace', 'errtrace', 'ParameterValue', 'ERR trap is inherited by shell functions')
                        [System.Management.Automation.CompletionResult]::new('functrace', 'functrace', 'ParameterValue', 'DEBUG trap is inherited by shell functions')
                        [System.Management.Automation.CompletionResult]::new('hashall', 'hashall', 'ParameterValue', 'Remember the location of commands as they are looked up')
                        [System.Management.Automation.CompletionResult]::new('histexpand', 'histexpand', 'ParameterValue', 'Enable history expansion with !')
                        [System.Management.Automation.CompletionResult]::new('history', 'history', 'ParameterValue', 'Enable command history')
                        [System.Management.Automation.CompletionResult]::new('ignoreeof', 'ignoreeof', 'ParameterValue', 'Do not exit shell on EOF')
                        [System.Management.Automation.CompletionResult]::new('interactive-comments', 'interactive-comments', 'ParameterValue', 'Allow comments in interactive shell')
                        [System.Management.Automation.CompletionResult]::new('keyword', 'keyword', 'ParameterValue', 'Place all assignment statements before command in environment')
                        [System.Management.Automation.CompletionResult]::new('monitor', 'monitor', 'ParameterValue', 'Enable job control')
                        [System.Management.Automation.CompletionResult]::new('noclobber', 'noclobber', 'ParameterValue', 'Prevent output redirection from overwriting existing files')
                        [System.Management.Automation.CompletionResult]::new('noexec', 'noexec', 'ParameterValue', 'Read commands but do not execute them')
                        [System.Management.Automation.CompletionResult]::new('noglob', 'noglob', 'ParameterValue', 'Disable filename expansion')
                        [System.Management.Automation.CompletionResult]::new('nolog', 'nolog', 'ParameterValue', 'Do not save function definitions in history')
                        [System.Management.Automation.CompletionResult]::new('notify', 'notify', 'ParameterValue', 'Report status of terminated background jobs immediately')
                        [System.Management.Automation.CompletionResult]::new('nounset', 'nounset', 'ParameterValue', 'Treat unset variables as an error')
                        [System.Management.Automation.CompletionResult]::new('onecmd', 'onecmd', 'ParameterValue', 'Exit after reading and executing one command')
                        [System.Management.Automation.CompletionResult]::new('physical', 'physical', 'ParameterValue', 'Do not follow symbolic links')
                        [System.Management.Automation.CompletionResult]::new('pipefail', 'pipefail', 'ParameterValue', 'Pipeline returns status of last command to exit with non-zero status')
                        [System.Management.Automation.CompletionResult]::new('posix', 'posix', 'ParameterValue', 'Match POSIX standard behavior')
                        [System.Management.Automation.CompletionResult]::new('privileged', 'privileged', 'ParameterValue', 'Turn on privileged mode')
                        [System.Management.Automation.CompletionResult]::new('verbose', 'verbose', 'ParameterValue', 'Print shell input lines as they are read')
                        [System.Management.Automation.CompletionResult]::new('vi', 'vi', 'ParameterValue', 'Use vi-style line editing interface')
                        [System.Management.Automation.CompletionResult]::new('xtrace', 'xtrace', 'ParameterValue', 'Print commands and their arguments as they are executed')
                    )
                }
                '--rcfile|--init-file' {
                    # Complete bash configuration files
                    $bashRcFiles = Get-ChildItem -Path ".*" -ErrorAction SilentlyContinue | Where-Object { $_.Name -match "(bashrc|bash_profile|profile)" } | Select-Object -ExpandProperty Name
                    foreach ($file in $bashRcFiles) {
                        $completions += [System.Management.Automation.CompletionResult]::new($file, $file, 'ParameterValue', "Bash RC file: $file")
                    }
                    
                    # Common paths
                    $completions += @(
                        [System.Management.Automation.CompletionResult]::new('~/.bashrc', '~/.bashrc', 'ParameterValue', 'User bash configuration')
                        [System.Management.Automation.CompletionResult]::new('~/.bash_profile', '~/.bash_profile', 'ParameterValue', 'User bash profile')
                        [System.Management.Automation.CompletionResult]::new('~/.profile', '~/.profile', 'ParameterValue', 'User shell profile')
                        [System.Management.Automation.CompletionResult]::new('/etc/bash.bashrc', '/etc/bash.bashrc', 'ParameterValue', 'System bash configuration')
                        [System.Management.Automation.CompletionResult]::new('/etc/profile', '/etc/profile', 'ParameterValue', 'System profile')
                    )
                }
            }
        }
        
        # Filter completions based on what user has typed
        if ($wordToComplete) {
            $completions = $completions | Where-Object { $_.CompletionText -like "$wordToComplete*" }
        }
        
        return $completions
    }
    
    Register-ArgumentCompleter -CommandName 'bash' -ScriptBlock $BashCompletion
}