# PSPredictor

## PowerShell Universal CLI Predictor

🚀 **Revolutionary PowerShell Binary Module transforming your terminal into a comprehensive IDE experience**

[![Build Status](https://github.com/wangkanai/PSPredictor/actions/workflows/dotnet.yml/badge.svg)](https://github.com/wangkanai/PSPredictor/actions/workflows/dotnet.yml)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/PSPredictor?style=flat-square)](https://www.powershellgallery.com/packages/PSPredictor)
[![License](https://img.shields.io/github/license/wangkanai/PSPredictor?style=flat-square)](LICENSE)
[![Stars](https://img.shields.io/github/stars/wangkanai/PSPredictor?style=flat-square)](https://github.com/wangkanai/PSPredictor/stargazers)

> **⚠️ MAJOR VERSION TRANSITION**: PSPredictor v2.0 is a complete rewrite from PowerShell scripts to a high-performance
> C# .NET 9.0 binary module with AI-powered intelligence and IDE-like features.

## ✨ Revolutionary Features

### 🧠 AI-Powered Intelligence

- **ML.NET Integration**: Local machine learning with embedded models for intelligent predictions
- **Context-Aware Suggestions**: Understands your workflow and environment for smarter completions
- **Predictive IntelliSense**: IDE-like IntelliSense experience directly in your terminal
- **Command History Learning**: Learns from your patterns to provide personalized suggestions

### 🎨 IDE-Like Terminal Experience

- **Real-Time Syntax Highlighting**: Live syntax coloring for PowerShell and CLI tools
- **Visual Error Indication**: Instant error detection and contextual error messages
- **Multi-Line Editing**: Advanced multi-line command editing with proper indentation
- **Dynamic Help Display**: Real-time help without losing your command-line position

### ⚡ Native Performance

- **C# Binary Module**: High-performance .NET 9.0 implementation with <100ms response times
- **Cross-Platform Support**: Full compatibility across Windows, Linux, and macOS (x64 and ARM64)
- **Memory Efficient**: <50MB memory footprint optimized for long-running sessions
- **PSReadLine Independent**: Native input handling system with advanced editing capabilities

### 🎯 Advanced Editing Modes

- **Multi-Modal Editing**: Cmd, Emacs, and Vi editing modes with full feature parity
- **Custom Key Bindings**: Fully customizable keyboard shortcuts and macro support
- **Kill-Ring System**: Emacs-style advanced clipboard functionality
- **Token-Based Navigation**: PowerShell syntax-aware cursor movement and selection

### 🛠️ Comprehensive CLI Tool Support

- **26+ CLI Tools**: Intelligent completion for Git, Docker, Azure, AWS, Kubernetes, and more
- **Plugin Architecture**: Easily extensible system for adding new tools
- **Context Awareness**: Tool-specific intelligence (Git branches, Docker containers, etc.)
- **Performance Optimized**: Intelligent caching and lazy loading for instant responses

## 🚀 Quick Start

### Installation

#### Production Release (Coming Soon)

```powershell
# Install from PowerShell Gallery
Install-Module -Name PSPredictor -RequiredVersion 2.0.0 -Scope CurrentUser

# Import the binary module
Import-Module PSPredictor

# Add to your PowerShell profile for automatic loading
Add-Content $PROFILE "Import-Module PSPredictor"
```

#### Development Build (Current)

```powershell
# Clone and build from source
git clone https://github.com/wangkanai/PSPredictor.git
cd PSPredictor

# Build the C# binary module (.NET 9.0 required)
dotnet build --configuration Release

# Import development build
Import-Module ./src/PSPredictor/bin/Release/net9.0/PSPredictor.dll -Force
```

### Usage

PSPredictor v2.0 transforms your PowerShell terminal into an intelligent IDE-like experience:

#### Basic Intelligent Completion

```powershell
# AI-powered Git completion with context awareness
git che<TAB>                    # → git checkout (with branch suggestions)
git checkout <TAB>              # Shows: main, develop, feature/xyz, origin/main
git commit -m "<TAB>            # Suggests commit message templates

# Docker completion with container context
docker exec -it <TAB>          # Shows running container names
docker logs <TAB>              # Shows containers with log output
docker ps --filter <TAB>       # Shows available filter options

# Kubernetes completion with cluster context
kubectl get <TAB>              # Shows: pods, services, deployments, etc.
kubectl describe pod <TAB>     # Shows actual pod names from current namespace
```

#### Advanced IDE Features

```powershell
# Enable enhanced editing mode with AI predictions
Set-PSPredictorMode -Mode Enhanced

# Configure advanced editing modes
Set-PSPredictorMode -EditingMode Emacs    # Emacs-style key bindings
Set-PSPredictorMode -EditingMode Vi       # Vi/Vim-style editing

# Customize key bindings
Set-PSPredictorKeyBinding -Key "Ctrl+Space" -Function "TriggerIntelliSense"
Set-PSPredictorKeyBinding -Key "F1" -Function "ShowDynamicHelp"

# Check module status and performance
Get-PSPredictorStatus                     # Shows AI model status, performance metrics
```

#### Real-Time Syntax and Error Detection

```powershell
# Real-time syntax highlighting (automatically active)
git status --invalid-flag                # Shows error highlighting
docker run --memory=invalid              # Visual error indication with suggestions

# Multi-line editing with proper indentation
if ($condition)
{
  Get-Process | Where-Object {
  # Automatic indentation
    $_.CPU -gt 100                    # Syntax highlighting
  }
}                                         # Bracket matching
```

## 📦 Supported CLI Tools

### Container & Infrastructure

- **Docker**: Complete container management (run, build, images, networks, volumes)
- **Podman**: Daemonless container tool with full Docker compatibility
- **Terraform**: Infrastructure as code (plan, apply, destroy, resources)
- **Kubernetes**: kubectl with resources, namespaces, and context switching

### Development Tools

- **Git**: Comprehensive version control (branches, commits, remotes, tags, workflows)
- **.NET**: Complete dotnet CLI (new templates, build, test, publish, packages)
- **Node.js**: npm, npx package management and script execution
- **Python**: pip, pipx, pyenv for package and version management
- **Python Interpreter**: Module execution, command-line options

### AI & Code Assistance

- **Claude AI**: Chat, completion, models, authentication, conversations
- **Gemini AI**: Generation, models, file operations, multi-modal support
- **OpenAI Codex**: Code completion and generation

### Cloud Platforms

- **Azure**: Comprehensive az CLI coverage (compute, storage, networking)
- **AWS**: Complete aws CLI with services, regions, and parameters
- **GitHub**: Full gh CLI integration (repos, PRs, issues, workflows, releases)

### Package Managers

- **Homebrew**: Complete brew commands (install, upgrade, services, cask)
- **Python**: pip (install, upgrade, requirements), pipx (applications)
- **Node.js**: npm (packages, scripts), npx (package execution)

### Terminal & System

- **tmux**: Terminal multiplexer (sessions, windows, panes, key bindings)
- **Hyper**: Modern terminal emulator

### Shells & Interpreters

- **PowerShell**: PowerShell Core (pwsh) with parameters, execution policies, profiles
- **Zsh**: Z shell with comprehensive options, emulation modes, built-in settings
- **Bash**: Bash shell with options, set configurations, RC file management

## 🎯 Key Advantages

### vs. Manual Setup

| Feature          | PSPredictor        | Manual Setup   |
|------------------|--------------------|----------------|
| **Coverage**     | 26+ tools          | Limited        |
| **Maintenance**  | Auto-updates       | Manual effort  |
| **Consistency**  | Unified experience | Varies by tool |
| **Installation** | Single command     | Complex setup  |

### vs. Other Solutions

- **🔥 Faster**: Optimized completion engine
- **🧠 Smarter**: Context-aware predictions
- **🎨 Better UX**: Enhanced visual feedback
- **📈 More Complete**: Broader tool coverage

## 🛠️ Configuration

### Basic Configuration

```powershell
# Enable/disable specific completions
Set-PSPredictorConfig -Tool "git" -Enabled $true
Set-PSPredictorConfig -Tool "docker" -Enabled $false

# Configure prediction behavior
Set-PSPredictorConfig -MaxSuggestions 10
Set-PSPredictorConfig -CaseSensitive $false
```

### Advanced Configuration

```powershell
# Custom completion files location
Set-PSPredictorConfig -CompletionPath "$HOME/.pspredict"

# Enable fuzzy matching
Set-PSPredictorConfig -FuzzyMatching $true

# Configure update frequency
Set-PSPredictorConfig -AutoUpdate -Frequency "Weekly"
```

## 📚 Examples

### Git Workflow

```powershell
# Branch operations
git branch <TAB>          # Shows all branches
git checkout -b feat<TAB>  # Creates new feature branch
git push origin <TAB>     # Shows remote branches

# Commit operations
git add <TAB>             # Shows modified files
git commit -m "<TAB>      # Shows commit message templates
```

### Docker Development

```powershell
# Container management
docker ps <TAB>           # Shows running containers
docker exec -it <TAB>     # Shows container names
docker logs <TAB>         # Shows container names with logs

# Image operations
docker build -t <TAB>     # Shows image name suggestions
docker pull <TAB>         # Shows popular images
```

### Package Management

```powershell
# NPM workflow
npm init <TAB>            # Shows init templates
npm install <TAB>         # Shows package suggestions
npm run <TAB>             # Shows available scripts

# .NET development
dotnet new <TAB>          # Shows project templates
dotnet add package <TAB>  # Shows NuGet packages
dotnet run --<TAB>        # Shows run options
```

### Shell Management

```powershell
# PowerShell Core management
pwsh -<TAB>               # Shows parameters like -Command, -File, -NoProfile
pwsh -ExecutionPolicy <TAB> # Shows policies: Restricted, AllSigned, RemoteSigned, etc.

# Zsh configuration
zsh -o <TAB>              # Shows options like autocd, autopushd, correct, etc.
zsh --emulate <TAB>       # Shows emulation modes: sh, ksh, bash, csh

# Bash configuration  
bash -o <TAB>             # Shows set options: errexit, nounset, pipefail, etc.
bash --rcfile <TAB>       # Shows available RC files: ~/.bashrc, ~/.bash_profile
```

## 🔧 Development

### Building from Source

```bash
# Clone the repository
git clone https://github.com/wangkanai/PSPredictor.git
cd PSPredictor

# Restore dependencies and build C# binary module
dotnet restore
dotnet build --configuration Release

# Run comprehensive test suite
dotnet test                 # All tests (unit, integration, performance)
dotnet test tests/Unit/     # Core module tests
dotnet test tests/AI/       # AI/ML model tests

# Build NuGet package
dotnet pack --configuration Release

# Install development build locally
Import-Module ./src/PSPredictor/bin/Release/net9.0/PSPredictor.dll -Force
```

### Architecture Overview

PSPredictor v2.0 follows a modern C# binary module architecture:

```
src/
├── PSPredictor/                    # Main binary module (.NET 9.0)
│   ├── Cmdlets/                   # PowerShell cmdlet implementations  
│   ├── Core/                      # Prediction engine, completion provider
│   ├── AI/                        # ML.NET integration with embedded models
│   ├── Input/                     # Native input handling (Cmd/Emacs/Vi modes)
│   ├── Rendering/                 # ANSI rendering, syntax highlighting
│   └── Completions/               # 26+ CLI tool completion providers
├── PSPredictor.Core/              # Shared core library
└── PSPredictor.Shared/            # Common utilities

tests/
├── PSPredictor.Tests/             # Main module tests
├── PSPredictor.AI.Tests/          # AI/ML prediction tests
├── PSPredictor.Integration.Tests/ # End-to-end integration tests
└── PSPredictor.Performance.Tests/ # Performance benchmarks
```

### Technology Stack

- **.NET 9.0**: High-performance C# 13.0 with the latest language features
- **ML.NET 3.0.1**: Local machine learning with embedded models
- **PowerShell SDK 7.4.6**: Native PowerShell cmdlet integration
- **xUnit v3 + FluentAssertions**: Next-generation testing framework with improved performance
- **BenchmarkDotNet**: Performance regression testing

### Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

1. Fork the repository
2. Create a feature branch
3. Add completions or improvements
4. Write tests
5. Submit a pull request

### Adding New CLI Tool Support

```csharp
// Example: Adding support for a new CLI tool in C#
public class MyCliCompletion : BaseCompletion
{
    public override string ToolName => "mycli";
    
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

Register the new completion provider:

```csharp
// In CompletionProvider.cs
RegisterProvider(new MyCliCompletion());
```

## 📈 Performance Specifications

### Response Time Targets (v2.0)

- **⚡ Completion Generation**: < 50ms for standard completions
- **🧠 AI Predictions**: < 100ms for ML-powered suggestions
- **🎨 Syntax Highlighting**: < 20ms for real-time coloring
- **📝 Multi-line Rendering**: < 30ms for complex command structures

### Memory Efficiency

- **🚀 Startup Footprint**: < 20MB initial memory usage
- **💾 Runtime Footprint**: < 50MB for typical usage patterns
- **🤖 Model Loading**: Lazy loading with < 5MB core embedded models
- **📚 History Management**: SQLite with automatic cleanup and archiving

### Architecture Performance

- **🔧 C# Binary Module**: Native .NET 9.0 performance with JIT optimization
- **🌐 Cross-Platform**: Consistent performance across Windows, Linux, macOS (x64/ARM64)
- **💡 Intelligent Caching**: LRU cache with 1000-item capacity and 5-minute TTL
- **⚙️ Resource Management**: Dynamic memory allocation with automatic garbage collection

## 🔗 Related Projects & Ecosystem

### PowerShell Enhancement Tools

- [oh-my-posh](https://github.com/JanDeDobbeleer/oh-my-posh) - Beautiful prompt themes (compatible)
- [posh-git](https://github.com/dahlbyk/posh-git) - Git integration for PowerShell (enhanced by PSPredictor)

### AI & Machine Learning

- [ML.NET](https://github.com/dotnet/machinelearning) - Core machine learning framework used in PSPredictor

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🛣️ Roadmap & Version History

### v2.0.0 (In Development) - The Revolutionary Rewrite

- **Complete Architecture Rewrite**: PowerShell scripts → C# .NET 9.0 binary module
- **AI-Powered Intelligence**: ML.NET integration with embedded models
- **Native Input System**: PSReadLine-independent with advanced editing modes
- **IDE-Like Features**: Real-time syntax highlighting, error indication, multi-line editing
- **Cross-Platform Performance**: Full ARM64 support including Apple Silicon Macs

### v1.x (Legacy) - PowerShell Script Foundation

- PowerShell script-based completion system
- Basic CLI tool support and tab completion
- PSReadLine dependency for input handling
- Community-driven completion definitions

For detailed v1.x documentation, see `docs/archives/2025-07-30-PROJECT.md`

## 🙏 Acknowledgments

### v2.0 Development

- **.NET Team**: For the powerful .NET 9.0 platform and ML.NET framework
- **PowerShell Team**: For the excellent PowerShell SDK and System.Management.Automation
- **ML.NET Team**: For local machine learning capabilities and AutoML
- **Community Contributors**: For testing, feedback, and CLI tool expertise

### Legacy v1.x Foundation

- **PowerShell Team**: For PSReadLine module that inspired v1.x architecture
- **CLI Tool Maintainers**: For creating the fantastic tools we enhance
- **Early Adopters**: For feedback and contributions to the PowerShell script foundation

---

## 🚀 Made with ❤️ and AI for the PowerShell community

**Transform your terminal into an intelligent, IDE-like experience with PSPredictor v2.0**

[📋 Report Bug](https://github.com/wangkanai/PSPredictor/issues) ·
[💡 Request Feature](https://github.com/wangkanai/PSPredictor/issues) ·
[🤝 Contribute](CONTRIBUTING.md) ·
[📚 Documentation](docs/) ·
[🏗️ Architecture](docs/FRAMEWORK.md)
