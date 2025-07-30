<#
.SYNOPSIS
    Configures PSPredictor settings
.DESCRIPTION
    Updates PSPredictor configuration settings for completion behavior
.PARAMETER MaxSuggestions
    Maximum number of completion suggestions to display
.PARAMETER CaseSensitive
    Enable case-sensitive completion matching
.PARAMETER FuzzyMatching
    Enable fuzzy matching for completions
.PARAMETER Tool
    Specific tool to configure
.PARAMETER Enabled
    Enable or disable a specific tool
.EXAMPLE
    Set-PSPredictorConfig -MaxSuggestions 20
.EXAMPLE
    Set-PSPredictorConfig -Tool "git" -Enabled $true
#>
function Set-PSPredictorConfig {
    [CmdletBinding()]
    param(
        [int]$MaxSuggestions,
        [bool]$CaseSensitive,
        [bool]$FuzzyMatching,
        [string]$Tool,
        [bool]$Enabled
    )
    
    if ($PSBoundParameters.ContainsKey('MaxSuggestions')) {
        $script:PSPredictorConfig.MaxSuggestions = $MaxSuggestions
        Write-Verbose "Set MaxSuggestions to $MaxSuggestions"
    }
    
    if ($PSBoundParameters.ContainsKey('CaseSensitive')) {
        $script:PSPredictorConfig.CaseSensitive = $CaseSensitive
        Write-Verbose "Set CaseSensitive to $CaseSensitive"
    }
    
    if ($PSBoundParameters.ContainsKey('FuzzyMatching')) {
        $script:PSPredictorConfig.FuzzyMatching = $FuzzyMatching
        Write-Verbose "Set FuzzyMatching to $FuzzyMatching"
    }
    
    if ($Tool -and $PSBoundParameters.ContainsKey('Enabled')) {
        if ($script:SupportedTools.ContainsKey($Tool)) {
            $script:SupportedTools[$Tool].Enabled = $Enabled
            Write-Verbose "Set tool '$Tool' enabled status to $Enabled"
        } else {
            Write-Warning "Tool '$Tool' is not supported. Use Get-PSPredictorTools to see supported tools."
        }
    }
}