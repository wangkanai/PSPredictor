<#
.SYNOPSIS
    Python interpreter completion provider for PSPredictor
.DESCRIPTION
    Provides comprehensive tab completion for Python interpreter options and modules
#>

function Register-PythonCompletion {
    $PythonScriptBlock = {
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
        
        $completions = @()
        
        # Get the full command line to understand context
        $commandLine = $commandAst.ToString()
        $words = $commandLine -split '\s+' | Where-Object { $_ -ne '' }
        
        # Python command-line options
        if ($wordToComplete -like '-*') {
            $options = @(
                '-c', '-m', '-i', '-u', '-v', '-V', '--version', '-h', '--help',
                '-B', '-d', '-E', '-I', '-O', '-OO', '-q', '-s', '-S', '-t', '-tt',
                '-W', '-x', '-X', '--check-hash-based-pycs'
            )
            $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
        }
        # Handle -m module completion
        elseif ($words.Count -gt 2 -and $words[1] -eq '-m') {
            # Common Python modules
            $modules = @(
                'pip', 'venv', 'http.server', 'json.tool', 'calendar', 'timeit',
                'pdb', 'profile', 'cProfile', 'trace', 'dis', 'compileall',
                'py_compile', 'zipfile', 'tarfile', 'webbrowser', 'uuid',
                'base64', 'urllib.request', 'urllib.parse', 'smtplib', 'ftplib',
                'telnetlib', 'zipapp', 'ensurepip', 'site', 'sysconfig'
            )
            $completions += $modules | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "Module: $_") }
        }
        
        return $completions
    }
    
    Register-ArgumentCompleter -CommandName 'python' -ScriptBlock $PythonScriptBlock
    # Also register for python3 if available
    Register-ArgumentCompleter -CommandName 'python3' -ScriptBlock $PythonScriptBlock
}