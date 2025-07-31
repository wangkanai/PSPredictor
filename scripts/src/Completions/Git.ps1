<#
.SYNOPSIS
    Git completion provider for PSPredictor
.DESCRIPTION
    Provides tab completion for Git commands and options
#>

function Register-GitCompletion {
    [CmdletBinding()]
    param()
    
    Write-Verbose "Registering Git completion"
    
    # Basic git completions
    $gitCommands = @(
        'add', 'branch', 'checkout', 'clone', 'commit', 'diff', 'fetch', 'init',
        'log', 'merge', 'pull', 'push', 'rebase', 'reset', 'status', 'stash',
        'remote', 'tag', 'show', 'rm', 'mv', 'config'
    )
    
    # Register argument completer for git command
    Register-ArgumentCompleter -CommandName 'git' -ScriptBlock {
        param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameter)
        
        $gitCommands | Where-Object { $_ -like "$WordToComplete*" } | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
    }
    
    Write-Verbose "Git completion registered successfully"
}