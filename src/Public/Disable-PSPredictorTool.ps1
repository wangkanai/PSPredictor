<#
.SYNOPSIS
    Disables a specific CLI tool in PSPredictor
.DESCRIPTION
    Disables the specified CLI tool and unregisters its completion
.PARAMETER Tool
    The CLI tool to disable
.EXAMPLE
    Disable-PSPredictorTool -Tool "git"
#>
function Disable-PSPredictorTool {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Tool
    )
    
    if (-not $script:SupportedTools.ContainsKey($Tool)) {
        Write-Warning "Tool '$Tool' is not supported. Use Get-PSPredictorTools to see supported tools."
        return
    }
    
    $script:SupportedTools[$Tool].Enabled = $false
    Unregister-PSPredictorCompletion -Tool $Tool
    
    Write-Host "🔇 Disabled completion for '$Tool'" -ForegroundColor Yellow
}