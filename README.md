# PSPredictor
## PowerShell Universal CLI Predictor

🚀 **Comprehensive auto-completion and intelligent prediction for popular command-line tools in PowerShell**

[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/PSPredictor?style=flat-square)](https://www.powershellgallery.com/packages/PSPredictor)
[![License](https://img.shields.io/github/license/wangkanai/PSPredictor?style=flat-square)](LICENSE)
[![Stars](https://img.shields.io/github/stars/wangkanai/PSPredictor?style=flat-square)](https://github.com/wangkanai/PSPredictor/stargazers)

## ✨ Features

- **🎯 Universal CLI Prediction**: Intelligent auto-completion for 26+ popular command-line tools
- **⚡ Fast & Lightweight**: Optimized for performance with minimal startup overhead
- **🔧 Easy Installation**: Single command installation from PowerShell Gallery
- **🎨 Enhanced UI**: Beautiful tab completion with syntax highlighting
- **🔄 Auto-Updates**: Keep completions up-to-date automatically
- **🛠️ Extensible**: Easy to add custom completions for your tools

## 🚀 Quick Start

### Installation

```powershell
# Install from PowerShell Gallery
Install-Module -Name PSPredictor -Scope CurrentUser

# Import the module
Import-Module PSPredictor

# Add to your PowerShell profile for automatic loading
Add-Content $PROFILE "Import-Module PSPredictor"
```

### Usage

Once installed, PSPredictor automatically provides intelligent completions for supported CLI tools:

```powershell
# Git commands with intelligent completion
git che<TAB>  # → git checkout
git checkout ma<TAB>  # → git checkout main

# Docker commands
docker ru<TAB>  # → docker run
docker run -p 80<TAB>  # → docker run -p 8080:80

# NPM commands
npm inst<TAB>  # → npm install
npm install --save-d<TAB>  # → npm install --save-dev
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
| Feature | PSPredictor | Manual Setup |
|---------|-------------|--------------|
| **Coverage** | 26+ tools | Limited |
| **Maintenance** | Auto-updates | Manual effort |
| **Consistency** | Unified experience | Varies by tool |
| **Installation** | Single command | Complex setup |

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

# Build the module
./build.ps1

# Run tests
./test.ps1

# Install locally
./install.ps1
```

### Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

1. Fork the repository
2. Create a feature branch
3. Add completions or improvements
4. Write tests
5. Submit a pull request

### Adding New Completions

```powershell
# Example: Adding support for a new CLI tool
Register-PSPredictorCompletion -Command "mycli" -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    
    # Your completion logic here
    return @("option1", "option2", "option3")
}
```

## 📈 Performance

- **⚡ Startup Time**: < 100ms module load
- **🎯 Completion Speed**: < 50ms average response
- **💾 Memory Usage**: < 10MB runtime footprint
- **📦 Size**: < 5MB total package size

## 🔗 Related Projects

- [PSReadLine](https://github.com/PowerShell/PSReadLine) - Enhanced command line editing
- [oh-my-posh](https://github.com/JanDeDobbeleer/oh-my-posh) - Beautiful prompt themes
- [PSFzf](https://github.com/kelleyma49/PSFzf) - Fuzzy finder integration
- [posh-git](https://github.com/dahlbyk/posh-git) - Git integration for PowerShell

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- PowerShell team for the excellent PSReadLine module
- All CLI tool maintainers for their fantastic tools
- Community contributors for completions and feedback

---

**Made with ❤️ for the PowerShell community**

[Report Bug](https://github.com/wangkanai/PSPredictor/issues) · [Request Feature](https://github.com/wangkanai/PSPredictor/issues) · [Contribute](CONTRIBUTING.md)