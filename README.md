# PSPredictor

## PowerShell Universal CLI Predictor

🚀 **Revolutionary PowerShell Binary Module transforming your terminal into a comprehensive IDE experience**

[![Build Status](https://github.com/wangkanai/PSPredictor/actions/workflows/dotnet.yml/badge.svg)](https://github.com/wangkanai/PSPredictor/actions/workflows/dotnet.yml)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/PSPredictor?style=flat-square)](https://www.powershellgallery.com/packages/PSPredictor)
[![License](https://img.shields.io/github/license/wangkanai/PSPredictor?style=flat-square)](LICENSE)
[![Stars](https://img.shields.io/github/stars/wangkanai/PSPredictor?style=flat-square)](https://github.com/wangkanai/PSPredictor/stargazers)

> **⚠️ MAJOR VERSION TRANSITION**: PSPredictor v2.0 is a complete rewrite from PowerShell scripts to a high-performance
> C# .NET 9.0 binary module with AI-powered intelligence and IDE-like features.

## 📋 Table of Contents

- [Getting Started](#-getting-started)
  - [Overview](#overview)
  - [Quick Installation](#quick-installation)
  - [First Steps](#first-steps)
- [Installation](#-installation)
  - [Prerequisites](#prerequisites)
  - [Production Installation](#production-installation)
  - [Development Installation](#development-installation)
  - [Verification](#verification)
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

## 📚 Legacy Version Reference

**Looking for PSPredictor v1.x?** The previous PowerShell script-based version is available at:
[📖 PSPredictor v1.x Documentation](https://github.com/wangkanai/PSPredictor/blob/release/1.3/README.md)

**Migration Path**: v1.x users can upgrade to v2.0 for significantly improved performance, AI-powered intelligence, and
native cross-platform support. See our [migration guide](docs/archives/2025-07-30-PROJECT.md) for detailed transition
instructions.

## 🚀 Getting Started

### Overview

PSPredictor v2.0 transforms your PowerShell terminal into an intelligent IDE-like experience with:

- **🧠 AI-Powered Completions**: Local ML.NET models provide context-aware suggestions for 26+ CLI tools
- **🎨 Real-Time Syntax Highlighting**: Live syntax coloring and error detection as you type
- **⚡ Native Performance**: C# .NET 9.0 binary module with <100ms response times
- **🎯 Advanced Editing**: Cmd/Emacs/Vi modes with customizable key bindings and multi-line editing

### Quick Installation

```powershell
# Install from PowerShell Gallery (Coming Soon)
Install-Module -Name PSPredictor -RequiredVersion 2.0.0 -Scope CurrentUser
Import-Module PSPredictor

# Add to your PowerShell profile for automatic loading
Add-Content $PROFILE "Import-Module PSPredictor"
```

### First Steps

1. **Enable Enhanced Mode**: `Set-PSPredictorMode -Mode Enhanced`
2. **Test Git Completion**: Type `git che<TAB>` to see intelligent branch suggestions
3. **Try Docker Commands**: Use `docker exec -it <TAB>` to see running containers
4. **Explore Help**: Use `Get-PSPredictorStatus` to see available features

## 📦 Installation

### Prerequisites

- **PowerShell**: PowerShell 7.4+ or Windows PowerShell 5.1+ 
- **.NET Runtime**: .NET 9.0 Runtime (automatically installed with PowerShell 7.5+)
- **Operating System**: Windows 10+, Linux (Ubuntu 20.04+), macOS 12+ (Intel x64 or Apple Silicon ARM64)
- **Memory**: Minimum 4GB RAM, recommended 8GB+ for large repositories

### Production Installation

#### From PowerShell Gallery (Coming Soon)

```powershell
# Install latest stable version
Install-Module -Name PSPredictor -RequiredVersion 2.0.0 -Scope CurrentUser

# Verify installation
Import-Module PSPredictor
Get-PSPredictorStatus

# Add to PowerShell profile for automatic loading
if (!(Test-Path $PROFILE)) { New-Item -ItemType File -Path $PROFILE -Force }
Add-Content $PROFILE "Import-Module PSPredictor"
```

#### From GitHub Releases

```powershell
# Download and install from GitHub releases
$LatestRelease = Invoke-RestMethod "https://api.github.com/repos/wangkanai/PSPredictor/releases/latest"
$DownloadUrl = $LatestRelease.assets | Where-Object name -like "*.nupkg" | Select-Object -First 1 -ExpandProperty browser_download_url

# Install from downloaded package
Install-Package -Source $DownloadUrl -Scope CurrentUser
```

### Development Installation

#### From Source Code

```powershell
# Clone and build from source (.NET 9.0 SDK required)
git clone https://github.com/wangkanai/PSPredictor.git
cd PSPredictor

# Build the C# binary module
dotnet restore
dotnet build --configuration Release

# Import development build
$ModulePath = Join-Path -Path (Get-Location) -ChildPath "src/PSPredictor/bin/Release/net9.0/PSPredictor.dll"
Import-Module $ModulePath -Force

# Run tests to verify everything works
dotnet test
```

#### For Contributors

```powershell
# Install .NET 9.0 SDK if not present
# Windows: Download from https://dotnet.microsoft.com/download/dotnet/9.0
# Linux: Use package manager (apt, yum, etc.)
# macOS: Use Homebrew - brew install dotnet@9

# Clone and setup development environment
git clone https://github.com/wangkanai/PSPredictor.git
cd PSPredictor

# Build and test
dotnet build --configuration Debug
dotnet test --configuration Debug

# Install for development testing
$ModulePath = Join-Path -Path (Get-Location) -ChildPath "src/PSPredictor/bin/Debug/net9.0/PSPredictor.dll"
Import-Module $ModulePath -Force
```

### Verification

```powershell
# Check module is loaded correctly
Get-Module PSPredictor

# Verify core functionality
Get-PSPredictorStatus                    # Show module status and performance metrics
Get-PSPredictorTools                     # List all supported CLI tools

# Test basic completion
git <TAB>                                # Should show Git subcommands
docker <TAB>                             # Should show Docker commands

# Enable enhanced features
Set-PSPredictorMode -Mode Enhanced       # Enable AI predictions and advanced features
```

## ⚙️ Configuration

### Basic Configuration

#### Enable/Disable Features

```powershell
# Enable enhanced AI predictions
Set-PSPredictorMode -Mode Enhanced

# Configure specific CLI tool completions
Set-PSPredictorConfig -Tool "git" -Enabled $true
Set-PSPredictorConfig -Tool "docker" -Enabled $true
Set-PSPredictorConfig -Tool "kubectl" -Enabled $false

# Set completion behavior
Set-PSPredictorConfig -MaxSuggestions 10
Set-PSPredictorConfig -CaseSensitive $false
Set-PSPredictorConfig -FuzzyMatching $true
```

#### Editing Mode Configuration

```powershell
# Set editing mode (Cmd, Emacs, or Vi)
Set-PSPredictorMode -EditingMode Emacs    # Emacs-style key bindings
Set-PSPredictorMode -EditingMode Vi       # Vi/Vim-style editing
Set-PSPredictorMode -EditingMode Cmd      # Windows Cmd-style (default)

# Custom key bindings
Set-PSPredictorKeyBinding -Key "Ctrl+Space" -Function "TriggerIntelliSense"
Set-PSPredictorKeyBinding -Key "F1" -Function "ShowDynamicHelp"
Set-PSPredictorKeyBinding -Key "Alt+?" -Function "ShowContextualHelp"
```

### Advanced Settings

#### AI and ML Configuration

```powershell
# Configure AI prediction engine
Set-PSPredictorAI -EnableLocalModels $true
Set-PSPredictorAI -DownloadEnhancedModels $false  # Use only embedded models
Set-PSPredictorAI -PredictionConfidence 0.7       # Minimum confidence threshold

# Performance tuning
Set-PSPredictorConfig -ResponseTimeout 100ms      # Maximum completion response time
Set-PSPredictorConfig -CacheSize 1000             # Number of cached completions
Set-PSPredictorConfig -HistorySize 10000          # Command history retention
```

#### Rendering and Display

```powershell
# Syntax highlighting configuration
Set-PSPredictorDisplay -SyntaxHighlighting $true
Set-PSPredictorDisplay -ErrorHighlighting $true
Set-PSPredictorDisplay -ColorScheme "VSCode"      # Options: Default, VSCode, GitHub, Monokai

# IntelliSense display settings
Set-PSPredictorDisplay -ShowInlineHelp $true
Set-PSPredictorDisplay -ShowParameterHints $true
Set-PSPredictorDisplay -MaxDisplayItems 15
```

### Profile Management

#### Built-in Profiles

```powershell
# Use predefined profiles
Set-PSPredictorProfile -Name "Developer"          # Optimized for software development
Set-PSPredictorProfile -Name "SysAdmin"           # System administration focus
Set-PSPredictorProfile -Name "DevOps"             # Cloud and container operations
Set-PSPredictorProfile -Name "Minimal"            # Lightweight configuration

# Create custom profile
New-PSPredictorProfile -Name "MyCustomProfile" -BasedOn "Developer"
```

#### Configuration Export/Import

```powershell
# Export current configuration
Export-PSPredictorConfig -Path "$HOME\PSPredictor-Config.json"

# Import configuration
Import-PSPredictorConfig -Path "$HOME\PSPredictor-Config.json"

# Reset to defaults
Reset-PSPredictorConfig -Confirm:$false
```

### Customization

#### Adding Custom Completions

```powershell
# Register custom completion for your tools
Register-PSPredictorCompletion -CommandName "mytool" -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    
    # Custom completion logic
    $suggestions = @("option1", "option2", "option3")
    $suggestions | Where-Object { $_ -like "$wordToComplete*" }
}

# Enable custom completion
Enable-PSPredictorCompletion -CommandName "mytool"
```

#### Configuration File Location

By default, PSPredictor stores configuration in:

- **Windows**: `$env:APPDATA\PSPredictor\config.json`
- **Linux/macOS**: `$HOME/.config/PSPredictor/config.json`

```powershell
# Get current configuration file path
Get-PSPredictorConfig | Select-Object ConfigPath

# Use custom configuration location
Set-PSPredictorConfig -ConfigPath "$HOME\Custom\PSPredictor.json"
```

## ✨ Features

### 🧠 AI-Powered Intelligence

#### Local Machine Learning
- **ML.NET Integration**: Embedded models provide intelligent predictions without cloud dependencies
- **Context-Aware Suggestions**: Understands your workflow, current directory, and environment
- **Predictive IntelliSense**: IDE-like IntelliSense experience directly in your terminal
- **Command History Learning**: Learns from your patterns to provide personalized suggestions

```powershell
# AI automatically suggests relevant commands based on context
git che<TAB>                    # In a Git repo → shows 'checkout' with branch suggestions
docker exec<TAB>                # Shows running containers with intelligent filtering
kubectl get<TAB>                # Shows relevant Kubernetes resources for current context
```

### 🎨 IDE-Like Terminal Experience

#### Real-Time Visual Feedback
- **Syntax Highlighting**: Live syntax coloring for PowerShell and 26+ CLI tools
- **Error Indication**: Instant error detection with contextual suggestions
- **Multi-Line Editing**: Advanced editing with proper indentation and bracket matching
- **Dynamic Help**: Real-time help display without losing command-line position

```powershell
# Real-time syntax highlighting and error detection
git status --invalid-flag      # Shows error highlighting with suggestion
docker run --memory=invalid    # Visual error indication with valid options

# Multi-line editing with intelligent indentation
if ($condition) {
  Get-Process | Where-Object {
    $_.CPU -gt 100             # Automatic indentation and syntax highlighting
  }
}                              # Bracket matching and completion
```

### ⚡ Native Performance

#### High-Performance Architecture
- **C# Binary Module**: Native .NET 9.0 performance with <100ms response times
- **Memory Efficient**: <50MB footprint optimized for long-running sessions
- **Cross-Platform**: Windows, Linux, macOS with full ARM64 support (Apple Silicon)
- **PSReadLine Independent**: Native input handling without external dependencies

#### Performance Metrics
- **⚡ Completion Generation**: <50ms for standard completions
- **🧠 AI Predictions**: <100ms for ML-powered suggestions  
- **🎨 Syntax Highlighting**: <20ms for real-time coloring
- **📝 Multi-line Rendering**: <30ms for complex structures

### 🎯 Advanced Editing Modes

#### Multi-Modal Editing System
- **Cmd Mode**: Windows Command Prompt-style editing (default)
- **Emacs Mode**: Full Emacs-style key bindings with kill-ring support
- **Vi Mode**: Complete Vi/Vim-style editing with modal interface

```powershell
# Switch between editing modes
Set-PSPredictorMode -EditingMode Emacs    # Emacs-style bindings
Set-PSPredictorMode -EditingMode Vi       # Vi/Vim modal editing
Set-PSPredictorMode -EditingMode Cmd      # Windows Cmd-style

# Custom key bindings in any mode
Set-PSPredictorKeyBinding -Key "Ctrl+R" -Function "ReverseHistorySearch"
Set-PSPredictorKeyBinding -Key "Alt+." -Function "InsertLastArgument"
```

### 🛠️ Comprehensive CLI Tool Support

#### 26+ Supported Tools with Intelligent Context

**Container & Infrastructure**
- **Docker**: Container management with live container/image suggestions
- **Podman**: Daemonless container operations with Docker compatibility
- **Kubernetes**: kubectl with cluster context and resource awareness
- **Terraform**: Infrastructure as code with workspace and resource completion

**Development Tools**
- **Git**: Branch-aware completion with repository state intelligence
- **.NET**: Project templates, package references, and build configurations
- **Node.js**: npm packages, scripts, and dependency management
- **Python**: pip packages, virtual environments, and module execution

**Cloud Platforms**
- **Azure**: az CLI with subscription and resource group context
- **AWS**: Complete aws CLI with region and service awareness
- **GitHub**: gh CLI with repository and organization context

**AI & Code Assistance**
- **Claude AI**: Chat, completion, and model interactions
- **Gemini AI**: Multi-modal AI operations and file handling
- **OpenAI**: Code completion and generation workflows

```powershell
# Tool-specific intelligent completion examples
git checkout <TAB>              # Shows actual branches from your repository
docker exec -it <TAB>           # Lists only running containers
kubectl get pods -n <TAB>       # Shows available namespaces
az vm list --resource-group <TAB> # Shows your actual resource groups
```

### 🔧 Extensibility and Customization

#### Plugin Architecture
- **Easy Extension**: Simple API for adding new CLI tools
- **Custom Providers**: Create specialized completion providers
- **Community Contributions**: Share and discover community completions
- **Hot-Reloading**: Update completions without restarting PowerShell

```csharp
// Example: Adding a new CLI tool completion provider
public class MyToolCompletion : BaseCompletion
{
    public override string ToolName => "mytool";
    
    public override IEnumerable<CompletionResult> GetCompletions(
        string commandLine, int cursorPosition)
    {
        // Your intelligent completion logic with AI assistance
        return _aiEngine.PredictCompletions(commandLine, cursorPosition);
    }
}
```

## 📖 User Guide

### Basic Usage

#### Getting Started with Completions

```powershell
# Enable PSPredictor for intelligent completions
Import-Module PSPredictor
Set-PSPredictorMode -Mode Enhanced

# Basic tab completion for any supported tool
git <TAB>                       # Shows Git subcommands
docker <TAB>                    # Shows Docker commands
kubectl <TAB>                   # Shows Kubernetes commands

# Context-aware completion
git checkout <TAB>              # Shows branches in current repository
docker ps --filter <TAB>        # Shows available filter options
kubectl get <TAB>               # Shows available resource types
```

#### Understanding the Interface

**Completion Display Elements:**
- **Command**: The actual command text to be inserted
- **Description**: Brief explanation of what the command does
- **Type**: Category (Command, Parameter, Value, etc.)
- **Context**: Additional context-specific information

**Visual Indicators:**
- 🟢 **Green**: Valid command or parameter
- 🟡 **Yellow**: Deprecated but still functional
- 🔴 **Red**: Invalid or error condition
- 🔵 **Blue**: Custom or user-defined completion

### Advanced Workflows

#### Git Development Workflow

```powershell
# Intelligent branch management
git branch <TAB>                # Lists all branches (local and remote)
git checkout -b feature/<TAB>   # Suggests branch naming patterns
git merge <TAB>                 # Shows merge candidates excluding current branch

# Smart commit assistance
git add <TAB>                   # Shows modified/untracked files
git commit -m "<TAB>            # Suggests commit message templates
git push origin <TAB>           # Shows remote branch suggestions

# Advanced Git operations
git rebase -i <TAB>             # Shows commits available for interactive rebase
git cherry-pick <TAB>           # Shows commits from other branches
```

#### Docker Container Management

```powershell
# Container lifecycle management
docker run <TAB>                # Shows popular image names and options
docker run -it <TAB>            # Filters to interactive-capable images
docker exec -it <TAB>           # Shows only running containers

# Image and network operations
docker build -t <TAB>           # Suggests image naming conventions
docker network create <TAB>     # Shows network driver options
docker volume create <TAB>      # Shows volume driver options

# Docker Compose workflows
docker-compose <TAB>            # Shows compose commands
docker-compose up <TAB>         # Shows service names from docker-compose.yml
```

#### Kubernetes Operations

```powershell
# Resource management
kubectl get <TAB>               # Shows all available resource types
kubectl describe pod <TAB>      # Shows actual pod names in current namespace
kubectl logs <TAB>              # Shows pods with available logs

# Namespace and context switching
kubectl config use-context <TAB> # Shows available contexts
kubectl config set-context <TAB> # Shows context configuration options
kubectl -n <TAB>                # Shows available namespaces

# Advanced operations
kubectl apply -f <TAB>          # Shows YAML/JSON files in current directory
kubectl port-forward <TAB>      # Shows services and pods that can be forwarded
```

#### Package Management Workflows

```powershell
# .NET development
dotnet new <TAB>                # Shows available project templates
dotnet add package <TAB>        # Shows popular NuGet packages
dotnet run --<TAB>              # Shows available runtime options

# Node.js development  
npm init <TAB>                  # Shows initialization templates
npm install <TAB>               # Shows popular packages and suggestions
npm run <TAB>                   # Shows available scripts from package.json

# Python development
pip install <TAB>               # Shows popular PyPI packages
pip show <TAB>                  # Shows installed packages
python -m <TAB>                 # Shows available modules
```

### Completion Examples

#### Real-World Scenarios

**Scenario 1: Setting up a new Git repository**
```powershell
# PSPredictor guides you through the entire workflow
git init                        # Initialize repository
git add <TAB>                   # Shows files to add
git commit -m "Initial commit"  # Commit changes
git remote add origin <TAB>     # Suggests common remote patterns
git push -u origin <TAB>        # Shows branch options
```

**Scenario 2: Docker development environment**
```powershell
# Complete container development workflow
docker network create <TAB>     # Shows network driver options
docker run -d --name db <TAB>   # Shows database image suggestions
docker run --link db <TAB>      # Shows linking options with existing containers
docker logs <TAB>               # Shows containers with available logs
```

**Scenario 3: Kubernetes deployment**
```powershell
# Full Kubernetes application deployment
kubectl create namespace <TAB>   # Suggests naming conventions
kubectl apply -f <TAB>          # Shows YAML files in directory
kubectl get pods -n <TAB>       # Shows available namespaces
kubectl port-forward <TAB>      # Shows services available for forwarding
```

### Troubleshooting

#### Common Issues and Solutions

**Issue: Completions not appearing**
```powershell
# Check module status
Get-PSPredictorStatus

# Verify module is loaded
Get-Module PSPredictor

# Re-import module if needed
Import-Module PSPredictor -Force
```

**Issue: Slow completion performance**
```powershell
# Check performance metrics
Get-PSPredictorStatus | Select-Object -ExpandProperty Performance

# Optimize cache settings
Set-PSPredictorConfig -CacheSize 500  # Reduce cache size
Set-PSPredictorConfig -ResponseTimeout 50ms  # Reduce timeout
```

**Issue: AI predictions not working**
```powershell
# Check AI engine status
Get-PSPredictorAI

# Reset AI models
Reset-PSPredictorAI -ReloadModels

# Disable AI if needed
Set-PSPredictorAI -EnableLocalModels $false
```

**Issue: Conflicts with other modules**
```powershell
# Check for conflicting completions
Get-PSReadLineKeyHandler | Where-Object { $_.Key -eq "Tab" }

# Disable conflicting modules temporarily
Remove-Module PSReadLine -Force
Import-Module PSPredictor -Force
```

#### Performance Optimization

```powershell
# Monitor performance
Measure-Command { <your command><TAB> }

# Optimize for your workflow
Set-PSPredictorProfile -Name "Performance"  # Use performance-optimized profile
Set-PSPredictorConfig -MaxSuggestions 5     # Limit suggestions for speed
Set-PSPredictorConfig -FuzzyMatching $false # Disable fuzzy matching if not needed
```

#### Debugging and Logging

```powershell
# Enable verbose logging
Set-PSPredictorConfig -LogLevel "Verbose"
Set-PSPredictorConfig -LogPath "$HOME\PSPredictor.log"

# View recent activity
Get-PSPredictorLog -Last 50

# Clear logs
Clear-PSPredictorLog -Confirm:$false
```

## 📚 References

### Documentation

#### Core Documentation
- **[Product Requirements Document](PRD.md)**: Complete product specification and architecture details
- **[Technical Framework](FRAMEWORK.md)**: Architectural patterns, design principles, and technical guidelines
- **[Development Standards](STANDARDS.md)**: Coding standards, quality requirements, and best practices
- **[Technical Specifications](SPECIFICATIONS.md)**: API contracts, system requirements, and technical details
- **[Project Planning](PLANNING.md)**: Development roadmap, milestones, and project management
- **[Strategic Roadmap](ROADMAP.md)**: Long-term vision and strategic direction (2025-2027)

#### User Documentation
- **[Contributing Guide](CONTRIBUTING.md)**: How to contribute to the project
- **[Legacy v1.x Documentation](docs/archives/2025-07-30-PROJECT.md)**: Previous version reference
- **[Migration Guide](docs/archives/2025-07-30-PROJECT.md)**: Upgrading from v1.x to v2.0
- **[Troubleshooting Guide](docs/archives/TROUBLESHOOTING.md)**: Common issues and solutions

### API Reference

#### Core Cmdlets

**Configuration Management**
```powershell
Get-PSPredictorStatus          # Display module status and performance metrics
Set-PSPredictorMode           # Configure editing mode and behavior
Set-PSPredictorConfig         # Modify configuration settings
Get-PSPredictorConfig         # Retrieve current configuration
```

**AI and Prediction Engine**
```powershell
Set-PSPredictorAI             # Configure AI prediction settings
Get-PSPredictorAI             # Get AI engine status
Reset-PSPredictorAI           # Reset AI models and cache
```

**Profile and Customization**
```powershell
Set-PSPredictorProfile        # Switch between configuration profiles
New-PSPredictorProfile        # Create custom configuration profile
Export-PSPredictorConfig      # Export configuration to file
Import-PSPredictorConfig      # Import configuration from file
```

**Completion Management**
```powershell
Get-PSPredictorTools          # List all supported CLI tools
Register-PSPredictorCompletion # Add custom completion provider
Enable-PSPredictorCompletion  # Enable specific tool completion
Disable-PSPredictorCompletion # Disable specific tool completion
```

#### Advanced Configuration Objects

**PSPredictorConfig**
- `MaxSuggestions`: Maximum number of completion suggestions (default: 10)
- `CaseSensitive`: Enable case-sensitive matching (default: false)
- `FuzzyMatching`: Enable fuzzy matching algorithm (default: true)
- `ResponseTimeout`: Maximum completion response time (default: 100ms)
- `CacheSize`: Number of cached completions (default: 1000)

**PSPredictorAI**
- `EnableLocalModels`: Use embedded ML.NET models (default: true)
- `DownloadEnhancedModels`: Download additional models (default: false)
- `PredictionConfidence`: Minimum confidence threshold (default: 0.7)
- `ModelPath`: Custom model file location

### Development

#### Building from Source

**Prerequisites**
- .NET 9.0 SDK or later
- PowerShell 7.4+ 
- Git for source control

**Build Commands**
```bash
# Clone repository
git clone https://github.com/wangkanai/PSPredictor.git
cd PSPredictor

# Restore dependencies and build
dotnet restore
dotnet build --configuration Release

# Run comprehensive test suite
dotnet test                           # All tests
dotnet test tests/Core/               # Core functionality tests
dotnet test tests/AI/                 # AI/ML prediction tests
dotnet test tests/Integration/        # End-to-end integration tests
dotnet test tests/Performance/        # Performance benchmarks

# Build NuGet package
dotnet pack --configuration Release
```

#### Architecture Overview

**Project Structure**
```
src/
├── PSPredictor/                    # Main binary module (.NET 9.0)
│   ├── Cmdlets/                   # PowerShell cmdlet implementations  
│   ├── Core/                      # Prediction engine, completion provider
│   ├── AI/                        # ML.NET integration with embedded models
│   ├── Input/                     # Native input handling (Cmd/Emacs/Vi modes)
│   ├── Rendering/                 # ANSI rendering, syntax highlighting
│   └── Completions/               # 26+ CLI tool completion providers
├── Core/                          # Shared core library
└── Shared/                        # Common utilities

tests/
├── Core/                          # Core module tests
├── AI/                            # AI/ML prediction tests
├── Integration/                   # End-to-end integration tests
└── Performance/                   # Performance benchmarks
```

#### Technology Stack
- **.NET 9.0**: High-performance C# 13.0 with latest language features
- **PowerShell SDK 7.5**: Enhanced PowerShell framework with improved performance
- **ML.NET 4.0**: Latest machine learning framework with enhanced capabilities
- **xUnit v3 + FluentAssertions**: Modern testing framework with fluent assertions
- **BenchmarkDotNet**: Performance testing and regression detection

#### Adding New CLI Tool Support

**Step 1: Create Completion Provider**
```csharp
public class MyToolCompletion : BaseCompletion
{
    public override string ToolName => "mytool";
    
    public override IEnumerable<CompletionResult> GetCompletions(
        string commandLine, int cursorPosition)
    {
        // AI-powered completion logic with context awareness
        var context = AnalyzeContext(commandLine, cursorPosition);
        var predictions = _aiEngine.PredictCompletions(context);
        
        return predictions.Select(p => new CompletionResult(
            p.Text, p.DisplayText, p.Description, p.ResultType));
    }
    
    protected override bool ShouldCache(string input) => true;
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
