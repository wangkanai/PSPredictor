# PSPredictor Installation Guide

## 📦 Installation

### Prerequisites

**PowerShell Requirements:**
- **Windows**: PowerShell 5.1+ or PowerShell Core 7.0+
- **Linux/macOS**: PowerShell Core 7.0+
- **Recommended**: PowerShell 7.4+ for optimal performance

**.NET Requirements:**
- **.NET Runtime**: .NET 9.0+ (automatically installed with PowerShell 7.4+)
- **Platform Support**: x64 and ARM64 architectures fully supported
- **Dependencies**: No additional dependencies required (self-contained)

**Operating System Compatibility:**
- ✅ **Windows**: 10/11, Server 2019/2022
- ✅ **Linux**: Ubuntu 20.04+, RHEL 8+, Debian 11+, Arch Linux
- ✅ **macOS**: 11.0+ (Big Sur), including Apple Silicon (M1/M2/M3)

**Terminal Compatibility:**
- ✅ **Windows**: Windows Terminal, PowerShell ISE, ConEmu, cmder
- ✅ **Linux**: GNOME Terminal, Konsole, xterm, tmux/screen
- ✅ **macOS**: Terminal.app, iTerm2, Hyper

### Production Installation

**Option 1: PowerShell Gallery (Recommended)**
```powershell
# Install for current user (no admin required)
Install-Module PSPredictor -Scope CurrentUser

# Install system-wide (requires admin/sudo)
Install-Module PSPredictor -Scope AllUsers

# Install specific version
Install-Module PSPredictor -RequiredVersion 2.0.0

# Update to latest version
Update-Module PSPredictor
```

**Option 2: NuGet Package**
```powershell
# Using PackageManagement
Find-Package PSPredictor -Source "https://www.nuget.org/api/v2"
Install-Package PSPredictor

# Using .NET CLI
dotnet add package PSPredictor
```

**Option 3: GitHub Releases**
```powershell
# Download latest release
$url = "https://github.com/wangkanai/PSPredictor/releases/latest/download/PSPredictor.2.0.0.nupkg"
Invoke-WebRequest $url -OutFile "PSPredictor.nupkg"

# Install from local package
Install-Module PSPredictor -Repository PSGallery -Source "./PSPredictor.nupkg"
```

### Development Installation

**Prerequisites for Development:**
- **.NET SDK 9.0+**: Required for building from source
- **Git**: For cloning the repository
- **Visual Studio Code** or **Visual Studio 2022**: Recommended IDEs

**Clone and Build:**
```bash
# Clone repository
git clone https://github.com/wangkanai/PSPredictor.git
cd PSPredictor

# Restore dependencies
dotnet restore

# Build the module
dotnet build --configuration Release

# Run tests
dotnet test

# Create package
dotnet pack --configuration Release
```

**Install Development Build:**
```powershell
# Build and install locally
$ModulePath = Join-Path -Path (Get-Location) -ChildPath "src/PSPredictor/bin/Release/net9.0/PSPredictor.dll"
Import-Module $ModulePath -Force

# Verify development installation
Get-PSPredictorStatus
```

**Development Workflow:**
```bash
# Watch mode for continuous development
dotnet watch build --project src/PSPredictor/PSPredictor.csproj

# Run specific tests
dotnet test tests/PSPredictor.Tests/ --filter "Category=Core"

# Performance testing
dotnet run --project tests/PSPredictor.Performance.Tests/
```

### Verification

**Basic Verification:**
```powershell
# Check module installation
Get-Module PSPredictor -ListAvailable

# Verify module loads correctly
Import-Module PSPredictor
Get-PSPredictorStatus

# Test basic functionality
Enable-PSPredictor
git <TAB>  # Should show Git completions
```

**Advanced Verification:**
```powershell
# Test AI prediction engine
Test-PSPredictorAI -Verbose

# Verify completion providers
Get-PSPredictorProviders | Format-Table

# Test syntax highlighting
Test-PSPredictorSyntaxHighlighting -Command "Get-Process | Where-Object"

# Check performance metrics
Measure-PSPredictorPerformance -Iterations 100
```

**Troubleshooting Installation:**
```powershell
# Reset configuration
Reset-PSPredictorConfig

# Reinstall with verbose logging
Install-Module PSPredictor -Force -Verbose

# Check for conflicts
Get-Module *Predictor* -ListAvailable

# Validate dependencies
Test-PSPredictorDependencies
```

## Next Steps

After successful installation, see the [User Guide](readme.md#-user-guide) for detailed usage instructions and configuration options.

## Getting Help

If you encounter installation issues:

1. Check the [Troubleshooting Guide](readme.md#troubleshooting) for common solutions
2. Review the [FAQ](readme.md#-references) for frequently asked questions
3. [Open an issue](https://github.com/wangkanai/PSPredictor/issues) on GitHub for additional support

---

**[← Back to Main README](readme.md)**