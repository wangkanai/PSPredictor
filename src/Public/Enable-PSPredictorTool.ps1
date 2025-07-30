<#
.SYNOPSIS
    Enables a specific CLI tool in PSPredictor
.DESCRIPTION
    Enables the specified CLI tool for completion and registers its completion
.PARAMETER Tool
    The CLI tool to enable
.EXAMPLE
    Enable-PSPredictorTool -Tool "git"
#>
function Enable-PSPredictorTool {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Tool
    )
    
    if (-not $script:SupportedTools.ContainsKey($Tool)) {
        Write-Warning "Tool '$Tool' is not supported. Use Get-PSPredictorTools to see supported tools."
        return
    }
    
    $script:SupportedTools[$Tool].Enabled = $true
    Register-PSPredictorCompletion -Tool $Tool
    
    Write-Host "✅ Enabled completion for '$Tool'" -ForegroundColor Green
}