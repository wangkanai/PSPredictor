# PSPredictor Troubleshooting Guide

Comprehensive guide for resolving common PSPredictor completion issues based on real-world debugging experiences.

---

## 🚨 **Common Issues & Solutions**

### 1. Tab Completions Not Working

#### **Symptom**: No completions appear when pressing Tab
```powershell
dotnet <TAB>    # Shows nothing or falls back to file completions
```

#### **Root Causes & Solutions**:

**A. PSPredictor Not Installed/Activated**
```powershell
# Check if module is loaded
Get-Module PSPredictor

# If not loaded, install and activate
Import-Module PSPredictor
Install-PSPredictor
```

**B. PSReadLine MenuComplete Conflict**
```powershell
# Check current Tab handler
Get-PSReadLineKeyHandler | Where-Object Key -eq 'Tab'

# If shows MenuComplete, fix it:
Set-PSReadLineKeyHandler -Chord Tab -Function Complete
```

**C. Missing -Native Parameter**
- **Issue**: Completion provider uses wrong parameter signature
- **Fix**: Ensure external CLI completers use `-Native` parameter:
```powershell
Register-ArgumentCompleter -Native -CommandName 'dotnet' -ScriptBlock $ScriptBlock
```

### 2. History Showing Below Completions

#### **Symptom**: Command history appears below tab completions
```powershell
dotnet <TAB>
new        build      run        # <-- Completions (good)
> dotnet restore              # <-- History (unwanted)
> dotnet build                # <-- More history
```

#### **Root Cause**: PSReadLine PredictionViewStyle set to ListView

#### **Solutions**:

**Option A: InlineView (Recommended)**
```powershell
Set-PSReadLineOption -PredictionViewStyle InlineView
```

**Option B: Disable History Predictions**
```powershell
Set-PSReadLineOption -PredictionSource Plugin
```

**Option C: Smart Profile Configuration**
```powershell
# In your PowerShell profile
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle InlineView
Set-PSReadLineKeyHandler -Chord Tab -Function Complete
```

### 3. Subcommand Completions Not Working

#### **Symptom**: Subcommands show main commands instead of sub-options
```powershell
dotnet add <TAB>    # Shows: new, build, run (wrong)
                    # Should show: package, reference (correct)
```

#### **Root Causes**:

**A. Incorrect Word Count Logic**
```powershell
# Problem: Using > instead of >=
if ($words.Count -gt 2) {

# Solution: Handle both cases
if ($words.Count -ge 2) {
```

**B. Wrong Completion Detection Logic**
```powershell
# Problem: Not detecting subcommand context correctly
if ($words.Count -le 2) {
    # Show main commands
}

# Solution: Better context detection
if ($words.Count -eq 1 -or ($words.Count -eq 2 -and $words[1] -like "$wordToComplete*")) {
    # Show main commands
} else {
    # Show subcommands
}
```

### 4. Stub Function Conflicts

#### **Symptom**: Verbose message shows "stub not implemented"
```powershell
Register-PSPredictorCompletion -Tool dotnet -Verbose
# Output: "Dotnet CLI completion stub - not implemented"
```

#### **Root Cause**: Stub functions in `Stubs.ps1` override real implementations

#### **Solution**: Remove conflicting stubs
```powershell
# Remove from src/Completions/Stubs.ps1:
function Register-DotnetCompletion { 
    Write-Verbose "Dotnet CLI completion stub - not implemented"
}
```

### 5. Module Loading Issues

#### **Symptom**: Completions work in testing but not in profile
```powershell
# Works:
Import-Module PSPredictor -Force
Install-PSPredictor

# Doesn't work in profile automatically
```

#### **Root Cause**: Missing `Install-PSPredictor` in profile

#### **Solution**: Add activation to profile
```powershell
# In PowerShell profile:
Import-Module PSPredictor
Install-PSPredictor
```

### 6. Multiple Tab Handler Edge Case

#### **Symptom**: Install-PSPredictor fails to detect MenuComplete when multiple handlers exist

#### **Root Cause**: Multiple Tab handlers return an array, breaking single-object comparison
```powershell
# Problem: This fails when $currentHandler is an array
if ($currentHandler.Function -eq 'MenuComplete') {

# Solution: Use Where-Object to handle arrays
if ($currentHandler | Where-Object { $_.Function -eq 'MenuComplete' }) {
```

#### **Detection**: Check for multiple handlers
```powershell
$tabHandlers = Get-PSReadLineKeyHandler | Where-Object { $_.Key -eq 'Tab' }
if ($tabHandlers.Count -gt 1) {
    Write-Warning "Multiple Tab handlers detected: $($tabHandlers.Function -join ', ')"
}
```

---

## 🔧 **Debugging Techniques**

### 1. Test Completions Programmatically

```powershell
# Test if completions are working
$completions = TabExpansion2 'dotnet ' 7
$completions.CompletionMatches | Select-Object CompletionText

# Should show: new, build, run, test, etc.
# If shows files/directories, completions aren't working
```

### 2. Check Argument Completer Registration

```powershell
# PowerShell 7+ (may not work in all versions)
Get-ArgumentCompleter | Where-Object CommandName -eq 'dotnet'

# Alternative: Check if function exists
Get-Command Register-DotnetCompletion -ErrorAction SilentlyContinue
```

### 3. Debug Completion Parameters

Add debug output to completion script blocks:
```powershell
$ScriptBlock = {
    param($wordToComplete, $commandAst, $cursorPosition)
    
    # Debug output
    Write-Host "Debug: wordToComplete='$wordToComplete'" -ForegroundColor Yellow
    Write-Host "Debug: commandAst='$($commandAst.ToString())'" -ForegroundColor Yellow
    Write-Host "Debug: cursorPosition=$cursorPosition" -ForegroundColor Yellow
    
    # Your completion logic here...
}
```

### 4. Verify PSReadLine Configuration

```powershell
# Check all PSReadLine settings
Get-PSReadLineOption | Select-Object PredictionSource, PredictionViewStyle, EditMode

# Check key handlers
Get-PSReadLineKeyHandler | Where-Object Key -in @('Tab', 'Shift+Tab')

# Expected optimal settings:
# PredictionSource: HistoryAndPlugin
# PredictionViewStyle: InlineView  
# Tab: Complete
```

### 5. Module and Function Verification

```powershell
# Verify module loading
Get-Module PSPredictor | Select-Object Name, Version, ExportedFunctions

# Check if completion functions are loaded
Get-Command Register-*Completion | Select-Object Name, Source

# Verify tool registration
Get-PSPredictorTools | Where-Object Name -in @('dotnet', 'claude')
```

---

## 📋 **Diagnostic Checklist**

### Basic Functionality Check
- [ ] PSPredictor module loaded: `Get-Module PSPredictor`
- [ ] Completions installed: `Install-PSPredictor` executed
- [ ] Tab handler correct: `Get-PSReadLineKeyHandler | Where Key -eq 'Tab'`
- [ ] Programmatic test works: `TabExpansion2 'dotnet ' 7`

### Advanced Configuration Check
- [ ] No stub conflicts: Search for stub functions in module
- [ ] PSReadLine optimal: `InlineView` + `HistoryAndPlugin`
- [ ] Profile activation: `Install-PSPredictor` in profile
- [ ] Native completers: `-Native` parameter used for external tools

### Specific Tool Testing
- [ ] Main commands: `dotnet <TAB>` shows new, build, run
- [ ] Subcommands: `dotnet new <TAB>` shows templates
- [ ] Sub-subcommands: `dotnet add <TAB>` shows package, reference
- [ ] Options: `dotnet build <TAB>` shows --configuration, --framework

---

## 🛠️ **Configuration Templates**

### Optimal PowerShell Profile Configuration

```powershell
# PowerShell Profile Template for PSPredictor
# Location: ~/.config/powershell/Microsoft.PowerShell_profile.ps1

# Import required modules
Import-Module PSReadLine
Import-Module PSPredictor

# Configure PSReadLine for optimal completion experience
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle InlineView
Set-PSReadLineOption -EditMode Windows

# Set up completion handlers
Set-PSReadLineKeyHandler -Chord Tab -Function Complete
Set-PSReadLineKeyHandler -Chord Shift+Tab -Function MenuComplete

# Configure history
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -MaximumHistoryCount 10000
Set-PSReadLineOption -HistorySaveStyle SaveIncrementally

# Activate PSPredictor
Install-PSPredictor

# Optional: Configure predictive IntelliSense
Set-PSReadLineOption -ShowToolTips
```

### Completion Provider Template

```powershell
# Template for new completion providers
function Register-{ToolName}Completion {
    $ScriptBlock = {
        param($wordToComplete, $commandAst, $cursorPosition)
        
        $completions = @()
        
        # Parse command context
        $commandLine = $commandAst.ToString()
        $words = $commandLine -split '\s+' | Where-Object { $_ -ne '' }
        
        # Main command completion
        if ($words.Count -eq 1 -or ($words.Count -eq 2 -and $words[1] -like "$wordToComplete*")) {
            $mainCommands = @('command1', 'command2', 'command3')
            $completions += $mainCommands | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { 
                    [System.Management.Automation.CompletionResult]::new(
                        $_, $_, 'ParameterValue', "Description of $_"
                    )
                }
        }
        # Subcommand completion
        else {
            $subCommand = $words[1]
            switch ($subCommand) {
                'command1' {
                    # Handle command1 subcommands/options
                }
                'command2' {
                    # Handle command2 subcommands/options
                }
            }
        }
        
        return $completions
    }
    
    Register-ArgumentCompleter -Native -CommandName '{toolname}' -ScriptBlock $ScriptBlock
}
```

---

## 🚀 **Performance Optimization**

### Completion Response Time Targets
- **Target**: < 100ms for most completions
- **Maximum**: < 500ms for complex completions
- **Timeout**: 2 seconds for network-dependent completions

### Optimization Techniques

#### 1. Caching Strategies
```powershell
# Cache expensive operations
$script:PackageCache = @{}
if (-not $script:PackageCache.ContainsKey($query)) {
    $script:PackageCache[$query] = Get-ExpensiveData $query
}
```

#### 2. Early Returns
```powershell
# Return early for invalid contexts
if ($words.Count -eq 0 -or $words[0] -ne 'expected-command') {
    return @()
}
```

#### 3. Limit Results
```powershell
# Limit completion results to prevent overwhelming UI
$completions | Select-Object -First 50
```

---

## 📞 **Getting Help**

### Self-Help Resources
1. **This troubleshooting guide** - Common issues and solutions
2. **TASKS.md** - Known issues and planned improvements
3. **Test your setup** - Use diagnostic commands above

### Reporting Issues
When reporting issues, include:
- **PowerShell version**: `$PSVersionTable.PSVersion`
- **PSPredictor version**: `Get-Module PSPredictor | Select-Object Version`
- **PSReadLine settings**: `Get-PSReadLineOption`
- **Specific commands that fail**: Exact tab completion sequences
- **Debug output**: Use debug techniques from this guide

### Community Support
- **GitHub Issues**: [PSPredictor Issues](https://github.com/wangkanai/PSPredictor/issues)
- **PowerShell Gallery**: Package management and installation issues
- **Documentation**: Comprehensive guides and examples

---

**Last Updated**: 2025-07-30  
**Version**: 1.2.0  
**Status**: Living document - updated as new issues are discovered and resolved