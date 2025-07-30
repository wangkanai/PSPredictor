# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

PSPredictor is a PowerShell module that provides comprehensive auto-completion and intelligent prediction for 50+ popular command-line tools. It's designed to enhance PowerShell's tab completion experience with context-aware suggestions for tools like Git, Docker, NPM, kubectl, Azure CLI, AWS CLI, and many others.

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
```powershell
# Publish with API key parameter
./build.ps1 -Task Publish -ApiKey "your-api-key"

# Publish using environment variable (recommended)
$env:PSGALLERY_API_KEY = "your-api-key"
./build.ps1 -Task Publish

# Force publish (overwrite existing version)
./build.ps1 -Task Publish -Force
```

### Development Workflow
```powershell
# Import module for testing during development
Import-Module ./PSPredictor.psm1 -Force

# Test basic functionality
Get-PSPredictorTools
Install-PSPredictor

# Test specific tool completions
git <TAB>
docker <TAB>
npm <TAB>
```

## Architecture Overview

### Core Components

**PSPredictor.psd1** - Module manifest containing:
- Module metadata and versioning
- Function exports and dependencies
- PowerShell Gallery publishing information
- Requires PSReadLine module

**PSPredictor.psm1** - Main module file with:
- Configuration management (`$script:PSPredictorConfig`)
- Tool registry (`$script:SupportedTools`) with 10+ CLI tools
- Core installation/management functions
- Individual completion registration functions
- Built-in completion implementations for Git, Docker, NPM

**build.ps1** - Comprehensive build automation:
- Multi-task build system (Build, Test, Package, Clean, Install, All)
- Module validation and testing
- Package creation for distribution
- Local installation support

### Key Architecture Patterns

**Tool Registration System**: Each CLI tool is registered in `$script:SupportedTools` with metadata including description, completion script reference, and enabled status.

**Completion Architecture**: Uses PowerShell's `Register-ArgumentCompleter` with `-Native` parameter to provide completions for external commands. Each tool has its own registration function (e.g., `Register-GitCompletion`, `Register-DockerCompletion`).

**Configuration Management**: Centralized configuration in `$script:PSPredictorConfig` supporting:
- Enable/disable specific tools
- Completion behavior settings (max suggestions, case sensitivity, fuzzy matching)
- Auto-update capabilities
- Custom completion path

**Modular Design**: Completion functions are separated by tool, making it easy to add new CLI tools or enhance existing ones.

### Extension Points

**Adding New CLI Tools**:
1. Add tool definition to `$script:SupportedTools` hashtable
2. Create completion function following `Register-{ToolName}Completion` pattern
3. Add case to the switch statement in `Register-PSPredictorCompletion`
4. Implement context-aware completion logic using `Register-ArgumentCompleter`

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

- **Core Functions**: Installation, configuration, and tool management
- **Built-in Completions**: Implemented for Git, Docker, NPM (others are stubs)
- **Export Strategy**: Explicit function and alias exports for controlled API surface
- **Dependency**: Requires PSReadLine for enhanced completion experience

## Testing and Quality

The build system includes comprehensive validation:
- Module manifest validation with `Test-ModuleManifest`
- Module import testing
- Function export verification
- Basic functionality testing with supported tools count validation

## Development Notes

- Module supports PowerShell 5.1+ with PSReadLine dependency
- Uses PowerShell's native argument completion system
- Completion functions should be performant (< 100ms recommended)
- Context-aware completions can parse command AST for intelligent suggestions
- Configuration persists across sessions and can be customized per user