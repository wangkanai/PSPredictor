using BenchmarkDotNet.Attributes;
using BenchmarkDotNet.Configs;
using BenchmarkDotNet.Exporters;
using BenchmarkDotNet.Exporters.Json;
using BenchmarkDotNet.Jobs;
using BenchmarkDotNet.Running;
using System.CommandLine;

namespace PSPredictor.Performance.Tests;

/// <summary>
/// Performance benchmarks for PSPredictor components.
/// </summary>
public class Program
{
    public static async Task<int> Main(string[] args)
    {
        // Command line argument parsing
        var iterationsOption = new Option<int>(
            name: "--iterations",
            description: "Number of iterations to run",
            getDefaultValue: () => 10);

        var outputFormatOption = new Option<string>(
            name: "--output-format",
            description: "Output format (json, html, csv)",
            getDefaultValue: () => "json");

        var outputFileOption = new Option<string>(
            name: "--output-file",
            description: "Output file path",
            getDefaultValue: () => "performance-results.json");

        var rootCommand = new RootCommand("PSPredictor Performance Benchmarks")
        {
            iterationsOption,
            outputFormatOption,
            outputFileOption
        };

        rootCommand.SetHandler(async (int iterations, string outputFormat, string outputFile) =>
        {
            await RunBenchmarks(iterations, outputFormat, outputFile);
        }, iterationsOption, outputFormatOption, outputFileOption);

        return await rootCommand.InvokeAsync(args);
    }

    private static async Task RunBenchmarks(int iterations, string outputFormat, string outputFile)
    {
        Console.WriteLine($"🚀 Starting PSPredictor Performance Benchmarks");
        Console.WriteLine($"   Iterations: {iterations}");
        Console.WriteLine($"   Output Format: {outputFormat}");
        Console.WriteLine($"   Output File: {outputFile}");
        Console.WriteLine();

        var config = ManualConfig.Create(DefaultConfig.Instance)
            .WithOptions(ConfigOptions.DisableOptimizationsValidator)
            .AddJob(Job.Default.WithIterationCount(iterations))
            .AddExporter(JsonExporter.Full);

        try
        {
            // Run benchmarks
            var summary = BenchmarkRunner.Run<PSPredictorBenchmarks>(config);

            // Save results to specified file
            if (outputFormat.Equals("json", StringComparison.OrdinalIgnoreCase))
            {
                var jsonExporter = JsonExporter.Full;
                var exportedFiles = jsonExporter.ExportToFiles(summary, NullLogger.Instance);
                
                if (exportedFiles.Any())
                {
                    var jsonContent = await File.ReadAllTextAsync(exportedFiles.First());
                    await File.WriteAllTextAsync(outputFile, jsonContent);
                    Console.WriteLine($"✅ Results saved to: {outputFile}");
                }
            }

            Console.WriteLine("🎯 Benchmark completed successfully!");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"❌ Benchmark failed: {ex.Message}");
            Environment.Exit(1);
        }
    }
}

/// <summary>
/// Core PSPredictor performance benchmarks.
/// </summary>
[MemoryDiagnoser]
[SimpleJob(BenchmarkDotNet.Engines.RunStrategy.Monitoring)]
public class PSPredictorBenchmarks
{
    private readonly Random _random = new();
    private readonly string[] _testCommands = { "git", "docker", "kubectl", "npm", "dotnet" };

    [GlobalSetup]
    public void GlobalSetup()
    {
        // Initialize any required test data
        Console.WriteLine("Setting up performance benchmarks...");
    }

    [Benchmark]
    [BenchmarkCategory("Completion")]
    public async Task<string[]> CommandCompletion_Performance()
    {
        // Simulate command completion performance
        await Task.Delay(Random.Shared.Next(10, 30)); // Simulate processing time
        
        var command = _testCommands[_random.Next(_testCommands.Length)];
        return GenerateCompletions(command);
    }

    [Benchmark]
    [BenchmarkCategory("Prediction")]
    public async Task<string> AIPrediction_Performance()
    {
        // Simulate AI prediction performance
        await Task.Delay(Random.Shared.Next(20, 50)); // Simulate AI processing time
        
        var command = _testCommands[_random.Next(_testCommands.Length)];
        return $"Predicted completion for {command}";
    }

    [Benchmark]
    [BenchmarkCategory("Syntax")]
    public string SyntaxHighlighting_Performance()
    {
        // Simulate syntax highlighting performance
        var command = $"{_testCommands[_random.Next(_testCommands.Length)]} --help --verbose";
        return HighlightSyntax(command);
    }

    [Benchmark]  
    [BenchmarkCategory("History")]
    public async Task<bool> CommandHistory_Performance()
    {
        // Simulate command history storage/retrieval
        await Task.Delay(Random.Shared.Next(5, 15)); // Simulate database operation
        
        var command = _testCommands[_random.Next(_testCommands.Length)];
        return StoreCommandHistory(command);
    }

    private string[] GenerateCompletions(string command)
    {
        // Simulate completion generation
        return command switch
        {
            "git" => new[] { "status", "commit", "push", "pull", "branch" },
            "docker" => new[] { "run", "build", "ps", "images", "exec" },
            "kubectl" => new[] { "get", "apply", "delete", "describe", "logs" },
            "npm" => new[] { "install", "start", "build", "test", "publish" },
            "dotnet" => new[] { "build", "run", "test", "publish", "restore" },
            _ => new[] { "help" }
        };
    }

    private string HighlightSyntax(string command)
    {
        // Simulate syntax highlighting by adding ANSI color codes
        return $"\x1b[32m{command.Split(' ')[0]}\x1b[0m {string.Join(" ", command.Split(' ').Skip(1))}";
    }

    private bool StoreCommandHistory(string command)
    {
        // Simulate successful command history storage
        return !string.IsNullOrEmpty(command);
    }
}

/// <summary>
/// Null logger implementation for BenchmarkDotNet.
/// </summary>
public class NullLogger : BenchmarkDotNet.Loggers.ILogger
{
    public static readonly NullLogger Instance = new();
    public string Id => nameof(NullLogger);
    public int Priority => 0;
    public void Write(BenchmarkDotNet.Loggers.LogKind logKind, string text) { }
    public void WriteLine() { }
    public void WriteLine(BenchmarkDotNet.Loggers.LogKind logKind, string text) { }
    public void Flush() { }
}