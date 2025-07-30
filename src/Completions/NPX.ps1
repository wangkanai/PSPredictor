<#
.SYNOPSIS
    NPX Node.js package runner completion provider for PSPredictor
.DESCRIPTION
    Provides comprehensive tab completion for npx commands and options
#>

function Register-NPXCompletion {
    $NPXScriptBlock = {
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
        
        $completions = @()
        
        # Get the full command line to understand context
        $commandLine = $commandAst.ToString()
        $words = $commandLine -split '\s+' | Where-Object { $_ -ne '' }
        
        # NPX options
        if ($wordToComplete -like '-*') {
            $options = @(
                '--package', '--cache', '--always-spawn', '--prefer-offline', '--prefer-online',
                '--shell', '--shell-auto-fallback', '--ignore-existing', '--quiet', '--npm',
                '--node-arg', '--version', '--help'
            )
            $completions += $options | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
        } else {
            # Common npx packages/commands
            $packages = @(
                'create-react-app', 'create-next-app', 'create-vue', 'degit', 'typescript',
                'ts-node', 'nodemon', 'pm2', 'webpack', 'vite', 'rollup', 'parcel',
                'eslint', 'prettier', 'jest', 'mocha', 'cypress', 'playwright',
                'storybook', 'serve', 'http-server', 'live-server', 'json-server',
                'concurrently', 'cross-env', 'rimraf', 'mkdirp', 'ncp', 'cpx'
            )
            $completions += $packages | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "Package: $_") }
        }
        
        return $completions
    }
    
    Register-ArgumentCompleter -CommandName 'npx' -ScriptBlock $NPXScriptBlock
}