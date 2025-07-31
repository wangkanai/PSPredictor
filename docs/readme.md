# PSPredictor

## PowerShell Universal CLI Predictor

🚀 **Revolutionary PowerShell Binary Module transforming your terminal into a comprehensive IDE experience**

> **⚠️ MAJOR VERSION TRANSITION**: PSPredictor v2.0 is a complete rewrite from PowerShell scripts to a high-performance
> C# .NET 9.0 binary module with AI-powered intelligence and IDE-like features.

## 📋 Table of Contents

- [Getting Started](#-getting-started)
  - [Overview](#overview)
  - [Quick Installation](#quick-installation)
  - [First Steps](#first-steps)
- [Installation](installation.md) - Complete installation guide
- [Configuration](#-configuration)
  - [Basic Configuration](#basic-configuration)
  - [Advanced Settings](#advanced-settings)
  - [Profile Management](#profile-management)
  - [Customization](#customization)
- [Features](#-features)
  - [AI-Powered Intelligence](#-ai-powered-intelligence)
  - [IDE-Like Terminal Experience](#-ide-like-terminal-experience)
  - [Native Performance](#-native-performance)
  - [Advanced Editing Modes](#-advanced-editing-modes)
  - [CLI Tool Support](#-comprehensive-cli-tool-support)
- [User Guide](#-user-guide)
  - [Basic Usage](#basic-usage)
  - [Advanced Workflows](#advanced-workflows)
  - [Completion Examples](#completion-examples)
  - [Troubleshooting](#troubleshooting)
- [References](#-references)
  - [Documentation](#documentation)
  - [API Reference](#api-reference)
  - [Development](#development)
  - [Community](#community)

---

## 🚀 Getting Started

### Overview

PSPredictor v2.0 is a revolutionary **C# .NET 9.0 binary module** that transforms PowerShell into an intelligent,
IDE-like terminal experience. Unlike traditional command-line tools, PSPredictor provides:

**🧠 AI-Powered Intelligence**

- **ML.NET Integration**: Local machine learning models for intelligent command prediction
- **Context-Aware Suggestions**: Understands your workflow and suggests relevant commands
- **Predictive IntelliSense**: Non-intrusive completion suggestions that appear as you type
- **Smart Parameter Detection**: Automatically suggests parameters based on command context

**⚡ Native Performance**

- **<50ms Response Time**: Lightning-fast completions powered by optimized C# code
- **<20MB Memory Footprint**: Efficient resource usage for everyday productivity
- **Lazy Loading**: Models and providers load on-demand for optimal startup performance
- **Cross-Platform**: Full compatibility across Windows, Linux, and macOS (including ARM64)

**🎨 IDE-Like Terminal Experience**

- **Real-time Syntax Highlighting**: PowerShell and CLI tool syntax coloring as you type
- **Visual Error Indication**: Immediate feedback on syntax errors and invalid commands
- **Multi-line Editing**: Advanced editing capabilities with proper indentation and formatting
- **Multiple Editing Modes**: Cmd, Emacs, and Vi modes with customizable key bindings

**🔧 Comprehensive CLI Tool Support**

- **26+ Popular Tools**: Git, Docker, Kubernetes, Azure CLI, AWS CLI, npm, and many more
- **Context-Aware Completions**: Understanding of tool state (Git branch, Docker containers, etc.)
- **Dynamic Help**: Real-time help and documentation without leaving the command line

### Quick Installation

Get started with PSPredictor in under 60 seconds:

```powershell
# Install from PowerShell Gallery (recommended)
Install-Module PSPredictor -Scope CurrentUser

# Import and enable
Import-Module PSPredictor
Enable-PSPredictor

# Verify installation
Get-PSPredictorStatus
```

**Immediate Benefits:**

- ✅ Intelligent completions for Git, Docker, PowerShell, and more
- ✅ Real-time syntax highlighting and error detection
- ✅ AI-powered command suggestions based on your usage patterns
- ✅ Enhanced editing experience with multiple modes

> 📖 **Need detailed installation instructions?** See the complete [Installation Guide](installation.md) for all installation options, development setup, troubleshooting, and platform-specific instructions.

### First Steps

**1. Enable Enhanced Mode**

```powershell
Set-PSPredictorMode -Mode Enhanced
```

**2. Try Intelligent Completions**

```powershell
git <TAB>           # See Git commands with descriptions
docker run <TAB>    # Get container options and image suggestions
kubectl get <TAB>   # Explore Kubernetes resources
```

**3. Experience Syntax Highlighting**

```powershell
# Type these commands and see real-time syntax coloring:
Get-Process | Where-Object CPU -gt 50
git commit -m "My commit message"
docker ps --filter "status=running"
```

**4. Configure Your Preferences**

```powershell
# Set your preferred editing mode
Set-PSPredictorMode -EditingMode Emacs  # or Vi, Cmd

# Customize key bindings
Set-PSPredictorKeyBinding -Key "Ctrl+Space" -Function "TriggerIntelliSense"

# View current configuration
Get-PSPredictorConfig
```

---

## ⚙️ Configuration

### Basic Configuration

**Quick Setup:**

```powershell
# Enable PSPredictor with default settings
Enable-PSPredictor

# Set preferred editing mode
Set-PSPredictorMode -EditingMode Emacs  # Options: Cmd, Emacs, Vi

# Configure completion behavior
Set-PSPredictorCompletion -MaxSuggestions 10 -EnableFuzzyMatching $true

# Enable syntax highlighting
Enable-PSPredictorSyntaxHighlighting
```

**Essential Settings:**

```powershell
# AI prediction settings
Set-PSPredictorAI -EnableLocalModels $true -PredictionAccuracy "Balanced"

# History management
Set-PSPredictorHistory -MaxEntries 10000 -EnablePersistence $true

# Performance tuning
Set-PSPredictorPerformance -ResponseTimeout 100 -CacheSize 1000
```

### Advanced Settings

**AI and Machine Learning:**

```powershell
# Configure AI prediction engine
Set-PSPredictorAI -Settings @{
  EnableLocalModels = $true
  EnableCloudModels = $false
  PredictionAccuracy = "High"        # Low, Balanced, High
  ModelUpdateFrequency = "Weekly"    # Never, Daily, Weekly, Monthly
  ContextWindowSize = 50             # Number of recent commands to consider
  MinConfidenceThreshold = 0.7       # Minimum prediction confidence (0.0-1.0)
}

# Model management
Update-PSPredictorModels -Force
Get-PSPredictorModelInfo | Format-Table
```

**Completion Provider Configuration:**

```powershell
# Configure specific tools
Set-PSPredictorProvider -Name "Git" -Settings @{
  EnableBranchCompletion = $true
  EnableFileCompletion = $true
  MaxHistoryItems = 100
  CacheTimeout = "5m"
}

Set-PSPredictorProvider -Name "Docker" -Settings @{
  EnableImageCompletion = $true
  EnableContainerCompletion = $true
  RegistryEndpoints = @("docker.io", "gcr.io")
}

# Disable specific providers
Disable-PSPredictorProvider -Name "Kubernetes"

# Custom provider registration
Register-PSPredictorProvider -Path "./MyCustomProvider.dll"
```

**Rendering and Display:**

```powershell
# Syntax highlighting configuration
Set-PSPredictorSyntaxHighlighting -Settings @{
  EnableRealTimeHighlighting = $true
  ColorScheme = "VSCode"             # VSCode, Monokai, Solarized, Custom
  HighlightErrors = $true
  HighlightWarnings = $true
  CustomColors = @{
    Command = "Cyan"
    Parameter = "Yellow"
    String = "Green"
    Variable = "Magenta"
    Error = "Red"
  }
}

# IntelliSense display settings
Set-PSPredictorIntelliSense -Settings @{
  MaxVisibleItems = 10
  ShowDescriptions = $true
  ShowKeyBindings = $true
  AutoSelectFirst = $false
  TriggerCharacters = @(".", "-", " ")
}
```

### Profile Management

**Creating Profiles:**

```powershell
# Create profile from current settings
New-PSPredictorProfile -Name "MyProfile" -Description "Custom development setup"

# Create profile with specific settings
New-PSPredictorProfile -Name "MinimalSetup" -Settings @{
  EditingMode = "Cmd"
  EnableAI = $false
  EnableSyntaxHighlighting = $false
  MaxCompletions = 5
}

# Clone existing profile
Copy-PSPredictorProfile -Source "Default" -Destination "MyCustomProfile"
```

**Managing Profiles:**

```powershell
# List available profiles
Get-PSPredictorProfile | Format-Table

# Switch to profile
Set-PSPredictorProfile -Name "MyProfile"

# Import/export profiles
Export-PSPredictorProfile -Name "MyProfile" -Path "./my-profile.json"
Import-PSPredictorProfile -Path "./my-profile.json"

# Set profile as default
Set-PSPredictorProfile -Name "MyProfile" -SetAsDefault
```

**Team Configuration:**

```powershell
# Export team configuration
Export-PSPredictorConfig -Path "./team-config.json" -IncludeProfiles

# Import team configuration
Import-PSPredictorConfig -Path "./team-config.json" -Merge

# Lock configuration for consistency
Lock-PSPredictorConfig -Settings @("EditingMode", "SyntaxHighlighting")
```

### Customization

**Key Bindings:**

```powershell
# Set custom key bindings
Set-PSPredictorKeyBinding -Key "Ctrl+Space" -Function "TriggerIntelliSense"
Set-PSPredictorKeyBinding -Key "Alt+?" -Function "ShowDynamicHelp"
Set-PSPredictorKeyBinding -Key "Ctrl+Shift+P" -Function "ShowProviders"

# Create custom macros
New-PSPredictorMacro -Name "GitStatus" -Keys "g", "s" -Command "git status"
New-PSPredictorMacro -Name "DockerPS" -Keys "d", "p" -Command "docker ps"

# Emacs-style bindings
Set-PSPredictorKeyBinding -Key "Ctrl+A" -Function "BeginningOfLine"
Set-PSPredictorKeyBinding -Key "Ctrl+E" -Function "EndOfLine"
Set-PSPredictorKeyBinding -Key "Alt+F" -Function "ForwardWord"
Set-PSPredictorKeyBinding -Key "Alt+B" -Function "BackwardWord"
```

**Custom Themes:**

```powershell
# Create custom color theme
New-PSPredictorTheme -Name "MyTheme" -Colors @{
  Command = "#569CD6"
  Parameter = "#DCDCAA"
  String = "#CE9178"
  Variable = "#9CDCFE"
  Comment = "#6A9955"
  Error = "#F44747"
  Warning = "#FFCC02"
}

# Apply custom theme
Set-PSPredictorTheme -Name "MyTheme"

# Export/import themes
Export-PSPredictorTheme -Name "MyTheme" -Path "./my-theme.json"
Import-PSPredictorTheme -Path "./my-theme.json"
```

**Environment-Specific Configuration:**

```powershell
# Development environment
Set-PSPredictorEnvironment -Name "Development" -Settings @{
  EnableDebugLogging = $true
  ResponseTimeout = 200
  EnableAllProviders = $true
}

# Production environment
Set-PSPredictorEnvironment -Name "Production" -Settings @{
  EnableDebugLogging = $false
  ResponseTimeout = 50
  DisableCloudFeatures = $true
}

# Automatic environment detection
Enable-PSPredictorAutoEnvironment -Rules @{
  Development = { (Get-Location).Path -like "*\dev\*" }
  Production = { $env:COMPUTERNAME -like "PROD-*" }
}
```

---

## ✨ Features

### 🧠 AI-Powered Intelligence

**Local Machine Learning Models:**

- **Embedded Core Models**: Ships with pre-trained models for instant functionality
- **Command Prediction**: Suggests commands based on current context and history
- **Parameter Intelligence**: Automatically suggests relevant parameters and values
- **Context Awareness**: Understands project structure, Git state, Docker environment

**Predictive IntelliSense:**

```powershell
# As you type, PSPredictor learns and suggests:
git ch<TAB>          # → git checkout, git cherry-pick, git check-ignore
docker run -<TAB>    # → -d, -it, -p, -v (most commonly used flags)
kubectl get <TAB>    # → pods, services, deployments (based on cluster context)
```

**Smart Context Detection:**

- **Git Repository**: Detects current branch, staged files, remote repositories
- **Docker Environment**: Aware of running containers, available images, networks
- **Kubernetes Cluster**: Understands current context, namespaces, resources
- **PowerShell Session**: Tracks variables, functions, modules, command history

**Continuous Learning:**

```powershell
# PSPredictor learns from your usage patterns
Enable-PSPredictorLearning

# View learning statistics
Get-PSPredictorLearningStats

# Export learned patterns (for team sharing)
Export-PSPredictorLearning -Path "./team-patterns.json"
```

### 🎨 IDE-Like Terminal Experience

**Real-time Syntax Highlighting:**

- **PowerShell Syntax**: Variables, cmdlets, parameters, strings, comments
- **CLI Tool Syntax**: Git commands, Docker syntax, Kubernetes YAML, JSON
- **Error Detection**: Real-time validation with visual error indicators
- **Custom Themes**: Multiple color schemes with customization options

**Visual Error Indication:**

```powershell
# Real-time feedback as you type:
Get-Process -InvalidParameter   # Red underline on invalid parameter
git commit --invalid-flag       # Error highlighting with suggestion
docker run --invalid-option    # Immediate feedback with correction
```

**Multi-line Editing:**

```powershell
# Advanced multi-line editing with proper indentation:
$complexCommand = Get-Process |
  Where-Object { $_.CPU -gt 50 } |
  Sort-Object CPU -Descending |
  Select-Object -First 10

# Automatic indentation and syntax preservation
if ($condition)
{
  # Proper indentation maintained
  Get-Content $file |
    ForEach-Object {
      # Nested indentation handled correctly
      $_ -replace "old", "new"
    }
}
```

**Dynamic Help System:**

```powershell
# Non-intrusive help that appears as you navigate:
git commit <Alt+?>           # Shows commit options and examples
docker run <Ctrl+Shift+?>    # Displays run command help
kubectl apply <F1>           # Context-sensitive Kubernetes help
```

### ⚡ Native Performance

**Response Time Specifications:**

- **Completion Generation**: <50ms for standard completions
- **AI Predictions**: <100ms for ML-powered suggestions
- **Syntax Highlighting**: <20ms for real-time coloring
- **Multi-line Rendering**: <30ms for complex command structures

**Memory Efficiency:**

- **Startup Footprint**: <20MB initial memory usage
- **Runtime Footprint**: <50MB for typical usage patterns
- **Model Loading**: Lazy loading with <5MB core embedded models
- **Cache Management**: Intelligent LRU caching with automatic cleanup

**Performance Monitoring:**

```powershell
# Real-time performance metrics
Get-PSPredictorPerformance -RealTime

# Detailed performance analysis
Measure-PSPredictorOperation {
  git log --oneline -10
} -Detailed

# Performance optimization
Optimize-PSPredictorCache
Clear-PSPredictorCache -OlderThan "7d"
```

### 🔧 Advanced Editing Modes

**Multiple Editing Modes:**

- **Cmd Mode**: Windows Command Prompt style (default for Windows)
- **Emacs Mode**: Emacs-style key bindings with kill ring support
- **Vi Mode**: Vi/Vim-style modal editing with command/insert modes

**Cmd Mode Features:**

```powershell
# Windows-familiar key bindings
Ctrl+A          # Select all
Ctrl+C          # Copy
Ctrl+V          # Paste
Ctrl+Z          # Undo
F7              # Command history popup
Tab             # Completion cycling
```

**Emacs Mode Features:**

```powershell
# Emacs-style navigation and editing
Ctrl+A          # Beginning of line
Ctrl+E          # End of line
Ctrl+F / Ctrl+B # Forward/backward character
Alt+F / Alt+B   # Forward/backward word
Ctrl+K          # Kill to end of line
Ctrl+Y          # Yank from kill ring
Alt+D           # Kill word forward
```

**Vi Mode Features:**

```powershell
# Modal editing with Vi-style commands
Esc             # Enter command mode
i               # Insert mode
A               # Append at end of line
o               # Open new line below
dd              # Delete line
yy              # Yank (copy) line
p               # Paste
u               # Undo
```

**Advanced Kill Ring (Emacs/Vi):**

```powershell
# Sophisticated clipboard management
Ctrl+W          # Kill region
Alt+W           # Copy region
Ctrl+Y          # Yank (paste)
Alt+Y           # Cycle through kill ring

# View kill ring contents
Get-PSPredictorKillRing
```

### 🛠️ Comprehensive CLI Tool Support

**Supported Tools (26+ and growing):**

**Version Control:**

- **Git**: Complete Git command completion with branch, file, and remote awareness
- **SVN**: Subversion command completion
- **Mercurial**: Hg command completion

**Container & Orchestration:**

- **Docker**: Container, image, network, volume completion
- **Kubernetes**: kubectl with resource, namespace, and context awareness
- **Podman**: Podman-specific completions
- **Docker Compose**: Service and configuration completion

**Cloud Platforms:**

- **Azure CLI**: Complete az command completion with subscription context
- **AWS CLI**: Comprehensive AWS service completion
- **Google Cloud**: gcloud command completion
- **Terraform**: Resource and provider completion

**Package Managers:**

- **npm/yarn**: Package and script completion
- **pip**: Python package completion
- **nuget**: .NET package completion
- **chocolatey**: Windows package completion

**Development Tools:**

- **PowerShell Core**: Enhanced cmdlet and parameter completion
- **Python**: Python REPL and script completion
- **Node.js**: Node command and module completion
- **dotnet CLI**: .NET SDK command completion

**System Administration:**

- **ssh**: Host and key completion
- **systemctl**: Service management completion
- **netstat**: Network command completion
- **ps**: Process management completion

**Advanced Tool Integration:**

```powershell
# Context-aware completions understand tool state
git checkout <TAB>              # Shows local branches, remotes, tags
docker exec <TAB>               # Shows running containers only
kubectl get pods -n <TAB>       # Shows available namespaces
az group list --location <TAB>  # Shows Azure regions

# Cross-tool intelligence
git status | docker build .     # Understands Git context in Docker commands
kubectl apply -f <TAB>          # Shows YAML/JSON files in current directory
```

---

## 📖 User Guide

### Basic Usage

**Getting Started with Completions:**

```powershell
# Enable PSPredictor
Enable-PSPredictor

# Basic completion workflow
git <TAB>                    # Shows available Git commands
git commit -<TAB>            # Shows commit flags and options
git checkout <TAB>           # Shows branches and tags

# Use arrow keys to navigate suggestions
# Press Tab/Enter to accept, Esc to cancel
```

**Essential Key Bindings:**

```powershell
Tab             # Accept completion / cycle through options
Shift+Tab       # Cycle backwards through completions
Ctrl+Space      # Trigger IntelliSense manually
Esc             # Cancel completion menu
Arrow Keys      # Navigate completion list
Enter           # Accept selected completion
F1              # Show help for current command
```

**Working with History:**

```powershell
# Enhanced history with AI assistance
Get-PSPredictorHistory -Search "git commit"
Get-PSPredictorHistory -LastDays 7

# History-based suggestions
# PSPredictor learns from your patterns and suggests based on:
# - Frequently used commands
# - Time-based patterns (morning vs evening workflows)
# - Project context (different suggestions per Git repository)
```

### Advanced Workflows

**Git Integration:**

```powershell
# Intelligent Git workflow support
git add <TAB>                    # Shows modified files only
git commit -m "<TAB>             # Suggests commit message patterns
git push origin <TAB>            # Shows current branch and remotes
git merge <TAB>                  # Shows merge candidates (excluding current branch)

# Branch-aware completions
git checkout feature/<TAB>       # Shows feature branches only
git rebase <TAB>                 # Suggests appropriate base branches
git cherry-pick <TAB>            # Shows commits from other branches

# Advanced Git scenarios
git log --author=<TAB>           # Shows contributors from repository
git bisect good <TAB>            # Shows commit hashes for bisecting
```

**Docker Workflow:**

```powershell
# Container lifecycle management
docker run <TAB>                 # Shows available images
docker run -p <TAB>              # Suggests common port mappings
docker exec <TAB>                # Shows running containers only
docker logs <TAB>                # Shows containers with recent activity

# Image and registry operations
docker pull <TAB>                # Shows images from configured registries
docker tag <TAB>                 # Shows local images for tagging
docker push <TAB>                # Shows images ready for pushing

# Docker Compose integration
docker-compose up <TAB>          # Shows services from docker-compose.yml
docker-compose logs <TAB>        # Shows services with log output
```

**Kubernetes Operations:**

```powershell
# Resource management
kubectl get <TAB>                # Shows available resource types
kubectl describe pod <TAB>       # Shows pods in current namespace
kubectl logs <TAB>               # Shows pods with recent log activity
kubectl port-forward <TAB>       # Shows services and pods with ports

# Namespace and context awareness
kubectl config use-context <TAB> # Shows available contexts
kubectl get pods -n <TAB>        # Shows available namespaces
kubectl apply -f <TAB>           # Shows YAML/JSON files

# Advanced Kubernetes workflows
kubectl exec -it <TAB>           # Shows running pods only
kubectl scale deployment <TAB>   # Shows deployments in current namespace
```

### Completion Examples

**PowerShell Enhanced Completions:**

```powershell
# Cmdlet parameter intelligence
Get-Process -Name <TAB>          # Shows running process names
Get-Service -Status <TAB>        # Shows: Running, Stopped, Paused
Get-ChildItem -Filter <TAB>      # Shows common filter patterns
Set-Location -Path <TAB>         # Shows directories with enhanced navigation

# Variable and function completion
$env: <TAB>                       # Shows environment variables
$PSVersionTable.<TAB>            # Shows PSVersionTable properties
Get-<TAB>                        # Shows Get-* cmdlets with descriptions
```

**Azure CLI Integration:**

```powershell
# Subscription and resource awareness
az account set --subscription <TAB>     # Shows available subscriptions
az group create --location <TAB>        # Shows Azure regions
az vm create --image <TAB>              # Shows available VM images
az storage account create --sku <TAB>   # Shows storage SKU options

# Resource group and service completions
az vm list --resource-group <TAB>       # Shows resource groups
az webapp create --runtime <TAB>        # Shows supported runtimes
```

**AWS CLI Integration:**

```powershell
# Profile and region awareness
aws configure --profile <TAB>           # Shows configured profiles
aws ec2 describe-instances --region <TAB> # Shows AWS regions
aws s3 cp <TAB>                         # Shows S3 buckets and local files
aws iam create-role --role-name <TAB>   # Shows role naming suggestions
```

### Troubleshooting

**Common Issues and Solutions:**

**Issue: Completions not appearing**

```powershell
# Check PSPredictor status
Get-PSPredictorStatus

# Verify module is loaded
Get-Module PSPredictor

# Enable debug logging
Enable-PSPredictorDebugLogging

# Restart PSPredictor
Restart-PSPredictor
```

**Issue: Slow completion performance**

```powershell
# Check performance metrics
Get-PSPredictorPerformance

# Clear cache if needed
Clear-PSPredictorCache

# Optimize configuration
Optimize-PSPredictorPerformance

# Disable heavy providers temporarily
Disable-PSPredictorProvider -Name "Kubernetes"
```

**Issue: Syntax highlighting not working**

```powershell
# Verify syntax highlighting is enabled
Get-PSPredictorSyntaxHighlighting

# Reset syntax highlighting
Reset-PSPredictorSyntaxHighlighting

# Check terminal compatibility
Test-PSPredictorTerminalSupport

# Update color scheme
Set-PSPredictorSyntaxHighlighting -ColorScheme "Default"
```

**Issue: AI predictions not accurate**

```powershell
# Check AI model status
Get-PSPredictorAIStatus

# Update models
Update-PSPredictorModels

# Reset learning data
Reset-PSPredictorLearning

# Adjust prediction sensitivity
Set-PSPredictorAI -MinConfidenceThreshold 0.8
```

**Issue: Memory usage high**

```powershell
# Monitor memory usage
Get-PSPredictorMemoryUsage -Detailed

# Clear unnecessary caches
Clear-PSPredictorCache -All

# Reduce cache sizes
Set-PSPredictorPerformance -CacheSize 500

# Disable unused providers
Get-PSPredictorProviders | Where-Object Enabled | Disable-PSPredictorProvider
```

**Getting Help:**

```powershell
# Built-in help system
Get-Help PSPredictor -Full
Get-PSPredictorHelp -Topic "Configuration"

# Diagnostic information
Get-PSPredictorDiagnostics | Export-Csv "diagnostics.csv"

# Support information
Get-PSPredictorSupportInfo
```

---

## 📚 References

### Documentation

#### Core Documentation

- **[Product Requirements](../PRD.md)**: Comprehensive product specification and requirements
- **[Architecture Guide](../FRAMEWORK.md)**: Technical architecture and design patterns
- **[Development Standards](../STANDARDS.md)**: Coding guidelines and quality standards
- **[Specifications](../SPECIFICATIONS.md)**: Detailed technical specifications and APIs
- **[Project Planning](../PLANNING.md)**: Development roadmap and project management
- **[Strategic Roadmap](../ROADMAP.md)**: Long-term vision and strategic direction

#### User Documentation

- **[Installation Guide](installation.md)**: Detailed installation instructions for all platforms
- **[Configuration Reference](configuration.md)**: Complete configuration options and settings
- **[User Manual](user-guide.md)**: Comprehensive user guide with examples and workflows
- **[Troubleshooting Guide](troubleshooting.md)**: Common issues and their solutions
- **[FAQ](faq.md)**: Frequently asked questions and answers

#### Migration and Legacy

- **[v1.x Documentation](archives/2025-07-30-PROJECT.md)**: Complete v1.x reference and migration guide
- **[Migration Guide](migration.md)**: Step-by-step guide for migrating from v1.x to v2.0
- **[Breaking Changes](breaking-changes.md)**: Comprehensive list of breaking changes in v2.0

### API Reference

#### Core APIs

- **[IPredictionEngine](api/IPredictionEngine.md)**: Core prediction engine interface
- **[ICompletionProvider](api/ICompletionProvider.md)**: Completion provider interface
- **[ISyntaxHighlighter](api/ISyntaxHighlighter.md)**: Syntax highlighting interface
- **[IMLPredictionEngine](api/IMLPredictionEngine.md)**: Machine learning engine interface

#### PowerShell Cmdlets

- **[Get-PSPredictorStatus](api/Get-PSPredictorStatus.md)**: Module status and configuration
- **[Set-PSPredictorMode](api/Set-PSPredictorMode.md)**: Configure editing and prediction modes
- **[Enable-PSPredictor](api/Enable-PSPredictor.md)**: Enable PSPredictor functionality
- **[Set-PSPredictorConfig](api/Set-PSPredictorConfig.md)**: Configuration management

#### Extension APIs

- **[Creating Custom Providers](api/custom-providers.md)**: Guide for building completion providers
- **[Plugin Development](api/plugin-development.md)**: Extending PSPredictor with custom plugins
- **[Theme Development](api/theme-development.md)**: Creating custom color themes

### Development

#### Getting Started

- **[Development Setup](development/setup.md)**: Setting up development environment
- **[Building from Source](development/building.md)**: Building PSPredictor from source code
- **[Testing Guide](development/testing.md)**: Running tests and validation
- **[Debugging](development/debugging.md)**: Debugging PSPredictor issues

#### Contributing

- **[Contributing Guidelines](../CONTRIBUTING.md)**: How to contribute to PSPredictor
- **[Code Review Process](development/code-review.md)**: Code review guidelines and process
- **[Release Process](development/releases.md)**: How releases are created and published

#### Architecture Deep Dive

- **[ML.NET Integration](development/mlnet-integration.md)**: Machine learning implementation details
- **[Performance Optimization](development/performance.md)**: Performance considerations and optimizations
- **[Cross-Platform Support](development/cross-platform.md)**: Platform-specific implementation details

### Community

#### Example: Creating a Custom CLI Tool Provider

**Step 1: Create Provider Class**

```csharp
public class MyToolCompletion : BaseCompletion
{
    public override string ToolName => "mytool";
    
    public override async Task<IEnumerable<CompletionResult>> GetCompletionsAsync(
        string commandLine, int cursorPosition)
    {
        var results = new List<CompletionResult>();
        
        // Add tool-specific completion logic
        if (commandLine.EndsWith("mytool "))
        {
            results.Add(new CompletionResult("command1", "First command", ToolTip: "Description of command1"));
            results.Add(new CompletionResult("command2", "Second command", ToolTip: "Description of command2"));
        }
        
        return results;
    }
    
    protected override TimeSpan CacheDuration => TimeSpan.FromMinutes(5);
}
```

**Step 2: Register Provider**

```csharp
// In CompletionProvider.cs
RegisterProvider(new MyToolCompletion());
```

**Step 3: Add Tests**

```csharp
[Fact]
public void MyTool_ShouldProvideBasicCompletions()
{
    var completion = new MyToolCompletion();
    var results = completion.GetCompletions("mytool ", 7);
    
    results.Should().NotBeEmpty();
    results.Should().Contain(r => r.CompletionText == "command1");
}
```

### Community

#### Contributing

- **[Contributing Guidelines](CONTRIBUTING.md)**: Detailed guide for contributors
- **[Code of Conduct](https://github.com/wangkanai/PSPredictor/blob/main/CODE_OF_CONDUCT.md)**: Community guidelines
- **[Issue Templates](https://github.com/wangkanai/PSPredictor/issues/new/choose)**: Report bugs or request features

#### Support and Community

- **[GitHub Issues](https://github.com/wangkanai/PSPredictor/issues)**: Bug reports and feature requests
- **[GitHub Discussions](https://github.com/wangkanai/PSPredictor/discussions)**: Community discussions and Q&A
- **[PowerShell Gallery](https://www.powershellgallery.com/packages/PSPredictor)**: Official package distribution
- **[NuGet Gallery](https://www.nuget.org/packages/PSPredictor)**: Alternative package source

#### Related Projects

- **[oh-my-posh](https://github.com/JanDeDobbeleer/oh-my-posh)**: Beautiful prompt themes (compatible)
- **[posh-git](https://github.com/dahlbyk/posh-git)**: Git integration for PowerShell (enhanced by PSPredictor)
- **[ML.NET](https://github.com/dotnet/machinelearning)**: Core machine learning framework

#### Performance Specifications

**Response Time Targets**

- ⚡ **Completion Generation**: <50ms for standard completions
- 🧠 **AI Predictions**: <100ms for ML-powered suggestions
- 🎨 **Syntax Highlighting**: <20ms for real-time coloring
- 📝 **Multi-line Rendering**: <30ms for complex command structures

**Memory Efficiency**

- 🚀 **Startup Footprint**: <20MB initial memory usage
- 💾 **Runtime Footprint**: <50MB for typical usage patterns
- 🤖 **Model Loading**: Lazy loading with <5MB core embedded models
- 📚 **History Management**: SQLite with automatic cleanup and archiving

#### License and Legal

- **License**: MIT License - see [LICENSE](LICENSE) file
- **Copyright**: © 2024-2025 PSPredictor Contributors
- **Trademark**: PSPredictor is a trademark of the project maintainers

---

## 🚀 Made with ❤️ and AI for the PowerShell community

**Transform your terminal into an intelligent, IDE-like experience with PSPredictor v2.0**

[📋 Report Bug](https://github.com/wangkanai/PSPredictor/issues) ·
[💡 Request Feature](https://github.com/wangkanai/PSPredictor/issues) ·
[🤝 Contribute](CONTRIBUTING.md) ·
[📚 Documentation](docs/) ·
[🏗️ Architecture](FRAMEWORK.md)
