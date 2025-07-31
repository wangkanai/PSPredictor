# 🚀 PowerShell Gallery Publishing Automation

This document explains the automated publishing setup for PSPredictor to PowerShell Gallery using GitHub Actions.

## 📋 Overview

The automation consists of:

- **Continuous Testing**: Tests run on every PR and push
- **Automated Publishing**: Publishes to PowerShell Gallery on merge to main
- **Version Management**: Prevents duplicate versions and manages releases
- **Cross-Platform Testing**: Tests on Windows, Linux, and macOS

## 🔧 Setup Instructions

### 1. Repository Secrets

You need to set up the following secret in your GitHub repository:

1. Go to your repository → **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Add:
   - **Name**: `PSGALLERY_API_KEY`
   - **Value**: Your PowerShell Gallery API key

### 2. Environment Protection (Recommended)

For additional security, set up a production environment:

1. Go to **Settings** → **Environments**
2. Create an environment named `production`
3. Add protection rules:
   - ✅ **Required reviewers** (optional)
   - ✅ **Wait timer** (optional, e.g., 5 minutes)
   - ✅ **Deployment branches**: Only `main` branch

## 🔄 Workflow Triggers

### Automated Publishing (`publish.yml`)

**Triggers:**

- ✅ Push to `main` branch (when module files change)
- ✅ Manual trigger via workflow_dispatch
- ✅ Only publishes if version doesn't exist in PowerShell Gallery

**Files that trigger publishing:**

- `PSPredictor.psd1` (manifest changes)
- `PSPredictor.psm1` (module code changes)
- `.github/workflows/publish.yml` (workflow updates)

### Testing (`test.yml`)

**Triggers:**

- ✅ All pull requests to `main`
- ✅ Manual trigger via workflow_dispatch

**Platforms tested:**

- 🐧 Ubuntu (Linux)
- 🪟 Windows
- 🍎 macOS

## 📦 Publishing Process

### Automatic Publishing Workflow

1. **Code Changes**: Developer pushes changes to `main` branch
2. **Version Check**: Workflow checks if version already exists in PowerShell Gallery
3. **Testing**: Runs comprehensive tests (manifest validation, module import, functionality)
4. **Building**: Builds the module package
5. **Publishing**: Publishes to PowerShell Gallery (if version is new)
6. **Release**: Creates GitHub release with auto-generated notes

### Version Management

**Current Version Detection:**

- Reads version from `PSPredictor.psd1`
- Checks PowerShell Gallery for existing versions
- Skips publishing if version already exists

**Version Bumping Helper:**

```powershell
# Patch version (1.0.0 → 1.0.1)
./.github/scripts/bump-version.ps1 -Type Patch

# Minor version (1.0.1 → 1.1.0)
./.github/scripts/bump-version.ps1 -Type Minor

# Major version (1.1.0 → 2.0.0)
./.github/scripts/bump-version.ps1 -Type Major

# Specific version
./.github/scripts/bump-version.ps1 -Type Specific -Version "2.1.0"
```

## 🛠️ Development Workflow

### For Contributors

1. **Create Feature Branch:**

   ```bash
   git checkout -b feature/my-feature
   ```

2. **Make Changes and Test Locally:**

   ```powershell
   ./build.ps1 -Task All
   ```

3. **Create Pull Request:**
   - Tests will run automatically on PR
   - Merge only after tests pass

4. **Maintainer Merges to Main:**
   - Automatic publishing will trigger
   - New version will be available on PowerShell Gallery

### For Maintainers

1. **Before Merging PR:**
   - Ensure version in `PSPredictor.psd1` is incremented
   - Review changes and test results

2. **Version Management:**

   ```powershell
   # Quick version bump
   ./.github/scripts/bump-version.ps1 -Type Patch
   git add PSPredictor.psd1
   git commit -m "Bump version to $(./build.ps1 -Task GetVersion)"
   ```

3. **Emergency Publishing:**
   - Use **Actions** → **Publish to PowerShell Gallery** → **Run workflow**
   - Enable "Force publish" if needed to overwrite existing version

## 📊 Workflow Status

### Success Indicators

**✅ Tests Pass:**

- Module manifest validation
- Module import successful
- All exported functions available
- Cross-platform compatibility

**✅ Publishing Success:**

- Version doesn't already exist (or force flag used)
- Module built successfully
- Published to PowerShell Gallery
- GitHub release created

### Common Issues & Solutions

#### "Version already exists"

- **Solution**: Increment version in `PSPredictor.psd1`
- **Quick fix**: Use bump-version script

#### "API Key invalid"

- **Solution**: Check `PSGALLERY_API_KEY` secret is set correctly
- **Get new key**: <https://www.powershellgallery.com/account/apikeys>

#### "Module validation failed"

- **Solution**: Run `./build.ps1 -Task Test` locally to debug
- **Common causes**: Missing dependencies, syntax errors, manifest issues

#### "Build failed"

- **Solution**: Check build script compatibility with GitHub Actions environment
- **Debug**: Review workflow logs for specific error messages

## 🔍 Monitoring

### Workflow Status

- **GitHub Actions Tab**: View all workflow runs
- **Badges**: Add status badges to README (optional)
- **Notifications**: GitHub will notify on workflow failures

### PowerShell Gallery

- **Module Page**: Monitor downloads and feedback
- **Statistics**: Track adoption and usage metrics
- **Issues**: Address user-reported problems

## 🎯 Best Practices

### Version Management Best Practices

- ✅ Always increment version before merging to main
- ✅ Use semantic versioning (MAJOR.MINOR.PATCH)
- ✅ Test locally before pushing to main
- ✅ Write meaningful commit messages

### Security

- ✅ Use repository secrets for API keys
- ✅ Enable environment protection for production
- ✅ Regularly rotate API keys
- ✅ Review workflow permissions

### Quality

- ✅ All PRs must pass tests
- ✅ Test on multiple platforms
- ✅ Validate module manifest before publishing
- ✅ Include meaningful release notes

## 📞 Support

If you encounter issues with the automation:

1. **Check Workflow Logs**: GitHub Actions → Failed workflow → View logs
2. **Test Locally**: Run `./build.ps1 -Task All` to reproduce issues
3. **Create Issue**: Report problems with detailed error messages
4. **Manual Publishing**: Use local publishing as fallback if needed

---

**🎉 Happy Publishing!** Your PowerShell module will now be automatically published to the PowerShell Gallery
whenever you merge changes to the main branch.
