<#
.SYNOPSIS
    Installs PSPredictor completion system
.DESCRIPTION
    Sets up PSPredictor with enhanced tab completion for supported CLI tools.
    Can optionally configure PSReadLine to work optimally with PSPredictor.
.PARAMETER Force
    Forces installation and PSReadLine configuration without prompts
.PARAMETER ConfigurePSReadLine
    Configures PSReadLine Tab handler for optimal PSPredictor experience
.EXAMPLE
    Install-PSPredictor
    Installs PSPredictor with default settings
.EXAMPLE
    Install-PSPredictor -ConfigurePSReadLine
    Installs PSPredictor and configures PSReadLine for optimal Tab completion
.EXAMPLE
    Install-PSPredictor -Force
    Forces installation and configures PSReadLine automatically
#>
function Install-PSPredictor {
    [CmdletBinding()]
    param(
        [switch]$Force,
        [switch]$ConfigurePSReadLine
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
    
    # Configure PSReadLine for optimal completion experience
    if ($ConfigurePSReadLine -or $Force) {
        Write-Host "🔧 Configuring PSReadLine for PSPredictor..." -ForegroundColor Cyan
        
        # Check current Tab key handler
        $currentHandler = Get-PSReadLineKeyHandler | Where-Object { $_.Key -eq 'Tab' }
        
        if ($currentHandler -and $currentHandler.Function -eq 'MenuComplete') {
            Write-Host "⚠️  Current Tab handler is MenuComplete - this may interfere with PSPredictor" -ForegroundColor Yellow
            Write-Host "   Configuring hybrid completion (Complete first, then MenuComplete)" -ForegroundColor Yellow
            
            # Set up hybrid completion: Complete first, then MenuComplete on subsequent tabs
            Set-PSReadLineKeyHandler -Chord Tab -Function Complete
            Set-PSReadLineKeyHandler -Chord Shift+Tab -Function MenuComplete
            
            Write-Host "✅ PSReadLine configured:" -ForegroundColor Green
            Write-Host "   - Tab: Standard completion (includes PSPredictor)" -ForegroundColor Gray
            Write-Host "   - Shift+Tab: Menu completion" -ForegroundColor Gray
        } else {
            Write-Verbose "Tab handler is already compatible with PSPredictor"
        }
    } elseif ((Get-PSReadLineKeyHandler | Where-Object { $_.Key -eq 'Tab' -and $_.Function -eq 'MenuComplete' })) {
        Write-Host "⚠️  MenuComplete detected - use -ConfigurePSReadLine to fix Tab completion" -ForegroundColor Yellow
        Write-Host "   Or manually run: Set-PSReadLineKeyHandler -Chord Tab -Function Complete" -ForegroundColor Gray
    }
    
    # Register completions for enabled tools
    $registeredCount = 0
    foreach ($tool in $script:SupportedTools.Keys) {
        if ($script:SupportedTools[$tool].Enabled) {
            Register-PSPredictorCompletion -Tool $tool
            $registeredCount++
        }
    }
    
    Write-Host "✅ PSPredictor installed successfully!" -ForegroundColor Green
    Write-Host "📊 Registered $registeredCount CLI tool completions" -ForegroundColor Gray
    Write-Host "💡 Try typing: git che<TAB> or docker ru<TAB>" -ForegroundColor Yellow
}