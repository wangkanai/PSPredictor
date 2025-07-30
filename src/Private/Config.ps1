<#
.SYNOPSIS
    PSPredictor configuration management

.DESCRIPTION
    Core configuration settings and cross-platform path handling for PSPredictor module.
#>

# Module configuration
$script:PSPredictorConfig = @{
    Enabled = $true
    MaxSuggestions = 15
    CaseSensitive = $false
    FuzzyMatching = $true
    AutoUpdate = $true
    CompletionPath = if ($IsWindows -or $env:OS -eq 'Windows_NT') {
        Join-Path $env:USERPROFILE '.pspredict'
    } else {
        Join-Path $env:HOME '.pspredict'
    }
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
    'claude' = @{
        Description = 'Claude AI CLI'
        CompletionScript = 'Claude-Completion.ps1'
        Enabled = $true
    }
    'gemini' = @{
        Description = 'Google Gemini AI CLI'
        CompletionScript = 'Gemini-Completion.ps1'
        Enabled = $true
    }
    'gh' = @{
        Description = 'GitHub CLI'
        CompletionScript = 'GitHub-Completion.ps1'
        Enabled = $true
    }
    'podman' = @{
        Description = 'Podman container tool'
        CompletionScript = 'Podman-Completion.ps1'
        Enabled = $true
    }
    'tmux' = @{
        Description = 'Terminal multiplexer'
        CompletionScript = 'Tmux-Completion.ps1'
        Enabled = $true
    }
    'hyper' = @{
        Description = 'Hyper terminal'
        CompletionScript = 'Hyper-Completion.ps1'
        Enabled = $true
    }
    'codex' = @{
        Description = 'OpenAI Codex CLI'
        CompletionScript = 'Codex-Completion.ps1'
        Enabled = $true
    }
    'brew' = @{
        Description = 'Homebrew package manager'
        CompletionScript = 'Brew-Completion.ps1'
        Enabled = $true
    }
    'npx' = @{
        Description = 'Node.js package runner'
        CompletionScript = 'NPX-Completion.ps1'
        Enabled = $true
    }
    'pip' = @{
        Description = 'Python package installer'
        CompletionScript = 'Pip-Completion.ps1'
        Enabled = $true
    }
    'pipx' = @{
        Description = 'Python application installer'
        CompletionScript = 'Pipx-Completion.ps1'
        Enabled = $true
    }
    'pyenv' = @{
        Description = 'Python version manager'
        CompletionScript = 'Pyenv-Completion.ps1'
        Enabled = $true
    }
    'python' = @{
        Description = 'Python interpreter'
        CompletionScript = 'Python-Completion.ps1'
        Enabled = $true
    }
}