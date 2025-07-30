#Requires -Version 5.1
#Requires -Modules PSReadLine

<#
.SYNOPSIS
    PSPredictor - PowerShell Universal CLI Predictor

.DESCRIPTION
    Comprehensive auto-completion and intelligent prediction for popular command-line tools in PowerShell.
    Provides enhanced tab completion for Git, Docker, NPM, kubectl, Azure CLI, AWS CLI, and many more tools.

.AUTHOR
    Sarin Na Wangkanai

.VERSION
    1.0.0

.LINK
    https://github.com/wangkanai/PSPredictor
#>

# Module configuration
$script:PSPredictorConfig = @{
    Enabled = $true
    MaxSuggestions = 15
    CaseSensitive = $false
    FuzzyMatching = $true
    AutoUpdate = $true
    CompletionPath = "$env:USERPROFILE\.pspredict"
    EnabledTools = @()
    DisabledTools = @()
}

# Supported CLI tools registry
$script:SupportedTools = @{
    'git' = @{
        Description = 'Git version control system'
        CompletionScript = 'Git-Completion.ps1'
        Enabled = $true
    }
    'docker' = @{
        Description = 'Docker container platform'
        CompletionScript = 'Docker-Completion.ps1'
        Enabled = $true
    }
    'npm' = @{
        Description = 'Node Package Manager'
        CompletionScript = 'NPM-Completion.ps1'
        Enabled = $true
    }
    'yarn' = @{
        Description = 'Yarn package manager'
        CompletionScript = 'Yarn-Completion.ps1'
        Enabled = $true
    }
    'pnpm' = @{
        Description = 'PNPM package manager'
        CompletionScript = 'PNPM-Completion.ps1'
        Enabled = $true
    }
    'kubectl' = @{
        Description = 'Kubernetes command-line tool'
        CompletionScript = 'Kubectl-Completion.ps1'
        Enabled = $true
    }
    'az' = @{
        Description = 'Azure CLI'
        CompletionScript = 'Azure-Completion.ps1'
        Enabled = $true
    }
    'aws' = @{
        Description = 'AWS CLI'
        CompletionScript = 'AWS-Completion.ps1'
        Enabled = $true
    }
    'dotnet' = @{
        Description = '.NET CLI'
        CompletionScript = 'Dotnet-Completion.ps1'
        Enabled = $true
    }
    'terraform' = @{
        Description = 'Terraform infrastructure tool'
        CompletionScript = 'Terraform-Completion.ps1'
        Enabled = $true
    }
}

#region Core Functions

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
    
    # Initialize completion directory
    if (-not (Test-Path $script:PSPredictorConfig.CompletionPath)) {
        New-Item -Path $script:PSPredictorConfig.CompletionPath -ItemType Directory -Force | Out-Null
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

<#
.SYNOPSIS
    Uninstalls PSPredictor completion system
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

<#
.SYNOPSIS
    Registers completion for a specific CLI tool
.PARAMETER Tool
    The CLI tool to register completion for
.EXAMPLE
    Register-PSPredictorCompletion -Tool "git"
#>
function Register-PSPredictorCompletion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Tool,
        
        [scriptblock]$ScriptBlock
    )
    
    if (-not $script:SupportedTools.ContainsKey($Tool)) {
        Write-Warning "Tool '$Tool' is not supported. Use Get-PSPredictorTools to see supported tools."
        return
    }
    
    try {
        if ($ScriptBlock) {
            # Use provided script block
            Register-ArgumentCompleter -Native -CommandName $Tool -ScriptBlock $ScriptBlock
        } else {
            # Use built-in completion for the tool
            switch ($Tool) {
                'git' { Register-GitCompletion }
                'docker' { Register-DockerCompletion }
                'npm' { Register-NPMCompletion }
                'yarn' { Register-YarnCompletion }
                'pnpm' { Register-PNPMCompletion }
                'kubectl' { Register-KubectlCompletion }
                'az' { Register-AzureCompletion }
                'aws' { Register-AWSCompletion }
                'dotnet' { Register-DotnetCompletion }
                'terraform' { Register-TerraformCompletion }
                default {
                    Write-Warning "No built-in completion available for '$Tool'"
                    return
                }
            }
        }
        
        Write-Verbose "Registered completion for '$Tool'"
    } catch {
        Write-Error "Failed to register completion for '$Tool': $_"
    }
}

<#
.SYNOPSIS
    Unregisters completion for a specific CLI tool
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
    
    try {
        # Remove the argument completer (PowerShell doesn't have a direct way to unregister)
        # This is a workaround that clears the completion
        Register-ArgumentCompleter -Native -CommandName $Tool -ScriptBlock { }
        Write-Verbose "Unregistered completion for '$Tool'"
    } catch {
        Write-Error "Failed to unregister completion for '$Tool': $_"
    }
}

<#
.SYNOPSIS
    Gets the list of supported CLI tools
.EXAMPLE
    Get-PSPredictorTools
#>
function Get-PSPredictorTools {
    [CmdletBinding()]
    param()
    
    $tools = foreach ($tool in $script:SupportedTools.Keys) {
        [PSCustomObject]@{
            Tool = $tool
            Description = $script:SupportedTools[$tool].Description
            Enabled = $script:SupportedTools[$tool].Enabled
            Available = (Get-Command $tool -ErrorAction SilentlyContinue) -ne $null
        }
    }
    
    return $tools | Sort-Object Tool
}

<#
.SYNOPSIS
    Configures PSPredictor settings
.EXAMPLE
    Set-PSPredictorConfig -MaxSuggestions 20 -FuzzyMatching $false
#>
function Set-PSPredictorConfig {
    [CmdletBinding()]
    param(
        [int]$MaxSuggestions,
        [bool]$CaseSensitive,
        [bool]$FuzzyMatching,
        [bool]$AutoUpdate,
        [string]$CompletionPath,
        [string]$Tool,
        [bool]$Enabled
    )
    
    if ($PSBoundParameters.ContainsKey('MaxSuggestions')) {
        $script:PSPredictorConfig.MaxSuggestions = $MaxSuggestions
    }
    
    if ($PSBoundParameters.ContainsKey('CaseSensitive')) {
        $script:PSPredictorConfig.CaseSensitive = $CaseSensitive
    }
    
    if ($PSBoundParameters.ContainsKey('FuzzyMatching')) {
        $script:PSPredictorConfig.FuzzyMatching = $FuzzyMatching
    }
    
    if ($PSBoundParameters.ContainsKey('AutoUpdate')) {
        $script:PSPredictorConfig.AutoUpdate = $AutoUpdate
    }
    
    if ($PSBoundParameters.ContainsKey('CompletionPath')) {
        $script:PSPredictorConfig.CompletionPath = $CompletionPath
    }
    
    if ($Tool -and $PSBoundParameters.ContainsKey('Enabled')) {
        if ($script:SupportedTools.ContainsKey($Tool)) {
            $script:SupportedTools[$Tool].Enabled = $Enabled
            if ($Enabled) {
                Register-PSPredictorCompletion -Tool $Tool
            } else {
                Unregister-PSPredictorCompletion -Tool $Tool
            }
        }
    }
}

<#
.SYNOPSIS
    Enables completion for a specific tool
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
    
    Set-PSPredictorConfig -Tool $Tool -Enabled $true
    Write-Host "✅ Enabled completion for '$Tool'" -ForegroundColor Green
}

<#
.SYNOPSIS
    Disables completion for a specific tool
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
    
    Set-PSPredictorConfig -Tool $Tool -Enabled $false
    Write-Host "🔇 Disabled completion for '$Tool'" -ForegroundColor Yellow
}

<#
.SYNOPSIS
    Updates completion data for all tools
.EXAMPLE
    Update-PSPredictorCompletions
#>
function Update-PSPredictorCompletions {
    [CmdletBinding()]
    param()
    
    Write-Host "🔄 Updating PSPredictor completions..." -ForegroundColor Yellow
    
    foreach ($tool in $script:SupportedTools.Keys) {
        if ($script:SupportedTools[$tool].Enabled) {
            Register-PSPredictorCompletion -Tool $tool
        }
    }
    
    Write-Host "✅ Completions updated successfully!" -ForegroundColor Green
}

<#
.SYNOPSIS
    Gets completion suggestions for a command
.EXAMPLE
    Get-PSPredictorCompletion -Command "git" -Word "che"
#>
function Get-PSPredictorCompletion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Command,
        
        [string]$Word = "",
        
        [string]$CommandLine = "",
        
        [int]$CursorPosition = 0
    )
    
    # This is a placeholder for the actual completion logic
    # In a real implementation, this would delegate to specific completion handlers
    return @()
}

#endregion

#region Built-in Completions

# Git completion
function Register-GitCompletion {
    Register-ArgumentCompleter -Native -CommandName git -ScriptBlock {
        param($wordToComplete, $commandAst, $cursorPosition)
        
        $gitCommands = @(
            'add', 'branch', 'checkout', 'clone', 'commit', 'diff', 'fetch', 'init',
            'log', 'merge', 'pull', 'push', 'rebase', 'reset', 'status', 'tag'
        )
        
        $gitCommands | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
    }
}

# Docker completion
function Register-DockerCompletion {
    Register-ArgumentCompleter -Native -CommandName docker -ScriptBlock {
        param($wordToComplete, $commandAst, $cursorPosition)
        
        $dockerCommands = @(
            'build', 'run', 'ps', 'images', 'pull', 'push', 'exec', 'logs',
            'stop', 'start', 'restart', 'rm', 'rmi', 'volume', 'network'
        )
        
        $dockerCommands | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
    }
}

# NPM completion
function Register-NPMCompletion {
    Register-ArgumentCompleter -Native -CommandName npm -ScriptBlock {
        param($wordToComplete, $commandAst, $cursorPosition)
        
        $npmCommands = @(
            'install', 'uninstall', 'update', 'run', 'start', 'test', 'build',
            'init', 'publish', 'version', 'audit', 'outdated', 'list'
        )
        
        $npmCommands | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
    }
}

# Additional completion functions for other tools would go here...
function Register-YarnCompletion { }
function Register-PNPMCompletion { }
function Register-KubectlCompletion { }
function Register-AzureCompletion { }
function Register-AWSCompletion { }
function Register-DotnetCompletion { }
function Register-TerraformCompletion { }

#endregion

#region Aliases

New-Alias -Name pspredict -Value Install-PSPredictor -Force
New-Alias -Name psp -Value Get-PSPredictorTools -Force

#endregion

#region Module Initialization

# Auto-install on import if enabled
if ($script:PSPredictorConfig.Enabled) {
    Write-Host "🎯 PSPredictor loaded! Enhanced CLI completions ready." -ForegroundColor Cyan
    Write-Host "💡 Run 'Install-PSPredictor' to enable all completions." -ForegroundColor Yellow
}

#endregion

# Export module members
Export-ModuleMember -Function @(
    'Install-PSPredictor',
    'Uninstall-PSPredictor',
    'Get-PSPredictorCompletion',
    'Set-PSPredictorConfig',
    'Register-PSPredictorCompletion',
    'Unregister-PSPredictorCompletion',
    'Update-PSPredictorCompletions',
    'Enable-PSPredictorTool',
    'Disable-PSPredictorTool',
    'Get-PSPredictorTools'
) -Alias @('pspredict', 'psp')