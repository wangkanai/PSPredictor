<#
.SYNOPSIS
    Zsh shell completion provider for PSPredictor

.DESCRIPTION
    Provides intelligent completion for Zsh shell commands, options, and built-in functions
#>

function Register-ZshCompletion {
    $ZshCompletion = {
        param($wordToComplete, $commandAst, $cursorPosition)
        
        $completions = @()
        $command = $commandAst.CommandElements
        
        # If we're completing the first argument after zsh
        if ($command.Count -eq 2) {
            $completions += @(
                # Common options
                [System.Management.Automation.CompletionResult]::new('-c', '-c', 'ParameterName', 'Execute command from string')
                [System.Management.Automation.CompletionResult]::new('-i', '-i', 'ParameterName', 'Interactive shell')
                [System.Management.Automation.CompletionResult]::new('-l', '-l', 'ParameterName', 'Login shell')
                [System.Management.Automation.CompletionResult]::new('-s', '-s', 'ParameterName', 'Read commands from stdin')
                [System.Management.Automation.CompletionResult]::new('-x', '-x', 'ParameterName', 'Print commands and their arguments as they are executed')
                [System.Management.Automation.CompletionResult]::new('-v', '-v', 'ParameterName', 'Verbose mode - print shell input lines as they are read')
                
                # Long options
                [System.Management.Automation.CompletionResult]::new('--version', '--version', 'ParameterName', 'Display version information')
                [System.Management.Automation.CompletionResult]::new('--help', '--help', 'ParameterName', 'Display help information')
                [System.Management.Automation.CompletionResult]::new('--emulate', '--emulate', 'ParameterName', 'Emulate another shell')
                
                # Zsh-specific options
                [System.Management.Automation.CompletionResult]::new('-o', '-o', 'ParameterName', 'Set option')
                [System.Management.Automation.CompletionResult]::new('+o', '+o', 'ParameterName', 'Unset option')
                [System.Management.Automation.CompletionResult]::new('-f', '-f', 'ParameterName', 'Fast startup - do not run /etc/zshrc')
                [System.Management.Automation.CompletionResult]::new('-d', '-d', 'ParameterName', 'Do not use global rc files')
                [System.Management.Automation.CompletionResult]::new('-g', '-g', 'ParameterName', 'Do not use global startup files')
                [System.Management.Automation.CompletionResult]::new('-n', '-n', 'ParameterName', 'Do not execute commands, only check syntax')
                [System.Management.Automation.CompletionResult]::new('-u', '-u', 'ParameterName', 'Treat unset variables as an error')
                [System.Management.Automation.CompletionResult]::new('-y', '-y', 'ParameterName', 'Do not change the shell environment')
                [System.Management.Automation.CompletionResult]::new('-z', '-z', 'ParameterName', 'Do not use RCS files')
                
                # Debug and development options
                [System.Management.Automation.CompletionResult]::new('-X', '-X', 'ParameterName', 'Print commands and their arguments after expansion')
                [System.Management.Automation.CompletionResult]::new('-Y', '-Y', 'ParameterName', 'Start zsh in tracing mode')
            )
        }
        
        # Handle specific parameter completions
        if ($command.Count -ge 3) {
            $previousParam = $command[-2].ToString()
            
            switch -Regex ($previousParam) {
                '-o|\+o' {
                    # Zsh options
                    $completions += @(
                        [System.Management.Automation.CompletionResult]::new('allexport', 'allexport', 'ParameterValue', 'All variable assignments are exported')
                        [System.Management.Automation.CompletionResult]::new('autocd', 'autocd', 'ParameterValue', 'Directory name as command changes to that directory')
                        [System.Management.Automation.CompletionResult]::new('autopushd', 'autopushd', 'ParameterValue', 'Make cd push the old directory onto the directory stack')
                        [System.Management.Automation.CompletionResult]::new('beep', 'beep', 'ParameterValue', 'Beep on error in line editor')
                        [System.Management.Automation.CompletionResult]::new('bgnice', 'bgnice', 'ParameterValue', 'Run background jobs at lower priority')
                        [System.Management.Automation.CompletionResult]::new('braceccl', 'braceccl', 'ParameterValue', 'Make brace expansion work with character classes')
                        [System.Management.Automation.CompletionResult]::new('bsdecho', 'bsdecho', 'ParameterValue', 'Make echo builtin compatible with BSD echo')
                        [System.Management.Automation.CompletionResult]::new('cdablevars', 'cdablevars', 'ParameterValue', 'If argument to cd is not a directory, try to expand as variable')
                        [System.Management.Automation.CompletionResult]::new('chasedots', 'chasedots', 'ParameterValue', 'Resolve .. in paths')
                        [System.Management.Automation.CompletionResult]::new('chaselinks', 'chaselinks', 'ParameterValue', 'Resolve symbolic links to their true values')
                        [System.Management.Automation.CompletionResult]::new('checkjobs', 'checkjobs', 'ParameterValue', 'Report status of background jobs before exiting')
                        [System.Management.Automation.CompletionResult]::new('clobber', 'clobber', 'ParameterValue', 'Allow > redirection to overwrite existing files')
                        [System.Management.Automation.CompletionResult]::new('completealiases', 'completealiases', 'ParameterValue', 'Complete aliases as well as commands')
                        [System.Management.Automation.CompletionResult]::new('completeinword', 'completeinword', 'ParameterValue', 'Allow completion from within a word')
                        [System.Management.Automation.CompletionResult]::new('correct', 'correct', 'ParameterValue', 'Try to correct spelling of commands')
                        [System.Management.Automation.CompletionResult]::new('correctall', 'correctall', 'ParameterValue', 'Try to correct spelling of all arguments')
                        [System.Management.Automation.CompletionResult]::new('dvorak', 'dvorak', 'ParameterValue', 'Use Dvorak keyboard layout for spelling correction')
                        [System.Management.Automation.CompletionResult]::new('emacs', 'emacs', 'ParameterValue', 'Use emacs-style line editing')
                        [System.Management.Automation.CompletionResult]::new('errexit', 'errexit', 'ParameterValue', 'Exit immediately if a command returns non-zero status')
                        [System.Management.Automation.CompletionResult]::new('exec', 'exec', 'ParameterValue', 'Do not fork on exec')
                        [System.Management.Automation.CompletionResult]::new('extendedglob', 'extendedglob', 'ParameterValue', 'Use extended globbing patterns')
                        [System.Management.Automation.CompletionResult]::new('extendedhistory', 'extendedhistory', 'ParameterValue', 'Save timestamp and duration with history entries')
                        [System.Management.Automation.CompletionResult]::new('flowcontrol', 'flowcontrol', 'ParameterValue', 'Enable flow control (Ctrl-S/Ctrl-Q)')
                        [System.Management.Automation.CompletionResult]::new('glob', 'glob', 'ParameterValue', 'Perform filename generation (globbing)')
                        [System.Management.Automation.CompletionResult]::new('globdots', 'globdots', 'ParameterValue', 'Include files beginning with . in filename globbing')
                        [System.Management.Automation.CompletionResult]::new('hashcmds', 'hashcmds', 'ParameterValue', 'Hash commands as they are looked up')
                        [System.Management.Automation.CompletionResult]::new('hashdirs', 'hashdirs', 'ParameterValue', 'Hash directories as they are looked up')
                        [System.Management.Automation.CompletionResult]::new('histexpiredupsfirst', 'histexpiredupsfirst', 'ParameterValue', 'Expire duplicate entries first when trimming history')
                        [System.Management.Automation.CompletionResult]::new('histignoredups', 'histignoredups', 'ParameterValue', 'Do not enter duplicate lines in history')
                        [System.Management.Automation.CompletionResult]::new('histignorespace', 'histignorespace', 'ParameterValue', 'Do not enter lines starting with space in history')
                        [System.Management.Automation.CompletionResult]::new('histnostore', 'histnostore', 'ParameterValue', 'Do not store history or fc commands in history')
                        [System.Management.Automation.CompletionResult]::new('histreduceblanks', 'histreduceblanks', 'ParameterValue', 'Remove extra blanks from history lines')
                        [System.Management.Automation.CompletionResult]::new('histverify', 'histverify', 'ParameterValue', 'Verify history expansions before executing')
                        [System.Management.Automation.CompletionResult]::new('ignoreeof', 'ignoreeof', 'ParameterValue', 'Do not exit on EOF (Ctrl-D)')
                        [System.Management.Automation.CompletionResult]::new('interactive', 'interactive', 'ParameterValue', 'Interactive shell')
                        [System.Management.Automation.CompletionResult]::new('interactivecomments', 'interactivecomments', 'ParameterValue', 'Allow comments in interactive shell')
                        [System.Management.Automation.CompletionResult]::new('kshglob', 'kshglob', 'ParameterValue', 'Use ksh-style globbing patterns')
                        [System.Management.Automation.CompletionResult]::new('listambiguous', 'listambiguous', 'ParameterValue', 'List choices on ambiguous completion')
                        [System.Management.Automation.CompletionResult]::new('listbeep', 'listbeep', 'ParameterValue', 'Beep when listing completion choices')
                        [System.Management.Automation.CompletionResult]::new('listpacked', 'listpacked', 'ParameterValue', 'Try to make completion lists smaller by printing matches in columns')
                        [System.Management.Automation.CompletionResult]::new('listtypes', 'listtypes', 'ParameterValue', 'Show types of files in completion lists')
                        [System.Management.Automation.CompletionResult]::new('login', 'login', 'ParameterValue', 'Login shell')
                        [System.Management.Automation.CompletionResult]::new('longlistjobs', 'longlistjobs', 'ParameterValue', 'List jobs in long format by default')
                        [System.Management.Automation.CompletionResult]::new('magicequalsubst', 'magicequalsubst', 'ParameterValue', 'Perform filename expansion on arguments of = form')
                        [System.Management.Automation.CompletionResult]::new('mailwarning', 'mailwarning', 'ParameterValue', 'Print warning if mail file has been accessed')
                        [System.Management.Automation.CompletionResult]::new('markdirs', 'markdirs', 'ParameterValue', 'Append / to directory names in completion')
                        [System.Management.Automation.CompletionResult]::new('menucomplete', 'menucomplete', 'ParameterValue', 'Use menu completion')
                        [System.Management.Automation.CompletionResult]::new('monitor', 'monitor', 'ParameterValue', 'Enable job control')
                        [System.Management.Automation.CompletionResult]::new('multios', 'multios', 'ParameterValue', 'Perform multiple redirections')
                        [System.Management.Automation.CompletionResult]::new('nomatch', 'nomatch', 'ParameterValue', 'Print error if globbing pattern matches nothing')
                        [System.Management.Automation.CompletionResult]::new('notify', 'notify', 'ParameterValue', 'Report status of background jobs immediately')
                        [System.Management.Automation.CompletionResult]::new('nullglob', 'nullglob', 'ParameterValue', 'Remove non-matching glob patterns')
                        [System.Management.Automation.CompletionResult]::new('numericglobsort', 'numericglobsort', 'ParameterValue', 'Sort numerically when globbing')
                        [System.Management.Automation.CompletionResult]::new('overstrike', 'overstrike', 'ParameterValue', 'Use overstrike mode in line editor')
                        [System.Management.Automation.CompletionResult]::new('pathdirs', 'pathdirs', 'ParameterValue', 'Perform path search even on commands with slashes')
                        [System.Management.Automation.CompletionResult]::new('posixbuiltins', 'posixbuiltins', 'ParameterValue', 'Use POSIX builtin behavior')
                        [System.Management.Automation.CompletionResult]::new('printexitvalue', 'printexitvalue', 'ParameterValue', 'Print exit value of programs with non-zero exit status')
                        [System.Management.Automation.CompletionResult]::new('privileged', 'privileged', 'ParameterValue', 'Turn on privileged mode')
                        [System.Management.Automation.CompletionResult]::new('promptcr', 'promptcr', 'ParameterValue', 'Print CR before printing a prompt in line editor')
                        [System.Management.Automation.CompletionResult]::new('promptsp', 'promptsp', 'ParameterValue', 'Attempt to preserve partial lines that would be covered up by command prompt')
                        [System.Management.Automation.CompletionResult]::new('pushdignoredups', 'pushdignoredups', 'ParameterValue', 'Do not push duplicate directories onto stack')
                        [System.Management.Automation.CompletionResult]::new('pushdminus', 'pushdminus', 'ParameterValue', 'Exchange meaning of + and - in pushd/popd')
                        [System.Management.Automation.CompletionResult]::new('pushdsilent', 'pushdsilent', 'ParameterValue', 'Do not print directory stack after pushd/popd')
                        [System.Management.Automation.CompletionResult]::new('pushdtohome', 'pushdtohome', 'ParameterValue', 'pushd with no arguments goes to home directory')
                        [System.Management.Automation.CompletionResult]::new('rcexpandparam', 'rcexpandparam', 'ParameterValue', 'Array expansions with subscripts')
                        [System.Management.Automation.CompletionResult]::new('rcquotes', 'rcquotes', 'ParameterValue', 'Use rc-style quoting')
                        [System.Management.Automation.CompletionResult]::new('rcs', 'rcs', 'ParameterValue', 'Source /etc/zshrc and ~/.zshrc')
                        [System.Management.Automation.CompletionResult]::new('recexact', 'recexact', 'ParameterValue', 'Recognize exact matches even if they are ambiguous')
                        [System.Management.Automation.CompletionResult]::new('rematchpcre', 'rematchpcre', 'ParameterValue', 'Use PCRE library for =~ regex operator')
                        [System.Management.Automation.CompletionResult]::new('restricted', 'restricted', 'ParameterValue', 'Enable restricted shell mode')
                        [System.Management.Automation.CompletionResult]::new('rmstarsilent', 'rmstarsilent', 'ParameterValue', 'Do not query user before rm with *')
                        [System.Management.Automation.CompletionResult]::new('rmstarwait', 'rmstarwait', 'ParameterValue', 'Wait 10 seconds before querying for rm with *')
                        [System.Management.Automation.CompletionResult]::new('sharehistory', 'sharehistory', 'ParameterValue', 'Share history between all sessions')
                        [System.Management.Automation.CompletionResult]::new('shfileexpansion', 'shfileexpansion', 'ParameterValue', 'Use sh-style file expansion')
                        [System.Management.Automation.CompletionResult]::new('shglob', 'shglob', 'ParameterValue', 'Use sh-style globbing')
                        [System.Management.Automation.CompletionResult]::new('shinstdin', 'shinstdin', 'ParameterValue', 'Enable SHIN_STDIN option')
                        [System.Management.Automation.CompletionResult]::new('shnullcmd', 'shnullcmd', 'ParameterValue', 'Use sh-style null command behavior')
                        [System.Management.Automation.CompletionResult]::new('shoptionletters', 'shoptionletters', 'ParameterValue', 'Use sh-style option letters')
                        [System.Management.Automation.CompletionResult]::new('shortloops', 'shortloops', 'ParameterValue', 'Allow short loop syntax')
                        [System.Management.Automation.CompletionResult]::new('shwordsplit', 'shwordsplit', 'ParameterValue', 'Use sh-style word splitting')
                        [System.Management.Automation.CompletionResult]::new('singlelinezle', 'singlelinezle', 'ParameterValue', 'Use single line mode for line editor')
                        [System.Management.Automation.CompletionResult]::new('sourcetrace', 'sourcetrace', 'ParameterValue', 'Print script name when sourcing files')
                        [System.Management.Automation.CompletionResult]::new('sunkeyboardhack', 'sunkeyboardhack', 'ParameterValue', 'Use workaround for Sun keyboard')
                        [System.Management.Automation.CompletionResult]::new('transientrprompt', 'transientrprompt', 'ParameterValue', 'Remove right prompt when accepting line')
                        [System.Management.Automation.CompletionResult]::new('trapsasync', 'trapsasync', 'ParameterValue', 'Execute traps asynchronously')
                        [System.Management.Automation.CompletionResult]::new('typesetsilent', 'typesetsilent', 'ParameterValue', 'Make typeset not print values')
                        [System.Management.Automation.CompletionResult]::new('unset', 'unset', 'ParameterValue', 'Treat undefined variables as having empty value')
                        [System.Management.Automation.CompletionResult]::new('verbose', 'verbose', 'ParameterValue', 'Print shell input lines as they are read')
                        [System.Management.Automation.CompletionResult]::new('vi', 'vi', 'ParameterValue', 'Use vi-style line editing')
                        [System.Management.Automation.CompletionResult]::new('warncreateglobal', 'warncreateglobal', 'ParameterValue', 'Warn when creating global variables')
                        [System.Management.Automation.CompletionResult]::new('warnnestedvar', 'warnnestedvar', 'ParameterValue', 'Warn about nested variable assignments')
                        [System.Management.Automation.CompletionResult]::new('xtrace', 'xtrace', 'ParameterValue', 'Print commands and arguments as they are executed')
                        [System.Management.Automation.CompletionResult]::new('zle', 'zle', 'ParameterValue', 'Use zsh line editor')
                    )
                }
                '--emulate' {
                    $completions += @(
                        [System.Management.Automation.CompletionResult]::new('sh', 'sh', 'ParameterValue', 'Emulate Bourne shell')
                        [System.Management.Automation.CompletionResult]::new('ksh', 'ksh', 'ParameterValue', 'Emulate Korn shell')
                        [System.Management.Automation.CompletionResult]::new('csh', 'csh', 'ParameterValue', 'Emulate C shell')
                        [System.Management.Automation.CompletionResult]::new('bash', 'bash', 'ParameterValue', 'Emulate Bash shell')
                        [System.Management.Automation.CompletionResult]::new('zsh', 'zsh', 'ParameterValue', 'Use native zsh mode')
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
    
    Register-ArgumentCompleter -CommandName 'zsh' -ScriptBlock $ZshCompletion
}