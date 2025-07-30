<#
.SYNOPSIS
    Kubectl (Kubernetes CLI) completion provider for PSPredictor
.DESCRIPTION
    Provides comprehensive tab completion for kubectl commands, resources, and options
#>

function Register-KubectlCompletion {
    $KubectlScriptBlock = {
        param($wordToComplete, $commandAst, $cursorPosition)
        
        $completions = @()
        
        # Get the full command line to understand context
        $commandLine = $commandAst.ToString()
        $words = $commandLine -split '\s+' | Where-Object { $_ -ne '' }
        
        # Determine completion level: kubectl <command> <resource> <name> <options>
        if ($words.Count -eq 1 -or ($words.Count -eq 2 -and [string]::IsNullOrEmpty($wordToComplete) -eq $false -and $words[1] -like "$wordToComplete*")) {
            # Completing kubectl commands
            $commands = @(
                'get', 'describe', 'create', 'delete', 'apply', 'edit', 'patch',
                'replace', 'expose', 'rollout', 'scale', 'autoscale',
                'logs', 'exec', 'port-forward', 'proxy', 'cp', 'attach',
                'run', 'explain', 'diff', 'kustomize',
                'label', 'annotate', 'completion', 'version',
                'cluster-info', 'top', 'cordon', 'uncordon', 'drain', 'taint',
                'config', 'plugin', 'certificate', 'api-resources', 'api-versions',
                'wait', 'auth', 'debug'
            )
            
            $completions += $commands | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { 
                    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "kubectl $_")
                }
                
            # Global kubectl options
            if ($wordToComplete -like '-*') {
                $globalOptions = @(
                    '--kubeconfig', '--context', '--cluster', '--user', '--namespace', '-n',
                    '--server', '--insecure-skip-tls-verify', '--certificate-authority',
                    '--client-certificate', '--client-key', '--token', '--as', '--as-group',
                    '--cache-dir', '--match-server-version', '--request-timeout', '-v', '--v'
                )
                $completions += $globalOptions | Where-Object { $_ -like "$wordToComplete*" } |
                    ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
            }
        }
        # Handle command-specific completions
        elseif ($words.Count -ge 2) {
            $command = $words[1]
            
            # Define Kubernetes resources
            $resources = @(
                'pods', 'po', 'services', 'svc', 'deployments', 'deploy', 'replicasets', 'rs',
                'statefulsets', 'sts', 'daemonsets', 'ds', 'jobs', 'cronjobs', 'cj',
                'configmaps', 'cm', 'secrets', 'persistentvolumes', 'pv',
                'persistentvolumeclaims', 'pvc', 'storageclasses', 'sc',
                'nodes', 'no', 'namespaces', 'ns', 'endpoints', 'ep',
                'ingresses', 'ing', 'networkpolicies', 'netpol',
                'serviceaccounts', 'sa', 'roles', 'rolebindings',
                'clusterroles', 'clusterrolebindings', 'podsecuritypolicies', 'psp',
                'horizontalpodautoscalers', 'hpa', 'verticalpodautoscalers', 'vpa',
                'poddisruptionbudgets', 'pdb', 'priorityclasses', 'pc',
                'customresourcedefinitions', 'crd', 'events', 'ev',
                'certificates', 'csr', 'leases'
            )
            
            switch ($command) {
                { $_ -in @('get', 'describe', 'delete', 'edit', 'patch', 'label', 'annotate') } {
                    if (($words.Count -eq 2) -or ($words.Count -eq 3 -and [string]::IsNullOrEmpty($wordToComplete)) -or ($words.Count -eq 3 -and -not $wordToComplete.StartsWith('-'))) {
                        # Resource completions
                        $completions += $resources | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "Resource: $_") }
                        
                        # Special resource combinations
                        $specialResources = @('all', 'pods,services', 'deploy,svc')
                        $completions += $specialResources | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "Special: $_") }
                    }
                    if ($wordToComplete -like '-*') {
                        $resourceOptions = @(
                            '--output', '-o', '--show-labels', '--selector', '-l', '--field-selector',
                            '--all-namespaces', '-A', '--watch', '-w', '--watch-only',
                            '--sort-by', '--no-headers', '--export', '--raw'
                        )
                        if ($command -eq 'get') {
                            $resourceOptions += @('--ignore-not-found', '--include-uninitialized', '--show-kind')
                        }
                        $completions += $resourceOptions | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'create' {
                    if (($words.Count -eq 2) -or ($words.Count -eq 3 -and [string]::IsNullOrEmpty($wordToComplete)) -or ($words.Count -eq 3 -and -not $wordToComplete.StartsWith('-'))) {
                        # Create subcommands
                        $createCommands = @(
                            'deployment', 'service', 'configmap', 'secret', 'namespace',
                            'serviceaccount', 'clusterrole', 'clusterrolebinding',
                            'role', 'rolebinding', 'quota', 'job', 'cronjob'
                        )
                        $completions += $createCommands | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "create $_") }
                    }
                    if ($wordToComplete -like '-*') {
                        $createOptions = @('--filename', '-f', '--dry-run', '--save-config', '--validate')
                        $completions += $createOptions | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'apply' {
                    if ($wordToComplete -like '-*') {
                        $applyOptions = @(
                            '--filename', '-f', '--recursive', '-R', '--dry-run', '--force',
                            '--grace-period', '--timeout', '--validate', '--wait', '--prune',
                            '--prune-whitelist', '--all', '--overwrite'
                        )
                        $completions += $applyOptions | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'logs' {
                    if (($words.Count -eq 2) -or ($words.Count -eq 3 -and [string]::IsNullOrEmpty($wordToComplete)) -or ($words.Count -eq 3 -and -not $wordToComplete.StartsWith('-'))) {
                        # For logs, typically target pods or deployments
                        $logResources = @('pods', 'po', 'deployments', 'deploy', 'statefulsets', 'sts', 'daemonsets', 'ds', 'jobs')
                        $completions += $logResources | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "Resource: $_") }
                    }
                    if ($wordToComplete -like '-*') {
                        $logOptions = @(
                            '--follow', '-f', '--previous', '-p', '--since', '--since-time',
                            '--tail', '--timestamps', '--container', '-c', '--prefix',
                            '--max-log-requests', '--ignore-errors'
                        )
                        $completions += $logOptions | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'exec' {
                    if (($words.Count -eq 2) -or ($words.Count -eq 3 -and [string]::IsNullOrEmpty($wordToComplete)) -or ($words.Count -eq 3 -and -not $wordToComplete.StartsWith('-'))) {
                        # For exec, target pods
                        $execResources = @('pods', 'po')
                        $completions += $execResources | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "Resource: $_") }
                    }
                    if ($wordToComplete -like '-*') {
                        $execOptions = @(
                            '--stdin', '-i', '--tty', '-t', '--container', '-c',
                            '--pod-running-timeout'
                        )
                        $completions += $execOptions | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'scale' {
                    if (($words.Count -eq 2) -or ($words.Count -eq 3 -and [string]::IsNullOrEmpty($wordToComplete)) -or ($words.Count -eq 3 -and -not $wordToComplete.StartsWith('-'))) {
                        # Scalable resources
                        $scaleResources = @('deployments', 'deploy', 'replicasets', 'rs', 'statefulsets', 'sts')
                        $completions += $scaleResources | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "Resource: $_") }
                    }
                    if ($wordToComplete -like '-*') {
                        $scaleOptions = @('--replicas', '--resource-version', '--timeout')
                        $completions += $scaleOptions | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'rollout' {
                    if (($words.Count -eq 2) -or ($words.Count -eq 3 -and [string]::IsNullOrEmpty($wordToComplete)) -or ($words.Count -eq 3 -and -not $wordToComplete.StartsWith('-'))) {
                        # Rollout subcommands
                        $rolloutCommands = @('status', 'history', 'undo', 'pause', 'resume', 'restart')
                        $completions += $rolloutCommands | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "rollout $_") }
                    }
                }
                'config' {
                    if (($words.Count -eq 2) -or ($words.Count -eq 3 -and [string]::IsNullOrEmpty($wordToComplete)) -or ($words.Count -eq 3 -and -not $wordToComplete.StartsWith('-'))) {
                        # Config subcommands
                        $configCommands = @(
                            'current-context', 'delete-cluster', 'delete-context', 'delete-user',
                            'get-clusters', 'get-contexts', 'get-users', 'rename-context',
                            'set', 'set-cluster', 'set-context', 'set-credentials',
                            'unset', 'use-context', 'view'
                        )
                        $completions += $configCommands | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "config $_") }
                    }
                }
                'top' {
                    if (($words.Count -eq 2) -or ($words.Count -eq 3 -and [string]::IsNullOrEmpty($wordToComplete)) -or ($words.Count -eq 3 -and -not $wordToComplete.StartsWith('-'))) {
                        # Top resources
                        $topResources = @('nodes', 'no', 'pods', 'po')
                        $completions += $topResources | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "Resource: $_") }
                    }
                    if ($wordToComplete -like '-*') {
                        $topOptions = @('--containers', '--no-headers', '--sort-by', '--selector', '-l')
                        $completions += $topOptions | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
            }
            
            # Common options for all commands
            if ($wordToComplete -like '-*') {
                $commonOptions = @(
                    '--kubeconfig', '--context', '--cluster', '--user', '--namespace', '-n',
                    '--server', '--insecure-skip-tls-verify', '--request-timeout', '-v', '--v'
                )
                $completions += $commonOptions | Where-Object { $_ -like "$wordToComplete*" } |
                    ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
            }
        }
        
        return $completions
    }
    
    Register-ArgumentCompleter -Native -CommandName 'kubectl' -ScriptBlock $KubectlScriptBlock
}