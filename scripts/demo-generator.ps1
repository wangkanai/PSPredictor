#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Demo content generator for PSPredictor social media campaigns
.DESCRIPTION
    Creates formatted demo scripts and test scenarios for recording PSPredictor demonstrations.
    Helps content creators showcase the before/after experience effectively.
.PARAMETER Scenario
    The demo scenario to generate (Git, Docker, Kubernetes, AWS, Multi-Tool)
.PARAMETER Duration
    Target duration for the demo (30, 60, 90 seconds)
.PARAMETER Platform
    Target social media platform (Twitter, LinkedIn, YouTube, GitHub)
.EXAMPLE
    ./demo-generator.ps1 -Scenario Git -Duration 30 -Platform Twitter
.EXAMPLE
    ./demo-generator.ps1 -Scenario Multi-Tool -Duration 90 -Platform YouTube
#>

param(
    [Parameter(Mandatory)]
    [ValidateSet('Git', 'Docker', 'Kubernetes', 'AWS', 'Python', 'Multi-Tool', 'DevOps')]
    [string]$Scenario,
    
    [Parameter(Mandatory)]
    [ValidateSet(30, 60, 90)]
    [int]$Duration,
    
    [Parameter(Mandatory)]
    [ValidateSet('Twitter', 'LinkedIn', 'YouTube', 'GitHub')]
    [string]$Platform
)

Write-Host "🎬 PSPredictor Demo Generator" -ForegroundColor Cyan
Write-Host "Scenario: $Scenario | Duration: ${Duration}s | Platform: $Platform" -ForegroundColor Yellow
Write-Host ""

# Demo content templates
$DemoScripts = @{
    'Git' = @{
        'Before' = @(
            'git che<TAB>           # No completions shown',
            'git checkout ma<TAB>   # No branch suggestions',
            'git log --gra<TAB>     # No option hints',
            'git commit -m "fix"    # Remembering options manually'
        )
        'After' = @(
            'git che<TAB>           # Shows: checkout, cherry-pick, check-ignore',
            'git checkout ma<TAB>   # Shows: main, master (actual branches)',
            'git log --gra<TAB>     # Shows: --graph, --grep, --grep-reflog',
            'git commit --<TAB>     # Shows: --message, --amend, --author'
        )
        'Benefits' = 'Git workflow 5x faster with intelligent branch and option completion'
    }
    
    'Docker' = @{
        'Before' = @(
            'docker <TAB>                    # Generic shell completion only',
            'docker run --<TAB>              # No option suggestions',
            'docker exec -it container<TAB>  # No command hints'
        )
        'After' = @(
            'docker <TAB>                    # Shows: run, build, pull, push, exec, logs',
            'docker run --<TAB>              # Shows: --detach, --volume, --port, --env',
            'docker exec -it myapp <TAB>     # Shows: bash, sh, /bin/bash, /bin/sh'
        )
        'Benefits' = 'Container management becomes intuitive with comprehensive Docker completion'
    }
    
    'Kubernetes' = @{
        'Before' = @(
            'kubectl <TAB>                   # Basic shell completion',
            'kubectl get <TAB>               # No resource suggestions',
            'kubectl describe pod<TAB>       # No pod name hints'
        )
        'After' = @(
            'kubectl <TAB>                   # Shows: get, describe, create, delete, apply',
            'kubectl get <TAB>               # Shows: pods, services, deployments, configmaps',
            'kubectl describe pod <TAB>      # Shows: actual pod names from cluster'
        )
        'Benefits' = 'Kubernetes management simplified with 40+ commands and 60+ resource types'
    }
    
    'AWS' = @{
        'Before' = @(
            'aws <TAB>                       # Basic service list',
            'aws s3 <TAB>                    # No command suggestions',
            'aws ec2 describe-<TAB>          # No completion hints'
        )
        'After' = @(
            'aws <TAB>                       # Shows 65+ services: s3, ec2, lambda, iam',
            'aws s3 <TAB>                    # Shows: ls, cp, sync, mb, rb, presign',
            'aws ec2 describe-<TAB>          # Shows: describe-instances, describe-images'
        )
        'Benefits' = 'AWS CLI mastery with 65+ services and hundreds of commands completed'
    }
    
    'Python' = @{
        'Before' = @(
            'pip <TAB>                       # Limited system completion',
            'python -m <TAB>                 # No module suggestions',
            'pyenv <TAB>                     # No version hints'
        )
        'After' = @(
            'pip <TAB>                       # Shows: install, uninstall, list, show, freeze',
            'python -m <TAB>                 # Shows: pip, venv, json, http.server',
            'pyenv <TAB>                     # Shows: install, versions, global, local'
        )
        'Benefits' = 'Python development accelerated with comprehensive package and version management'
    }
    
    'Multi-Tool' = @{
        'Before' = @(
            '# Struggling across multiple tools',
            'git che<TAB>           # No Git completions',
            'docker ru<TAB>         # No Docker hints', 
            'kubectl g<TAB>         # No Kubernetes help',
            'aws s<TAB>             # No AWS assistance'
        )
        'After' = @(
            '# Smooth workflow across all tools',
            'git che<TAB>           # ✅ Git: checkout, cherry-pick',
            'docker ru<TAB>         # ✅ Docker: run, restart',
            'kubectl g<TAB>         # ✅ Kubernetes: get, generate',
            'aws s<TAB>             # ✅ AWS: s3, sns, sqs, ssm'
        )
        'Benefits' = '26+ CLI tools unified with intelligent completion - one module, unlimited productivity'
    }
    
    'DevOps' = @{
        'Before' = @(
            '# DevOps workflow friction',
            'git push origin<TAB>            # No branch completion',
            'docker build -t myapp<TAB>      # No tag suggestions',
            'kubectl apply -f<TAB>           # No file hints',
            'terraform plan<TAB>             # No option completion'
        )
        'After' = @(
            '# Streamlined DevOps pipeline',
            'git push origin<TAB>            # ✅ Shows: main, develop, feature/xyz',
            'docker build -t myapp<TAB>      # ✅ Shows: :latest, :v1.0, :dev',
            'kubectl apply -f<TAB>           # ✅ Shows: deployment.yaml, service.yaml',
            'terraform plan<TAB>             # ✅ Shows: -out, -var, -var-file'
        )
        'Benefits' = 'Complete DevOps toolkit with Git → Docker → Kubernetes → Terraform completion chain'
    }
}

# Platform-specific formatting
$PlatformSpecs = @{
    'Twitter' = @{
        'MaxLength' = 280
        'HashtagCount' = 3
        'Style' = 'Concise'
        'CTA' = 'Install-Module PSPredictor'
    }
    'LinkedIn' = @{
        'MaxLength' = 3000
        'HashtagCount' = 5
        'Style' = 'Professional'
        'CTA' = 'Try PSPredictor and transform your CLI workflow'
    }
    'YouTube' = @{
        'MaxLength' = 5000
        'HashtagCount' = 10
        'Style' = 'Detailed'
        'CTA' = 'Subscribe for more PowerShell productivity tips'
    }
    'GitHub' = @{
        'MaxLength' = 10000
        'HashtagCount' = 8
        'Style' = 'Technical'
        'CTA' = 'Star the repo: github.com/wangkanai/PSPredictor'
    }
}

# Generate timing structure based on duration
$TimingStructure = switch ($Duration) {
    30 {
        @{
            'Hook' = '0-3s'
            'Problem' = '3-8s'  
            'Solution' = '8-10s'
            'Demo' = '10-25s'
            'CTA' = '25-30s'
        }
    }
    60 {
        @{
            'Hook' = '0-5s'
            'Problem' = '5-15s'
            'Solution' = '15-20s'
            'Demo' = '20-50s'
            'CTA' = '50-60s'
        }
    }
    90 {
        @{
            'Hook' = '0-10s'
            'Problem' = '10-25s'
            'Solution' = '25-30s'
            'Demo' = '30-80s'
            'CTA' = '80-90s'
        }
    }
}

# Generate demo script
$script = $DemoScripts[$Scenario]
$platformSpec = $PlatformSpecs[$Platform]
$timing = $TimingStructure

Write-Host "📝 Generated Demo Script:" -ForegroundColor Green
Write-Host "=========================" -ForegroundColor Green
Write-Host ""

Write-Host "🎯 TIMING STRUCTURE ($Duration seconds)" -ForegroundColor Magenta
Write-Host "Hook: $($timing.Hook)" -ForegroundColor White
Write-Host "Problem: $($timing.Problem)" -ForegroundColor White  
Write-Host "Solution: $($timing.Solution)" -ForegroundColor White
Write-Host "Demo: $($timing.Demo)" -ForegroundColor White
Write-Host "CTA: $($timing.CTA)" -ForegroundColor White
Write-Host ""

Write-Host "🔧 BEFORE PSPREDICTOR (Frustrating):" -ForegroundColor Red
foreach ($line in $script.Before) {
    Write-Host "  $line" -ForegroundColor DarkRed
}
Write-Host ""

Write-Host "✨ AFTER PSPREDICTOR (Smooth):" -ForegroundColor Green
foreach ($line in $script.After) {
    Write-Host "  $line" -ForegroundColor DarkGreen
}
Write-Host ""

Write-Host "💡 KEY BENEFIT:" -ForegroundColor Yellow
Write-Host "  $($script.Benefits)" -ForegroundColor DarkYellow
Write-Host ""

# Generate social media post
Write-Host "📱 SOCIAL MEDIA POST ($Platform):" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

$post = switch ($Platform) {
    'Twitter' {
        @"
🚀 Stop googling CLI commands!

BEFORE: git che<TAB> → nothing 😤
AFTER: git che<TAB> → checkout, cherry-pick ✨

PSPredictor = 26+ tools with intelligent completion

Install-Module PSPredictor

#PowerShell #DevOps #CLI
"@
    }
    'LinkedIn' {
        @"
🎯 DevOps Productivity Hack: Never Google CLI Commands Again

The Problem:
• Constantly looking up command syntax
• Wasting time on basic CLI operations  
• Context switching kills flow state

The Solution: PSPredictor
✅ Intelligent completion for 26+ CLI tools
✅ Git, Docker, kubectl, AWS, Azure support
✅ Cross-platform PowerShell 7+ module

Results: 5x faster CLI workflows

Try it: Install-Module PSPredictor

What's your biggest CLI pain point? 👇

#PowerShell #DevOps #Productivity #CLI #Automation
"@
    }
    'YouTube' {
        @"
🔥 STOP Googling CLI Commands - This PowerShell Module Changes Everything!

In this video, I'll show you how PSPredictor transforms your command line experience:

⏰ Timestamps:
0:00 - The CLI struggle is real
0:10 - Introducing PSPredictor  
0:30 - Git workflow transformation
1:00 - Docker & Kubernetes magic
1:30 - AWS & Azure cloud tools
2:00 - Installation & setup

🚀 Get PSPredictor:
Install-Module PSPredictor

💪 What you'll learn:
• Intelligent tab completion for 26+ tools
• Git branch and command completion
• Docker container management
• Kubernetes resource navigation
• AWS/Azure service discovery

#PowerShell #CLI #DevOps #Productivity #Docker #Kubernetes #Git #AWS #Azure
"@
    }
    'GitHub' {
        @"
# PSPredictor Demo: $Scenario Workflow

## Before PSPredictor
```bash
$($script.Before -join "`n")
```

## After PSPredictor  
```bash
$($script.After -join "`n")
```

## Impact
$($script.Benefits)

## Quick Start
```powershell
Install-Module PSPredictor
Import-Module PSPredictor
Install-PSPredictor
```

**Result:** Transform your CLI workflow with intelligent completion for 26+ tools.

[⭐ Star this repo](https://github.com/wangkanai/PSPredictor) | [📦 PowerShell Gallery](https://www.powershellgallery.com/packages/PSPredictor)
"@
    }
}

Write-Host $post -ForegroundColor White
Write-Host ""

# Generate hashtag suggestions
Write-Host "🏷️  HASHTAG STRATEGY:" -ForegroundColor Blue
$hashtags = @('#PowerShell', '#CLI', '#DevOps', '#Productivity', '#Automation', '#Git', '#Docker', '#kubernetes', '#AWS', '#Azure', '#OpenSource', '#DeveloperTools')
$selectedHashtags = $hashtags | Select-Object -First $platformSpec.HashtagCount
Write-Host "  $($selectedHashtags -join ' ')" -ForegroundColor DarkBlue
Write-Host ""

# Recording tips
Write-Host "🎬 RECORDING TIPS:" -ForegroundColor Magenta
Write-Host "• Terminal: Use high contrast theme with large font (16pt+)" -ForegroundColor White
Write-Host "• Timing: 3s pause between commands, 2s after completions" -ForegroundColor White
Write-Host "• Quality: Record at 1920x1080, export to platform specs" -ForegroundColor White
Write-Host "• Content: Show typing naturally, highlight TAB completions" -ForegroundColor White
Write-Host ""

Write-Host "✅ Demo script generated successfully!" -ForegroundColor Green
Write-Host "📁 Save this output for your recording session." -ForegroundColor Yellow