# SPECIFICATIONS.md - PSPredictor Technical Specifications

**Version**: 2.0.0  
**Last Updated**: 2025-07-31  
**Target Framework**: .NET 9.0, C# 13.0  
**Module Type**: PowerShell Binary Module

---

## System Requirements

### Runtime Environment

**Minimum Requirements**:

- **.NET Runtime**: .NET 9.0+ with C# 13.0 language support
- **PowerShell**: PowerShell Core 7.5+ (latest with enhanced performance and language features)
- **Memory**: 512MB available RAM (20MB base + 50MB runtime)
- **Storage**: 100MB available disk space
- **Network**: Optional for enhanced model downloads

**Supported Platforms**:

```yaml
Windows:
  versions: [ Windows 10, Windows 11, Windows Server 2019+ ]
  architectures: [ x64, ARM64 ]
  powershell: [ PowerShell 5.1+, PowerShell Core 7+ ]

Linux:
  distributions: [ Ubuntu 20.04+, CentOS 8+, RHEL 8+, Debian 11+ ]
  architectures: [ x64, ARM64 ]
  powershell: [ PowerShell Core 7+ ]

macOS:
  versions: [ macOS 11+ (Big Sur), macOS 12+ (Monterey), macOS 13+ (Ventura), macOS 14+ (Sonoma) ]
  architectures: [ x64 (Intel), ARM64 (Apple Silicon M1/M2/M3) ]
  powershell: [ PowerShell Core 7+ ]
```

**Architecture-Specific Features**:

- **x64 Platforms**: Full ML.NET support with AI prediction models
- **ARM64 Platforms**: Core functionality with graceful ML.NET degradation
- **Cross-Platform**: Consistent ANSI rendering and input handling

### Performance Specifications

**Response Time Requirements**:

```yaml
completion_generation:
  target: <50ms
  maximum: 100ms
  measurement: P95 response time

ai_prediction:
  target: <100ms
  maximum: 200ms
  measurement: P95 response time

git_completion:
  target: <50ms
  maximum: 100ms
  measurement: P95 response time
  benchmark: 3-8x faster than posh-git (typical 150-400ms)

syntax_highlighting:
  target: <20ms
  maximum: 50ms
  measurement: P99 response time

rendering_updates:
  target: <30ms
  maximum: 100ms
  measurement: P95 response time

module_initialization:
  target: <200ms
  maximum: 500ms
  measurement: Cold start time
```

**Memory Specifications**:

```yaml
startup_footprint:
  target: <20MB
  maximum: 30MB
  measurement: Initial allocation

runtime_footprint:
  target: <50MB
  maximum: 100MB
  measurement: Typical usage pattern

model_memory:
  core_models: <5MB
  enhanced_models: <20MB
  total_ml_memory: <25MB

cache_limits:
  completion_cache: 1000 entries (LRU)
  prediction_cache: 500 entries (5min TTL)
  syntax_cache: 200 parsed commands
  configuration_cache: In-memory with file monitoring
```

---

## Module Architecture

### Binary Module Structure

**PowerShell Module Manifest (PSPredictor.psd1)**:

```powershell
@{
  RootModule = 'PSPredictor.dll'
  ModuleVersion = '2.0.0'
  GUID = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'
  Author = 'PSPredictor Team'
  CompanyName = 'Wangkanai'
  Copyright = '(c) 2025 Wangkanai. All rights reserved.'
  Description = 'AI-powered PowerShell command prediction and completion'
  PowerShellVersion = '7.5'
  DotNetFrameworkVersion = '9.0'
  CLRVersion = '9.0'
  RequiredModules = @()
  RequiredAssemblies = @('PSPredictor.dll')
  CmdletsToExport = @(
    'Get-PSPredictorStatus',
    'Set-PSPredictorMode',
    'Enable-PSPredictorMode',
    'Disable-PSPredictorMode',
    'Install-PSPredictor',
    'Update-PSPredictor',
    'Set-PSPredictorConfiguration',
    'Get-PSPredictorConfiguration',
    'Export-PSPredictorConfig',
    'Import-PSPredictorConfig'
  )
  FunctionsToExport = @()
  VariablesToExport = @()
  AliasesToExport = @()
  PrivateData = @{
    PSData = @{
      Tags = @('PowerShell', 'Completion', 'AI', 'Prediction', 'CLI')
      LicenseUri = 'https://github.com/wangkanai/PSPredictor/blob/main/LICENSE'
      ProjectUri = 'https://github.com/wangkanai/PSPredictor'
      ReleaseNotes = 'Complete rewrite as C# binary module with AI prediction'
    }
  }
}
```

### Core Components API

**IPredictionEngine Interface**:

```csharp
/// <summary>
/// Core prediction engine for generating command completions and suggestions
/// </summary>
public interface IPredictionEngine
{
    /// <summary>
    /// Gets intelligent completions for the current command context
    /// </summary>
    Task<CompletionResult[]> GetCompletionsAsync(
        CompletionContext context, 
        CancellationToken cancellationToken = default);
    
    /// <summary>
    /// Predicts the next likely command based on history and context
    /// </summary>
    Task<PredictionResult[]> PredictNextCommandAsync(
        PredictionContext context,
        CancellationToken cancellationToken = default);
    
    /// <summary>
    /// Learns from user command execution patterns
    /// </summary>
    Task LearnFromExecutionAsync(
        ExecutionContext context,
        CancellationToken cancellationToken = default);
}

/// <summary>
/// Completion result with metadata for rendering
/// </summary>
public sealed record CompletionResult(
    string Text,
    string Description,
    CompletionType Type,
    int Priority = 0,
    string? ToolTip = null,
    CompletionCategory Category = CompletionCategory.General
);

/// <summary>
/// Completion context with command parsing information
/// </summary>
public sealed record CompletionContext(
    string CommandLine,
    string CurrentCommand,
    int CursorPosition,
    string[] Arguments = null,
    Dictionary<string, object>? Metadata = null
);
```

**ICompletionProvider Interface**:

```csharp
/// <summary>
/// Base interface for CLI tool completion providers
/// </summary>
public interface ICompletionProvider
{
    /// <summary>
    /// Tool name this provider handles (e.g., "git", "docker")
    /// </summary>
    string ToolName { get; }
    
    /// <summary>
    /// Priority for provider selection (higher = preferred)
    /// </summary>
    int Priority { get; }
    
    /// <summary>
    /// Check if this provider can handle the given command
    /// </summary>
    bool CanProvideCompletions(CompletionContext context);
    
    /// <summary>
    /// Generate completions for the given context
    /// </summary>
    Task<CompletionResult[]> GetCompletionsAsync(
        CompletionContext context,
        CancellationToken cancellationToken = default);
}
```

### ML.NET Integration Specifications

**AI Prediction Models**:

```csharp
/// <summary>
/// ML.NET prediction engine wrapper with fallback support
/// </summary>
public interface IMLPredictionEngine
{
    /// <summary>
    /// Indicates if ML.NET features are available on current platform
    /// </summary>
    bool IsAvailable { get; }
    
    /// <summary>
    /// Load embedded prediction models
    /// </summary>
    Task LoadModelsAsync(CancellationToken cancellationToken = default);
    
    /// <summary>
    /// Predict command completions using ML models
    /// </summary>
    Task<PredictionResult[]> PredictCompletionsAsync(
        MLPredictionContext context,
        CancellationToken cancellationToken = default);
}

/// <summary>
/// Embedded ML models for core functionality
/// </summary>
public static class EmbeddedModels
{
    public const string CommandPredictionModel = "Models/CommandPrediction.zip";
    public const string ParameterPredictionModel = "Models/ParameterPrediction.zip"; 
    public const string ContextAwarenessModel = "Models/ContextAwareness.zip";
    
    /// <summary>
    /// Model availability matrix by platform architecture
    /// </summary>
    public static readonly Dictionary<Architecture, bool> PlatformSupport = new()
    {
        [Architecture.X64] = true,    // Full ML.NET support
        [Architecture.Arm64] = false  // Graceful degradation
    };
}
```

---

## Input System Specifications

### Native Input Handling

**Key Binding Architecture**:

```csharp
/// <summary>
/// Custom key handler for advanced editing features
/// </summary>
public interface IKeyHandler
{
    /// <summary>
    /// Register custom key binding
    /// </summary>
    void RegisterKeyBinding(KeyCombination keys, KeyAction action);
    
    /// <summary>
    /// Process key input and execute bound actions  
    /// </summary>
    Task<InputResult> ProcessKeyAsync(
        ConsoleKeyInfo keyInfo,
        InputContext context,
        CancellationToken cancellationToken = default);
    
    /// <summary>
    /// Switch between editing modes (Cmd/Emacs/Vi)
    /// </summary>
    void SetEditingMode(EditingMode mode);
}

/// <summary>
/// Key combination specification
/// </summary>
public sealed record KeyCombination(
    ConsoleKey Key,
    ConsoleModifiers Modifiers = ConsoleModifiers.None,
    string? Description = null
);

/// <summary>
/// Editing mode implementations
/// </summary>
public enum EditingMode
{
    /// <summary>Windows Cmd-style editing</summary>
    Cmd,
    /// <summary>Emacs-style key bindings with kill ring</summary>
    Emacs,
    /// <summary>Vi/Vim-style modal editing</summary>
    Vi
}
```

**Multi-Line Editor Specifications**:

```csharp
/// <summary>
/// Advanced multi-line editing with PowerShell syntax awareness
/// </summary>
public interface IMultiLineEditor
{
    /// <summary>
    /// Current editor content
    /// </summary>
    string Content { get; }
    
    /// <summary>
    /// Cursor position in content
    /// </summary>
    CursorPosition Position { get; }
    
    /// <summary>
    /// Insert text at current position
    /// </summary>
    void Insert(string text);
    
    /// <summary>
    /// Delete text in specified range
    /// </summary>
    void Delete(TextRange range);
    
    /// <summary>
    /// Move cursor to new position
    /// </summary>
    void MoveCursor(CursorPosition newPosition);
    
    /// <summary>
    /// Navigate by PowerShell tokens (words, operators, etc.)
    /// </summary>
    void NavigateByToken(NavigationDirection direction);
}
```

### Command History System

**SQLite-Based History Storage**:

```sql
-- Command history schema
CREATE TABLE command_history
(
  id                INTEGER PRIMARY KEY AUTOINCREMENT,
  command_text      TEXT NOT NULL,
  executed_at       DATETIME DEFAULT CURRENT_TIMESTAMP,
  execution_time_ms INTEGER,
  exit_code         INTEGER,
  working_directory TEXT,
  session_id        TEXT,
  user_context      TEXT,
  frequency_count   INTEGER  DEFAULT 1,
  last_accessed     DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_command_text ON command_history (command_text);
CREATE INDEX idx_executed_at ON command_history (executed_at);
CREATE INDEX idx_frequency ON command_history (frequency_count DESC);

-- Configuration table
CREATE TABLE configuration
(
  key        TEXT PRIMARY KEY,
  value      TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Completion statistics
CREATE TABLE completion_stats
(
  provider_name            TEXT,
  command                  TEXT,
  completion_count         INTEGER  DEFAULT 0,
  average_response_time_ms REAL,
  last_used                DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (provider_name, command)
);
```

**History Management API**:

```csharp
/// <summary>
/// Command history storage and retrieval
/// </summary>
public interface ICommandHistory
{
    /// <summary>
    /// Add executed command to history
    /// </summary>
    Task AddCommandAsync(
        HistoryEntry entry,
        CancellationToken cancellationToken = default);
    
    /// <summary>
    /// Search command history with intelligent ranking
    /// </summary>
    Task<HistoryEntry[]> SearchHistoryAsync(
        string query,
        int maxResults = 50,
        CancellationToken cancellationToken = default);
    
    /// <summary>
    /// Get frequently used commands for prediction
    /// </summary>
    Task<CommandFrequency[]> GetFrequentCommandsAsync(
        int maxResults = 100,
        CancellationToken cancellationToken = default);
    
    /// <summary>
    /// Clean up old history entries based on retention policy
    /// </summary>
    Task CleanupHistoryAsync(
        TimeSpan retentionPeriod,
        CancellationToken cancellationToken = default);
}
```

---

## Rendering System Specifications

### ANSI Console Rendering

**Cross-Platform Rendering Engine**:

```csharp
/// <summary>
/// ANSI-compatible console rendering for cross-platform support
/// </summary>
public interface IANSIRenderer
{
    /// <summary>
    /// Render text with syntax highlighting
    /// </summary>
    void RenderHighlightedText(
        string text,
        SyntaxHighlightInfo[] highlights,
        RenderingOptions options = null);
    
    /// <summary>
    /// Display IntelliSense popup without disturbing command line
    /// </summary>
    void RenderIntelliSense(
        IntelliSenseInfo info,
        ConsolePosition position);
    
    /// <summary>
    /// Show contextual help overlay
    /// </summary>
    void RenderDynamicHelp(
        HelpContent help,
        HelpDisplayOptions options = null);
    
    /// <summary>
    /// Clear specific rendering regions
    /// </summary>
    void ClearRegion(RenderingRegion region);
}

/// <summary>
/// Syntax highlighting information
/// </summary>
public sealed record SyntaxHighlightInfo(
    TextRange Range,
    SyntaxCategory Category,
    ConsoleColor ForegroundColor,
    ConsoleColor? BackgroundColor = null,
    TextStyle Style = TextStyle.Normal
);

/// <summary>
/// Syntax categories for different command elements
/// </summary>
public enum SyntaxCategory
{
    Command,
    Parameter,
    Argument,
    String,
    Number,
    Operator,
    Comment,
    Error,
    Variable,
    Path,
    Url
}
```

**IntelliSense Display System**:

```csharp
/// <summary>
/// Predictive IntelliSense display without command line interference
/// </summary>
public interface IIntelliSenseDisplay
{
    /// <summary>
    /// Show completion suggestions
    /// </summary>
    Task ShowCompletionsAsync(
        CompletionResult[] completions,
        CompletionDisplayOptions options = null,
        CancellationToken cancellationToken = default);
    
    /// <summary>
    /// Update display with filtered results
    /// </summary>
    Task UpdateCompletionsAsync(
        CompletionResult[] filteredCompletions,
        CancellationToken cancellationToken = default);
    
    /// <summary>
    /// Hide IntelliSense display
    /// </summary>
    Task HideAsync(CancellationToken cancellationToken = default);
    
    /// <summary>
    /// Handle navigation within completion list
    /// </summary>
    void NavigateCompletions(NavigationDirection direction);
}
```

---

## CLI Tool Integration Specifications

### Completion Provider Architecture

**Supported CLI Tools (26+ providers)**:

```yaml
version_control:
  - git: Git version control with branch/tag/remote awareness
  - svn: Subversion with repository context
  - hg: Mercurial with branch and bookmark support

containerization:
  - docker: Docker commands with container/image/network context
  - kubectl: Kubernetes with cluster/namespace awareness
  - podman: Podman container management

cloud_platforms:
  - az: Azure CLI with subscription/resource group context
  - aws: AWS CLI with profile/region awareness
  - gcloud: Google Cloud SDK with project context

package_managers:
  - npm: Node.js package manager with package.json awareness
  - yarn: Yarn package manager with workspace support
  - pip: Python package installer with virtual environment
  - dotnet: .NET CLI with project/solution context

shells_and_terminals:
  - pwsh: PowerShell Core with module/cmdlet completion
  - bash: Bash shell with built-in command completion
  - zsh: Z shell with advanced completion features

development_tools:
  - code: Visual Studio Code with workspace awareness
  - vim: Vim editor with file and command completion
  - emacs: Emacs editor with buffer and command support

build_systems:
  - make: Makefile target completion
  - cmake: CMake with target and option awareness
  - gradle: Gradle with task and project completion

networking:
  - ssh: SSH with host completion from config
  - curl: HTTP client with URL and option completion
  - wget: Web downloader with similar capabilities

system_administration:
  - systemctl: systemd service management
  - sudo: Privilege elevation with command context
  - chmod: File permission management
```

**Base Completion Provider Contract**:

```csharp
/// <summary>
/// Base implementation for CLI tool completion providers
/// </summary>
public abstract class BaseCompletion : ICompletionProvider
{
    protected ILogger Logger { get; }
    protected IConfiguration Configuration { get; }
    
    protected BaseCompletion(ILogger logger, IConfiguration configuration)
    {
        Logger = logger;
        Configuration = configuration;
    }
    
    /// <summary>
    /// Tool-specific completion logic implementation
    /// </summary>
    protected abstract Task<CompletionResult[]> GetToolCompletionsAsync(
        CompletionContext context,
        CancellationToken cancellationToken);
    
    /// <summary>
    /// Validate command context before processing
    /// </summary>
    protected virtual bool ValidateContext(CompletionContext context)
    {
        return !string.IsNullOrWhiteSpace(context.CurrentCommand)
            && context.CursorPosition >= 0;
    }
    
    /// <summary>
    /// Cache completion results for performance
    /// </summary>
    protected virtual TimeSpan CacheDuration => TimeSpan.FromMinutes(5);
}
```

### Git Completion Provider (Reference Implementation)

**Superior Git Performance Requirements**:

- **Target Performance**: Aiming for 3-8x faster response times than posh-git, with a goal of <50ms compared to the typical 150–400ms posh-git response. Benchmark data and testing methodology are available in the [Performance Benchmarks](#performance-benchmarks) section.
- **AI-Powered Intelligence**: Context-aware suggestions based on repository state and workflow patterns
- **Intelligent Repository Analysis**: Selective parsing and async operations for large repositories
- **Real-Time Validation**: Live error detection and correction for Git commands
- **Advanced Caching**: Repository state caching with intelligent invalidation strategies

### Performance Benchmarks

Detailed benchmark data comparing PSPredictor's Git completion performance with posh-git can be found in the project's
repository under `benchmarks/`. Testing was conducted on various repository sizes and system configurations to ensure
comprehensive coverage.

**Git-Specific Context Awareness**:

```csharp
/// <summary>
/// Advanced Git completion with repository state awareness
/// </summary>
public sealed class GitCompletion : BaseCompletion
{
    private readonly IGitRepositoryAnalyzer _repositoryAnalyzer;
    
    public GitCompletion(
        ILogger<GitCompletion> logger,
        IConfiguration configuration,
        IGitRepositoryAnalyzer repositoryAnalyzer) 
        : base(logger, configuration)
    {
        _repositoryAnalyzer = repositoryAnalyzer;
    }
    
    protected override async Task<CompletionResult[]> GetToolCompletionsAsync(
        CompletionContext context,
        CancellationToken cancellationToken)
    {
        var gitContext = await _repositoryAnalyzer.AnalyzeCurrentRepositoryAsync(cancellationToken);
        
        return context.CurrentCommand switch
        {
            "add" => await GetAddCompletionsAsync(gitContext, context, cancellationToken),
            "branch" => await GetBranchCompletionsAsync(gitContext, context, cancellationToken),
            "checkout" => await GetCheckoutCompletionsAsync(gitContext, context, cancellationToken),
            "commit" => await GetCommitCompletionsAsync(gitContext, context, cancellationToken),
            "merge" => await GetMergeCompletionsAsync(gitContext, context, cancellationToken),
            "push" => await GetPushCompletionsAsync(gitContext, context, cancellationToken),
            "pull" => await GetPullCompletionsAsync(gitContext, context, cancellationToken),
            _ => await GetGeneralGitCompletionsAsync(gitContext, context, cancellationToken)
        };
    }
}

/// <summary>
/// Git repository state analysis
/// </summary>
public interface IGitRepositoryAnalyzer
{
    Task<GitRepositoryContext> AnalyzeCurrentRepositoryAsync(
        CancellationToken cancellationToken = default);
}

/// <summary>
/// Git repository context information
/// </summary>
public sealed record GitRepositoryContext(
    bool IsRepository,
    string? CurrentBranch,
    string[] LocalBranches,
    string[] RemoteBranches,
    string[] Tags,
    string[] Remotes,
    GitStatus Status,
    string? UpstreamBranch = null
);
```

---

## Configuration System Specifications

### JSON Configuration Schema

**Primary Configuration File (PSPredictorConfig.json)**:

```json
{
  "$schema": "https://schemas.wangkanai.com/pspredictor/v2.0/config.schema.json",
  "version": "2.0.0",
  "general": {
    "enablePrediction": true,
    "enableSyntaxHighlighting": true,
    "enableIntelliSense": true,
    "maxSuggestions": 10,
    "responseTimeoutMs": 5000
  },
  "editing": {
    "mode": "Emacs",
    "enableMultiLine": true,
    "historySize": 10000,
    "enableFuzzyMatching": true
  },
  "ai": {
    "enableLocalModels": true,
    "enableEnhancedModels": false,
    "modelUpdatePolicy": "Automatic",
    "predictionConfidenceThreshold": 0.7
  },
  "completion": {
    "providers": {
      "git": {
        "enabled": true,
        "priority": 100,
        "cacheTimeout": "00:05:00",
        "contextAwareness": true
      },
      "docker": {
        "enabled": true,
        "priority": 90,
        "cacheTimeout": "00:05:00"
      }
    }
  },
  "rendering": {
    "colorScheme": "Default",
    "syntaxColors": {
      "command": "Green",
      "parameter": "Yellow",
      "argument": "White",
      "error": "Red"
    },
    "intelliSense": {
      "maxVisibleItems": 10,
      "showDescriptions": true,
      "showTooltips": true
    }
  },
  "performance": {
    "cacheSize": 1000,
    "enablePerformanceLogging": false,
    "memoryLimitMB": 100
  }
}
```

**Configuration Management API**:

```csharp
/// <summary>
/// Configuration management with schema validation
/// </summary>
public interface IPSPredictorConfiguration
{
    /// <summary>
    /// Current configuration settings
    /// </summary>
    PSPredictorConfig Current { get; }
    
    /// <summary>
    /// Load configuration from file or create default
    /// </summary>
    Task LoadConfigurationAsync(CancellationToken cancellationToken = default);
    
    /// <summary>
    /// Save current configuration to file
    /// </summary>
    Task SaveConfigurationAsync(CancellationToken cancellationToken = default);
    
    /// <summary>
    /// Update specific configuration section
    /// </summary>
    Task UpdateConfigurationAsync<T>(
        string sectionPath,
        T newValue,
        CancellationToken cancellationToken = default) where T : class;
    
    /// <summary>
    /// Validate configuration against schema
    /// </summary>
    ValidationResult ValidateConfiguration(PSPredictorConfig config);
    
    /// <summary>
    /// Event fired when configuration changes
    /// </summary>
    event EventHandler<ConfigurationChangedEventArgs> ConfigurationChanged;
}
```

---

## Testing Specifications

### Test Architecture Requirements

**Unit Test Coverage Requirements**:

```csharp
// Example test structure for completion providers
[TestClass]
public class GitCompletionTests
{
    private Mock<ILogger<GitCompletion>> _loggerMock;
    private Mock<IConfiguration> _configurationMock;
    private Mock<IGitRepositoryAnalyzer> _repositoryAnalyzerMock;
    private GitCompletion _gitCompletion;
    
    [TestInitialize]
    public void Setup()
    {
        _loggerMock = new Mock<ILogger<GitCompletion>>();
        _configurationMock = new Mock<IConfiguration>();
        _repositoryAnalyzerMock = new Mock<IGitRepositoryAnalyzer>();
        _gitCompletion = new GitCompletion(
            _loggerMock.Object,
            _configurationMock.Object,
            _repositoryAnalyzerMock.Object);
    }
    
    [TestMethod]
    public async Task GetCompletionsAsync_WithGitStatus_ReturnsPorcelainOption()
    {
        // Arrange
        var context = new CompletionContext("git status ", "status", 11);
        var gitContext = new GitRepositoryContext(true, "main", ["main", "develop"], [], [], [], GitStatus.Clean);
        
        _repositoryAnalyzerMock
            .Setup(x => x.AnalyzeCurrentRepositoryAsync(default))
            .ReturnsAsync(gitContext);
        
        // Act
        var results = await _gitCompletion.GetCompletionsAsync(context);
        
        // Assert
        results.Should().NotBeEmpty();
        results.Should().Contain(r => r.Text == "--porcelain");
        results.Should().Contain(r => r.Text == "--short");
    }
}
```

**Performance Test Specifications**:

```csharp
[MemoryDiagnoser]
[SimpleJob(RuntimeMoniker.Net90)]
public class CompletionPerformanceBenchmarks
{
    private CompletionProvider _provider;
    private CompletionContext _context;
    
    [GlobalSetup]
    public void Setup()
    {
        // Initialize test environment
        _provider = CreateCompletionProvider();
        _context = new CompletionContext("git status ", "status", 11);
    }
    
    [Benchmark]
    [Params("git", "docker", "kubectl")]
    public async Task<CompletionResult[]> GetCompletions(string tool)
    {
        var context = new CompletionContext($"{tool} ", tool, tool.Length + 1);
        return await _provider.GetCompletionsAsync(context);
    }
    
    [Benchmark]
    public async Task<CompletionResult[]> GetCompletionsWithCache()
    {
        // First call to populate cache
        await _provider.GetCompletionsAsync(_context);
        
        // Measured call should use cache
        return await _provider.GetCompletionsAsync(_context);
    }
}
```

### Integration Test Requirements

**End-to-End Test Scenarios**:

```csharp
[TestClass]
public class PSPredictorIntegrationTests
{
    [TestMethod]
    public async Task FullWorkflow_GitCompletion_E2E()
    {
        // Arrange: Create real PSPredictor instance
        var predictor = CreatePSPredictorInstance();
        
        // Act: Simulate user typing "git st" and requesting completion
        var completions = await predictor.GetCompletionsAsync(
            new CompletionContext("git st", "st", 6));
        
        // Assert: Verify "status" is suggested
        completions.Should().Contain(c => c.Text.StartsWith("status"));
        
        // Act: Complete to "git status " and request parameter completions
        var paramCompletions = await predictor.GetCompletionsAsync(
            new CompletionContext("git status ", "status", 11));
        
        // Assert: Verify parameter options are available
        paramCompletions.Should().Contain(c => c.Text == "--porcelain");
    }
}
```

---

## Security Specifications

### Input Validation Requirements

**Command Input Security**:

```csharp
/// <summary>
/// Secure input validation for command processing
/// </summary>
public static class SecurityValidator
{
    private static readonly Regex SafeCommandPattern = 
        new(@"^[a-zA-Z0-9\s\-_.:/\\]+$", RegexOptions.Compiled);
    
    /// <summary>
    /// Validate command input for security threats
    /// </summary>
    public static ValidationResult ValidateCommandInput(string input)
    {
        if (string.IsNullOrWhiteSpace(input))
            return ValidationResult.Invalid("Input cannot be empty");
            
        if (input.Length > 10000)
            return ValidationResult.Invalid("Input exceeds maximum length");
            
        if (ContainsDangerousPatterns(input))
            return ValidationResult.Invalid("Input contains potentially dangerous patterns");
            
        return ValidationResult.Valid();
    }
    
    private static bool ContainsDangerousPatterns(string input)
    {
        var dangerousPatterns = new[]
        {
            ";", "|", "&", "&&", "||", ">", ">>", "<",
            "$(", "${", "`", "eval", "exec"
        };
        
        return dangerousPatterns.Any(pattern => 
            input.Contains(pattern, StringComparison.OrdinalIgnoreCase));
    }
}
```

### Process Execution Security

**Safe Process Execution**:

```csharp
/// <summary>
/// Secure process execution for CLI tool integration
/// </summary>
public static class SecureProcessExecutor
{
    public static async Task<ProcessResult> ExecuteAsync(
        string fileName,
        string arguments,
        TimeSpan timeout = default,
        CancellationToken cancellationToken = default)
    {
        // Validate inputs (ThrowIfNullOrWhiteSpace available in .NET 7+, we target .NET 9.0)
        ArgumentException.ThrowIfNullOrWhiteSpace(fileName);
        SecurityValidator.ValidateCommandInput(fileName).ThrowIfInvalid();
        SecurityValidator.ValidateCommandInput(arguments).ThrowIfInvalid();
        
        var startInfo = new ProcessStartInfo
        {
            FileName = fileName,
            Arguments = arguments,
            UseShellExecute = false,          // Never use shell execution
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            CreateNoWindow = true,
            WorkingDirectory = Environment.CurrentDirectory
        };
        
        // Set timeout (default 30 seconds)
        var effectiveTimeout = timeout == default ? TimeSpan.FromSeconds(30) : timeout;
        
        using var process = new Process { StartInfo = startInfo };
        using var timeoutCts = new CancellationTokenSource(effectiveTimeout);
        using var combinedCts = CancellationTokenSource.CreateLinkedTokenSource(
            cancellationToken, timeoutCts.Token);
        
        try
        {
            process.Start();
            
            var outputTask = process.StandardOutput.ReadToEndAsync(combinedCts.Token);
            var errorTask = process.StandardError.ReadToEndAsync(combinedCts.Token);
            
            await process.WaitForExitAsync(combinedCts.Token);
            
            var output = await outputTask;
            var error = await errorTask;
            
            return new ProcessResult(process.ExitCode, output, error);
        }
        catch (OperationCanceledException) when (timeoutCts.Token.IsCancellationRequested)
        {
            process.Kill(entireProcessTree: true);
            throw new TimeoutException($"Process execution timed out after {effectiveTimeout}");
        }
    }
}
```

---

## Deployment Specifications

### Package Distribution

**NuGet Package Structure**:

```text
PSPredictor.2.0.0.nupkg
├── lib/
│   └── net9.0/
│       ├── PSPredictor.dll
│       ├── PSPredictor.pdb
│       ├── PSPredictor.Core.dll
│       └── PSPredictor.Shared.dll
├── content/
│   └── PowerShell/
│       ├── PSPredictor.psd1
│       └── PSPredictor.psm1
├── tools/
│   ├── install.ps1
│   └── uninstall.ps1
├── models/
│   ├── CommandPrediction.zip
│   ├── ParameterPrediction.zip
│   └── ContextAwareness.zip
└── LICENSE.txt
```

**PowerShell Gallery Manifest**:

```powershell
@{
# Package metadata
  RootModule = 'PSPredictor.dll'
  ModuleVersion = '2.0.0'
  GUID = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'

  # Requirements
  PowerShellVersion = '7.5'
  DotNetFrameworkVersion = '9.0'
  RequiredModules = @()

  # Export definitions
  CmdletsToExport = @(
    'Get-PSPredictorStatus',
    'Set-PSPredictorMode',
    'Enable-PSPredictorMode',
    'Disable-PSPredictorMode'
  )

  # Package information
  PrivateData = @{
    PSData = @{
      Tags = @('PowerShell', 'Completion', 'AI', 'Prediction')
      LicenseUri = 'https://github.com/wangkanai/PSPredictor/blob/main/LICENSE'
      ProjectUri = 'https://github.com/wangkanai/PSPredictor'
      ReleaseNotes = 'https://github.com/wangkanai/PSPredictor/releases/tag/v2.0.0'
    }
  }
}
```

### Installation Requirements

**System Prerequisites Validation**:

```powershell
# install.ps1 - Package installation script
param(
  [string]$InstallPath,
  [switch]$Force
)

# Validate system requirements
$requirements = @{
  PowerShellVersion = [version]'7.5'
  DotNetVersion = [version]'9.0'
  MinimumMemoryMB = 512
  MinimumDiskSpaceMB = 100
}

function Test-SystemRequirements
{
  $errors = @()

  # Check PowerShell version
  if ($PSVersionTable.PSVersion -lt $requirements.PowerShellVersion)
  {
    $errors += "PowerShell $( $requirements.PowerShellVersion ) or higher required"
  }

  # Check .NET version
  try
  {
    $dotnetVersion = [System.Runtime.InteropServices.RuntimeInformation]::FrameworkDescription
    if (-not $dotnetVersion.Contains("9.0"))
    {
      $errors += ".NET 9.0 runtime required"
    }
  }
  catch
  {
    $errors += "Unable to determine .NET version"
  }

  # Check memory (cross-platform)
  $memory = if ($IsWindows)
  {
    (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1MB
  }
  elseif ($IsLinux)
  {
    [math]::Round((Get-Content '/proc/meminfo' | Where-Object { $_ -match '^MemTotal:' } | ForEach-Object { ($_ -split '\s+')[1] }) / 1KB, 0)
  }
  elseif ($IsMacOS)
  {
    [math]::Round((sysctl -n hw.memsize) / 1MB, 0)
  }
  else
  {
    # Fallback to .NET method
    [math]::Round([System.GC]::GetTotalMemory($false) / 1MB, 0)
  }

  if ($memory -lt $requirements.MinimumMemoryMB)
  {
    $errors += "Minimum $( $requirements.MinimumMemoryMB )MB RAM required (detected: ${memory}MB)"
  }

  return $errors
}
```

---

**Specifications Version**: 2.0.0  
**Effective Date**: 2025-08-01  
**Review Cycle**: Per major release  
**Compatibility**: .NET 9.0, PowerShell Core 7+
