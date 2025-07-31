# PSPredictor Developer Documentation

**Welcome to PSPredictor v2.0 Development!**

This document serves as the central hub for all developer-related information for PSPredictor v2.0,
a revolutionary PowerShell Binary Module written in C# .NET 9.0 that transforms the PowerShell
command-line experience into a comprehensive IDE within the terminal.

---

## 🚀 Quick Start for Developers

### New to PSPredictor?

1. **Read this document** to understand the project structure and requirements
2. **Review the [Architecture Overview](#️-architecture-overview)** to understand the system design
3. **Follow the [Development Setup](#️-development-setup)** to configure your environment
4. **Check [Contribution Guidelines](#-contribution-guidelines)** for workflow information
5. **Start with [First Contribution](#-first-contribution)** for hands-on guidance

### Returning Contributors?

- Jump to [Development Workflow](#-development-workflow) for day-to-day processes
- Check [Standards & Guidelines](#-standards--guidelines) for coding requirements
- Review [Testing Strategy](#-testing-strategy) for validation procedures

---

## 📚 Documentation Framework

PSPredictor v2.0 features comprehensive documentation organized into specialized documents:

### Core Documentation

| Document | Purpose | Key Contents |
|----------|---------|--------------|
| **[STANDARDS.md](../STANDARDS.md)** | Development Standards | Code quality standards, performance requirements, testing guidelines |
| **[SPECIFICATIONS.md](../SPECIFICATIONS.md)** | Technical Specifications | API contracts, system requirements, platform support matrix |
| **[FRAMEWORK.md](../FRAMEWORK.md)** | Architectural Framework | Design patterns, component architecture, AI integration |
| **[PRD.md](../PRD.md)** | Product Requirements | Strategic objectives, feature requirements, success metrics |
| **[PLANNING.md](../PLANNING.md)** | Development Planning | Agile methodology, project timeline, resource planning |

### Specialized Documentation

| Document | Purpose | Audience |
|----------|---------|----------|
| **[CONTRIBUTING.md](../CONTRIBUTING.md)** | Contribution Guidelines | External contributors |
| **[README.md](../README.md)** | Project Overview | End users and newcomers |
| **[CLAUDE.md](../CLAUDE.md)** | AI Assistant Guidelines | Development tooling |

---

## 🎯 Project Overview

### What is PSPredictor v2.0?

PSPredictor v2.0 is a **complete rewrite** from PowerShell scripts to a C# .NET 9.0 binary module, providing:

- **Intelligent Auto-completion** for 26+ popular CLI tools
- **Real-time Syntax Highlighting** with error indication
- **AI-Powered Predictions** using embedded ML.NET models
- **Advanced Editing Modes** (Cmd/Emacs/Vi) with customizable key bindings
- **Multi-line Editing** with sophisticated history management
- **Cross-Platform Support** including ARM64 architecture (Apple Silicon)

### Key Technologies

- **.NET 9.0** with C# 13.0 language features
- **PowerShell SDK 7.5** for module integration
- **ML.NET 4.0** for AI-powered predictions
- **SQLite** for command history and configuration
- **xUnit v3** with FluentAssertions for testing
- **BenchmarkDotNet** for performance validation

---

## 🏗️ Architecture Overview

### System Architecture

```text
┌────────────────────────────────────────────────────────────────┐
│                    PowerShell Host Layer                       │
│        Cmdlets: Get-Status, Set-Mode, Install, etc.           │
└────────────────────────────────────────────────────────────────┘
                                │
┌────────────────────────────────────────────────────────────────┐
│                      Core Engine Layer                         │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐   │
│  │   Prediction    │ │   Completion    │ │     Syntax      │   │
│  │    Engine       │ │    Provider     │ │  Highlighter    │   │
│  └─────────────────┘ └─────────────────┘ └─────────────────┘   │
└────────────────────────────────────────────────────────────────┘
                                │
┌────────────────────────────────────────────────────────────────┐
│                    AI & Intelligence Layer                     │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐   │
│  │   ML.NET        │ │   Context       │ │   Learning      │   │
│  │   Models        │ │  Awareness      │ │   Pipeline      │   │
│  └─────────────────┘ └─────────────────┘ └─────────────────┘   │
└────────────────────────────────────────────────────────────────┘
                                │
┌────────────────────────────────────────────────────────────────┐
│                   Input & Rendering Layer                      │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐   │
│  │   Native Input  │ │   ANSI          │ │   Multi-line    │   │
│  │   Handling      │ │   Rendering     │ │   Editor        │   │
│  └─────────────────┘ └─────────────────┘ └─────────────────┘   │
└────────────────────────────────────────────────────────────────┘
                                │
┌────────────────────────────────────────────────────────────────┐
│                 Completion Providers Layer                     │
│    Git │ Docker │ kubectl │ Azure │ AWS │ npm │ [20+ more]     │
└────────────────────────────────────────────────────────────────┘
```

### Project Structure

```text
PSPredictor/
├── src/                           # Source code (C# .NET 9.0)
│   ├── PSPredictor/              # Main binary module
│   ├── Core/                     # Core library components
│   └── Shared/                   # Shared utilities
├── tests/                        # Test projects
│   ├── Unit/                     # Unit tests
│   ├── Integration/              # Integration tests
│   ├── Performance/              # Performance benchmarks
│   ├── AI/                       # AI/ML model tests
│   └── Completion/               # Completion provider tests
├── tools/                        # Development tools
│   ├── ModelTrainer/             # ML model training
│   ├── CodeGen/                  # Code generation
│   └── DevTools/                 # Development utilities
└── docs/                         # Documentation
    ├── developers.md             # This document
    ├── architecture/             # Architecture docs
    └── archives/                 # Historical documentation
```

For detailed architecture information, see **[FRAMEWORK.md](../FRAMEWORK.md)**.

---

## 🛠️ Development Setup

### Prerequisites

#### Required Software

- **.NET 9.0 SDK** (9.0.100 or later)
- **PowerShell 7.5+** (PowerShell Core)
- **Git** for version control
- **Visual Studio 2022** or **Visual Studio Code** (recommended)

#### Platform Support

- **Windows**: PowerShell 5.1+ and PowerShell Core 7+ (x64/ARM64)
- **Linux**: PowerShell Core 7+ (x64/ARM64)
- **macOS**: PowerShell Core 7+ (Intel x64 and Apple Silicon ARM64)

### Environment Setup

#### 1. Clone the Repository

```bash
# Fork the repository first on GitHub
git clone https://github.com/YOUR-USERNAME/PSPredictor.git
cd PSPredictor

# Add upstream remote
git remote add upstream https://github.com/wangkanai/PSPredictor.git
```

#### 2. Verify Prerequisites

```bash
# Check .NET SDK version
dotnet --version  # Should be 9.0.100+

# Check PowerShell version
pwsh --version    # Should be 7.5+

# Verify SDK compatibility
dotnet --list-sdks
```

#### 3. Restore Dependencies

```bash
# Restore NuGet packages (using central package management)
dotnet restore

# Verify package sources
dotnet nuget list source
```

#### 4. Build the Project

```bash
# Build all projects
dotnet build

# Build specific configuration
dotnet build --configuration Debug
dotnet build --configuration Release
```

#### 5. Run Tests

```bash
# Run all tests
dotnet test

# Run specific test projects
dotnet test tests/Unit/
dotnet test tests/Integration/
dotnet test tests/Performance/
```

### Development Tools Setup

#### Visual Studio Code Extensions

```json
{
  "recommendations": [
    "ms-dotnettools.csharp",
    "ms-dotnettools.csdevkit",
    "ms-vscode.powershell",
    "ms-vscode.vscode-json",
    "davidanson.vscode-markdownlint"
  ]
}
```

#### PowerShell Development Module

```powershell
# Install development dependencies
Install-Module -Name Pester -Scope CurrentUser -Force
Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force

# Load the development module
Import-Module ./src/PSPredictor/bin/Debug/net9.0/PSPredictor.dll -Force
```

For detailed setup requirements, see **[SPECIFICATIONS.md](../SPECIFICATIONS.md)**.

---

## 📋 Standards & Guidelines

### Code Quality Standards

#### Performance Requirements

- **Completion Generation**: <50ms for standard completions
- **AI Prediction**: <100ms for ML-powered suggestions
- **Memory Usage**: <50MB runtime footprint
- **Module Load Time**: <200ms initial import

#### Code Coverage Requirements

- **Core Components**: 90% line coverage, 85% branch coverage
- **Overall Project**: 80% line coverage minimum
- **Critical Paths**: 100% coverage for prediction and completion engines

#### Coding Standards

- **C# 13.0/.NET 9.0** modern language features
- **Async/await patterns** for all I/O operations
- **Dependency injection** with proper lifetime management
- **Interface-driven design** for testability
- **Cross-platform compatibility** (x64/ARM64)

For complete standards, see **[STANDARDS.md](../STANDARDS.md)**.

### Architecture Guidelines

#### Design Principles

- **Performance-First**: Sub-100ms response time for all operations
- **Modular Design**: Clear separation of concerns
- **AI-Powered**: Local ML models with intelligent fallbacks
- **Cross-Platform**: Consistent experience across all platforms

#### Component Guidelines

- **Completion Providers**: Plugin architecture with registration-based discovery
- **AI Integration**: Embedded models with optional enhancements
- **Input Handling**: Native system independent of PSReadLine
- **Rendering**: ANSI-based cross-platform console enhancement

For detailed architecture, see **[FRAMEWORK.md](../FRAMEWORK.md)**.

---

## 🧪 Testing Strategy

### Test Categories

#### Unit Tests (`tests/Unit/`)

- **Scope**: Individual components and functions
- **Framework**: xUnit v3 with FluentAssertions
- **Coverage**: 90%+ for core components
- **Execution**: Fast (<5 seconds total)

```bash
# Run unit tests
dotnet test tests/Unit/ --logger "console;verbosity=detailed"
```

#### Integration Tests (`tests/Integration/`)

- **Scope**: Component interactions and workflows
- **Framework**: xUnit v3 with test containers
- **Coverage**: End-to-end scenarios
- **Execution**: Medium (<30 seconds)

```bash
# Run integration tests
dotnet test tests/Integration/ --logger "console;verbosity=detailed"
```

#### Performance Tests (`tests/Performance/`)

- **Scope**: Performance regression detection
- **Framework**: BenchmarkDotNet
- **Metrics**: Response time, memory usage, throughput
- **Execution**: Comprehensive benchmarking

```bash
# Run performance tests
dotnet run --project tests/Performance/ --configuration Release
```

#### AI Model Tests (`tests/AI/`)

- **Scope**: ML.NET model validation
- **Framework**: xUnit v3 with ML.NET testing extensions
- **Coverage**: Model accuracy and performance
- **Execution**: Model-specific validation

### Testing Guidelines

#### Writing Tests

```csharp
[Fact]
public async Task PredictionEngine_ShouldGenerateCompletions_WithinPerformanceThreshold()
{
    // Arrange
    var engine = new PredictionEngine(mockProvider, mockConfig);
    var command = "git che";
    
    // Act
    var stopwatch = Stopwatch.StartNew();
    var results = await engine.GetCompletionsAsync(command);
    stopwatch.Stop();
    
    // Assert
    results.Should().NotBeEmpty();
    results.Should().Contain(c => c.Text.StartsWith("checkout"));
    stopwatch.ElapsedMilliseconds.Should().BeLessThan(50); // Performance requirement
}
```

#### Test Organization

- **Arrange-Act-Assert** pattern
- **Descriptive test names** explaining behavior
- **Performance assertions** for critical paths
- **Cross-platform validation** where applicable

For complete testing guidelines, see **[STANDARDS.md](../STANDARDS.md)**.

---

## 🔄 Development Workflow

### Branch Strategy

#### Branch Types

- **`main`**: Production-ready code for releases
- **`dev`**: Development integration branch
- **`feature/*`**: Individual feature development
- **`release/*`**: Release preparation branches

#### Workflow Process

1. **Create Feature Branch**

   ```bash
   git checkout dev
   git pull upstream dev
   git checkout -b feature/your-feature-name
   ```

2. **Develop and Test**

   ```bash
   # Make changes
   dotnet build
   dotnet test
   
   # Commit changes
   git add .
   git commit -m "feat: implement your feature"
   ```

3. **Submit Pull Request**

   ```bash
   git push origin feature/your-feature-name
   # Create PR via GitHub UI
   ```

### Daily Development

#### Build and Test Cycle

```bash
# Full development cycle
dotnet clean
dotnet restore
dotnet build --configuration Debug
dotnet test --configuration Debug

# Watch mode for continuous development
dotnet watch build --project src/PSPredictor/
```

#### Code Quality Checks

```bash
# Run static analysis
dotnet build --verbosity normal

# Check code coverage
dotnet test --collect:"XPlat Code Coverage"

# Performance validation
dotnet run --project tests/Performance/ --configuration Release
```

### Debugging and Development

#### Local Module Testing

```powershell
# Build and install for testing
dotnet build --configuration Debug
$ModulePath = "./src/PSPredictor/bin/Debug/net9.0/PSPredictor.dll"
Import-Module $ModulePath -Force

# Test functionality
Get-PSPredictorStatus
Enable-PSPredictorMode -Mode Enhanced
```

#### Performance Profiling

```bash
# Profile specific scenarios
dotnet run --project tools/DevTools/ -- --profile-completions
dotnet run --project tools/DevTools/ -- --analyze-memory
```

For detailed workflow information, see **[PLANNING.md](../PLANNING.md)**.

---

## 🤝 Contribution Guidelines

### Types of Contributions

#### High Priority Areas

- **CLI Tool Completions**: New completion providers for popular tools
- **AI Model Improvements**: Enhanced prediction accuracy and performance
- **Cross-Platform Features**: Platform-specific optimizations
- **Performance Optimizations**: Response time and memory improvements

#### Medium Priority Areas

- **Documentation**: User guides, API documentation, examples
- **Testing**: Increased coverage, edge case validation
- **Configuration**: User experience improvements
- **Accessibility**: Enhanced terminal compatibility

### Contribution Process

#### Before Starting

1. **Check existing issues** for similar work
2. **Create or comment on issue** to discuss approach
3. **Review architecture docs** to understand design patterns
4. **Set up development environment** following this guide

#### Development Process

1. **Follow coding standards** from [STANDARDS.md](../STANDARDS.md)
2. **Write tests first** (TDD approach)
3. **Implement minimal changes** focusing on specific requirements
4. **Validate performance** against established benchmarks
5. **Update documentation** as needed

#### Pull Request Guidelines

- **Clear description** of changes and rationale
- **Link to related issues** or discussions
- **Include tests** with appropriate coverage
- **Performance validation** for user-facing changes
- **Documentation updates** for new features

### Adding New CLI Tools

#### Step-by-Step Process

1. **Create Completion Provider**

   ```csharp
   // src/PSPredictor/Completions/YourTool/YourToolCompletion.cs
   public class YourToolCompletion : BaseCompletion
   {
       public override async Task<IEnumerable<CompletionResult>> GetCompletionsAsync(
           string commandLine, int cursorPosition, CancellationToken cancellationToken)
       {
           // Implementation
       }
   }
   ```

2. **Register Provider**

   ```csharp
   // Update src/PSPredictor/Core/CompletionProvider.cs
   RegisterCompletion("yourtool", new YourToolCompletion());
   ```

3. **Add Tests**

   ```csharp
   // tests/Completion/YourTool.Tests.cs
   public class YourToolCompletionTests
   {
       [Fact]
       public async Task ShouldProvideValidCompletions()
       {
           // Test implementation
       }
   }
   ```

4. **Update Documentation**
   - Add tool to README.md supported tools list
   - Update completion provider documentation
   - Include usage examples

For complete contribution guidelines, see **[CONTRIBUTING.md](../CONTRIBUTING.md)**.

---

## 🎯 First Contribution

### Beginner-Friendly Tasks

#### Documentation Improvements

- **Fix typos** or improve clarity in existing docs
- **Add code examples** to API documentation
- **Create usage tutorials** for specific CLI tools
- **Improve error messages** and help text

#### Simple Code Enhancements

- **Add new CLI tool** with basic completion support
- **Improve existing completions** with additional options
- **Add unit tests** for uncovered scenarios
- **Performance optimizations** in specific components

### Step-by-Step First Contribution

#### 1. Choose Your Task

Browse [GitHub Issues](https://github.com/wangkanai/PSPredictor/issues) labeled:

- `good first issue`
- `documentation`
- `help wanted`
- `completion-provider`

#### 2. Set Up Environment

Follow the [Development Setup](#️-development-setup) section completely.

#### 3. Make Your Changes

Start small and focused:

- Make minimal, surgical changes
- Follow existing code patterns
- Include appropriate tests
- Update relevant documentation

#### 4. Test Thoroughly

```bash
# Build and test your changes
dotnet build
dotnet test

# Test module functionality
pwsh -c "Import-Module ./src/PSPredictor/bin/Debug/net9.0/PSPredictor.dll; Get-PSPredictorStatus"
```

#### 5. Submit Pull Request

- **Clear title** describing the change
- **Detailed description** with context and rationale
- **Link related issues** using "Fixes #123" syntax
- **Request review** from maintainers

### Getting Help

#### Resources

- **GitHub Discussions**: Technical questions and feature discussions
- **GitHub Issues**: Bug reports and feature requests
- **Documentation**: This guide and related documentation files
- **Code Examples**: Existing completion providers for reference

#### Community Guidelines

- **Be respectful** and professional in all interactions
- **Ask questions** if you're unsure about anything
- **Provide context** when reporting issues or requesting help
- **Follow up** on feedback and suggestions promptly

---

## 📚 Additional Resources

### Technical Documentation

| Resource | Description | Link |
|----------|-------------|------|
| **API Specifications** | Detailed API contracts and interfaces | [SPECIFICATIONS.md](../SPECIFICATIONS.md) |
| **Architecture Guide** | System design and component relationships | [FRAMEWORK.md](../FRAMEWORK.md) |
| **Performance Standards** | Response time and memory requirements | [STANDARDS.md](../STANDARDS.md) |
| **Product Requirements** | Feature requirements and success metrics | [PRD.md](../PRD.md) |

### Development Resources

| Resource | Description | Link |
|----------|-------------|------|
| **Project Planning** | Development methodology and timeline | [PLANNING.md](../PLANNING.md) |
| **Contribution Guide** | Detailed contribution workflows | [CONTRIBUTING.md](../CONTRIBUTING.md) |
| **AI Assistant Guide** | Development tooling guidelines | [CLAUDE.md](../CLAUDE.md) |

### External Resources

- **[.NET 9.0 Documentation](https://docs.microsoft.com/en-us/dotnet/)**
- **[PowerShell SDK Documentation](https://docs.microsoft.com/en-us/powershell/)**
- **[ML.NET Documentation](https://docs.microsoft.com/en-us/dotnet/machine-learning/)**
- **[xUnit Testing Framework](https://xunit.net/docs/getting-started/netcore/cmdline)**

---

## 🔧 Troubleshooting

### Common Issues

#### Build Problems

**Issue**: `.NET 9.0 SDK not found`

```bash
# Solution: Install .NET 9.0 SDK or update global.json
# Download from: https://dotnet.microsoft.com/download/dotnet/9.0
```

**Issue**: `Package restore failed`

```bash
# Solution: Clear NuGet cache and restore
dotnet nuget locals all --clear
dotnet restore
```

#### Test Failures

**Issue**: `Performance tests failing`

```bash
# Solution: Run in Release configuration
dotnet test tests/Performance/ --configuration Release
```

**Issue**: `Integration tests timeout`

```bash
# Solution: Increase timeout in test configuration
# Check tests/Integration/test.runsettings
```

#### Module Loading

**Issue**: `Module import errors`

```powershell
# Solution: Check PowerShell execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Verify module path
Test-Path "./src/PSPredictor/bin/Debug/net9.0/PSPredictor.dll"
```

### Performance Issues

#### Slow Completions

1. **Check AI model loading**: Ensure models are properly cached
2. **Verify database performance**: SQLite database optimization
3. **Review completion logic**: Algorithmic efficiency improvements
4. **Profile memory usage**: Memory leak detection and cleanup

#### Memory Usage

1. **Monitor startup footprint**: Should be <20MB
2. **Check runtime growth**: Should stabilize <50MB
3. **Validate model memory**: Lazy loading working correctly
4. **Review cache behavior**: LRU eviction functioning properly

For additional troubleshooting, see archived documentation in `docs/archives/TROUBLESHOOTING.md`.

---

## 🎯 Success Metrics

### Code Quality Metrics

- **Build Success Rate**: 100% across all platforms
- **Test Pass Rate**: 100% for all test categories
- **Code Coverage**: 80%+ overall, 90%+ for core components
- **Performance Benchmarks**: Meeting all response time targets

### Contribution Metrics

- **Pull Request Response Time**: <48 hours for initial review
- **Issue Resolution Time**: <7 days for critical issues
- **Community Engagement**: Active discussions and feedback
- **Documentation Quality**: Comprehensive and up-to-date

### Development Velocity

- **Sprint Completion Rate**: 80%+ of planned work
- **Feature Delivery**: Regular milestone achievements
- **Technical Debt**: Managed through refactoring sprints
- **Platform Support**: Consistent cross-platform functionality

---

## 📞 Contact and Support

### Maintainer Contact

- **GitHub Issues**: Primary channel for technical questions
- **GitHub Discussions**: Feature discussions and community support
- **Pull Request Reviews**: Direct feedback on contributions

### Community Resources

- **GitHub Repository**: [wangkanai/PSPredictor](https://github.com/wangkanai/PSPredictor)
- **Documentation**: Always up-to-date in the repository
- **Releases**: Track progress through GitHub releases
- **Roadmap**: Long-term planning in [ROADMAP.md](../ROADMAP.md)

---

**Thank you for contributing to PSPredictor v2.0! Together, we're transforming the PowerShell
command-line experience into an intelligent, IDE-like terminal environment.** 🚀
