# Copilot Auto-Approval Workflow Example

## Scenario: GitHub Copilot creates a PR to fix a documentation issue

### 1. Copilot creates PR
- **Author**: `copilot-autofix[bot]`
- **Branch**: `copilot-autofix/fix-readme-typo`
- **Files changed**: `README.md` (fixed typos)
- **Title**: "Copilot Autofix: Fix typos in README.md"

### 2. Auto-approval workflow triggers
```yaml
# Triggered by: pull_request_target
# Conditions: 
# - Author is copilot-autofix[bot] ✅
# - Branch contains "copilot-autofix" ✅
# - Title contains "Copilot Autofix" ✅
```

### 3. File validation
```bash
# Changed files: README.md
# Pattern check: \.md$ ✅ (matches safe pattern)
# Security check: No unsafe files ✅
# Result: SAFE_FOR_AUTO_APPROVE="true" ✅
```

### 4. Auto-approval action
- ✅ PR gets automatic approval
- 🏷️ Labels added: `auto-merge-eligible`, `copilot-approved`
- 💬 Comment added explaining automatic approval

### 5. CI/CD checks run
- ✅ `dotnet.yml` workflow runs (build and test)
- ✅ `markdownlint` checks pass
- ✅ All status checks green

### 6. Auto-merge triggers
```yaml
# Triggered by: check_suite completion
# Conditions:
# - PR has `auto-merge-eligible` label ✅
# - PR is approved ✅
# - All status checks pass ✅
# - Author is trusted bot ✅
```

### 7. Auto-merge action
- 🚀 PR automatically merged with squash strategy
- 🗑️ Branch automatically deleted
- 💬 Merge comment added with details

## Result
- **Zero manual intervention required** for safe Copilot changes
- **Full security validation** maintained
- **All CI/CD checks enforced** before merge
- **Complete audit trail** with automatic comments

## Alternative Scenario: Unsafe Changes

If Copilot modifies a `.ps1` PowerShell script:

### 1-3. Same as above until file validation

### 4. File validation (different result)
```bash
# Changed files: scripts/deploy.ps1
# Pattern check: \.ps1$ ❌ (matches unsafe pattern)
# Security check: PowerShell script detected ❌
# Result: SAFE_FOR_AUTO_APPROVE="false" ❌
```

### 5. Manual review required
- ⚠️ No automatic approval
- 💬 Comment added explaining why manual review is needed
- 👤 Human maintainer must review and approve manually

This ensures **security-first automation** that speeds up safe changes while protecting sensitive modifications.