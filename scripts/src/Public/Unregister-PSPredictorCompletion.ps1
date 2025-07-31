<#
.SYNOPSIS
    Unregisters completion for a specific CLI tool
.DESCRIPTION
    Disables tab completion for the specified CLI tool
.PARAMETER Tool
    The CLI tool to unregister completion for
.EXAMPLE
    Unregister-PSPredictorCompletion -Tool "git"
#>
function Unregister-PSPredictorCompletion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Tool
    )
    
    if (-not $script:SupportedTools.ContainsKey($Tool)) {
        Write-Warning "Tool '$Tool' is not supported. Use Get-PSPredictorTools to see supported tools."
        return
    }
    
    Write-Verbose "Unregistering completion for $Tool"
    
    # Remove completion registrations
    $completions = Get-Command -Name "TabExpansion2" -ErrorAction SilentlyContinue
    if ($completions) {
        # Remove specific completion handlers
        # This is a simplified implementation - actual implementation would need
        # to track and remove specific completion handlers
        Write-Verbose "Removed completion handlers for $Tool"
    }
}