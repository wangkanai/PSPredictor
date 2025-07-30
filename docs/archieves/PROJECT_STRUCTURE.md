# PSPredictor Project Structure

## 📁 Directory Organization

```
PSPredictor/
├── src/                          # 📦 Source Code
│   ├── PSPredictor.psd1         #    Module manifest with metadata
│   ├── PSPredictor.psm1         #    Main module loader
│   ├── Public/                  #    Public functions (exported)
│   │   ├── Get-PSPredictorTools.ps1           #    Tool listing
│   │   ├── Install-PSPredictor.ps1            #    Installation
│   │   ├── Register-PSPredictorCompletion.ps1 #    Completion registration
│   │   └── Uninstall-PSPredictor.ps1          #    Uninstallation
│   ├── Private/                 #    Private functions (internal)
│   │   └── Config.ps1           #    Tool configuration and settings
│   └── Completions/             #    CLI completion providers (26+ tools)
│       ├── Azure.ps1            #    Azure CLI completions
│       ├── AWS.ps1              #    AWS CLI completions
│       ├── Bash.ps1             #    Bash shell completions
│       ├── Claude.ps1           #    Claude AI CLI completions
│       ├── Docker.ps1           #    Docker completions
│       ├── DotNet.ps1           #    .NET CLI completions
│       ├── Gemini.ps1           #    Gemini AI CLI completions
│       ├── Git.ps1              #    Git completions
│       ├── GitHub.ps1           #    GitHub CLI completions
│       ├── Homebrew.ps1         #    Homebrew completions
│       ├── Kubectl.ps1          #    Kubernetes kubectl completions
│       ├── NPM.ps1              #    npm completions
│       ├── Podman.ps1           #    Podman completions
│       ├── PowerShell.ps1       #    PowerShell Core (pwsh) completions
│       ├── Python.ps1           #    Python completions
│       ├── Terraform.ps1        #    Terraform completions
│       ├── Tmux.ps1             #    tmux completions
│       ├── Zsh.ps1              #    Zsh shell completions
│       └── ... (18+ more tools) #    Additional CLI tools
├── tests/                        # 🧪 Test Suite (145+ tests)
│   ├── PSPredictor.Tests.ps1    #    Core module functionality tests
│   ├── Public/                  #    Public function tests
│   │   ├── Get-PSPredictorTools.Tests.ps1
│   │   ├── Install-PSPredictor.Tests.ps1
│   │   ├── Register-PSPredictorCompletion.Tests.ps1
│   │   └── Uninstall-PSPredictor.Tests.ps1
│   ├── Private/                 #    Private function tests
│   │   └── Config.Tests.ps1
│   ├── Completions/             #    CLI completion tests
│   │   ├── Shell.Tests.ps1      #    Shell completions (PowerShell/Zsh/Bash)
│   │   ├── Azure.Tests.ps1      #    Azure CLI tests
│   │   ├── AWS.Tests.ps1        #    AWS CLI tests
│   │   ├── Claude.Tests.ps1     #    Claude AI tests
│   │   ├── Docker.Tests.ps1     #    Docker tests
│   │   ├── Git.Tests.ps1        #    Git tests
│   │   ├── Kubectl.Tests.ps1    #    Kubernetes tests
│   │   ├── NPM.Tests.ps1        #    npm tests
│   │   ├── Terraform.Tests.ps1  #    Terraform tests
│   │   └── ... (15+ more test files)
│   └── TestConfig.ps1           #    Test configuration and helpers
├── .github/                      # 🤖 CI/CD Automation
│   ├── workflows/               
│   │   ├── publish.yml          #    Automated PowerShell Gallery publishing
│   │   └── test.yml             #    Cross-platform testing (Windows/Linux/macOS)
│   ├── scripts/
│   │   └── bump-version.ps1     #    Version management utility
│   └── PUBLISH_AUTOMATION.md    #    Publishing documentation
├── build.ps1                    # 🔨 Build automation script
├── test-runner.ps1              # 🏃 Simple test runner
├── CLAUDE.md                    # 🤖 Claude Code integration guide
├── CONTRIBUTING.md              # 👥 Contribution guidelines
├── LICENSE                      # 📄 MIT License
└── README.md                    # 📖 Project documentation
```

## 🏗️ Architecture Benefits

### ✅ **Clean Separation**
- **Source code** isolated in `src/` for clean distribution
- **Tests** separated for focused development and CI/CD
- **Build artifacts** generated in temporary `build/` directory

### ✅ **Professional Testing**
- **Pester-based** comprehensive test suite (145+ tests across 17 test files)
- **Modular test structure** matching source organization
- **Cross-platform** compatibility validation (Windows/Linux/macOS)  
- **Performance** and resource usage monitoring
- **Error handling** and edge case coverage

### ✅ **Automated Quality**
- **GitHub Actions** for continuous integration
- **Automated publishing** to PowerShell Gallery
- **Version management** with semantic versioning
- **Release notes** auto-generation

### ✅ **Developer Experience**
- **Build script** with multiple tasks (Build, Test, Package, Publish)
- **Version bumping** utility for easy releases
- **Documentation** for contributors and maintainers
- **IDE integration** guidance in CLAUDE.md

## 🚀 Development Workflow

### 1. **Local Development**
```powershell
# Build module (creates modular structure in build/)
./build.ps1 -Task Build

# Run comprehensive tests (145+ tests)
./build.ps1 -Task Test

# Install locally for testing
./build.ps1 -Task Install

# Build and package everything
./build.ps1 -Task All
```

### 2. **Version Management**
```powershell
# Bump version
./.github/scripts/bump-version.ps1 -Type Patch

# Commit changes
git add src/PSPredictor.psd1
git commit -m "Bump version to $(Get-Content src/PSPredictor.psd1 | Select-String 'ModuleVersion')"
```

### 3. **Automated Publishing**
```bash
# Create pull request
git checkout -b feature/my-feature
git push origin feature/my-feature

# After PR approval and merge to main:
# - Tests run automatically
# - Module publishes to PowerShell Gallery
# - GitHub release created
```

## 🧪 Testing Strategy

### **Test Coverage**
- **Module Structure**: Manifest validation, imports, exports, modular loading
- **Public Functions**: All 4 exported functions with comprehensive scenarios
- **Private Functions**: Internal configuration and helper functions
- **Completion Providers**: All 26+ CLI tools with registration testing
- **Error Handling**: Invalid inputs, edge cases, recovery scenarios
- **Performance**: Load times, memory usage, response times
- **Cross-Platform**: Windows, Linux, macOS compatibility validation

### **Test Execution**
```powershell
# Run specific test suites
Invoke-Pester ./tests/PSPredictor.Tests.ps1
Invoke-Pester ./tests/Public/
Invoke-Pester ./tests/Completions/

# Run all tests via build script (145+ tests)
./build.ps1 -Task Test

# Simple functionality validation
./test-runner.ps1
```

## 📦 Distribution

### **PowerShell Gallery**
- **Automated publishing** on main branch merges
- **Version conflict prevention** (won't publish duplicate versions)
- **Release notes** auto-generated from commits
- **Installation**: `Install-Module -Name PSPredictor`

### **GitHub Releases**
- **Tagged releases** with installation instructions
- **Changelog** with commit history
- **Download links** for manual installation
- **Release assets** with module packages

## 🔧 Build System

### **Available Tasks**
- `Build`: Compile module from source to build directory
- `Test`: Run Pester tests with fallback to basic tests
- `Package`: Create distribution packages (ZIP, NuGet structure)
- `Install`: Install module locally for testing
- `Publish`: Publish to PowerShell Gallery with API key
- `Clean`: Remove build artifacts
- `All`: Execute Clean → Build → Test → Package sequence

### **Build Configuration**
- **Debug**: Development builds with debug version suffix
- **Release**: Production builds for publishing
- **Verbose**: Detailed build output for troubleshooting
- **Force**: Override existing installations/packages

## 🎯 Quality Standards

### **Code Quality**
- **PowerShell best practices** compliance
- **Consistent formatting** and naming conventions
- **Comprehensive documentation** for all functions
- **Error handling** with meaningful messages

### **Testing Requirements**
- **≥80% test coverage** for core functionality
- **Cross-platform compatibility** validation
- **Performance benchmarks** (load <2s, functions <500ms)
- **Error scenarios** covered with expected behaviors

### **CI/CD Standards**
- **All tests must pass** before merge
- **Version increments** required for publishing
- **Automated quality gates** with build validation
- **Security scanning** and dependency updates

---

**Last Updated**: 2025-07-30  
**Version**: 3.0 (Updated for modular architecture with 26+ CLI tools)  
**Maintainer**: Sarin Na Wangkanai  
**License**: MIT