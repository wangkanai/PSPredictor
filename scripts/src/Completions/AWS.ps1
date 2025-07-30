<#
.SYNOPSIS
    AWS CLI completion provider for PSPredictor
.DESCRIPTION
    Provides comprehensive tab completion for AWS CLI commands, services, and options
#>

function Register-AWSCompletion {
    $AWSScriptBlock = {
        param($wordToComplete, $commandAst, $cursorPosition)
        
        $completions = @()
        
        # Get the full command line to understand context
        $commandLine = $commandAst.ToString()
        $words = $commandLine -split '\s+' | Where-Object { $_ -ne '' }
        
        # Determine completion level: aws <service> <command> <options>
        if ($words.Count -eq 1 -or ($words.Count -eq 2 -and [string]::IsNullOrEmpty($wordToComplete) -eq $false -and $words[1] -like "$wordToComplete*")) {
            # Completing AWS service names
            $services = @(
                'ec2', 's3', 'lambda', 'iam', 'cloudformation', 'rds', 'ecs', 'eks', 'sns', 'sqs',
                'dynamodb', 'cloudwatch', 'logs', 'route53', 'elb', 'elbv2', 'autoscaling',
                'apigateway', 'cognito-idp', 'secretsmanager', 'ssm', 'kms', 'acm', 'ecr',
                'batch', 'glue', 'kinesis', 'firehose', 'redshift', 'athena', 'quicksight',
                'organizations', 'support', 'trustedadvisor', 'config', 'cloudtrail',
                'inspector', 'guardduty', 'macie', 'securityhub', 'waf', 'wafv2',
                'backup', 'datasync', 'storagegateway', 'fsx', 'efs', 'glacier',
                'mediaconvert', 'transcribe', 'translate', 'comprehend', 'rekognition',
                'textract', 'polly', 'lex', 'connect', 'chime', 'workspaces', 'appstream',
                'lightsail', 'amplify', 'appsync', 'eventbridge', 'stepfunctions'
            )
            
            $completions += $services | Where-Object { $_ -like "$wordToComplete*" } |
                ForEach-Object { 
                    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "AWS $_")
                }
                
            # Global AWS CLI options
            if ($wordToComplete -like '--*') {
                $globalOptions = @('--region', '--output', '--profile', '--debug', '--endpoint-url', '--no-verify-ssl', '--no-paginate', '--no-cli-pager')
                $completions += $globalOptions | Where-Object { $_ -like "$wordToComplete*" } |
                    ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
            }
        }
        # Handle service-specific commands and options
        elseif ($words.Count -ge 2) {
            $service = $words[1]
            
            switch ($service) {
                's3' {
                    if ($words.Count -eq 2 -or ($words.Count -eq 3 -and -not $wordToComplete.StartsWith('-'))) {
                        # S3 commands
                        $s3Commands = @(
                            'ls', 'cp', 'mv', 'rm', 'sync', 'mb', 'rb', 'presign',
                            'api', 'website', 'notification', 'lifecycle', 'cors',
                            'versioning', 'logging', 'inventory', 'metrics', 'encryption'
                        )
                        $completions += $s3Commands | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "s3 $_") }
                    }
                    if ($wordToComplete -like '--*') {
                        $s3Options = @('--recursive', '--exclude', '--include', '--dryrun', '--delete', '--storage-class', '--acl')
                        $completions += $s3Options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'ec2' {
                    if ($words.Count -eq 2 -or ($words.Count -eq 3 -and -not $wordToComplete.StartsWith('-'))) {
                        # EC2 commands
                        $ec2Commands = @(
                            'describe-instances', 'run-instances', 'terminate-instances', 'stop-instances', 'start-instances',
                            'describe-images', 'describe-key-pairs', 'describe-security-groups', 'describe-subnets',
                            'describe-vpcs', 'describe-volumes', 'create-key-pair', 'create-security-group',
                            'authorize-security-group-ingress', 'revoke-security-group-ingress',
                            'allocate-address', 'associate-address', 'disassociate-address', 'release-address',
                            'create-snapshot', 'describe-snapshots', 'delete-snapshot',
                            'create-volume', 'attach-volume', 'detach-volume', 'delete-volume'
                        )
                        $completions += $ec2Commands | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "ec2 $_") }
                    }
                    if ($wordToComplete -like '--*') {
                        $ec2Options = @('--instance-ids', '--image-id', '--instance-type', '--key-name', '--security-groups', '--subnet-id', '--dry-run')
                        $completions += $ec2Options | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'lambda' {
                    if ($words.Count -eq 2 -or ($words.Count -eq 3 -and -not $wordToComplete.StartsWith('-'))) {
                        # Lambda commands
                        $lambdaCommands = @(
                            'create-function', 'delete-function', 'get-function', 'list-functions',
                            'update-function-code', 'update-function-configuration', 'invoke',
                            'create-alias', 'delete-alias', 'get-alias', 'list-aliases',
                            'publish-version', 'list-versions-by-function',
                            'add-permission', 'remove-permission', 'get-policy'
                        )
                        $completions += $lambdaCommands | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "lambda $_") }
                    }
                    if ($wordToComplete -like '--*') {
                        $lambdaOptions = @('--function-name', '--runtime', '--role', '--handler', '--zip-file', '--timeout', '--memory-size')
                        $completions += $lambdaOptions | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'iam' {
                    if ($words.Count -eq 2 -or ($words.Count -eq 3 -and -not $wordToComplete.StartsWith('-'))) {
                        # IAM commands
                        $iamCommands = @(
                            'create-user', 'delete-user', 'get-user', 'list-users',
                            'create-group', 'delete-group', 'get-group', 'list-groups',
                            'create-role', 'delete-role', 'get-role', 'list-roles',
                            'create-policy', 'delete-policy', 'get-policy', 'list-policies',
                            'attach-user-policy', 'detach-user-policy', 'list-attached-user-policies',
                            'attach-group-policy', 'detach-group-policy', 'list-attached-group-policies',
                            'attach-role-policy', 'detach-role-policy', 'list-attached-role-policies',
                            'create-access-key', 'delete-access-key', 'list-access-keys'
                        )
                        $completions += $iamCommands | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "iam $_") }
                    }
                    if ($wordToComplete -like '--*') {
                        $iamOptions = @('--user-name', '--group-name', '--role-name', '--policy-name', '--policy-arn', '--policy-document')
                        $completions += $iamOptions | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'cloudformation' {
                    if ($words.Count -eq 2 -or ($words.Count -eq 3 -and -not $wordToComplete.StartsWith('-'))) {
                        # CloudFormation commands
                        $cfnCommands = @(
                            'create-stack', 'delete-stack', 'describe-stacks', 'list-stacks',
                            'update-stack', 'cancel-update-stack', 'continue-update-rollback',
                            'describe-stack-events', 'describe-stack-resources', 'list-stack-resources',
                            'validate-template', 'estimate-template-cost',
                            'create-change-set', 'delete-change-set', 'describe-change-set', 'execute-change-set',
                            'deploy', 'package'
                        )
                        $completions += $cfnCommands | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "cloudformation $_") }
                    }
                    if ($wordToComplete -like '--*') {
                        $cfnOptions = @('--stack-name', '--template-body', '--template-url', '--parameters', '--capabilities', '--tags')
                        $completions += $cfnOptions | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
                'rds' {
                    if ($words.Count -eq 2 -or ($words.Count -eq 3 -and -not $wordToComplete.StartsWith('-'))) {
                        # RDS commands
                        $rdsCommands = @(
                            'create-db-instance', 'delete-db-instance', 'describe-db-instances', 'modify-db-instance',
                            'start-db-instance', 'stop-db-instance', 'reboot-db-instance',
                            'create-db-snapshot', 'delete-db-snapshot', 'describe-db-snapshots',
                            'restore-db-instance-from-db-snapshot', 'create-db-cluster', 'delete-db-cluster',
                            'describe-db-clusters', 'start-db-cluster', 'stop-db-cluster'
                        )
                        $completions += $rdsCommands | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', "rds $_") }
                    }
                    if ($wordToComplete -like '--*') {
                        $rdsOptions = @('--db-instance-identifier', '--db-instance-class', '--engine', '--master-username', '--allocated-storage')
                        $completions += $rdsOptions | Where-Object { $_ -like "$wordToComplete*" } |
                            ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
                    }
                }
            }
            
            # Common options for all services
            if ($wordToComplete -like '--*') {
                $commonOptions = @('--region', '--output', '--profile', '--debug', '--endpoint-url', '--no-verify-ssl', '--no-paginate', '--no-cli-pager')
                $completions += $commonOptions | Where-Object { $_ -like "$wordToComplete*" } |
                    ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterName', $_) }
            }
        }
        
        return $completions
    }
    
    Register-ArgumentCompleter -Native -CommandName 'aws' -ScriptBlock $AWSScriptBlock
}