#Requires -Version 7.0

<#
.SYNOPSIS
    PSPredictor - PowerShell Universal CLI Predictor

.DESCRIPTION
    Comprehensive auto-completion and intelligent prediction for popular command-line tools in PowerShell.
    Provides enhanced tab completion for Git, Docker, NPM, kubectl, Azure CLI, AWS CLI, and many more tools.
    
    This modular version is designed for PowerShell 7+ with cross-platform compatibility.

.AUTHOR
    Sarin Na Wangkanai

.VERSION
    1.1.0

.LINK
    https://github.com/wangkanai/PSPredictor
#>

#region Module Initialization

# Get the module root path
$ModuleRoot = $PSScriptRoot

# Import configuration and core functionality
Write-Verbose "Loading PSPredictor configuration..."
. (Join-Path $ModuleRoot 'Private' 'Config.ps1')

# Import all public functions
Write-Verbose "Loading public functions..."
$PublicFunctions = @()
Get-ChildItem -Path (Join-Path $ModuleRoot 'Public') -Filter '*.ps1' | ForEach-Object {
    Write-Verbose "Loading function: $($_.BaseName)"
    . $_.FullName
    $PublicFunctions += $_.BaseName
}

# Import all completion providers
Write-Verbose "Loading completion providers..."
Get-ChildItem -Path (Join-Path $ModuleRoot 'Completions') -Filter '*.ps1' | ForEach-Object {
    Write-Verbose "Loading completion provider: $($_.BaseName)"
    . $_.FullName
}

#endregion

#region Module Initialization

# Auto-install on import if enabled
if ($script:PSPredictorConfig.Enabled) {
    # Module loaded silently - use Install-PSPredictor to enable completions
}

#endregion

#region Export Module Members

# Set up aliases
Set-Alias -Name 'pspredict' -Value 'Install-PSPredictor'
Set-Alias -Name 'psp' -Value 'Get-PSPredictorTools'

# Export all public functions
Export-ModuleMember -Function $PublicFunctions

# Export aliases
Export-ModuleMember -Alias @('pspredict', 'psp')

#endregion

Write-Verbose "PSPredictor module loaded successfully (modular version)"