# PSPredictor

## PowerShell Universal CLI Predictor

🚀 **Revolutionary PowerShell Binary Module transforming your terminal into a comprehensive IDE experience**

[![Build Status](https://github.com/wangkanai/PSPredictor/actions/workflows/dotnet.yml/badge.svg)](https://github.com/wangkanai/PSPredictor/actions/workflows/dotnet.yml)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/PSPredictor?style=flat-square)](https://www.powershellgallery.com/packages/PSPredictor)
[![License](https://img.shields.io/github/license/wangkanai/PSPredictor?style=flat-square)](LICENSE)
[![Stars](https://img.shields.io/github/stars/wangkanai/PSPredictor?style=flat-square)](https://github.com/wangkanai/PSPredictor/stargazers)

> **⚠️ MAJOR VERSION TRANSITION**: PSPredictor v2.0 is a complete rewrite from PowerShell scripts to a high-performance
> C# .NET 9.0 binary module with AI-powered intelligence and IDE-like features.

## 📚 Legacy Version Reference

**Looking for PSPredictor v1.x?** The previous PowerShell script-based version is available at:
[📖 PSPredictor v1.x Documentation](https://github.com/wangkanai/PSPredictor/blob/release/1.3/README.md)

**Migration Path**: v1.x users can upgrade to v2.0 for significantly improved performance, AI-powered intelligence, and
native cross-platform support. See our [migration guide](docs/archives/2025-07-30-PROJECT.md) for detailed transition
instructions.

---

## 🚀 Quick Start

### What is PSPredictor?

PSPredictor v2.0 is a revolutionary **C# .NET 9.0 binary module** that transforms PowerShell into an intelligent, 
IDE-like terminal experience with:

- 🧠 **AI-Powered Intelligence**: ML.NET integration with local models for intelligent command prediction
- ⚡ **Native Performance**: <50ms response time with <20MB memory footprint
- 🎨 **Real-time Syntax Highlighting**: PowerShell and CLI tool syntax coloring as you type
- 🔧 **26+ CLI Tool Support**: Git, Docker, Kubernetes, Azure CLI, AWS CLI, and more
- 📝 **Advanced Editing Modes**: Cmd, Emacs, and Vi modes with customizable key bindings

### Installation

```powershell
# Install from PowerShell Gallery (recommended)
Install-Module PSPredictor -Scope CurrentUser

# Import and enable
Import-Module PSPredictor
Enable-PSPredictor

# Verify installation
Get-PSPredictorStatus
```

### Try It Now

```powershell
# Experience intelligent completions
git <TAB>           # See Git commands with descriptions
docker run <TAB>    # Get container options and image suggestions
kubectl get <TAB>   # Explore Kubernetes resources

# Configure your preferences
Set-PSPredictorMode -EditingMode Emacs  # or Vi, Cmd
Set-PSPredictorKeyBinding -Key "Ctrl+Space" -Function "TriggerIntelliSense"
```

**Immediate Benefits:**
- ✅ Intelligent completions for Git, Docker, PowerShell, and more
- ✅ Real-time syntax highlighting and error detection
- ✅ AI-powered command suggestions based on your usage patterns
- ✅ Enhanced editing experience with multiple modes

---

## 📖 Documentation

For comprehensive documentation, configuration guides, and advanced usage examples, see our complete documentation:

**📚 [Complete User Guide & Documentation →](docs/readme.md)**

### Quick Links

- **[Installation Guide](docs/readme.md#-installation)**: Detailed setup for all platforms
- **[Configuration Reference](docs/readme.md#-configuration)**: Complete configuration options  
- **[Features Overview](docs/readme.md#-features)**: Full feature showcase with examples
- **[User Guide](docs/readme.md#-user-guide)**: Comprehensive usage guide and workflows
- **[Troubleshooting](docs/readme.md#troubleshooting)**: Common issues and solutions

### Architecture & Development

- **[Architecture Guide](FRAMEWORK.md)**: Technical architecture and design patterns
- **[Development Standards](STANDARDS.md)**: Coding guidelines and quality standards
- **[API Specifications](SPECIFICATIONS.md)**: Detailed technical specifications
- **[Contributing Guidelines](CONTRIBUTING.md)**: How to contribute to PSPredictor

### Legacy Support

- **[v1.x Documentation](docs/archives/2025-07-30-PROJECT.md)**: Complete v1.x reference
- **[Migration Guide](docs/readme.md#-legacy-version-reference)**: Upgrading from v1.x to v2.0

---

## ✨ Key Features

### 🧠 AI-Powered Intelligence
- **Local ML Models**: Embedded ML.NET models for instant, offline functionality
- **Context-Aware Suggestions**: Understands Git state, Docker environment, Kubernetes cluster
- **Predictive IntelliSense**: Non-intrusive completion suggestions that appear as you type
- **Continuous Learning**: Learns from your usage patterns to improve suggestions

### 🎨 IDE-Like Terminal Experience
- **Real-time Syntax Highlighting**: PowerShell and CLI tool syntax coloring
- **Visual Error Indication**: Immediate feedback on syntax errors and invalid commands
- **Multi-line Editing**: Advanced editing with proper indentation and formatting
- **Dynamic Help System**: Context-sensitive help without leaving the command line

### ⚡ Native Performance
- **<50ms Response Time**: Lightning-fast completions powered by optimized C# code
- **<20MB Memory Footprint**: Efficient resource usage for everyday productivity
- **Cross-Platform**: Full Windows, Linux, and macOS support (including ARM64)
- **Lazy Loading**: Components load on-demand for optimal startup performance

### 🔧 Comprehensive CLI Tool Support
- **26+ Popular Tools**: Git, Docker, Kubernetes, Azure CLI, AWS CLI, npm, and many more
- **Context-Aware Completions**: Understanding of tool state and environment
- **Dynamic Parameters**: Intelligent parameter suggestions based on command context
- **Cross-Tool Intelligence**: Understands relationships between different tools

---

## 🛠️ System Requirements

### Supported Platforms
- ✅ **Windows**: 10/11, Server 2019/2022 (PowerShell 5.1+ or Core 7.0+)
- ✅ **Linux**: Ubuntu 20.04+, RHEL 8+, Debian 11+ (PowerShell Core 7.0+)
- ✅ **macOS**: 11.0+ including Apple Silicon M1/M2/M3 (PowerShell Core 7.0+)

### Prerequisites
- **.NET Runtime**: .NET 9.0+ (included with PowerShell 7.4+)
- **Architecture**: x64 and ARM64 fully supported
- **Dependencies**: Self-contained, no additional dependencies required

---

## 🤝 Community & Support

### Getting Help
- **[GitHub Issues](https://github.com/wangkanai/PSPredictor/issues)**: Bug reports and feature requests
- **[GitHub Discussions](https://github.com/wangkanai/PSPredictor/discussions)**: Community Q&A
- **[Documentation](docs/readme.md)**: Comprehensive guides and examples

### Contributing
- **[Contributing Guide](CONTRIBUTING.md)**: How to contribute to PSPredictor
- **[Development Setup](docs/readme.md#development-installation)**: Building from source
- **[Architecture Guide](FRAMEWORK.md)**: Understanding the codebase

### Distribution
- **[PowerShell Gallery](https://www.powershellgallery.com/packages/PSPredictor)**: Official package distribution
- **[NuGet Gallery](https://www.nuget.org/packages/PSPredictor)**: Alternative package source
- **[GitHub Releases](https://github.com/wangkanai/PSPredictor/releases)**: Latest releases and pre-releases

---

## 📋 Performance Specifications

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

---

## 🚀 Made with ❤️ and AI for the PowerShell community

**Transform your terminal into an intelligent, IDE-like experience with PSPredictor v2.0**

**License**: MIT License - see [LICENSE](LICENSE) file  
**Copyright**: © 2024-2025 PSPredictor Contributors

[📋 Report Bug](https://github.com/wangkanai/PSPredictor/issues) ·
[💡 Request Feature](https://github.com/wangkanai/PSPredictor/issues) ·
[🤝 Contribute](CONTRIBUTING.md) ·
[📚 Documentation](docs/readme.md) ·
[🏗️ Architecture](FRAMEWORK.md)