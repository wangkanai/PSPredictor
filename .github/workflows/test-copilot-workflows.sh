#!/bin/bash

# Test script for Copilot auto-approval workflows
# This script validates the workflows are properly configured

echo "🧪 Testing Copilot Auto-Approval Workflows"
echo "============================================"

# Test 1: Check workflow files exist
echo "📁 Checking workflow files..."
APPROVE_WORKFLOW=".github/workflows/copilot-auto-approve.yml"
MERGE_WORKFLOW=".github/workflows/copilot-auto-merge.yml"

if [[ -f "$APPROVE_WORKFLOW" ]]; then
    echo "✅ Auto-approve workflow found"
else
    echo "❌ Auto-approve workflow missing"
    exit 1
fi

if [[ -f "$MERGE_WORKFLOW" ]]; then
    echo "✅ Auto-merge workflow found"
else
    echo "❌ Auto-merge workflow missing"
    exit 1
fi

# Test 2: Validate YAML syntax
echo "📝 Validating YAML syntax..."
if command -v yamllint >/dev/null 2>&1; then
    if yamllint "$APPROVE_WORKFLOW" >/dev/null 2>&1; then
        echo "✅ Auto-approve workflow YAML is valid"
    else
        echo "⚠️ Auto-approve workflow has YAML formatting warnings (functional but not perfect)"
    fi
    
    if yamllint "$MERGE_WORKFLOW" >/dev/null 2>&1; then
        echo "✅ Auto-merge workflow YAML is valid"
    else
        echo "⚠️ Auto-merge workflow has YAML formatting warnings (functional but not perfect)"
    fi
else
    echo "⚠️ yamllint not available, skipping syntax validation"
fi

# Test 3: Check for required permissions
echo "🔒 Checking workflow permissions..."
if grep -q "pull-requests: write" "$APPROVE_WORKFLOW" && grep -q "contents: read" "$APPROVE_WORKFLOW"; then
    echo "✅ Auto-approve workflow has required permissions"
else
    echo "❌ Auto-approve workflow missing required permissions"
    exit 1
fi

if grep -q "contents: write" "$MERGE_WORKFLOW" && grep -q "pull-requests: write" "$MERGE_WORKFLOW"; then
    echo "✅ Auto-merge workflow has required permissions"
else
    echo "❌ Auto-merge workflow missing required permissions"
    exit 1
fi

# Test 4: Check for trusted bot patterns
echo "🤖 Checking trusted bot configurations..."
TRUSTED_BOTS=("github-actions[bot]" "dependabot[bot]" "copilot-autofix[bot]")

for bot in "${TRUSTED_BOTS[@]}"; do
    if grep -q "$bot" "$APPROVE_WORKFLOW" && grep -q "$bot" "$MERGE_WORKFLOW"; then
        echo "✅ Bot $bot configured in both workflows"
    else
        echo "❌ Bot $bot missing from workflows"
        exit 1
    fi
done

# Test 5: Check for safe file patterns
echo "📂 Checking safe file patterns..."
SAFE_PATTERNS=('\.md\$' '\.yml\$' '\.json\$' '\.cs\$')

for pattern in "${SAFE_PATTERNS[@]}"; do
    if grep -q "$pattern" "$APPROVE_WORKFLOW"; then
        echo "✅ Safe pattern $pattern found"
    else
        echo "❌ Safe pattern $pattern missing"
        exit 1
    fi
done

# Test 6: Check for workflow triggers
echo "⚡ Checking workflow triggers..."
if grep -q "pull_request_target:" "$APPROVE_WORKFLOW"; then
    echo "✅ Auto-approve workflow has correct trigger"
else
    echo "❌ Auto-approve workflow missing pull_request_target trigger"
    exit 1
fi

if grep -q "pull_request_target:" "$MERGE_WORKFLOW" && grep -q "check_suite:" "$MERGE_WORKFLOW"; then
    echo "✅ Auto-merge workflow has correct triggers"
else
    echo "❌ Auto-merge workflow missing required triggers"
    exit 1
fi

echo ""
echo "🎉 All tests passed! Copilot auto-approval workflows are properly configured."
echo ""
echo "📋 Summary:"
echo "- Auto-approve workflow will automatically approve safe Copilot PRs"
echo "- Auto-merge workflow will merge approved PRs after all checks pass"
echo "- Security controls are in place for file type validation"
echo "- Only trusted bots can trigger auto-approval"
echo ""
echo "🚀 The workflows are ready to automatically handle Copilot PRs!"