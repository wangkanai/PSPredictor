# Contributing to PSPredictor

🎉 Thank you for your interest in contributing to PSPredictor! We welcome contributions from the community to make this PowerShell module even better.

## 🚀 Ways to Contribute

- **🐛 Bug Reports**: Report issues you encounter
- **💡 Feature Requests**: Suggest new CLI tools or features
- **📝 Documentation**: Improve docs, examples, or README
- **🔧 Code**: Add completions for new tools or improve existing ones
- **🧪 Testing**: Help test the module on different platforms

## 🛠️ Development Setup

### Prerequisites

- PowerShell 7.0 or later (required for cross-platform support)
- PSReadLine module
- Pester module (for testing)
- Git for version control

### Getting Started

1. **Fork the repository**

   ```bash
   # Go to https://github.com/wangkanai/PSPredictor and click "Fork"
   ```

2. **Clone your fork**

   ```bash
   git clone https://github.com/YOUR-USERNAME/PSPredictor.git
   cd PSPredictor
   ```

3. **Build and test the module**

   ```powershell
   # Build the module
   ./build.ps1 -Task Build
   
   # Run all tests
   ./build.ps1 -Task Test
   ```

4. **Install and test**

   ```powershell
   # Install locally for testing
   ./build.ps1 -Task Install
   
   # Test functionality
   Get-PSPredictorTools
   Register-PSPredictorCompletion -Tool "git"
   ```

## 🔧 Adding New CLI Tool Completions

### Step 1: Add Tool Definition

Edit `src/Private/Config.ps1` and add your tool to the `$script:SupportedTools` hashtable:

```powershell
'mytool' = @{
    Description = 'Description of your CLI tool'
    CompletionScript = 'MyTool-Completion.ps1'
    Enabled = $true
}
```

### Step 2: Create Completion Function

Create a new file `src/Completions/MyTool.ps1` with your completion function:

```powershell
function Register-MyToolCompletion {
    Register-ArgumentCompleter -Native -CommandName mytool -ScriptBlock {
        param($wordToComplete, $commandAst, $cursorPosition)
        
        # Your completion logic here
        $commands = @('command1', 'command2', 'command3')
        
        $commands | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
    }
}
```

### Step 3: Wire It Up

Add your tool to the switch statement in `src/Public/Register-PSPredictorCompletion.ps1`:

```powershell
'mytool' { Register-MyToolCompletion }
```

### Step 4: Test Your Addition

```powershell
# Build and test the module
./build.ps1 -Task Build
./build.ps1 -Task Test

# Install for testing
./build.ps1 -Task Install

# Test your completion
mytool <TAB>
```

## 📋 Completion Best Practices

### 1. **Performance**

- Keep completion functions fast (< 100ms)
- Cache expensive operations
- Limit results to reasonable numbers

### 2. **Accuracy**

- Provide relevant, context-aware suggestions
- Include popular commands and options first
- Handle edge cases gracefully

### 3. **Consistency**

- Follow the existing code style
- Use similar parameter naming
- Maintain consistent behavior

### Example: Advanced Git Completion

```powershell
function Register-GitCompletion {
    Register-ArgumentCompleter -Native -CommandName git -ScriptBlock {
        param($wordToComplete, $commandAst, $cursorPosition)
        
        $commandElements = $commandAst.CommandElements
        $command = @($commandElements)[1].Value
        
        switch ($command) {
            'checkout' {
                # Get git branches
                $branches = git branch --format='%(refname:short)' 2>$null
                $branches | Where-Object { $_ -like "$wordToComplete*" }
            }
            'add' {
                # Get modified files
                $files = git diff --name-only 2>$null
                $files | Where-Object { $_ -like "$wordToComplete*" }
            }
            default {
                # Git subcommands
                $gitCommands = @('add', 'branch', 'checkout', 'commit', 'diff', 'merge', 'pull', 'push')
                $gitCommands | Where-Object { $_ -like "$wordToComplete*" }
            }
        }
    }
}
```

## 🧪 Testing Guidelines

### Manual Testing

```powershell
# Build and install module
./build.ps1 -Task Install

# Test tool listing
Get-PSPredictorTools

# Test completion registration
Register-PSPredictorCompletion -Tool "git"

# Test actual completion
git <TAB>
git checkout <TAB>
```

### Writing Tests

Create a new file `tests/Completions/MyTool.Tests.ps1`:

```powershell
BeforeAll {
    Import-Module "$PSScriptRoot/../../src/PSPredictor.psd1" -Force
}

Describe "MyTool Completion Tests" {
    Context "MyTool Completion Registration" {
        It "Should register mytool completion without errors" {
            { Register-PSPredictorCompletion -Tool "mytool" } | Should -Not -Throw
        }
    }
}
```

## 📝 Documentation

When adding new features:

1. **Update README.md** with new supported tools
2. **Add examples** showing how to use the new completion
3. **Update help comments** in functions
4. **Include usage examples** in your PR description

## 🔍 Code Review Process

1. **Submit a Pull Request** with a clear description
2. **Include tests** for new functionality
3. **Update documentation** as needed
4. **Respond to feedback** promptly
5. **Squash commits** before merge if requested

## 📋 Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature (CLI tool completion)
- [ ] Documentation update
- [ ] Performance improvement

## Testing
- [ ] Tested manually
- [ ] Added/updated tests
- [ ] Documentation updated

## CLI Tools Added/Modified
- Tool: [name]
- Commands supported: [list]
- Special features: [any unique aspects]
```

## 🎯 Priority Areas

We're especially looking for contributions in these areas:

### High Priority

- **Cloud CLIs**: AWS, Azure, GCP completions
- **Kubernetes**: Enhanced kubectl completions
- **Container Tools**: Docker, Podman improvements
- **Package Managers**: Language-specific PM completions

### Medium Priority

- **Development Tools**: Terraform, Ansible, etc.
- **System Tools**: Enhanced file operation completions
- **Database CLIs**: MySQL, PostgreSQL, MongoDB

### Nice to Have

- **Custom Predictor Engine**: Smarter context awareness
- **Configuration UI**: Web-based configuration
- **Telemetry**: Anonymous usage analytics

## ❓ Questions?

- **General Questions**: Open a GitHub issue
- **Development Help**: Check existing issues or create new ones
- **Feature Discussions**: Start a GitHub discussion

## 🙏 Recognition

Contributors will be:

- Listed in README.md
- Mentioned in release notes
- Credited in module metadata

Thank you for making PSPredictor better for everyone! 🚀
