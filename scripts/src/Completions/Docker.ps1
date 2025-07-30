<#
.SYNOPSIS
    Docker completion provider for PSPredictor
.DESCRIPTION
    Provides tab completion for Docker commands and options
#>

function Register-DockerCompletion {
    [CmdletBinding()]
    param()
    
    Write-Verbose "Registering Docker completion"
    
    # Basic docker completions
    $dockerCommands = @(
        'build', 'run', 'pull', 'push', 'ps', 'images', 'exec', 'logs',
        'stop', 'start', 'restart', 'rm', 'rmi', 'create', 'inspect',
        'network', 'volume', 'compose', 'system', 'version', 'info'
    )
    
    # Register argument completer for docker command
    Register-ArgumentCompleter -CommandName 'docker' -ScriptBlock {
        param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameter)
        
        $dockerCommands | Where-Object { $_ -like "$WordToComplete*" } | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
    }
    
    Write-Verbose "Docker completion registered successfully"
}