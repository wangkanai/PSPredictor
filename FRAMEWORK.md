# FRAMEWORK.md - PSPredictor Architectural Framework

**Version**: 2.0.0  
**Last Updated**: 2025-07-31  
**Architecture**: C# .NET 9.0 Binary Module with AI-Powered Prediction Engine

> **⚠️ Implementation Status**: This document represents the target architecture for PSPredictor v2.0.
> Interfaces and classes referenced (ISyntaxHighlighter, IPredictionEngine, etc.) are planned implementations.
> Current source code contains placeholder implementations pending full v2.0 development.

---

## Architectural Overview

### Core Design Principles

**Performance-First Architecture**:

- **Sub-100ms Response Time**: All user-facing operations optimized for <100ms response
- **Lazy Loading**: Components loaded on-demand to minimize startup time
- **Asynchronous Operations**: Non-blocking I/O with proper cancellation token support
- **Memory Efficiency**: <50MB runtime footprint with intelligent caching strategies
- **Cross-Platform Optimization**: Consistent performance across Windows, Linux, macOS (x64/ARM64)

**Modular Component Design**:

- **Separation of Concerns**: Clear boundaries between prediction, completion, rendering, and input handling
- **Dependency Injection**: Loose coupling through IoC container with lifetime management
- **Plugin Architecture**: Extensible completion providers with registration-based discovery
- **Interface-Driven**: Contract-based design enabling testability and extensibility

**AI-Powered Intelligence**:

- **Embedded ML Models**: Local machine learning with embedded models for offline functionality
- **Context Awareness**: Intelligent prediction based on command history, environment, and user patterns
- **Adaptive Learning**: Continuous improvement through user interaction patterns
- **Graceful Degradation**: Full functionality on ARM64 with ML.NET fallback strategies

### System Architecture Layers

```text
┌────────────────────────────────────────────────────────────────┐
│                    PowerShell Host Layer                       │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐   │
│  │   Get-Status    │ │   Set-Mode      │ │   Install       │   │
│  │     Cmdlet      │ │    Cmdlet       │ │    Cmdlet       │   │
│  └─────────────────┘ └─────────────────┘ └─────────────────┘   │
└────────────────────────────────────────────────────────────────┘
                                │
┌────────────────────────────────────────────────────────────────┐
│                    Core Engine Layer                           │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐   │
│  │   Prediction    │ │   Completion    │ │     Syntax      │   │
│  │     Engine      │ │    Provider     │ │   Highlighter   │   │
│  └─────────────────┘ └─────────────────┘ └─────────────────┘   │
└────────────────────────────────────────────────────────────────┘
                                │
┌────────────────────────────────────────────────────────────────┐
│                    AI Intelligence Layer                       │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐   │
│  │   ML.NET        │ │   Command       │ │   Context       │   │
│  │   Engine        │ │   History       │ │   Analyzer      │   │
│  └─────────────────┘ └─────────────────┘ └─────────────────┘   │
└────────────────────────────────────────────────────────────────┘
                                │
┌────────────────────────────────────────────────────────────────┐
│                    Input & Rendering Layer                     │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐   │
│  │   Key Handler   │ │   ANSI          │ │   Multi-Line    │   │
│  │   (Cmd/Emacs)   │ │   Renderer      │ │    Editor       │   │
│  └─────────────────┘ └─────────────────┘ └─────────────────┘   │
└────────────────────────────────────────────────────────────────┘
                                │
┌────────────────────────────────────────────────────────────────┐
│                    Provider Ecosystem                          │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐   │
│  │      Git        │ │     Docker      │ │   Azure CLI     │   │
│  │   Completion    │ │   Completion    │ │   Completion    │   │
│  └─────────────────┘ └─────────────────┘ └─────────────────┘   │
│            ... 26+ CLI Tool Providers ...                      │
└────────────────────────────────────────────────────────────────┘
                                │
┌────────────────────────────────────────────────────────────────┐
│                    Storage & Configuration                     │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐   │
│  │     SQLite      │ │      JSON       │ │     Caching     │   │
│  │    History      │ │   Configuration │ │    Strategy     │   │
│  └─────────────────┘ └─────────────────┘ └─────────────────┘   │
└────────────────────────────────────────────────────────────────┘
```

---

## Component Architecture

### Core Engine Components

**IPredictionEngine - Central Orchestrator**:

```csharp
/// <summary>
/// Core prediction engine orchestrating all completion and AI prediction services
/// </summary>
public interface IPredictionEngine
{
    /// <summary>
    /// Get intelligent completions with AI-powered ranking
    /// </summary>
    Task<CompletionResult[]> GetCompletionsAsync(
        CompletionContext context,
        CancellationToken cancellationToken = default);
    
    /// <summary>
    /// Predict next likely commands based on history and patterns
    /// </summary>
    Task<PredictionResult[]> PredictNextCommandAsync(
        PredictionContext context,
        CancellationToken cancellationToken = default);
    
    /// <summary>
    /// Learn from user command execution for adaptive improvement
    /// </summary>
    Task LearnFromExecutionAsync(
        ExecutionContext context,
        CancellationToken cancellationToken = default);
}

/// <summary>
/// Production implementation with dependency coordination
/// </summary>
public sealed class PredictionEngine : IPredictionEngine, IDisposable
{
    private readonly ICompletionProvider _completionProvider;
    private readonly IMLPredictionEngine _mlEngine;
    private readonly ICommandHistory _commandHistory;
    private readonly ISyntaxHighlighter _syntaxHighlighter;
    private readonly IMemoryCache _cache;
    private readonly ILogger<PredictionEngine> _logger;
    
    public PredictionEngine(
        ICompletionProvider completionProvider,
        IMLPredictionEngine mlEngine,
        ICommandHistory commandHistory,
        ISyntaxHighlighter syntaxHighlighter,
        IMemoryCache cache,
        ILogger<PredictionEngine> logger)
    {
        _completionProvider = completionProvider;
        _mlEngine = mlEngine;
        _commandHistory = commandHistory;
        _syntaxHighlighter = syntaxHighlighter;
        _cache = cache;
        _logger = logger;
    }
    
    public async Task<CompletionResult[]> GetCompletionsAsync(
        CompletionContext context,
        CancellationToken cancellationToken = default)
    {
        var cacheKey = GenerateCacheKey(context);
        
        // Check cache first for performance
        if (_cache.TryGetValue(cacheKey, out CompletionResult[] cachedResults))
        {
            _logger.LogDebug("Cache hit for completion context: {Context}", context.CommandLine);
            return cachedResults;
        }
        
        // Get base completions from providers
        var completions = await _completionProvider.GetCompletionsAsync(context, cancellationToken);
        
        // Enhance with AI predictions if available
        if (_mlEngine.IsAvailable && completions.Length > 0)
        {
            var aiPredictions = await _mlEngine.PredictCompletionsAsync(
                MLPredictionContext.FromCompletion(context), 
                cancellationToken);
            
            completions = MergeAndRankResults(completions, aiPredictions);
        }
        
        // Cache results for performance
        _cache.Set(cacheKey, completions, TimeSpan.FromMinutes(5));
        
        return completions;
    }
}
```

**ICompletionProvider - Provider Orchestrator**:

```csharp
/// <summary>
/// Orchestrates multiple CLI tool completion providers
/// </summary>
public interface ICompletionProvider
{
    /// <summary>
    /// Register a new completion provider
    /// </summary>
    void RegisterProvider(ICliToolCompletion provider);
    
    /// <summary>
    /// Get completions from the most appropriate provider
    /// </summary>
    Task<CompletionResult[]> GetCompletionsAsync(
        CompletionContext context,
        CancellationToken cancellationToken = default);
    
    /// <summary>
    /// Get all available providers for diagnostics
    /// </summary>
    IReadOnlyList<ICliToolCompletion> GetRegisteredProviders();
}

/// <summary>
/// Production implementation with provider prioritization
/// </summary>
public sealed class CompletionProvider : ICompletionProvider
{
    private readonly ConcurrentDictionary<string, ICliToolCompletion> _providers;
    private readonly ILogger<CompletionProvider> _logger;
    
    public CompletionProvider(
        IEnumerable<ICliToolCompletion> providers,
        ILogger<CompletionProvider> logger)
    {
        _providers = new ConcurrentDictionary<string, ICliToolCompletion>();
        _logger = logger;
        
        // Register all injected providers
        foreach (var provider in providers)
        {
            RegisterProvider(provider);
        }
    }
    
    public async Task<CompletionResult[]> GetCompletionsAsync(
        CompletionContext context,
        CancellationToken cancellationToken = default)
    {
        var command = ExtractCommand(context.CommandLine);
        
        // Find matching provider
        if (_providers.TryGetValue(command, out var provider) && 
            provider.CanProvideCompletions(context))
        {
            var stopwatch = Stopwatch.StartNew();
            
            try
            {
                var results = await provider.GetCompletionsAsync(context, cancellationToken);
                stopwatch.Stop();
                
                _logger.LogDebug(
                    "Completion provider {Provider} returned {Count} results in {ElapsedMs}ms",
                    provider.GetType().Name, results.Length, stopwatch.ElapsedMilliseconds);
                
                return results;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex,
                    "Error getting completions from provider {Provider} for command {Command}",
                    provider.GetType().Name, command);
                
                return Array.Empty<CompletionResult>();
            }
        }
        
        // Fallback to generic completions
        return await GetGenericCompletionsAsync(context, cancellationToken);
    }
}
```

### AI Intelligence Layer

**IMLPredictionEngine - Machine Learning Integration**:

```csharp
/// <summary>
/// ML.NET integration with platform-specific availability
/// </summary>
public interface IMLPredictionEngine
{
    /// <summary>
    /// Indicates if ML.NET features are available on current platform
    /// </summary>
    bool IsAvailable { get; }
    
    /// <summary>
    /// Load embedded ML models asynchronously
    /// </summary>
    Task LoadModelsAsync(CancellationToken cancellationToken = default);
    
    /// <summary>
    /// Predict command completions using trained models
    /// </summary>
    Task<PredictionResult[]> PredictCompletionsAsync(
        MLPredictionContext context,
        CancellationToken cancellationToken = default);
    
    /// <summary>
    /// Train models with user interaction data
    /// </summary>
    Task TrainModelsAsync(
        TrainingData data,
        CancellationToken cancellationToken = default);
}

/// <summary>
/// Production implementation with ARM64 fallback
/// </summary>
public sealed class MLPredictionEngine : IMLPredictionEngine, IDisposable
{
    private readonly bool _isAvailable;
    private readonly ILogger<MLPredictionEngine> _logger;
    private MLContext? _mlContext;
    private ITransformer? _commandModel;
    private ITransformer? _parameterModel;
    private ITransformer? _contextModel;
    
    public MLPredictionEngine(ILogger<MLPredictionEngine> logger)
    {
        _logger = logger;
        _isAvailable = RuntimeInformation.ProcessArchitecture == Architecture.X64;
        
        if (_isAvailable)
        {
            _mlContext = new MLContext(seed: 1);
        }
        else
        {
            _logger.LogInformation(
                "ML.NET features disabled on {Architecture} - using fallback implementations",
                RuntimeInformation.ProcessArchitecture);
        }
    }
    
    public bool IsAvailable => _isAvailable;
    
    public async Task LoadModelsAsync(CancellationToken cancellationToken = default)
    {
        if (!_isAvailable) return;
        
        try
        {
            // Load embedded models
            _commandModel = await LoadEmbeddedModelAsync("CommandPrediction.zip", cancellationToken);
            _parameterModel = await LoadEmbeddedModelAsync("ParameterPrediction.zip", cancellationToken);
            _contextModel = await LoadEmbeddedModelAsync("ContextAwareness.zip", cancellationToken);
            
            _logger.LogInformation("ML models loaded successfully");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to load ML models - falling back to rule-based predictions");
        }
    }
    
    public async Task<PredictionResult[]> PredictCompletionsAsync(
        MLPredictionContext context,
        CancellationToken cancellationToken = default)
    {
        if (!_isAvailable || _commandModel == null)
        {
            // Fallback to rule-based predictions
            return await GetRuleBasedPredictionsAsync(context, cancellationToken);
        }
        
        try
        {
            // Use ML models for prediction
            return await GetMLPredictionsAsync(context, cancellationToken);
        }
        catch (Exception ex)
        {
            _logger.LogWarning(ex, "ML prediction failed - falling back to rule-based");
            return await GetRuleBasedPredictionsAsync(context, cancellationToken);
        }
    }
}
```

### Input System Architecture

**IKeyHandler - Advanced Input Management**:

```csharp
/// <summary>
/// Advanced key handling with multi-modal editing support
/// </summary>
public interface IKeyHandler
{
    /// <summary>
    /// Current editing mode
    /// </summary>
    EditingMode CurrentMode { get; }
    
    /// <summary>
    /// Process key input and execute bound actions
    /// </summary>
    Task<InputResult> ProcessKeyAsync(
        ConsoleKeyInfo keyInfo,
        InputContext context,
        CancellationToken cancellationToken = default);
    
    /// <summary>
    /// Register custom key binding
    /// </summary>
    void RegisterKeyBinding(KeyCombination keys, KeyAction action);
    
    /// <summary>
    /// Switch editing mode (Cmd/Emacs/Vi)
    /// </summary>
    void SetEditingMode(EditingMode mode);
}

/// <summary>
/// Production implementation with mode switching
/// </summary>
public sealed class KeyHandler : IKeyHandler
{
    private readonly Dictionary<EditingMode, IEditingMode> _editingModes;
    private readonly ILogger<KeyHandler> _logger;
    private EditingMode _currentMode;
    
    public KeyHandler(
        IEnumerable<IEditingMode> editingModes,
        ILogger<KeyHandler> logger)
    {
        _editingModes = editingModes.ToDictionary(mode => mode.Mode, mode => mode);
        _logger = logger;
        _currentMode = EditingMode.Emacs; // Default to Emacs mode
    }
    
    public EditingMode CurrentMode => _currentMode;
    
    public async Task<InputResult> ProcessKeyAsync(
        ConsoleKeyInfo keyInfo,
        InputContext context,
        CancellationToken cancellationToken = default)
    {
        if (!_editingModes.TryGetValue(_currentMode, out var editingMode))
        {
            throw new InvalidOperationException($"Editing mode {_currentMode} not registered");
        }
        
        return await editingMode.ProcessKeyAsync(keyInfo, context, cancellationToken);
    }
    
    public void SetEditingMode(EditingMode mode)
    {
        if (!_editingModes.ContainsKey(mode))
        {
            throw new ArgumentException($"Editing mode {mode} not available");
        }
        
        _currentMode = mode;
        _logger.LogDebug("Switched to editing mode: {Mode}", mode);
    }
}
```

**Multi-Modal Editing Implementations**:

```csharp
/// <summary>
/// Base interface for editing mode implementations
/// </summary>
public interface IEditingMode
{
    /// <summary>
    /// Editing mode identifier
    /// </summary>
    EditingMode Mode { get; }
    
    /// <summary>
    /// Process key input according to mode rules
    /// </summary>
    Task<InputResult> ProcessKeyAsync(
        ConsoleKeyInfo keyInfo,
        InputContext context,
        CancellationToken cancellationToken = default);
}

/// <summary>
/// Emacs-style editing with kill ring support
/// </summary>
public sealed class EmacsEditingMode : IEditingMode
{
    private readonly IKillRing _killRing;
    private readonly ILogger<EmacsEditingMode> _logger;
    
    public EditingMode Mode => EditingMode.Emacs;
    
    public EmacsEditingMode(IKillRing killRing, ILogger<EmacsEditingMode> logger)
    {
        _killRing = killRing;
        _logger = logger;
    }
    
    public async Task<InputResult> ProcessKeyAsync(
        ConsoleKeyInfo keyInfo,
        InputContext context,
        CancellationToken cancellationToken = default)
    {
        // Emacs key binding implementation
        return (keyInfo.Key, keyInfo.Modifiers) switch
        {
            (ConsoleKey.A, ConsoleModifiers.Control) => 
                await MoveToBeginningOfLineAsync(context, cancellationToken),
            (ConsoleKey.E, ConsoleModifiers.Control) => 
                await MoveToEndOfLineAsync(context, cancellationToken),
            (ConsoleKey.K, ConsoleModifiers.Control) => 
                await KillToEndOfLineAsync(context, cancellationToken),
            (ConsoleKey.Y, ConsoleModifiers.Control) => 
                await YankFromKillRingAsync(context, cancellationToken),
            (ConsoleKey.F, ConsoleModifiers.Control) => 
                await MoveForwardCharAsync(context, cancellationToken),
            (ConsoleKey.B, ConsoleModifiers.Control) => 
                await MoveBackwardCharAsync(context, cancellationToken),
            _ => await HandleDefaultKeyAsync(keyInfo, context, cancellationToken)
        };
    }
}

/// <summary>
/// Vi-style modal editing
/// </summary>
public sealed class ViEditingMode : IEditingMode
{
    private ViMode _viMode = ViMode.Insert;
    private readonly ILogger<ViEditingMode> _logger;
    
    public EditingMode Mode => EditingMode.Vi;
    
    public async Task<InputResult> ProcessKeyAsync(
        ConsoleKeyInfo keyInfo,
        InputContext context,
        CancellationToken cancellationToken = default)
    {
        return _viMode switch
        {
            ViMode.Insert => await ProcessInsertModeAsync(keyInfo, context, cancellationToken),
            ViMode.Normal => await ProcessNormalModeAsync(keyInfo, context, cancellationToken),
            ViMode.Visual => await ProcessVisualModeAsync(keyInfo, context, cancellationToken),
            _ => throw new InvalidOperationException($"Unknown Vi mode: {_viMode}")
        };
    }
}
```

### Rendering System Architecture

**IANSIRenderer - Cross-Platform Rendering**:

```csharp
/// <summary>
/// ANSI-based cross-platform console rendering
/// </summary>
public interface IANSIRenderer
{
    /// <summary>
    /// Render text with syntax highlighting
    /// </summary>
    Task RenderHighlightedTextAsync(
        string text,
        SyntaxHighlightInfo[] highlights,
        RenderingOptions? options = null,
        CancellationToken cancellationToken = default);
    
    /// <summary>
    /// Display IntelliSense without disturbing command line
    /// </summary>
    Task RenderIntelliSenseAsync(
        IntelliSenseInfo info,
        ConsolePosition position,
        CancellationToken cancellationToken = default);
    
    /// <summary>
    /// Clear specific rendering regions
    /// </summary>
    Task ClearRegionAsync(
        RenderingRegion region,
        CancellationToken cancellationToken = default);
}

/// <summary>
/// Production implementation with platform detection
/// </summary>
public sealed class ANSIRenderer : IANSIRenderer
{
    private readonly bool _supportsAnsi;
    private readonly ILogger<ANSIRenderer> _logger;
    
    public ANSIRenderer(ILogger<ANSIRenderer> logger)
    {
        _logger = logger;
        _supportsAnsi = DetectAnsiSupport();
    }
    
    public async Task RenderHighlightedTextAsync(
        string text,
        SyntaxHighlightInfo[] highlights,
        RenderingOptions? options = null,
        CancellationToken cancellationToken = default)
    {
        if (!_supportsAnsi)
        {
            // Fallback to plain text rendering
            Console.Write(text);
            return;
        }
        
        var buffer = new StringBuilder(text.Length * 2);
        var currentPosition = 0;
        
        foreach (var highlight in highlights.OrderBy(h => h.Range.Start))
        {
            // Write text before highlight
            if (highlight.Range.Start > currentPosition)
            {
                buffer.Append(text[currentPosition..highlight.Range.Start]);
            }
            
            // Apply highlighting
            buffer.Append(GetAnsiColorCode(highlight.ForegroundColor));
            if (highlight.BackgroundColor.HasValue)
            {
                buffer.Append(GetAnsiBackgroundCode(highlight.BackgroundColor.Value));
            }
            
            // Write highlighted text
            buffer.Append(text[highlight.Range.Start..highlight.Range.End]);
            
            // Reset formatting
            buffer.Append(AnsiCodes.Reset);
            
            currentPosition = highlight.Range.End;
        }
        
        // Write remaining text
        if (currentPosition < text.Length)
        {
            buffer.Append(text[currentPosition..]);
        }
        
        Console.Write(buffer.ToString());
        await Task.CompletedTask;
    }
}
```

---

## Provider Ecosystem Framework

### Base Completion Provider Pattern

**Abstract Base Implementation**:

```csharp
/// <summary>
/// Base implementation providing common functionality for CLI tool providers
/// </summary>
public abstract class BaseCliToolCompletion : ICliToolCompletion
{
    protected ILogger Logger { get; }
    protected IConfiguration Configuration { get; }
    protected IMemoryCache Cache { get; }
    
    protected BaseCliToolCompletion(
        ILogger logger,
        IConfiguration configuration,
        IMemoryCache cache)
    {
        Logger = logger;
        Configuration = configuration;
        Cache = cache;
    }
    
    public abstract string ToolName { get; }
    public virtual int Priority => 100;
    
    public virtual bool CanProvideCompletions(CompletionContext context)
    {
        return context.CommandLine.StartsWith(ToolName, StringComparison.OrdinalIgnoreCase);
    }
    
    public async Task<CompletionResult[]> GetCompletionsAsync(
        CompletionContext context,
        CancellationToken cancellationToken = default)
    {
        var cacheKey = $"{ToolName}:{context.GetHashCode()}";
        
        if (Cache.TryGetValue(cacheKey, out CompletionResult[] cachedResults))
        {
            return cachedResults;
        }
        
        try
        {
            var results = await GetToolSpecificCompletionsAsync(context, cancellationToken);
            
            // Cache results with configurable TTL
            var cacheDuration = GetCacheDuration();
            Cache.Set(cacheKey, results, cacheDuration);
            
            return results;
        }
        catch (Exception ex)
        {
            Logger.LogError(ex, "Error getting completions for {Tool}", ToolName);
            return Array.Empty<CompletionResult>();
        }
    }
    
    /// <summary>
    /// Tool-specific completion implementation
    /// </summary>
    protected abstract Task<CompletionResult[]> GetToolSpecificCompletionsAsync(
        CompletionContext context,
        CancellationToken cancellationToken);
    
    /// <summary>
    /// Get cache duration for this provider
    /// </summary>
    protected virtual TimeSpan GetCacheDuration() => TimeSpan.FromMinutes(5);
    
    /// <summary>
    /// Execute tool command safely
    /// </summary>
    protected async Task<ProcessResult> ExecuteToolCommandAsync(
        string arguments,
        TimeSpan timeout = default,
        CancellationToken cancellationToken = default)
    {
        var effectiveTimeout = timeout == default ? TimeSpan.FromSeconds(10) : timeout;
        
        return await SecureProcessExecutor.ExecuteAsync(
            ToolName,
            arguments,
            effectiveTimeout,
            cancellationToken);
    }
}
```

## Git Provider Architecture

### Superior Git Performance Requirements

**Performance Specifications vs posh-git**:

- **3-8x Faster Response Time**: Target <50ms vs typical 150-400ms posh-git response
- **AI-Powered Intelligence**: Context-aware suggestions based on repository state and workflow patterns
- **Intelligent Repository Analysis**: Selective parsing and async operations for large repositories
- **Real-Time Validation**: Live error detection and correction for Git commands
- **Advanced Caching**: Repository state caching with intelligent invalidation strategies

**Git-Specific Architecture Components**:

```csharp
/// <summary>
/// Git repository context information with performance optimization
/// </summary>
public sealed record GitRepositoryContext(
    bool IsRepository,
    string? CurrentBranch,
    string[] LocalBranches,
    string[] RemoteBranches,
    string[] Tags, 
    string[] Remotes,
    GitStatus Status,
    string? UpstreamBranch = null,
    DateTime LastAnalyzed = default,
    TimeSpan CacheValidity = default
)
{
    public static readonly GitRepositoryContext NotARepository = new(
        false, null, [], [], [], [], GitStatus.Unknown);
        
    public bool IsCacheValid => DateTime.UtcNow - LastAnalyzed < CacheValidity;
}
```

### Git Provider Implementation (Reference)

**Advanced Git Integration**:

```csharp
/// <summary>
/// Advanced Git completion with repository state awareness
/// </summary>
public sealed class GitCompletion : BaseCliToolCompletion
{
    private readonly IGitRepositoryAnalyzer _repositoryAnalyzer;
    private readonly Lazy<Dictionary<string, GitCommandInfo>> _gitCommands;
    
    public override string ToolName => "git";
    public override int Priority => 100;
    
    public GitCompletion(
        ILogger<GitCompletion> logger,
        IConfiguration configuration,
        IMemoryCache cache,
        IGitRepositoryAnalyzer repositoryAnalyzer)
        : base(logger, configuration, cache)
    {
        _repositoryAnalyzer = repositoryAnalyzer;
        _gitCommands = new Lazy<Dictionary<string, GitCommandInfo>>(LoadGitCommands);
    }
    
    protected override async Task<CompletionResult[]> GetToolSpecificCompletionsAsync(
        CompletionContext context,
        CancellationToken cancellationToken)
    {
        var gitContext = await _repositoryAnalyzer.AnalyzeCurrentRepositoryAsync(cancellationToken);
        var parsedCommand = ParseGitCommand(context);
        
        return parsedCommand.SubCommand switch
        {
            null or "" => GetMainCommandCompletions(),
            "add" => await GetAddCompletionsAsync(gitContext, parsedCommand, cancellationToken),
            "branch" => await GetBranchCompletionsAsync(gitContext, parsedCommand, cancellationToken),
            "checkout" => await GetCheckoutCompletionsAsync(gitContext, parsedCommand, cancellationToken),
            "commit" => await GetCommitCompletionsAsync(gitContext, parsedCommand, cancellationToken),
            "merge" => await GetMergeCompletionsAsync(gitContext, parsedCommand, cancellationToken),
            "push" => await GetPushCompletionsAsync(gitContext, parsedCommand, cancellationToken),
            "pull" => await GetPullCompletionsAsync(gitContext, parsedCommand, cancellationToken),
            "status" => GetStatusCompletions(parsedCommand),
            "log" => await GetLogCompletionsAsync(gitContext, parsedCommand, cancellationToken),
            "diff" => await GetDiffCompletionsAsync(gitContext, parsedCommand, cancellationToken),
            _ => GetGenericParameterCompletions(parsedCommand.SubCommand)
        };
    }
    
    private async Task<CompletionResult[]> GetBranchCompletionsAsync(
        GitRepositoryContext gitContext,
        GitParsedCommand command,
        CancellationToken cancellationToken)
    {
        var completions = new List<CompletionResult>();
        
        // Add branch parameters
        if (command.NeedsParameter)
        {
            completions.AddRange(new[]
            {
                new CompletionResult("-a", "List both local and remote branches", CompletionType.Parameter),
                new CompletionResult("-r", "List remote branches only", CompletionType.Parameter),
                new CompletionResult("-d", "Delete branch", CompletionType.Parameter),
                new CompletionResult("-D", "Force delete branch", CompletionType.Parameter),
                new CompletionResult("-m", "Rename branch", CompletionType.Parameter),
                new CompletionResult("--merged", "List branches merged into HEAD", CompletionType.Parameter),
                new CompletionResult("--no-merged", "List branches not merged into HEAD", CompletionType.Parameter)
            });
        }
        
        // Add branch names based on context
        if (command.ExpectsBranchName)
        {
            // Local branches
            foreach (var branch in gitContext.LocalBranches)
            {
                completions.Add(new CompletionResult(
                    branch,
                    $"Local branch: {branch}",
                    CompletionType.Value,
                    branch == gitContext.CurrentBranch ? 100 : 50));
            }
            
            // Remote branches (if -a or -r specified)
            if (command.Parameters.Contains("-a") || command.Parameters.Contains("-r"))
            {
                foreach (var branch in gitContext.RemoteBranches)
                {
                    completions.Add(new CompletionResult(
                        branch,
                        $"Remote branch: {branch}",
                        CompletionType.Value,
                        30));
                }
            }
        }
        
        return completions.ToArray();
    }
}

/// <summary>
/// Git repository state analyzer
/// </summary>
public interface IGitRepositoryAnalyzer
{
    Task<GitRepositoryContext> AnalyzeCurrentRepositoryAsync(
        CancellationToken cancellationToken = default);
}

public sealed class GitRepositoryAnalyzer : IGitRepositoryAnalyzer
{
    private readonly ILogger<GitRepositoryAnalyzer> _logger;
    
    public GitRepositoryAnalyzer(ILogger<GitRepositoryAnalyzer> logger)
    {
        _logger = logger;
    }
    
    public async Task<GitRepositoryContext> AnalyzeCurrentRepositoryAsync(
        CancellationToken cancellationToken = default)
    {
        try
        {
            // Check if we're in a Git repository
            var isRepoResult = await SecureProcessExecutor.ExecuteAsync(
                "git", "rev-parse --is-inside-work-tree", 
                TimeSpan.FromSeconds(2), cancellationToken);
            
            if (isRepoResult.ExitCode != 0)
            {
                return GitRepositoryContext.NotARepository;
            }
            
            // Get current branch
            var branchResult = await SecureProcessExecutor.ExecuteAsync(
                "git", "branch --show-current",
                TimeSpan.FromSeconds(2), cancellationToken);
            
            var currentBranch = branchResult.ExitCode == 0 
                ? branchResult.Output.Trim() 
                : null;
            
            // Get all branches
            var branchesResult = await SecureProcessExecutor.ExecuteAsync(
                "git", "branch -a --format='%(refname:short)'",
                TimeSpan.FromSeconds(5), cancellationToken);
            
            var allBranches = branchesResult.ExitCode == 0
                ? branchesResult.Output.Split('\n', StringSplitOptions.RemoveEmptyEntries)
                : Array.Empty<string>();
            
            var localBranches = allBranches
                .Where(b => !b.StartsWith("origin/"))
                .ToArray();
            
            var remoteBranches = allBranches
                .Where(b => b.StartsWith("origin/"))
                .ToArray();
            
            // Get repository status
            var statusResult = await SecureProcessExecutor.ExecuteAsync(
                "git", "status --porcelain",
                TimeSpan.FromSeconds(3), cancellationToken);
            
            var status = ParseGitStatus(statusResult.Output);
            
            return new GitRepositoryContext(
                IsRepository: true,
                CurrentBranch: currentBranch,
                LocalBranches: localBranches,
                RemoteBranches: remoteBranches,
                Tags: await GetTagsAsync(cancellationToken),
                Remotes: await GetRemotesAsync(cancellationToken),
                Status: status);
        }
        catch (Exception ex)
        {
            _logger.LogWarning(ex, "Failed to analyze Git repository");
            return GitRepositoryContext.NotARepository;
        }
    }
}
```

---

## Dependency Injection Framework

### Service Registration Strategy

**Service Collection Extensions**:

```csharp
/// <summary>
/// Extension methods for registering PSPredictor services
/// </summary>
public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddPSPredictor(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        // Core engine services
        services.AddSingleton<IPredictionEngine, PredictionEngine>();
        services.AddSingleton<ICompletionProvider, CompletionProvider>();
        services.AddSingleton<ISyntaxHighlighter, SyntaxHighlighter>();
        services.AddSingleton<ICommandHistory, CommandHistory>();
        
        // AI services with conditional registration
        if (RuntimeInformation.ProcessArchitecture == Architecture.X64)
        {
            services.AddSingleton<IMLPredictionEngine, MLPredictionEngine>();
        }
        else
        {
            services.AddSingleton<IMLPredictionEngine, FallbackMLPredictionEngine>();
        }
        
        // Input and rendering services
        services.AddSingleton<IKeyHandler, KeyHandler>();
        services.AddSingleton<IANSIRenderer, ANSIRenderer>();
        services.AddSingleton<IMultiLineEditor, MultiLineEditor>();
        
        // Editing modes
        services.AddTransient<IEditingMode, CmdEditingMode>();
        services.AddTransient<IEditingMode, EmacsEditingMode>();
        services.AddTransient<IEditingMode, ViEditingMode>();
        
        // Kill ring for Emacs mode
        services.AddSingleton<IKillRing, KillRing>();
        
        // CLI tool completion providers
        RegisterCompletionProviders(services);
        
        // Configuration and caching
        services.Configure<PSPredictorOptions>(configuration.GetSection("PSPredictor"));
        services.AddMemoryCache();
        services.AddLogging();
        
        return services;
    }
    
    private static void RegisterCompletionProviders(IServiceCollection services)
    {
        // Version control
        services.AddTransient<ICliToolCompletion, GitCompletion>();
        services.AddTransient<ICliToolCompletion, SvnCompletion>();
        
        // Containerization
        services.AddTransient<ICliToolCompletion, DockerCompletion>();
        services.AddTransient<ICliToolCompletion, KubectlCompletion>();
        services.AddTransient<ICliToolCompletion, PodmanCompletion>();
        
        // Cloud platforms
        services.AddTransient<ICliToolCompletion, AzureCompletion>();
        services.AddTransient<ICliToolCompletion, AwsCompletion>();
        services.AddTransient<ICliToolCompletion, GcloudCompletion>();
        
        // Package managers
        services.AddTransient<ICliToolCompletion, NpmCompletion>();
        services.AddTransient<ICliToolCompletion, YarnCompletion>();
        services.AddTransient<ICliToolCompletion, PipCompletion>();
        services.AddTransient<ICliToolCompletion, DotnetCompletion>();
        
        // Shell and development tools
        services.AddTransient<ICliToolCompletion, PowerShellCompletion>();
        services.AddTransient<ICliToolCompletion, BashCompletion>();
        services.AddTransient<ICliToolCompletion, ZshCompletion>();
        services.AddTransient<ICliToolCompletion, VimCompletion>();
        
        // Repository analyzers
        services.AddSingleton<IGitRepositoryAnalyzer, GitRepositoryAnalyzer>();
    }
}

/// <summary>
/// Configuration options for PSPredictor
/// </summary>
public sealed class PSPredictorOptions
{
    public const string SectionName = "PSPredictor";
    
    public GeneralOptions General { get; set; } = new();
    public EditingOptions Editing { get; set; } = new();
    public AIOptions AI { get; set; } = new();
    public CompletionOptions Completion { get; set; } = new();
    public RenderingOptions Rendering { get; set; } = new();
    public PerformanceOptions Performance { get; set; } = new();
    
    public sealed class GeneralOptions
    {
        public bool EnablePrediction { get; set; } = true;
        public bool EnableSyntaxHighlighting { get; set; } = true;
        public bool EnableIntelliSense { get; set; } = true;
        public int MaxSuggestions { get; set; } = 10;
        public TimeSpan ResponseTimeout { get; set; } = TimeSpan.FromSeconds(5);
    }
    
    public sealed class EditingOptions
    {
        public EditingMode Mode { get; set; } = EditingMode.Emacs;
        public bool EnableMultiLine { get; set; } = true;
        public int HistorySize { get; set; } = 10000;
        public bool EnableFuzzyMatching { get; set; } = true;
    }
    
    public sealed class AIOptions
    {
        public bool EnableLocalModels { get; set; } = true;
        public bool EnableEnhancedModels { get; set; } = false;
        public ModelUpdatePolicy UpdatePolicy { get; set; } = ModelUpdatePolicy.Automatic;
        public double PredictionConfidenceThreshold { get; set; } = 0.7;
    }
}
```

### Service Lifetime Management

**Service Scope Strategy**:

- **Singleton**: Stateless services with expensive initialization (PredictionEngine, ML models)
- **Transient**: Lightweight services and completion providers
- **Scoped**: Per-session services (not applicable in PowerShell module context)

**Resource Management**:

- **IDisposable Pattern**: Proper cleanup of ML models, file handles, and caches
- **CancellationToken Support**: Graceful cancellation throughout the pipeline
- **Memory Pressure**: Automatic cache eviction and model unloading under memory pressure

---

## Configuration Architecture

### Hierarchical Configuration System

**Configuration Precedence (Highest to Lowest)**:

1. **Command-line Parameters**: Temporary overrides for testing
2. **Environment Variables**: Deployment-specific settings
3. **User Configuration**: `~/.pspredictor/config.json`
4. **Team Configuration**: Shared team settings
5. **Default Configuration**: Built-in defaults

**Configuration Loading Pipeline**:

```csharp
/// <summary>
/// Hierarchical configuration loading with validation
/// </summary>
public sealed class PSPredictorConfigurationManager : IPSPredictorConfiguration
{
    private readonly ILogger<PSPredictorConfigurationManager> _logger;
    private readonly FileSystemWatcher _configWatcher;
    private PSPredictorConfig _currentConfig;
    
    public PSPredictorConfig Current => _currentConfig;
    
    public event EventHandler<ConfigurationChangedEventArgs>? ConfigurationChanged;
    
    public PSPredictorConfigurationManager(ILogger<PSPredictorConfigurationManager> logger)
    {
        _logger = logger;
        _currentConfig = PSPredictorConfig.Default;
        
        // Watch for configuration file changes
        _configWatcher = CreateConfigurationWatcher();
    }
    
    public async Task LoadConfigurationAsync(CancellationToken cancellationToken = default)
    {
        var configBuilder = new ConfigurationBuilder();
        
        // 1. Start with defaults
        configBuilder.AddInMemoryCollection(GetDefaultConfiguration());
        
        // 2. Add team configuration if available
        var teamConfigPath = FindTeamConfigurationFile();
        if (teamConfigPath != null)
        {
            configBuilder.AddJsonFile(teamConfigPath, optional: true);
        }
        
        // 3. Add user configuration
        var userConfigPath = GetUserConfigurationPath();
        configBuilder.AddJsonFile(userConfigPath, optional: true);
        
        // 4. Add environment variables
        configBuilder.AddEnvironmentVariables("PSPREDICTOR_");
        
        // 5. Build and validate configuration
        var configuration = configBuilder.Build();
        var newConfig = configuration.Get<PSPredictorConfig>() ?? PSPredictorConfig.Default;
        
        var validationResult = ValidateConfiguration(newConfig);
        if (!validationResult.IsValid)
        {
            _logger.LogWarning("Configuration validation failed: {Errors}", 
                string.Join(", ", validationResult.Errors));
            
            // Use previous valid configuration
            return;
        }
        
        var previousConfig = _currentConfig;
        _currentConfig = newConfig;
        
        // Fire change event if configuration actually changed
        if (!ConfigurationEquals(previousConfig, newConfig))
        {
            ConfigurationChanged?.Invoke(this, new ConfigurationChangedEventArgs(previousConfig, newConfig));
        }
        
        _logger.LogInformation("Configuration loaded successfully");
    }
}
```

---

## Testing Framework

### Test Architecture Strategy

**Multi-Layer Testing Approach**:

1. **Unit Tests**: Fast, isolated component testing
2. **Integration Tests**: Cross-component interaction testing  
3. **Performance Tests**: Response time and memory validation
4. **Cross-Platform Tests**: Platform-specific behavior validation

**Test Organization**:

```text
tests/
├── PSPredictor.Tests/                 # Main unit tests
│   ├── Core/                          # Core engine tests
│   ├── AI/                            # ML.NET integration tests
│   ├── Input/                         # Input handling tests
│   ├── Rendering/                     # Console rendering tests
│   └── TestHelpers/                   # Shared test utilities
├── PSPredictor.Integration.Tests/     # Integration tests
├── PSPredictor.Performance.Tests/     # BenchmarkDotNet tests
└── PSPredictor.CrossPlatform.Tests/   # Platform-specific tests
```

**Test Base Classes**:

```csharp
/// <summary>
/// Base class for PSPredictor unit tests with common setup
/// </summary>
public abstract class PSPredictorTestBase
{
    protected IServiceProvider ServiceProvider { get; private set; }
    protected ITestOutputHelper Output { get; }
    
    protected PSPredictorTestBase(ITestOutputHelper output)
    {
        Output = output;
        ServiceProvider = CreateTestServiceProvider();
    }
    
    protected virtual IServiceProvider CreateTestServiceProvider()
    {
        var services = new ServiceCollection();
        
        // Add logging that outputs to test console
        services.AddLogging(builder => builder.AddXUnit(Output));
        
        // Add test-specific configurations
        var configuration = new ConfigurationBuilder()
            .AddInMemoryCollection(GetTestConfiguration())
            .Build();
        
        services.AddSingleton<IConfiguration>(configuration);
        
        // Add PSPredictor services with test overrides
        services.AddPSPredictor(configuration);
        
        // Override services for testing
        services.Replace(ServiceDescriptor.Singleton<IMLPredictionEngine, MockMLPredictionEngine>());
        
        return services.BuildServiceProvider();
    }
    
    protected T GetService<T>() where T : notnull => ServiceProvider.GetRequiredService<T>();
    
    protected virtual Dictionary<string, string?> GetTestConfiguration()
    {
        return new Dictionary<string, string?>
        {
            ["PSPredictor:General:EnablePrediction"] = "true",
            ["PSPredictor:AI:EnableLocalModels"] = "false", // Disable for faster tests
            ["PSPredictor:Performance:CacheSize"] = "100"
        };
    }
}
```

---

**Framework Version**: 2.0.0  
**Effective Date**: 2025-08-01  
**Architecture Review**: Per major release  
**Cross-Platform Compatibility**: Windows, Linux, macOS (x64/ARM64)
