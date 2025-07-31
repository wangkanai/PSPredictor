# PSPredictor Configuration Guide

## 📋 Table of Contents

- [Basic Configuration](#basic-configuration)
- [Advanced Settings](#advanced-settings)
- [Profile Management](#profile-management)
- [Customization](#customization)
- [Configuration Reference](#configuration-reference)
- [Troubleshooting Configuration](#troubleshooting-configuration)

---

## Basic Configuration

### Quick Setup

**Initial Configuration:**
```powershell
# Enable PSPredictor with default settings
Enable-PSPredictor

# Set preferred editing mode
Set-PSPredictorMode -EditingMode Emacs  # Options: Cmd, Emacs, Vi

# Configure completion behavior
Set-PSPredictorCompletion -MaxSuggestions 10 -EnableFuzzyMatching $true

# Enable syntax highlighting
Enable-PSPredictorSyntaxHighlighting
```

### Essential Settings

**Core Configuration:**
```powershell
# AI prediction settings
Set-PSPredictorAI -EnableLocalModels $true -PredictionAccuracy "Balanced"

# History management
Set-PSPredictorHistory -MaxEntries 10000 -EnablePersistence $true

# Performance tuning
Set-PSPredictorPerformance -ResponseTimeout 100 -CacheSize 1000
```

**View Current Configuration:**
```powershell
# Display current settings
Get-PSPredictorConfig

# Show specific configuration sections
Get-PSPredictorConfig -Section "AI"
Get-PSPredictorConfig -Section "Completion"
Get-PSPredictorConfig -Section "Display"

# Export current configuration
Export-PSPredictorConfig -Path "./current-config.json"
```

---

## Advanced Settings

### AI and Machine Learning

**AI Prediction Engine Configuration:**
```powershell
# Configure AI prediction engine
Set-PSPredictorAI -Settings @{
    EnableLocalModels = $true
    EnableCloudModels = $false
    PredictionAccuracy = "High"        # Low, Balanced, High
    ModelUpdateFrequency = "Weekly"    # Never, Daily, Weekly, Monthly
    ContextWindowSize = 50             # Number of recent commands to consider
    MinConfidenceThreshold = 0.7       # Minimum prediction confidence (0.0-1.0)
}

# Model management
Update-PSPredictorModels -Force
Get-PSPredictorModelInfo | Format-Table

# AI learning configuration
Set-PSPredictorLearning -Settings @{
    EnableLearning = $true
    LearningRate = 0.1
    MaxLearningHistory = 10000
    PrivacyMode = "Local"              # Local, Anonymous, Disabled
}
```

### Completion Provider Configuration

**Configure Specific CLI Tools:**
```powershell
# Configure Git provider
Set-PSPredictorProvider -Name "Git" -Settings @{
    EnableBranchCompletion = $true
    EnableFileCompletion = $true
    EnableRemoteCompletion = $true
    MaxHistoryItems = 100
    CacheTimeout = "5m"
    ShowCommitHashes = $true
}

# Configure Docker provider
Set-PSPredictorProvider -Name "Docker" -Settings @{
    EnableImageCompletion = $true
    EnableContainerCompletion = $true
    EnableNetworkCompletion = $true
    RegistryEndpoints = @("docker.io", "gcr.io", "quay.io")
    MaxCachedImages = 500
}

# Configure Kubernetes provider
Set-PSPredictorProvider -Name "Kubernetes" -Settings @{
    EnableResourceCompletion = $true
    EnableNamespaceCompletion = $true
    ContextTimeout = "30s"
    MaxResources = 1000
}

# Configure Azure CLI provider
Set-PSPredictorProvider -Name "Azure" -Settings @{
    EnableSubscriptionCompletion = $true
    EnableResourceGroupCompletion = $true
    CacheSubscriptionData = $true
    SubscriptionCacheTimeout = "1h"
}

# Disable specific providers
Disable-PSPredictorProvider -Name "Kubernetes"

# Custom provider registration
Register-PSPredictorProvider -Path "./MyCustomProvider.dll"
```

### Rendering and Display

**Syntax Highlighting Configuration:**
```powershell
# Syntax highlighting configuration
Set-PSPredictorSyntaxHighlighting -Settings @{
    EnableRealTimeHighlighting = $true
    ColorScheme = "VSCode"             # VSCode, Monokai, Solarized, Custom
    HighlightErrors = $true
    HighlightWarnings = $true
    HighlightKeywords = $true
    HighlightStrings = $true
    HighlightComments = $true
    CustomColors = @{
        Command = "Cyan"
        Parameter = "Yellow"
        String = "Green"
        Variable = "Magenta"
        Comment = "Gray"
        Error = "Red"
        Warning = "Orange"
        Keyword = "Blue"
    }
}

# IntelliSense display settings
Set-PSPredictorIntelliSense -Settings @{
    MaxVisibleItems = 10
    ShowDescriptions = $true
    ShowKeyBindings = $true
    ShowTooltips = $true
    AutoSelectFirst = $false
    TriggerCharacters = @(".", "-", " ", "/")
    CompletionTimeout = "500ms"
}
```

### Performance and Memory Management

**Performance Optimization:**
```powershell
# Performance configuration
Set-PSPredictorPerformance -Settings @{
    ResponseTimeout = 100              # Max response time in milliseconds
    CacheSize = 1000                   # Number of cached items
    MaxMemoryUsage = "50MB"            # Maximum memory usage
    EnableLazyLoading = $true
    PreloadCommonProviders = $true
    OptimizeForSpeed = $true           # vs OptimizeForMemory
}

# Cache management
Set-PSPredictorCache -Settings @{
    CompletionCacheSize = 500
    AIPredictionCacheSize = 200
    HistoryCacheSize = 1000
    CacheTimeout = "15m"
    AutoCleanup = $true
    CleanupInterval = "1h"
}

# Memory management
Set-PSPredictorMemory -Settings @{
    MaxMemoryUsage = "50MB"
    GarbageCollectionMode = "Balanced"  # Aggressive, Balanced, Conservative
    EnableMemoryProfiling = $false
    MemoryWarningThreshold = "40MB"
}
```

---

## Profile Management

### Creating Profiles

**Profile Creation:**
```powershell
# Create profile from current settings
New-PSPredictorProfile -Name "MyProfile" -Description "Custom development setup"

# Create profile with specific settings
New-PSPredictorProfile -Name "MinimalSetup" -Settings @{
    EditingMode = "Cmd"
    EnableAI = $false
    EnableSyntaxHighlighting = $false
    MaxCompletions = 5
    EnabledProviders = @("Git", "PowerShell")
}

# Create specialized profiles
New-PSPredictorProfile -Name "Developer" -Settings @{
    EditingMode = "Emacs"
    EnableAI = $true
    PredictionAccuracy = "High"
    EnabledProviders = @("Git", "Docker", "Kubernetes", "Azure", "npm")
    SyntaxHighlighting = $true
    ColorScheme = "VSCode"
}

New-PSPredictorProfile -Name "SysAdmin" -Settings @{
    EditingMode = "Vi"
    EnableAI = $true
    PredictionAccuracy = "Balanced"
    EnabledProviders = @("PowerShell", "Azure", "systemctl", "ssh")
    MaxCompletions = 15
}

# Clone existing profile
Copy-PSPredictorProfile -Source "Default" -Destination "MyCustomProfile"
```

### Managing Profiles

**Profile Operations:**
```powershell
# List available profiles
Get-PSPredictorProfile | Format-Table

# Get detailed profile information
Get-PSPredictorProfile -Name "Developer" -Detailed

# Switch to profile
Set-PSPredictorProfile -Name "MyProfile"

# Import/export profiles
Export-PSPredictorProfile -Name "MyProfile" -Path "./my-profile.json"
Import-PSPredictorProfile -Path "./my-profile.json"

# Set profile as default
Set-PSPredictorProfile -Name "MyProfile" -SetAsDefault

# Remove profile
Remove-PSPredictorProfile -Name "OldProfile" -Confirm:$false

# Reset profile to defaults
Reset-PSPredictorProfile -Name "MyProfile"
```

### Team Configuration

**Team and Enterprise Settings:**
```powershell
# Export team configuration
Export-PSPredictorConfig -Path "./team-config.json" -IncludeProfiles

# Import team configuration
Import-PSPredictorConfig -Path "./team-config.json" -Merge

# Lock configuration for consistency
Lock-PSPredictorConfig -Settings @("EditingMode", "SyntaxHighlighting", "EnabledProviders")

# Create organization-wide profile
New-PSPredictorProfile -Name "CompanyStandard" -Settings @{
    EditingMode = "Cmd"
    EnableAI = $true
    PredictionAccuracy = "Balanced"
    EnabledProviders = @("Git", "Azure", "PowerShell")
    DisallowCustomization = $true
}

# Deploy configuration to multiple machines
Deploy-PSPredictorConfig -ConfigPath "./company-config.json" -Targets @("Server1", "Server2")
```

---

## Customization

### Key Bindings

**Custom Key Bindings:**
```powershell
# Set custom key bindings
Set-PSPredictorKeyBinding -Key "Ctrl+Space" -Function "TriggerIntelliSense"
Set-PSPredictorKeyBinding -Key "Alt+?" -Function "ShowDynamicHelp"
Set-PSPredictorKeyBinding -Key "Ctrl+Shift+P" -Function "ShowProviders"
Set-PSPredictorKeyBinding -Key "F12" -Function "ShowConfiguration"

# Create custom macros
New-PSPredictorMacro -Name "GitStatus" -Keys "g", "s" -Command "git status"
New-PSPredictorMacro -Name "DockerPS" -Keys "d", "p" -Command "docker ps"
New-PSPredictorMacro -Name "QuickCommit" -Keys "g", "c" -Command "git add . && git commit -m"

# Emacs-style bindings
Set-PSPredictorKeyBinding -Key "Ctrl+A" -Function "BeginningOfLine"
Set-PSPredictorKeyBinding -Key "Ctrl+E" -Function "EndOfLine"
Set-PSPredictorKeyBinding -Key "Alt+F" -Function "ForwardWord"
Set-PSPredictorKeyBinding -Key "Alt+B" -Function "BackwardWord"
Set-PSPredictorKeyBinding -Key "Ctrl+K" -Function "KillToEndOfLine"
Set-PSPredictorKeyBinding -Key "Ctrl+Y" -Function "Yank"

# Vi-style bindings (in Vi mode)
Set-PSPredictorKeyBinding -Key "Escape" -Function "EnterCommandMode"
Set-PSPredictorKeyBinding -Key "i" -Function "EnterInsertMode"
Set-PSPredictorKeyBinding -Key "A" -Function "AppendAtEndOfLine"
Set-PSPredictorKeyBinding -Key "o" -Function "OpenNewLineBelow"

# List current key bindings
Get-PSPredictorKeyBinding | Format-Table
```

### Custom Themes

**Theme Creation and Management:**
```powershell
# Create custom color theme
New-PSPredictorTheme -Name "MyTheme" -Colors @{
    Command = "#569CD6"
    Parameter = "#DCDCAA"
    String = "#CE9178"
    Variable = "#9CDCFE"
    Comment = "#6A9955"
    Error = "#F44747"
    Warning = "#FFCC02"
    Keyword = "#C586C0"
    Operator = "#D4D4D4"
    Number = "#B5CEA8"
}

# Create theme based on popular color schemes
New-PSPredictorTheme -Name "MonokaiPro" -BaseTheme "Monokai" -Modifications @{
    Background = "#2D2A2E"
    Foreground = "#FCFCFA"
    Command = "#78DCE8"
    String = "#FFD866"
    Error = "#FF6188"
}

# Apply custom theme
Set-PSPredictorTheme -Name "MyTheme"

# List available themes
Get-PSPredictorTheme | Format-Table

# Export/import themes
Export-PSPredictorTheme -Name "MyTheme" -Path "./my-theme.json"
Import-PSPredictorTheme -Path "./my-theme.json"

# Reset to default theme
Set-PSPredictorTheme -Name "Default"
```

### Environment-Specific Configuration

**Dynamic Environment Configuration:**
```powershell
# Development environment
Set-PSPredictorEnvironment -Name "Development" -Settings @{
    EnableDebugLogging = $true
    ResponseTimeout = 200
    EnableAllProviders = $true
    LogLevel = "Debug"
    ShowPerformanceMetrics = $true
}

# Production environment
Set-PSPredictorEnvironment -Name "Production" -Settings @{
    EnableDebugLogging = $false
    ResponseTimeout = 50
    DisableCloudFeatures = $true
    LogLevel = "Error"
    OptimizeForPerformance = $true
}

# Testing environment
Set-PSPredictorEnvironment -Name "Testing" -Settings @{
    EnableDebugLogging = $true
    MockExternalCalls = $true
    EnableTestingProviders = $true
    DisableNetworkRequests = $true
}

# Automatic environment detection
Enable-PSPredictorAutoEnvironment -Rules @{
    Development = { (Get-Location).Path -like "*\dev\*" }
    Production = { $env:COMPUTERNAME -like "PROD-*" }
    Testing = { $env:PSPredictorTestMode -eq "true" }
}

# Manual environment switching
Set-PSPredictorEnvironment -Name "Development"
Get-PSPredictorEnvironment
```

---

## Configuration Reference

### Configuration File Locations

**Configuration Storage:**
```powershell
# Default configuration locations
$UserConfigPath = "$env:USERPROFILE\.pspredict\config.json"         # Windows
$UserConfigPath = "$env:HOME/.pspredict/config.json"               # Linux/macOS

$SystemConfigPath = "$env:ProgramData\PSPredictor\config.json"     # Windows
$SystemConfigPath = "/etc/pspredict/config.json"                   # Linux/macOS

# Profile locations
$ProfilePath = "$env:USERPROFILE\.pspredict\profiles\"             # Windows
$ProfilePath = "$env:HOME/.pspredict/profiles/"                    # Linux/macOS

# View configuration file paths
Get-PSPredictorConfigPath
```

### Configuration Schema

**Complete Configuration Structure:**
```json
{
  "version": "2.0.0",
  "general": {
    "enabled": true,
    "editingMode": "Emacs",
    "autoUpdate": true,
    "telemetry": false
  },
  "ai": {
    "enableLocalModels": true,
    "enableCloudModels": false,
    "predictionAccuracy": "Balanced",
    "modelUpdateFrequency": "Weekly",
    "contextWindowSize": 50,
    "minConfidenceThreshold": 0.7
  },
  "completion": {
    "maxSuggestions": 10,
    "enableFuzzyMatching": true,
    "caseSensitive": false,
    "enableContextAware": true,
    "triggerCharacters": [".", "-", " ", "/"]
  },
  "providers": {
    "git": {
      "enabled": true,
      "enableBranchCompletion": true,
      "enableFileCompletion": true,
      "maxHistoryItems": 100,
      "cacheTimeout": "5m"
    },
    "docker": {
      "enabled": true,
      "enableImageCompletion": true,
      "enableContainerCompletion": true,
      "registryEndpoints": ["docker.io", "gcr.io"]
    }
  },
  "display": {
    "syntaxHighlighting": {
      "enabled": true,
      "colorScheme": "VSCode",
      "highlightErrors": true,
      "highlightWarnings": true
    },
    "intellisense": {
      "maxVisibleItems": 10,
      "showDescriptions": true,
      "showKeyBindings": true,
      "autoSelectFirst": false
    }
  },
  "performance": {
    "responseTimeout": 100,
    "cacheSize": 1000,
    "maxMemoryUsage": "50MB",
    "enableLazyLoading": true
  }
}
```

### Environment Variables

**Configuration via Environment Variables:**
```bash
# Enable/disable PSPredictor
export PSPREDICT_ENABLED=true

# Set editing mode
export PSPREDICT_EDITING_MODE=Emacs

# Configure AI settings
export PSPREDICT_AI_ENABLED=true
export PSPREDICT_AI_ACCURACY=High

# Performance settings
export PSPREDICT_RESPONSE_TIMEOUT=100
export PSPREDICT_CACHE_SIZE=1000

# Provider settings
export PSPREDICT_PROVIDERS_ENABLED="Git,Docker,PowerShell"
export PSPREDICT_PROVIDERS_DISABLED="Kubernetes"

# Debug settings
export PSPREDICT_DEBUG=true
export PSPREDICT_LOG_LEVEL=Debug
```

---

## Troubleshooting Configuration

### Common Configuration Issues

**Issue: Configuration not loading**
```powershell
# Check configuration file exists and is valid
Test-PSPredictorConfigFile

# Validate configuration schema
Test-PSPredictorConfigSchema -Path "./config.json"

# Reset to default configuration
Reset-PSPredictorConfig -ResetAll

# Repair corrupted configuration
Repair-PSPredictorConfig -BackupCurrent
```

**Issue: Profile not switching**
```powershell
# Check profile exists
Get-PSPredictorProfile -Name "MyProfile"

# Validate profile configuration
Test-PSPredictorProfile -Name "MyProfile"

# Force profile reload
Set-PSPredictorProfile -Name "MyProfile" -Force

# Clear profile cache
Clear-PSPredictorProfileCache
```

**Issue: Provider settings not applying**
```powershell
# Check provider is enabled
Get-PSPredictorProvider -Name "Git" | Select-Object Enabled, Settings

# Reload provider configuration
Restart-PSPredictorProvider -Name "Git"

# Reset provider to defaults
Reset-PSPredictorProvider -Name "Git"

# Validate provider settings
Test-PSPredictorProviderSettings -Name "Git"
```

### Configuration Debugging

**Debug Configuration Loading:**
```powershell
# Enable configuration debugging
Enable-PSPredictorConfigDebug

# View configuration load process
Get-PSPredictorConfigLoadTrace

# Check configuration merge process
Get-PSPredictorConfigMergeTrace

# Disable configuration debugging
Disable-PSPredictorConfigDebug
```

**Configuration Validation:**
```powershell
# Validate entire configuration
Test-PSPredictorConfig -Detailed

# Validate specific sections
Test-PSPredictorConfig -Section "AI"
Test-PSPredictorConfig -Section "Providers"

# Check for configuration conflicts
Get-PSPredictorConfigConflicts

# Generate configuration report
New-PSPredictorConfigReport -OutputPath "./config-report.html"
```

### Getting Help

**Configuration Help:**
```powershell
# Get help for configuration cmdlets
Get-Help Set-PSPredictorConfig -Full
Get-Help New-PSPredictorProfile -Examples

# Show configuration examples
Show-PSPredictorConfigExamples

# Get configuration documentation
Get-PSPredictorConfigDocumentation

# Open configuration editor
Open-PSPredictorConfigEditor
```

---

*For more information, see the [main documentation](readme.md) or visit the [GitHub repository](https://github.com/wangkanai/PSPredictor).*