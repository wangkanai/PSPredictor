<#
.SYNOPSIS
    Updates all PSPredictor completions
.DESCRIPTION
    Refreshes completion registrations for all enabled CLI tools
.EXAMPLE
    Update-PSPredictorCompletions
#>
function Update-PSPredictorCompletions {
    [CmdletBinding()]
    param()
    
    Write-Host "🔄 Updating PSPredictor completions..." -ForegroundColor Cyan
    
    foreach ($tool in $script:SupportedTools.Keys) {
        if ($script:SupportedTools[$tool].Enabled) {
            Register-PSPredictorCompletion -Tool $tool
        }
    }
    
    Write-Host "✅ Completions updated successfully!" -ForegroundColor Green
}