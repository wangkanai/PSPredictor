<#
.SYNOPSIS
    Gets supported CLI tools for PSPredictor
.DESCRIPTION
    Returns a list of all supported CLI tools with their status and availability
.EXAMPLE
    Get-PSPredictorTools
.EXAMPLE
    Get-PSPredictorTools | Where-Object Available
#>
function Get-PSPredictorTools {
    [CmdletBinding()]
    param()
    
    $tools = @()
    foreach ($tool in $script:SupportedTools.Keys) {
        $toolInfo = $script:SupportedTools[$tool]
        $available = $null -ne (Get-Command $tool -ErrorAction SilentlyContinue)
        
        $tools += [PSCustomObject]@{
            Tool = $tool
            Description = $toolInfo.Description
            Enabled = $toolInfo.Enabled
            Available = $available
        }
    }
    
    return $tools | Sort-Object Tool
}