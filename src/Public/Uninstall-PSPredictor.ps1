<#
.SYNOPSIS
    Uninstalls PSPredictor completion system
.DESCRIPTION
    Removes PSPredictor completions and cleans up the installation
.EXAMPLE
    Uninstall-PSPredictor
#>
function Uninstall-PSPredictor {
    [CmdletBinding()]
    param()
    
    Write-Host "🔄 Uninstalling PSPredictor..." -ForegroundColor Yellow
    
    # Unregister all completions
    foreach ($tool in $script:SupportedTools.Keys) {
        Unregister-PSPredictorCompletion -Tool $tool
    }
    
    Write-Host "✅ PSPredictor uninstalled successfully!" -ForegroundColor Green
}