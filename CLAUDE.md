# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

PSPredictor is a PowerShell module that provides comprehensive auto-completion and intelligent prediction for 26+ popular command-line tools. It's designed to enhance PowerShell's tab completion experience with context-aware suggestions for tools like Git, Docker, NPM, kubectl, Azure CLI, AWS CLI, PowerShell Core, Zsh, Bash, and many others.

## Development Commands

### Building and Testing
```powershell
# Build the module (default task)
./build.ps1

# Run all build tasks (clean, build, test, package)
./build.ps1 -Task All

# Run specific tasks
./build.ps1 -Task Clean
./build.ps1 -Task Build
./build.ps1 -Task Test
./build.ps1 -Task Package

# Build in debug configuration
./build.ps1 -Task Build -Configuration Debug

# Install module locally for testing
./build.ps1 -Task Install
```

### Publishing to PowerShell Gallery

**Automated Publishing (Recommended):**
Publishing is automated via GitHub Actions when code is merged to main branch. The workflow:
- Tests the module on multiple platforms (Windows, Linux, macOS)
- Checks if the version already exists in PowerShell Gallery
- Builds and publishes automatically if version is new
- Creates GitHub releases with auto-generated notes

**Manual Publishing:**
```powershell
# Publish with API key parameter
./build.ps1 -Task Publish -ApiKey "your-api-key"

# Publish using environment variable (recommended)
$env:PSGALLERY_API_KEY = "your-api-key"
./build.ps1 -Task Publish

# Force publish (overwrite existing version)
./build.ps1 -Task Publish -Force
```

**Version Management:**
```powershell
# Bump version before publishing
./.github/scripts/bump-version.ps1 -Type Patch    # 1.0.0 → 1.0.1
./.github/scripts/bump-version.ps1 -Type Minor    # 1.0.1 → 1.1.0
./.github/scripts/bump-version.ps1 -Type Major    # 1.1.0 → 2.0.0
```

### Development Workflow
```powershell
# Build and install module for testing during development
./build.ps1 -Task Build
./build.ps1 -Task Install

# Test basic functionality
Get-PSPredictorTools
Register-PSPredictorCompletion -Tool "git"

# Test specific tool completions
git <TAB>
docker <TAB>
npm <TAB>
pwsh <TAB>  # PowerShell Core
zsh <TAB>   # Zsh shell
bash <TAB>  # Bash shell

# Run all tests (145+ tests)
./build.ps1 -Task Test

# Run specific Pester test suites
Invoke-Pester ./tests/PSPredictor.Tests.ps1
Invoke-Pester ./tests/Public/
Invoke-Pester ./tests/Completions/
```

## Architecture Overview

### Project Structure

```
PSPredictor/
├── src/                          # Source code
│   ├── PSPredictor.psd1         # Module manifest
│   ├── PSPredictor.psm1         # Main module loader
│   ├── Public/                  # Exported functions (4 functions)
│   │   ├── Get-PSPredictorTools.ps1
│   │   ├── Install-PSPredictor.ps1
│   │   ├── Register-PSPredictorCompletion.ps1
│   │   └── Uninstall-PSPredictor.ps1
│   ├── Private/                 # Internal functions
│   │   └── Config.ps1           # Tool configuration
│   └── Completions/             # CLI completion providers (26+ tools)
│       ├── Azure.ps1, AWS.ps1, Git.ps1, Docker.ps1
│       ├── PowerShell.ps1, Zsh.ps1, Bash.ps1
│       ├── NPM.ps1, Kubectl.ps1, Terraform.ps1
│       └── ... (20+ more tools)
├── tests/                        # Pester tests (145+ tests)
│   ├── PSPredictor.Tests.ps1    # Core module tests
│   ├── Public/                  # Public function tests
│   ├── Private/                 # Private function tests
│   ├── Completions/             # CLI completion tests (17 test files)
│   └── TestConfig.ps1           # Test configuration and helpers
├── .github/
│   ├── workflows/               # GitHub Actions
│   │   ├── publish.yml         # Automated publishing
│   │   └── test.yml            # Cross-platform testing
│   └── scripts/
│       └── bump-version.ps1    # Version management utility
└── build.ps1                   # Build automation script
```

### Core Components

**src/PSPredictor.psd1** - Module manifest containing:
- Module metadata and versioning
- Function exports and dependencies
- PowerShell Gallery publishing information
- Requires PSReadLine module

**src/PSPredictor.psm1** - Main module loader that:
- Dynamically loads Public/, Private/, and Completions/ functions
- Exports public functions (Get-PSPredictorTools, Install-PSPredictor, etc.)
- Manages modular architecture and function discovery

**src/Private/Config.ps1** - Configuration management with:
- Tool registry (`$script:SupportedTools`) with 26+ CLI tools  
- Configuration settings (`$script:PSPredictorConfig`)
- Tool metadata and enablement status

**src/Completions/*.ps1** - Individual completion providers:
- 26+ separate completion files (Azure.ps1, Git.ps1, PowerShell.ps1, etc.)
- Each file contains one Register-{Tool}Completion function
- Context-aware completion logic for each CLI tool

**tests/** - Comprehensive test suite (145+ tests):
- Modular test structure matching source organization
- Pester-based testing framework with 17 test files
- Public/, Private/, and Completions/ test directories
- Cross-platform compatibility tests (Windows/Linux/macOS)

**build.ps1** - Comprehensive build automation:
- Multi-task build system (Build, Test, Package, Clean, Install, All)
- Pester test integration
- Module validation and testing
- Package creation for distribution
- Local installation support

### Key Architecture Patterns

**Modular Architecture**: Clean separation of concerns with:
- **Public/**: Exported functions available to users
- **Private/**: Internal functions and configuration
- **Completions/**: Individual completion providers (26+ files)

**Tool Registration System**: Each CLI tool is registered in `$script:SupportedTools` (in Private/Config.ps1) with metadata including description, completion script reference, and enabled status.

**Completion Architecture**: Uses PowerShell's `Register-ArgumentCompleter` with `-Native` parameter. Each tool has its own file in Completions/ with a dedicated registration function (e.g., `Register-GitCompletion`, `Register-PowerShellCompletion`).

**Dynamic Loading**: Main module loader automatically discovers and loads:
- All .ps1 files from Public/, Private/, and Completions/ directories
- Functions are dot-sourced and available for use
- Exports only public functions to maintain clean API surface

**Configuration Management**: Centralized configuration in `$script:PSPredictorConfig` supporting:
- Enable/disable specific tools (26+ CLI tools supported)
- Completion behavior settings (max suggestions, case sensitivity, fuzzy matching)
- Shell-specific completions (PowerShell Core, Zsh, Bash)
- Cross-platform compatibility

### Extension Points

**Adding New CLI Tools**:
1. Add tool definition to `$script:SupportedTools` hashtable in `src/Private/Config.ps1`
2. Create new completion file `src/Completions/{ToolName}.ps1`
3. Implement `Register-{ToolName}Completion` function in the new file
4. Add case to the switch statement in `src/Public/Register-PSPredictorCompletion.ps1`
5. Create test file `tests/Completions/{ToolName}.Tests.ps1`

**Completion Function Pattern**:
```powershell
function Register-MyToolCompletion {
    Register-ArgumentCompleter -Native -CommandName mytool -ScriptBlock {
        param($wordToComplete, $commandAst, $cursorPosition)
        # Completion logic returning CompletionResult objects
    }
}
```

## Module Structure

- **Modular Organization**: Clean separation with Public/, Private/, Completions/ directories
- **Public Functions**: 4 exported functions for user interaction
- **Completion Providers**: 26+ individual completion files for CLI tools
- **Export Strategy**: Only public functions exported for controlled API surface
- **PowerShell 7+ Requirement**: Cross-platform support with PSReadLine dependency

## Testing and Quality

The build system includes comprehensive validation:
- **145+ Pester tests** across 17 test files with modular structure
- Module manifest validation with `Test-ModuleManifest`
- Modular function loading and import testing
- Public/Private/Completion function verification
- All 26+ CLI tool completion registration testing
- Cross-platform compatibility validation

## CI/CD Pipeline

**GitHub Actions Workflows:**
- **`.github/workflows/publish.yml`**: Automated publishing to PowerShell Gallery on main branch merges
- **`.github/workflows/test.yml`**: Cross-platform testing on pull requests
- **Environment protection**: Production environment with optional review requirements

**Required Repository Secrets:**
- `PSGALLERY_API_KEY`: PowerShell Gallery API key for automated publishing

**Automated Release Process:**
1. Developer creates PR with version bump in `PSPredictor.psd1`
2. Tests run automatically on multiple platforms
3. On merge to main, workflow publishes to PowerShell Gallery if version is new
4. GitHub release is created automatically with installation instructions

## Development Notes

- **PowerShell 7+ Required**: Cross-platform support with PSReadLine dependency
- **Modular Architecture**: Clean separation enables easy extension and maintenance
- **Performance**: Completion functions should be performant (< 100ms recommended)
- **Context-Aware**: Completions can parse command AST for intelligent suggestions
- **26+ CLI Tools**: Comprehensive coverage including shells (PowerShell, Zsh, Bash)
- **Extensive Testing**: 145+ tests ensure reliability across platforms
- **Build Automation**: Comprehensive build.ps1 with all development tasks
- **Version Management**: Helper script available at `.github/scripts/bump-version.ps1`