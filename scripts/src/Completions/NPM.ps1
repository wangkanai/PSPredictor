<#
.SYNOPSIS
    NPM completion provider for PSPredictor
.DESCRIPTION
    Provides tab completion for NPM commands and options
#>

function Register-NPMCompletion {
    [CmdletBinding()]
    param()
    
    Write-Verbose "Registering NPM completion"
    
    # Basic npm completions
    $npmCommands = @(
        'install', 'uninstall', 'update', 'run', 'start', 'test', 'build',
        'init', 'publish', 'pack', 'link', 'unlink', 'config', 'cache',
        'search', 'view', 'list', 'outdated', 'audit', 'fund', 'version'
    )
    
    # Register argument completer for npm command
    Register-ArgumentCompleter -CommandName 'npm' -ScriptBlock {
        param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameter)
        
        $npmCommands | Where-Object { $_ -like "$WordToComplete*" } | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
    }
    
    Write-Verbose "NPM completion registered successfully"
}