<#
.SYNOPSIS
    Installs PSPredictor completion system
.DESCRIPTION
    Sets up PSPredictor with enhanced tab completion for supported CLI tools
.EXAMPLE
    Install-PSPredictor
#>
function Install-PSPredictor {
    [CmdletBinding()]
    param(
        [switch]$Force
    )
    
    Write-Host "🚀 Installing PSPredictor..." -ForegroundColor Green
    
    # Initialize completion directory with error handling
    try {
        if (-not (Test-Path $script:PSPredictorConfig.CompletionPath)) {
            New-Item -Path $script:PSPredictorConfig.CompletionPath -ItemType Directory -Force | Out-Null
            Write-Verbose "Created completion directory: $($script:PSPredictorConfig.CompletionPath)"
        }
    } catch {
        Write-Warning "Could not create completion directory: $($_.Exception.Message)"
        Write-Warning "PSPredictor will work without persistent completions."
    }
    
    # Register completions for enabled tools
    foreach ($tool in $script:SupportedTools.Keys) {
        if ($script:SupportedTools[$tool].Enabled) {
            Register-PSPredictorCompletion -Tool $tool
        }
    }
    
    Write-Host "✅ PSPredictor installed successfully!" -ForegroundColor Green
    Write-Host "💡 Try typing: git che<TAB> or docker ru<TAB>" -ForegroundColor Yellow
}