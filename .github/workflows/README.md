# GitHub Copilot Auto-Approval Workflows

This directory contains two workflows that enable automatic approval and merging of GitHub Copilot-generated pull requests:

## Workflows

### 1. `copilot-auto-approve.yml`
- **Trigger**: When Copilot creates or updates a pull request
- **Purpose**: Automatically approves PRs from trusted bots that only modify safe files
- **Security**: Validates file types to ensure only safe changes are auto-approved
- **Output**: Adds approval and labels for eligible PRs

### 2. `copilot-auto-merge.yml`
- **Trigger**: When PR is labeled, status checks complete, or labeled PRs are updated
- **Purpose**: Automatically merges approved Copilot PRs after all checks pass
- **Security**: Requires approval and passing status checks before merge
- **Output**: Squash merges and deletes branch after successful validation

## Trusted Bot Accounts

The workflows automatically approve PRs from:
- `github-actions[bot]`
- `dependabot[bot]`
- `copilot-autofix[bot]`
- PRs with branch names containing `copilot-autofix`
- PRs with titles containing `Copilot Autofix`

## Safe File Types

Auto-approval is limited to these file types:
- Markdown files (`.md`)
- Configuration files (`.yml`, `.yaml`, `.json`)
- C# source files (`.cs`, `.csproj`, `.props`, `.targets`)
- Documentation and text files
- Package lock files

## Unsafe File Types (Manual Review Required)

These file types require manual review:
- PowerShell scripts (`.ps1`, `.psm1`, `.psd1`)
- Executables and libraries (`.exe`, `.dll`)
- Security-sensitive files (`.key`, `.pfx`, files with "secrets")

## Security Features

1. **File Type Validation**: Only safe file types are auto-approved
2. **Bot Authentication**: Only trusted bot accounts can trigger auto-approval
3. **Status Check Requirements**: All CI/CD checks must pass before merge
4. **Approval Requirements**: PRs must be approved before auto-merge
5. **Branch Protection**: Respects existing branch protection rules

## Setup Requirements

No additional setup is required. The workflows will automatically:
1. Detect Copilot-generated PRs
2. Validate file changes
3. Approve safe changes
4. Label PRs for auto-merge
5. Merge after all checks pass

## Labels

The workflows use these labels:
- `auto-merge-eligible`: Added to PRs that can be auto-merged
- `copilot-approved`: Added to PRs that have been auto-approved

## Monitoring

Check the Actions tab to monitor workflow execution and troubleshoot any issues.