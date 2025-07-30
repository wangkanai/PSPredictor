# PSPredictor Project Structure

## 📁 Directory Organization

```
PSPredictor/
├── src/                          # 📦 Source Code
│   ├── PSPredictor.psd1         #    Module manifest with metadata
│   └── PSPredictor.psm1         #    Main module implementation
├── tests/                        # 🧪 Test Suite
│   ├── PSPredictor.Tests.ps1    #    Core module functionality tests
│   ├── Completions.Tests.ps1    #    CLI completion behavior tests
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
- **Pester-based** comprehensive test suite (50+ tests)
- **Cross-platform** compatibility validation
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
# Import for testing
Import-Module ./src/PSPredictor.psm1 -Force

# Run comprehensive tests
./build.ps1 -Task Test

# Build and package
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
- **Module Structure**: Manifest validation, imports, exports
- **Core Functionality**: Configuration, tool management, completions
- **Error Handling**: Invalid inputs, edge cases, recovery
- **Performance**: Load times, memory usage, response times
- **Cross-Platform**: Windows, Linux, macOS compatibility

### **Test Execution**
```powershell
# Run specific test suites
Invoke-Pester ./tests/PSPredictor.Tests.ps1
Invoke-Pester ./tests/Completions.Tests.ps1

# Run all tests via build script
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
**Version**: 2.0 (Updated for src/tests structure)  
**Maintainer**: Sarin Na Wangkanai  
**License**: MIT