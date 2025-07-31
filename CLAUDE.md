# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Search Context Priority

When searching for information about this project, use the following order:

1. **MCP Memory** - Check knowledge graph for cached project insights and patterns
2. **MCP Repomix** - Use consolidated codebase analysis for comprehensive understanding
3. **MCP Filesystem** - Direct file system access for specific file operations
4. **Bash Commands** - Execute shell commands as the final option for system-level operations

## Project Overview

PSPredictor v2.0 is a revolutionary PowerShell Binary Module written in C# .NET that transforms the PowerShell command-line experience into a comprehensive IDE within the terminal. It provides intelligent auto-completion, syntax highlighting, error indication, multi-line editing, predictive IntelliSense, and advanced editing capabilities for 26+ popular command-line tools.

**⚠️ MAJOR VERSION TRANSITION**: This is v2.0 - a complete rewrite from PowerShell scripts to C# binary module. For v1.x documentation, see `docs/archives/2025-07-30-PROJECT.md`.

## Development Commands

### Building and Testing
```bash
# Build the C# binary module (default configuration: Release)
dotnet build

# Build specific configuration
dotnet build --configuration Debug
dotnet build --configuration Release

# Run all tests (unit, integration, performance)
dotnet test

# Run specific test projects
dotnet test tests/PSPredictor.Core.Tests/
dotnet test tests/PSPredictor.Completion.Tests/
dotnet test tests/PSPredictor.AI.Tests/
dotnet test tests/PSPredictor.Integration.Tests/

# Run tests with coverage
dotnet test --collect:"XPlat Code Coverage"

# Build NuGet package
dotnet pack --configuration Release

# Install module locally for testing
dotnet build --configuration Debug
Import-Module ./src/PSPredictor/bin/Debug/net9.0/PSPredictor.dll -Force
```

### Module Installation and Testing
```powershell
# Install development build locally
Install-PSPredictor -Development -Path "./src/PSPredictor/bin/Debug/net9.0/PSPredictor.dll"

# Test core functionality
Get-PSPredictorStatus
Enable-PSPredictorMode -Mode Enhanced

# Test intelligent completion for various tools
git <TAB>               # Git completion with syntax highlighting
docker <TAB>            # Docker completion with context awareness
npm <TAB>               # NPM completion with package suggestions
kubectl <TAB>           # Kubernetes completion with cluster context
pwsh <TAB>              # PowerShell Core completion with cmdlet help
az <TAB>                # Azure CLI completion with subscription context

# Test advanced editing features
Set-PSPredictorKeyBinding -Key "Ctrl+Space" -Function "TriggerIntelliSense"
Set-PSPredictorMode -EditingMode Emacs  # Switch to Emacs mode
Set-PSPredictorMode -EditingMode Cmd    # Switch to Cmd mode

# Test syntax highlighting and error indication
Get-PSPredictorSyntaxHighlighting -Command "git status --invalid-flag"
```

### Development Workflow
```bash
# Full development cycle
dotnet clean
dotnet restore
dotnet build --configuration Debug
dotnet test
dotnet pack

# Watch mode for continuous development
dotnet watch build --project src/PSPredictor/PSPredictor.csproj

# Performance testing
dotnet run --project tests/PSPredictor.Performance.Tests/

# AI model training and validation
dotnet run --project tools/PSPredictor.ModelTrainer/ -- --validate-models
```

## Architecture Overview

### Project Structure

```
PSPredictor/
├── src/                                    # Source code (C# .NET 9.0)
│   ├── PSPredictor/                       # Main binary module project
│   │   ├── PSPredictor.csproj            # Primary project file
│   │   ├── Module/                        # PowerShell module definition
│   │   │   ├── PSPredictor.psd1          # Module manifest
│   │   │   └── PSPredictor.psm1          # Module loader script
│   │   ├── Cmdlets/                       # PowerShell cmdlet implementations
│   │   │   ├── BaseCmdlet.cs             # Base cmdlet with common functionality
│   │   │   ├── GetPSPredictorStatusCmdlet.cs
│   │   │   ├── SetPSPredictorModeCmdlet.cs
│   │   │   └── InstallPSPredictorCmdlet.cs
│   │   ├── Core/                          # Core engine components
│   │   │   ├── PredictionEngine.cs       # Main prediction orchestrator
│   │   │   ├── CompletionProvider.cs     # Completion generation system
│   │   │   ├── SyntaxHighlighter.cs      # Real-time syntax highlighting
│   │   │   ├── ErrorIndicator.cs         # Visual error indication
│   │   │   └── CommandHistory.cs         # SQLite-based command history
│   │   ├── AI/                            # AI-powered prediction system
│   │   │   ├── MLPredictionEngine.cs     # ML.NET integration
│   │   │   ├── Models/                    # Embedded ML models
│   │   │   │   ├── CommandPrediction.zip # Core command prediction model
│   │   │   │   ├── ParameterPrediction.zip # Parameter completion model
│   │   │   │   └── ContextAwareness.zip  # Context-aware suggestions model
│   │   │   └── Training/                  # Model training infrastructure
│   │   │       ├── DataPipeline.cs       # Training data processing
│   │   │       └── ModelBuilder.cs       # ML model construction
│   │   ├── Input/                         # Native input handling system
│   │   │   ├── KeyHandler.cs             # Custom key binding system
│   │   │   ├── EditingModes/             # Cmd/Emacs/Vi editing modes
│   │   │   │   ├── CmdMode.cs            # Windows Cmd-style editing
│   │   │   │   ├── EmacsMode.cs          # Emacs-style key bindings
│   │   │   │   └── ViMode.cs             # Vi/Vim-style editing
│   │   │   ├── KillRing.cs               # Emacs-style clipboard system
│   │   │   ├── TokenNavigation.cs        # PowerShell token-based navigation
│   │   │   └── MultiLineEditor.cs        # Advanced multi-line editing
│   │   ├── Rendering/                     # Console rendering system
│   │   │   ├── ANSIRenderer.cs           # Cross-platform ANSI rendering
│   │   │   ├── SyntaxColorizer.cs        # Command-line syntax coloring
│   │   │   ├── IntelliSenseDisplay.cs    # Predictive IntelliSense UI
│   │   │   └── DynamicHelpRenderer.cs    # Real-time help display
│   │   ├── Completions/                   # CLI tool completion providers
│   │   │   ├── BaseCompletion.cs         # Base completion provider
│   │   │   ├── Git/                       # Git completion system
│   │   │   │   ├── GitCompletion.cs      # Main Git provider
│   │   │   │   ├── Commands/             # Git command completions
│   │   │   │   └── Context/              # Git context awareness
│   │   │   ├── Docker/                    # Docker completion system
│   │   │   ├── Azure/                     # Azure CLI completion
│   │   │   ├── AWS/                       # AWS CLI completion
│   │   │   ├── Kubernetes/                # kubectl completion
│   │   │   ├── PowerShell/                # PowerShell Core completion
│   │   │   ├── Shells/                    # Shell completions (Zsh/Bash)
│   │   │   └── [22+ other tools]/        # Additional CLI tool providers
│   │   ├── Configuration/                 # Configuration management
│   │   │   ├── PSPredictorConfig.cs      # Main configuration system
│   │   │   ├── UserSettings.cs           # User preference management
│   │   │   └── Profiles/                  # Configuration profiles
│   │   └── Utilities/                     # Shared utilities
│   │       ├── PowerShellASTParser.cs    # PowerShell AST analysis
│   │       ├── CrossPlatformSupport.cs   # Platform compatibility
│   │       └── PerformanceMonitor.cs     # Performance tracking
│   ├── PSPredictor.Core/                  # Core library (shared components)
│   │   ├── PSPredictor.Core.csproj      # Core library project
│   │   ├── Interfaces/                    # Core interfaces and contracts
│   │   ├── Models/                        # Data models and DTOs
│   │   └── Extensions/                    # Extension methods
│   └── PSPredictor.Shared/                # Shared utilities
│       ├── PSPredictor.Shared.csproj    # Shared utilities project
│       ├── Constants/                     # Application constants
│       └── Helpers/                       # Common helper methods
├── tests/                                  # Test projects (xUnit + FluentAssertions)
│   ├── PSPredictor.Tests/                # Main module tests
│   │   ├── PSPredictor.Tests.csproj     # Test project file
│   │   ├── Cmdlets/                       # Cmdlet testing
│   │   ├── Core/                          # Core engine tests
│   │   ├── AI/                            # AI prediction tests
│   │   ├── Input/                         # Input handling tests
│   │   ├── Rendering/                     # Rendering system tests
│   │   └── TestHelpers/                   # Test utilities and mocks
│   ├── PSPredictor.Core.Tests/           # Core library tests
│   ├── PSPredictor.Completion.Tests/     # Completion provider tests
│   ├── PSPredictor.AI.Tests/             # AI/ML model tests
│   ├── PSPredictor.Integration.Tests/    # Integration testing
│   └── PSPredictor.Performance.Tests/    # Performance benchmarks
├── tools/                                  # Development and build tools
│   ├── PSPredictor.ModelTrainer/         # ML model training tool
│   ├── PSPredictor.CodeGen/              # Code generation utilities
│   └── PSPredictor.DevTools/             # Development utilities
├── docs/                                   # Documentation
│   ├── PRD.md                            # Product Requirements Document
│   ├── architecture/                      # Architecture documentation
│   ├── user-guide/                        # User documentation
│   └── archives/                          # Archived documentation
│       └── 2025-07-30-PROJECT.md        # v1.x PowerShell script documentation
├── .github/
│   ├── workflows/                         # GitHub Actions
│   │   ├── dotnet.yml                   # Cross-platform CI/CD pipeline
│   │   ├── publish.yml                  # NuGet & PowerShell Gallery publishing
│   │   └── performance.yml              # Performance regression testing
│   ├── FUNDING.yml                      # GitHub sponsorship configuration
│   └── scripts/                           # GitHub automation scripts
│       ├── version-bump.ps1             # Version management
│       └── generate-changelog.ps1        # Changelog generation
├── PSPredictor.sln                        # Visual Studio solution file
├── Directory.Build.props                  # MSBuild shared properties
├── nuget.config                           # NuGet configuration
└── global.json                            # .NET SDK version specification
```

### Core Architecture Components

**PSPredictor.dll** - Primary binary module containing:
- PowerShell cmdlet implementations using System.Management.Automation
- Native input handling system (PSReadLine-independent)
- AI-powered prediction engine with embedded ML.NET models
- Cross-platform console rendering with ANSI support
- Advanced editing modes (Cmd/Emacs/Vi) with customizable key bindings

**AI-Powered Prediction Engine** - ML.NET integration featuring:
- Embedded models (CommandPrediction.zip, ParameterPrediction.zip, ContextAwareness.zip)
- Real-time command prediction and parameter suggestion
- Context-aware completions based on command history and environment
- Hybrid architecture with core embedded models and optional downloadable enhancements

**Native Input System** - PSReadLine-independent input handling:
- Custom key binding system with macro support
- Multi-modal editing (Cmd/Emacs/Vi modes) with full feature parity
- Kill-ring system for advanced clipboard functionality
- Token-based navigation using PowerShell syntax awareness
- Multi-line editing with sophisticated history management

**Advanced Rendering System** - Cross-platform console enhancement:
- Real-time syntax highlighting for PowerShell and CLI tools
- Visual error indication with contextual error messages
- Predictive IntelliSense with non-intrusive UI
- Dynamic help display without losing command-line position
- ANSI color rendering for consistent cross-platform experience

**Completion Provider Architecture** - Modular completion system:
- 26+ CLI tool providers with specialized context awareness
- Plugin architecture for easy extension and customization
- Intelligent caching and performance optimization
- Cross-platform compatibility with tool-specific optimizations

### Key Architecture Patterns

**Binary Module Architecture**: C# .NET 9.0 PowerShell module with:
- **Cmdlets/**: PowerShell cmdlet implementations for user interface
- **Core/**: Core engine components (prediction, completion, syntax, history)
- **AI/**: Machine learning integration with embedded models
- **Input/**: Native input handling system with advanced editing modes
- **Rendering/**: Console rendering and visual enhancement system
- **Completions/**: Modular CLI tool completion providers

**ML.NET Integration**: Local machine learning with:
- Embedded core models for offline functionality
- Optional downloadable enhanced models for advanced features
- Real-time prediction with <100ms response time target
- Training pipeline for continuous model improvement

**Cross-Platform Compatibility**: Unified experience across:
- Windows PowerShell 5.1+ and PowerShell Core 7+
- Linux with PowerShell Core and terminal emulator support
- macOS with PowerShell Core and Terminal.app integration
- Consistent ANSI rendering and input handling across platforms

**Performance-First Design**: Optimized for speed with:
- Lazy loading of completion providers and ML models
- Asynchronous prediction and rendering pipeline
- SQLite database for efficient command history storage
- Memory-efficient caching with LRU eviction policies

**Configuration Management**: Comprehensive settings system:
- JSON-based configuration with schema validation
- Profile system for different use cases (Developer, SysAdmin, etc.)
- Environment-specific overrides and team settings
- Real-time configuration updates without restart

### Extension Points

**Adding New CLI Tools**:
1. Create new completion provider in `src/PSPredictor/Completions/{ToolName}/`
2. Implement `{ToolName}Completion.cs` inheriting from `BaseCompletion`
3. Add tool registration in `CompletionProvider.cs`
4. Create test suite in `tests/PSPredictor.Completion.Tests/{ToolName}/`
5. Update configuration schema in `PSPredictorConfig.cs`

**Custom Editing Modes**:
1. Implement new mode in `src/PSPredictor/Input/EditingModes/{ModeName}Mode.cs`
2. Inherit from `BaseEditingMode` and implement required key bindings
3. Register mode in `KeyHandler.cs` mode factory
4. Add configuration options in `UserSettings.cs`

**ML Model Enhancement**:
1. Create training data pipeline in `tools/PSPredictor.ModelTrainer/`
2. Implement custom model in `src/PSPredictor/AI/Models/`
3. Add model loading logic in `MLPredictionEngine.cs`
4. Create validation tests in `tests/PSPredictor.AI.Tests/`

## Technology Stack

### Core Technologies
- **.NET 9.0**: Modern C# with latest language features and performance improvements
- **PowerShell SDK**: System.Management.Automation for cmdlet development
- **ML.NET**: Local machine learning with embedded model support
- **SQLite**: Lightweight database for command history and configuration
- **xUnit + FluentAssertions**: Comprehensive testing framework
- **BenchmarkDotNet**: Performance testing and regression detection

### Platform Support
- **Windows**: PowerShell 5.1+ and PowerShell Core 7+
- **Linux**: PowerShell Core 7+ with full terminal integration
- **macOS**: PowerShell Core 7+ with native Terminal.app support
- **Cross-Platform**: Consistent ANSI rendering and input handling

### Development Tools
- **Visual Studio 2022** or **Visual Studio Code**: Primary development environment
- **GitHub Actions**: CI/CD pipeline with automated testing and publishing
- **NuGet**: Package distribution and dependency management
- **.NET CLI**: Build automation and project management

## Testing and Quality

### Testing Strategy
- **Unit Tests**: Comprehensive coverage of core components and cmdlets
- **Integration Tests**: End-to-end testing of completion providers and AI prediction
- **Performance Tests**: Regression testing with <100ms response time validation
- **Cross-Platform Tests**: Validation across Windows, Linux, and macOS

### Quality Metrics
- **Code Coverage**: Minimum 80% coverage with 90% target for core components
- **Performance**: <100ms prediction response time, <50ms rendering updates
- **Memory**: <50MB memory footprint for standard usage patterns
- **Reliability**: Zero crashes during normal operation, graceful error handling

### Continuous Integration
- **Build Pipeline**: Automated builds on all platforms with matrix testing
- **Test Automation**: Full test suite execution on every pull request
- **Performance Monitoring**: Automated performance regression detection
- **Package Publishing**: Automated NuGet publishing on tagged releases

## Development Workflow

### Initial Setup
```bash
# Clone repository and initialize development environment
git clone <repository-url>
cd PSPredictor

# Restore dependencies and build
dotnet restore
dotnet build

# Run initial tests to verify setup
dotnet test

# Install development build for testing
dotnet build --configuration Debug
Import-Module ./src/PSPredictor/bin/Debug/net9.0/PSPredictor.dll -Force
```

### Development Cycle
```bash
# Make code changes
# Run affected tests
dotnet test tests/PSPredictor.Tests/ --filter "Category=Core"

# Build and test locally
dotnet build --configuration Debug
dotnet test

# Performance validation
dotnet run --project tests/PSPredictor.Performance.Tests/

# Package for distribution
dotnet pack --configuration Release
```

### AI Model Development
```bash
# Train new models with updated data
dotnet run --project tools/PSPredictor.ModelTrainer/ -- --train-all

# Validate model performance
dotnet run --project tools/PSPredictor.ModelTrainer/ -- --validate-models

# Update embedded models
dotnet run --project tools/PSPredictor.ModelTrainer/ -- --deploy-models
```

## Configuration and Customization

### User Configuration
```powershell
# Configure editing mode
Set-PSPredictorMode -EditingMode Emacs

# Customize key bindings
Set-PSPredictorKeyBinding -Key "Ctrl+Space" -Function "TriggerIntelliSense"
Set-PSPredictorKeyBinding -Key "Alt+?" -Function "ShowDynamicHelp"

# Configure completion behavior
Set-PSPredictorCompletion -MaxSuggestions 10 -EnableFuzzyMatching $true

# AI prediction settings
Set-PSPredictorAI -EnableLocalModels $true -DownloadEnhancedModels $false
```

### Profile Management
```powershell
# Create custom profile
New-PSPredictorProfile -Name "Developer" -BasedOn "Default"

# Switch profiles
Set-PSPredictorProfile -Name "Developer"

# Export/import configuration
Export-PSPredictorConfig -Path "./my-config.json"
Import-PSPredictorConfig -Path "./my-config.json"
```

## Performance Optimization

### Response Time Targets
- **Completion Generation**: <50ms for standard completions
- **AI Prediction**: <100ms for ML-powered suggestions
- **Syntax Highlighting**: <20ms for real-time coloring
- **Multi-line Rendering**: <30ms for complex command structures

### Memory Management
- **Startup Footprint**: <20MB initial memory usage
- **Runtime Footprint**: <50MB for typical usage patterns
- **Model Loading**: Lazy loading with <5MB core models
- **History Management**: SQLite with automatic cleanup and archiving

### Caching Strategy
- **Completion Results**: LRU cache with 1000-item capacity
- **AI Predictions**: Context-aware caching with 5-minute TTL
- **Syntax Parsing**: AST caching for recently used commands
- **Configuration**: In-memory caching with file system monitoring

## Distribution and Publishing

### Package Distribution
- **NuGet Gallery**: Primary distribution channel for stable releases
- **GitHub Releases**: Development builds and pre-release versions
- **PowerShell Gallery**: Alternative distribution for PowerShell-focused users

### Version Management
```bash
# Version bump utilities
./tools/version-bump.ps1 -Type Major    # 2.0.0 → 3.0.0
./tools/version-bump.ps1 -Type Minor    # 2.0.0 → 2.1.0
./tools/version-bump.ps1 -Type Patch    # 2.0.0 → 2.0.1

# Release preparation
./tools/prepare-release.ps1 -Version "2.1.0"
```

### GitHub Actions Workflows
- **dotnet.yml**: Cross-platform CI/CD pipeline with comprehensive testing across Windows, Linux, and macOS
- **publish.yml**: Automated dual publishing to NuGet.org and PowerShell Gallery with tag-based versioning
- **performance.yml**: Performance regression testing with <100ms response time and <50MB memory validation
- **FUNDING.yml**: GitHub sponsorship configuration for project sustainability

## Migration from v1.x

### Breaking Changes
- **Module Type**: PowerShell script module → C# binary module
- **Dependencies**: PSReadLine dependency removed
- **Configuration**: PowerShell-based config → JSON configuration
- **Installation**: PowerShell Gallery → NuGet + PowerShell Gallery

### Migration Guide
1. **Uninstall v1.x**: `Uninstall-Module PSPredictor -AllVersions`
2. **Install v2.0**: `Install-Module PSPredictor -RequiredVersion 2.0.0`
3. **Migrate Settings**: Use `Import-PSPredictorLegacyConfig` cmdlet
4. **Update Scripts**: Review breaking changes in configuration API

## Development Notes

- **Performance Critical**: All user-facing operations must meet <100ms response time
- **Cross-Platform**: Ensure consistent behavior across Windows, Linux, and macOS
- **Backward Compatible**: Maintain API compatibility within major versions
- **Extensible**: Design for easy addition of new CLI tools and features
- **AI-Powered**: Leverage ML.NET for intelligent prediction and learning
- **Native Experience**: Provide IDE-like features within the terminal environment
- **Memory Efficient**: Optimize for long-running PowerShell sessions
- **Configuration Driven**: Support extensive customization without code changes