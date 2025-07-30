<#
.SYNOPSIS
    Registers completion for a specific CLI tool
.DESCRIPTION
    Enables tab completion for the specified CLI tool using PSPredictor
.PARAMETER Tool
    The CLI tool to register completion for
.EXAMPLE
    Register-PSPredictorCompletion -Tool "git"
.EXAMPLE
    Register-PSPredictorCompletion -Tool "docker"
#>
function Register-PSPredictorCompletion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Tool,
        
        [Parameter()]
        [scriptblock]$ScriptBlock
    )
    
    if (-not $script:SupportedTools.ContainsKey($Tool)) {
        Write-Warning "Tool '$Tool' is not supported. Use Get-PSPredictorTools to see supported tools."
        return
    }
    
    # Check if tool is available on the system
    $toolCommand = Get-Command $Tool -ErrorAction SilentlyContinue
    if (-not $toolCommand) {
        Write-Verbose "Tool '$Tool' is not available on this system"
        return
    }
    
    Write-Verbose "Registering completion for $Tool"
    
    # If a custom ScriptBlock is provided, use it instead of default handler
    if ($ScriptBlock) {
        Write-Verbose "Using custom ScriptBlock for $Tool completion"
        Register-ArgumentCompleter -CommandName $Tool -ScriptBlock $ScriptBlock
        return
    }
    
    # Call the specific completion registration function
    switch ($Tool.ToLower()) {
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
        'claude' { Register-ClaudeCompletion }
        'gemini' { Register-GeminiCompletion }
        'gh' { Register-GitHubCompletion }
        default {
            Write-Warning "No completion handler found for tool: $Tool"
        }
    }
}