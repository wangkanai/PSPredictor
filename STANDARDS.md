# STANDARDS.md - PSPredictor Development Standards

**Version**: 2.0.0  
**Last Updated**: 2025-07-31  
**Scope**: PSPredictor C# .NET 9.0 Binary Module

> **⚠️ Implementation Status**: Code examples in this document represent planned implementations for PSPredictor v2.0.
> These interfaces, classes, and methods are architectural specifications pending full implementation.

---

## Code Quality Standards

### Performance Requirements

**Response Time Targets**:

- **Completion Generation**: <50ms for standard completions
- **AI Prediction**: <100ms for ML-powered suggestions  
- **Syntax Highlighting**: <20ms for real-time coloring
- **Multi-line Rendering**: <30ms for complex command structures
- **Module Load Time**: <200ms for initial module import

**Memory Management**:

- **Startup Footprint**: <20MB initial memory usage
- **Runtime Footprint**: <50MB for typical usage patterns
- **Model Loading**: Lazy loading with <5MB core models
- **History Database**: SQLite with automatic cleanup, <10MB max size
- **Cache Limits**: LRU eviction with configurable memory thresholds

**Reliability Standards**:

- **Zero Crashes**: Graceful error handling for all user-facing operations
- **Error Recovery**: Automatic fallback to basic functionality on component failure
- **Cross-Platform**: Consistent behavior across Windows, Linux, macOS (x64/ARM64)
- **Backward Compatibility**: API stability within major versions

### Code Coverage Requirements

**Minimum Coverage Thresholds**:

- **Core Components**: 90% line coverage, 85% branch coverage
- **Cmdlets**: 85% line coverage, 80% branch coverage  
- **Completion Providers**: 80% line coverage, 75% branch coverage
- **Utilities**: 85% line coverage, 80% branch coverage
- **Overall Project**: 80% line coverage minimum

**Testing Categories**:

- **Unit Tests**: Fast, isolated, deterministic tests for individual components
- **Integration Tests**: Cross-component interaction testing
- **Performance Tests**: BenchmarkDotNet regression testing with CI/CD integration
- **Cross-Platform Tests**: Validation across all supported operating systems and architectures

---

## Coding Standards

### C# Language Standards

**Language Features (.NET 9.0, C# 13.0)**:

- **Required Features**: Use modern C# features (records, pattern matching, nullable reference types)
- **File-Scoped Namespaces**: Mandatory for all new files
- **Target-Typed New**: Prefer `new()` over explicit type specification where clarity maintained
- **Global Using**: Organize common imports in GlobalUsings.cs
- **Primary Constructors**: Use for simple data classes and dependency injection

**Code Style Guidelines**:

```csharp
// ✅ GOOD: Modern C# with clear intent
public sealed record CompletionResult(
    string Text,
    string Description,
    CompletionType Type = CompletionType.Command
);

public class GitCompletion(ILogger<GitCompletion> logger) : BaseCompletion
{
    private readonly ILogger<GitCompletion> _logger = logger;
    
    public async Task<CompletionResult[]> GetCompletionsAsync(
        CompletionContext context,
        CancellationToken cancellationToken = default)
    {
        return context.Command switch
        {
            "status" => await GetStatusCompletionsAsync(context, cancellationToken),
            "commit" => await GetCommitCompletionsAsync(context, cancellationToken),
            _ => []
        };
    }
}

// ❌ AVOID: Verbose, outdated patterns
public class GitCompletion : BaseCompletion
{
    private readonly ILogger<GitCompletion> _logger;
    
    public GitCompletion(ILogger<GitCompletion> logger)
    {
        _logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }
    
    public async Task<CompletionResult[]> GetCompletionsAsync(CompletionContext context, CancellationToken cancellationToken)
    {
        if (context.Command == "status")
        {
            return await GetStatusCompletionsAsync(context, cancellationToken);
        }
        else if (context.Command == "commit")
        {
            return await GetCommitCompletionsAsync(context, cancellationToken);
        }
        else
        {
            return new CompletionResult[0];
        }
    }
}
```

### Naming Conventions

**Classes and Methods**:

- **Classes**: PascalCase with descriptive names (`GitCompletionProvider`, `MLPredictionEngine`)
- **Methods**: PascalCase with verb-noun pattern (`GetCompletionsAsync`, `ValidateInput`)
- **Properties**: PascalCase (`MaxSuggestions`, `EnableFuzzyMatching`)
- **Fields**: camelCase with underscore prefix (`_logger`, `_cancellationToken`)
- **Constants**: PascalCase (`DefaultTimeout`, `MaxHistoryEntries`)

**Interfaces and Abstractions**:

- **Interfaces**: IPascalCase (`ICompletionProvider`, `IPredictionEngine`)
- **Abstract Classes**: PascalCase with "Base" prefix (`BaseCompletion`, `BaseCmdlet`)
- **Generic Type Parameters**: Single uppercase letter (`T`, `TResult`, `TContext`)

**Async Method Standards**:

- **Suffix**: All async methods must end with "Async"
- **Return Types**: `Task<T>` for value-returning, `Task` for void-returning
- **CancellationToken**: Always accept CancellationToken parameter with default value
- **ConfigureAwait**: Use `ConfigureAwait(false)` for library code

### Error Handling Standards

**Exception Management**:

```csharp
// ✅ GOOD: Specific exceptions with context
public async Task<CompletionResult[]> GetCompletionsAsync(CompletionContext context, CancellationToken cancellationToken = default)
{
    ArgumentNullException.ThrowIfNull(context);
    
    try
    {
        return await ProcessCompletionsAsync(context, cancellationToken);
    }
    catch (OperationCanceledException) when (cancellationToken.IsCancellationRequested)
    {
        _logger.LogDebug("Completion request cancelled for command: {Command}", context.Command);
        return [];
    }
    catch (Exception ex) when (ex is not PSPredictorException)
    {
        _logger.LogError(ex, "Unexpected error during completion for command: {Command}", context.Command);
        throw new PSPredictorException($"Completion failed for command '{context.Command}'", ex);
    }
}

// ❌ AVOID: Generic catch-all exception handling
public async Task<CompletionResult[]> GetCompletionsAsync(CompletionContext context, CancellationToken cancellationToken = default)
{
    try
    {
        return await ProcessCompletionsAsync(context, cancellationToken);
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Error: {ex.Message}");
        return new CompletionResult[0];
    }
}
```

**Logging Standards**:

- **Structured Logging**: Use structured logging with Microsoft.Extensions.Logging
- **Log Levels**: DEBUG (development), INFO (user actions), WARN (recoverable issues), ERROR (failures)
- **Performance Logging**: Log slow operations (>100ms) at DEBUG level
- **Sensitive Data**: Never log user input, credentials, or personal information

---

## Architecture Standards

### Dependency Injection

**Service Registration Pattern**:

```csharp
// Program.cs or ServiceCollectionExtensions.cs
public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddPSPredictor(this IServiceCollection services)
    {
        // Core services
        services.AddSingleton<IPredictionEngine, PredictionEngine>();
        services.AddSingleton<ICompletionProvider, CompletionProvider>();
        services.AddSingleton<ISyntaxHighlighter, SyntaxHighlighter>(); // TODO: Define interface in Core/Interfaces/
        
        // Completion providers
        services.AddTransient<GitCompletion>();
        services.AddTransient<DockerCompletion>();
        services.AddTransient<AzureCompletion>();
        
        // Configuration
        services.Configure<PSPredictorOptions>(options => { });
        
        return services;
    }
}
```

**Constructor Injection Requirements**:

- **Primary Constructor**: Use for simple dependency injection
- **Null Checks**: Use `ArgumentNullException.ThrowIfNull()` for .NET 9.0
- **Service Lifetime**: Singleton for stateless services, Transient for stateful operations

### Async/Await Standards

**Async Method Implementation**:

```csharp
// ✅ GOOD: Proper async implementation
public async Task<CompletionResult[]> GetGitStatusAsync(CancellationToken cancellationToken = default)
{
    using var process = new Process
    {
        StartInfo = new ProcessStartInfo
        {
            FileName = "git",
            Arguments = "status --porcelain",
            UseShellExecute = false,
            RedirectStandardOutput = true,
            CreateNoWindow = true
        }
    };
    
    process.Start();
    var output = await process.StandardOutput.ReadToEndAsync(cancellationToken);
    await process.WaitForExitAsync(cancellationToken);
    
    return ParseGitStatus(output);
}

// ❌ AVOID: Blocking async operations
public Task<CompletionResult[]> GetGitStatusAsync(CancellationToken cancellationToken = default)
{
    var process = Process.Start("git", "status --porcelain");
    var output = process.StandardOutput.ReadToEnd(); // Blocking!
    process.WaitForExit(); // Blocking!
    
    return Task.FromResult(ParseGitStatus(output));
}
```

### Resource Management

**IDisposable Pattern**:

- **using statements**: Prefer `using` declarations over `using` blocks where possible
- **async disposal**: Implement `IAsyncDisposable` for async resource cleanup
- **cancellation**: Always respect CancellationToken in long-running operations

**Memory Management**:

- **ArrayPool**: Use `ArrayPool<T>` for temporary large arrays
- **StringBuilder**: Use for string concatenation in loops
- **Span&lt;T&gt;/Memory&lt;T&gt;**: Use for high-performance buffer operations

---

## Testing Standards

### Unit Testing Framework

**xUnit v3 with FluentAssertions**:

```csharp
[Fact]
public async Task GetCompletionsAsync_WithValidGitCommand_ReturnsExpectedCompletions()
{
    // Arrange
    var logger = new Mock<ILogger<GitCompletion>>();
    var completion = new GitCompletion(logger.Object);
    var context = new CompletionContext("git", "status", 11);
    
    // Act
    var results = await completion.GetCompletionsAsync(context);
    
    // Assert
    results.Should().NotBeEmpty();
    results.Should().Contain(r => r.Text == "--porcelain");
    results.Should().AllSatisfy(r => r.Type.Should().Be(CompletionType.Parameter));
}

[Theory]
[InlineData("")]
[InlineData("   ")]
[InlineData(null)]
public async Task GetCompletionsAsync_WithInvalidInput_ThrowsArgumentException(string command)
{
    // Arrange
    var logger = new Mock<ILogger<GitCompletion>>();
    var completion = new GitCompletion(logger.Object);
    var context = new CompletionContext("git", command, 0);
    
    // Act & Assert
    await completion.Invoking(c => c.GetCompletionsAsync(context))
        .Should().ThrowAsync<ArgumentException>()
        .WithMessage("*command*");
}
```

**Test Organization**:

- **AAA Pattern**: Arrange, Act, Assert structure
- **Single Responsibility**: One logical assertion per test
- **Descriptive Names**: Test names should describe scenario and expected outcome
- **Theory vs Fact**: Use `[Theory]` for parameterized tests, `[Fact]` for single-case tests

### Performance Testing

**BenchmarkDotNet Standards**:

```csharp
[MemoryDiagnoser]
[SimpleJob(RuntimeMoniker.Net90)]
public class CompletionProviderBenchmarks
{
    private CompletionProvider _provider;
    private CompletionContext _context;
    
    [GlobalSetup]
    public void Setup()
    {
        _provider = new CompletionProvider();
        _context = new CompletionContext("git", "status", 11);
    }
    
    [Benchmark]
    public async Task<CompletionResult[]> GetCompletions()
    {
        return await _provider.GetCompletionsAsync(_context);
    }
    
    [Benchmark]
    [Arguments("git status")]
    [Arguments("docker run")]
    [Arguments("kubectl get")]
    public async Task<CompletionResult[]> GetCompletions_WithDifferentCommands(string command)
    {
        var context = CompletionContext.Parse(command);
        return await _provider.GetCompletionsAsync(context);
    }
}
```

**Performance Assertions**:

- **Response Time**: All completions must complete within target times
- **Memory Allocation**: Track and minimize allocations in hot paths
- **Throughput**: Measure operations per second for high-frequency operations

---

## Documentation Standards

### Code Documentation

**XML Documentation Requirements**:

```csharp
/// <summary>
/// Provides intelligent completion suggestions for Git commands with context awareness.
/// </summary>
/// <remarks>
/// This completion provider analyzes the current Git repository state and provides
/// contextually relevant suggestions for Git commands, parameters, and file paths.
/// </remarks>
public sealed class GitCompletion : BaseCompletion
{
    /// <summary>
    /// Gets completion suggestions for the specified Git command context.
    /// </summary>
    /// <param name="context">The completion context containing command and cursor position.</param>
    /// <param name="cancellationToken">Token to cancel the operation.</param>
    /// <returns>
    /// An array of completion results matching the current context, 
    /// or an empty array if no relevant completions are available.
    /// </returns>
    /// <exception cref="ArgumentNullException">Thrown when <paramref name="context"/> is null.</exception>
    /// <exception cref="PSPredictorException">Thrown when completion processing fails.</exception>
    public async Task<CompletionResult[]> GetCompletionsAsync(
        CompletionContext context, 
        CancellationToken cancellationToken = default)
    {
        // Implementation
    }
}
```

**README Standards**:

- **Clear Purpose**: What the component does and why it exists
- **Quick Start**: Minimal example to get started
- **API Reference**: Key methods and their usage
- **Performance Notes**: Important performance characteristics

### Architecture Documentation

**Decision Records**:

- **ADR Format**: Use Architecture Decision Record template
- **Context**: Why the decision was needed
- **Options**: Alternatives considered
- **Decision**: What was chosen and rationale
- **Consequences**: Trade-offs and implications

---

## Security Standards

### Input Validation

**Command Input Sanitization**:

```csharp
public static class InputValidator
{
    private static readonly Regex ValidCommandPattern = new(@"^[a-zA-Z0-9\s\-_.:/\\]+$", RegexOptions.Compiled);
    
    public static bool IsValidCommand(string command)
    {
        return !string.IsNullOrWhiteSpace(command) 
            && command.Length <= 1000 
            && ValidCommandPattern.IsMatch(command);
    }
    
    public static string SanitizeInput(string input)
    {
        ArgumentNullException.ThrowIfNull(input);
        
        // Use allowlist approach: only allow safe characters instead of removing dangerous ones
        // This preserves legitimate commands while blocking potentially harmful input
        return ValidCommandPattern.IsMatch(input) ? input : throw new ArgumentException("Invalid command format", nameof(input));
    }
}
```

**Process Execution Security**:

- **No Shell Execution**: Never use `UseShellExecute = true`
- **Argument Validation**: Validate all process arguments
- **Timeout Limits**: Always set process timeouts
- **Output Limits**: Limit output buffer sizes

### Data Protection

**Configuration Security**:

- **No Hardcoded Secrets**: Use configuration providers
- **Environment Variables**: For deployment-specific settings
- **User Directory**: Store user data in appropriate OS locations
- **Permissions**: Restrict file permissions appropriately

---

## Cross-Platform Standards

### Platform Compatibility

**Supported Platforms**:

- **Windows**: PowerShell 5.1+ and PowerShell Core 7+
- **Linux**: PowerShell Core 7+ (x64 and ARM64)
- **macOS**: PowerShell Core 7+ (Intel x64 and Apple Silicon ARM64)

**Platform-Specific Code**:

```csharp
public static class PlatformHelper
{
    public static bool IsWindows => RuntimeInformation.IsOSPlatform(OSPlatform.Windows);
    public static bool IsLinux => RuntimeInformation.IsOSPlatform(OSPlatform.Linux);
    public static bool IsMacOS => RuntimeInformation.IsOSPlatform(OSPlatform.OSX);
    public static bool IsArm64 => RuntimeInformation.ProcessArchitecture == Architecture.Arm64;
    
    public static string GetConfigurationDirectory()
    {
        return Environment.GetFolderPath(IsWindows 
            ? Environment.SpecialFolder.ApplicationData 
            : Environment.SpecialFolder.UserProfile);
    }
}
```

### Architecture Support

**ARM64 Compatibility**:

- **ML.NET Conditional**: ML features only on x64, graceful degradation on ARM64
- **Performance Testing**: Validate performance on both architectures
- **Build Targets**: Dynamic platform targeting based on runtime detection

**File System Standards**:

- **Path Separators**: Use `Path.Combine()` and `Path.DirectorySeparatorChar`
- **File Names**: Avoid reserved names and invalid characters
- **Case Sensitivity**: Assume case-sensitive file systems

---

## Quality Gates

### Build Pipeline Requirements

**Pre-Merge Checks**:

1. **Build Success**: All projects must build without errors
2. **Test Execution**: All tests must pass with required coverage
3. **Static Analysis**: Clean code analysis with zero critical issues
4. **Performance**: No regression in benchmark tests
5. **Security**: No new security vulnerabilities detected

**Release Criteria**:

1. **Functional Testing**: Manual testing of key scenarios
2. **Performance Validation**: Response time and memory requirements met
3. **Cross-Platform Testing**: Validation on Windows, Linux, macOS
4. **Documentation**: All public APIs documented
5. **Changelog**: Release notes and breaking changes documented

### Code Review Standards

**Review Checklist**:

- [ ] **Performance**: No obvious performance issues or anti-patterns
- [ ] **Security**: Input validation, no hardcoded secrets
- [ ] **Error Handling**: Appropriate exception handling and logging
- [ ] **Testing**: Adequate test coverage for new functionality
- [ ] **Documentation**: Public APIs documented, complex logic explained
- [ ] **Cross-Platform**: No platform-specific assumptions
- [ ] **Memory**: Proper resource disposal and memory management

**Review Process**:

- **Required Reviewers**: Minimum 1 reviewer for minor changes, 2 for major changes
- **Automated Checks**: All CI/CD checks must pass before review
- **Approval**: Explicit approval required from code owner
- **Merge Strategy**: Squash and merge for feature branches

---

**Standards Version**: 2.0.0  
**Effective Date**: 2025-08-01  
**Review Cycle**: Quarterly  
**Owner**: PSPredictor Development Team
