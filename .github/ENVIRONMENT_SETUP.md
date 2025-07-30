# GitHub Environment Setup Guide

## Production Environment Configuration

The publish workflow requires a "production" environment to be configured in the GitHub repository with proper security controls.

## 🔧 Setup Instructions

### 1. Create Production Environment

1. Navigate to your repository on GitHub
2. Go to **Settings** → **Environments**
3. Click **New environment**
4. Name it: `production`
5. Click **Configure environment**

### 2. Configure Protection Rules

Add the following protection rules for security:

#### **Required Reviewers** (Recommended)
- Add trusted maintainers who can approve production deployments
- Minimum 1 reviewer required for publishing to PowerShell Gallery

#### **Deployment Branches**
- Restrict to: `main` branch only
- This ensures only approved code from the main branch can be published

#### **Wait Timer** (Optional)
- Add a brief wait period (e.g., 5 minutes) for last-minute cancellations

### 3. Add Environment Secrets

Add the following secrets to the **production** environment:

#### **PSGALLERY_API_KEY**
1. Get your API key from [PowerShell Gallery](https://www.powershellgallery.com/account/apikeys)
2. In the production environment settings, click **Add secret**
3. Name: `PSGALLERY_API_KEY`
4. Value: Your PowerShell Gallery API key
5. Click **Add secret**

## 🚀 Alternative Configuration (No Environment)

If you prefer not to use GitHub environments, you can modify the workflow:

```yaml
  publish:
    needs: test
    runs-on: ubuntu-latest
    name: Publish to PowerShell Gallery
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    # Remove this line to disable environment protection:
    # environment: production
    
    steps:
    # ... rest of the steps
```

**Note**: Without environment protection, the `PSGALLERY_API_KEY` secret must be added at the repository level instead.

## 🔒 Security Benefits

Using the production environment provides:

- **Manual Approval**: Prevents accidental publications
- **Branch Protection**: Only main branch can trigger publishing
- **Audit Trail**: Track who approved each deployment
- **Secret Isolation**: API keys are isolated to production deployments
- **Emergency Stop**: Ability to cancel deployments before they complete

## 📋 Verification Checklist

Before your first publish, verify:

- [ ] Production environment exists
- [ ] Required reviewers are configured
- [ ] Deployment branches restricted to `main`
- [ ] `PSGALLERY_API_KEY` secret is added to production environment
- [ ] Branch protection rules are enabled on `main` branch
- [ ] Test workflow passes successfully

## 🆘 Troubleshooting

### Workflow Fails with "Environment not found"
- Ensure the production environment is created in repository settings
- Check that the environment name exactly matches "production" (case-sensitive)

### API Key Errors
- Verify the `PSGALLERY_API_KEY` secret exists in the production environment
- Check that the API key is valid and has publish permissions
- Ensure the key hasn't expired

### Permission Denied
- Verify you have admin access to the repository
- Check that the workflow has `contents: write` permission
- Ensure branch protection rules allow the workflow to run

---

**Documentation Version**: 1.0  
**Last Updated**: 2025-07-30  
**Maintainer**: PSPredictor Team