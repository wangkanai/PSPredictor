<#
.SYNOPSIS
    PowerShell Core (pwsh) completion provider for PSPredictor

.DESCRIPTION
    Provides intelligent completion for PowerShell Core commands, parameters, and options
#>

function Register-PowerShellCompletion {
    $PowerShellCompletion = {
        param($wordToComplete, $commandAst, $cursorPosition)
        
        $completions = @()
        $command = $commandAst.CommandElements
        
        # If we're completing the first argument after pwsh
        if ($command.Count -eq 2) {
            $completions += @(
                # Common parameters
                [System.Management.Automation.CompletionResult]::new('-Command', '-Command', 'ParameterName', 'Execute specified command(s)')
                [System.Management.Automation.CompletionResult]::new('-File', '-File', 'ParameterName', 'Execute the specified script file')
                [System.Management.Automation.CompletionResult]::new('-ConfigurationName', '-ConfigurationName', 'ParameterName', 'Specifies a configuration endpoint')
                [System.Management.Automation.CompletionResult]::new('-ExecutionPolicy', '-ExecutionPolicy', 'ParameterName', 'Sets the execution policy')
                [System.Management.Automation.CompletionResult]::new('-InputFormat', '-InputFormat', 'ParameterName', 'Describes the format of data sent to PowerShell')
                [System.Management.Automation.CompletionResult]::new('-OutputFormat', '-OutputFormat', 'ParameterName', 'Determines how output is formatted')
                [System.Management.Automation.CompletionResult]::new('-WindowStyle', '-WindowStyle', 'ParameterName', 'Sets the window style for the session')
                [System.Management.Automation.CompletionResult]::new('-EncodedCommand', '-EncodedCommand', 'ParameterName', 'Accepts a base64 encoded string version of a command')
                
                # Common switches
                [System.Management.Automation.CompletionResult]::new('-NoExit', '-NoExit', 'ParameterName', 'Does not exit after running startup commands')
                [System.Management.Automation.CompletionResult]::new('-NoLogo', '-NoLogo', 'ParameterName', 'Hides the copyright banner at startup')
                [System.Management.Automation.CompletionResult]::new('-NonInteractive', '-NonInteractive', 'ParameterName', 'Does not present an interactive prompt to the user')
                [System.Management.Automation.CompletionResult]::new('-NoProfile', '-NoProfile', 'ParameterName', 'Does not load the PowerShell profile')
                [System.Management.Automation.CompletionResult]::new('-Sta', '-Sta', 'ParameterName', 'Starts PowerShell using a single-threaded apartment')
                [System.Management.Automation.CompletionResult]::new('-Mta', '-Mta', 'ParameterName', 'Starts PowerShell using a multi-threaded apartment')
                [System.Management.Automation.CompletionResult]::new('-Version', '-Version', 'ParameterName', 'Displays the version of PowerShell')
                [System.Management.Automation.CompletionResult]::new('-Help', '-Help', 'ParameterName', 'Shows this help message')
                
                # Interactive mode options
                [System.Management.Automation.CompletionResult]::new('-Interactive', '-Interactive', 'ParameterName', 'Interactive mode')
                [System.Management.Automation.CompletionResult]::new('-Login', '-Login', 'ParameterName', 'Login shell mode')
                [System.Management.Automation.CompletionResult]::new('-SSHServerMode', '-SSHServerMode', 'ParameterName', 'SSH server mode')
                [System.Management.Automation.CompletionResult]::new('-SettingsFile', '-SettingsFile', 'ParameterName', 'Override the system-wide powershell.config.json settings file')
                [System.Management.Automation.CompletionResult]::new('-CustomPipeName', '-CustomPipeName', 'ParameterName', 'Specifies the name to use for additional IPC server')
            )
        }
        
        # Handle specific parameter completions
        if ($command.Count -ge 3) {
            $previousParam = $command[-2].ToString()
            
            switch -Regex ($previousParam) {
                '-ExecutionPolicy' {
                    $completions += @(
                        [System.Management.Automation.CompletionResult]::new('Restricted', 'Restricted', 'ParameterValue', 'Does not load configuration files or run scripts')
                        [System.Management.Automation.CompletionResult]::new('AllSigned', 'AllSigned', 'ParameterValue', 'Requires that all scripts and configuration files be signed')
                        [System.Management.Automation.CompletionResult]::new('RemoteSigned', 'RemoteSigned', 'ParameterValue', 'Requires that all scripts and configuration files downloaded from the Internet be signed')
                        [System.Management.Automation.CompletionResult]::new('Unrestricted', 'Unrestricted', 'ParameterValue', 'Loads all configuration files and runs all scripts')
                        [System.Management.Automation.CompletionResult]::new('Bypass', 'Bypass', 'ParameterValue', 'Nothing is blocked and there are no warnings or prompts')
                        [System.Management.Automation.CompletionResult]::new('Undefined', 'Undefined', 'ParameterValue', 'Removes the currently assigned execution policy from the current scope')
                    )
                }
                '-WindowStyle' {
                    $completions += @(
                        [System.Management.Automation.CompletionResult]::new('Normal', 'Normal', 'ParameterValue', 'Normal window')
                        [System.Management.Automation.CompletionResult]::new('Minimized', 'Minimized', 'ParameterValue', 'Minimized window')
                        [System.Management.Automation.CompletionResult]::new('Maximized', 'Maximized', 'ParameterValue', 'Maximized window')
                        [System.Management.Automation.CompletionResult]::new('Hidden', 'Hidden', 'ParameterValue', 'Hidden window')
                    )
                }
                '-InputFormat|OutputFormat' {
                    $completions += @(
                        [System.Management.Automation.CompletionResult]::new('Text', 'Text', 'ParameterValue', 'Text strings')
                        [System.Management.Automation.CompletionResult]::new('XML', 'XML', 'ParameterValue', 'Serialized XML format')
                    )
                }
                '-File' {
                    # Complete .ps1 files in current directory
                    $ps1Files = Get-ChildItem -Path "*.ps1" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name
                    foreach ($file in $ps1Files) {
                        $completions += [System.Management.Automation.CompletionResult]::new($file, $file, 'ParameterValue', "PowerShell script: $file")
                    }
                }
            }
        }
        
        # Filter completions based on what user has typed
        if ($wordToComplete) {
            $completions = $completions | Where-Object { $_.CompletionText -like "$wordToComplete*" }
        }
        
        return $completions
    }
    
    Register-ArgumentCompleter -CommandName 'pwsh' -ScriptBlock $PowerShellCompletion
}