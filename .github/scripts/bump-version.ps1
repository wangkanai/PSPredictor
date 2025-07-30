#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Bump version script for PSPredictor module

.DESCRIPTION
    This script helps bump the module version in PSPredictor.psd1 for automated publishing.

.PARAMETER Type
    The type of version bump: Major, Minor, Patch, or Specific

.PARAMETER Version
    Specific version to set (only used with -Type Specific)

.EXAMPLE
    ./bump-version.ps1 -Type Patch
    ./bump-version.ps1 -Type Minor
    ./bump-version.ps1 -Type Specific -Version "2.1.0"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateSet('Major', 'Minor', 'Patch', 'Specific')]
    [string]$Type,
    
    [string]$Version,
    
    [string]$ManifestPath = './src/PSPredictor.psd1'
)

# Ensure manifest exists
if (-not (Test-Path $ManifestPath)) {
    Write-Error "Module manifest not found at: $ManifestPath"
    exit 1
}

# Get current version
try {
    $manifest = Import-PowerShellDataFile -Path $ManifestPath
    $currentVersion = [Version]$manifest.ModuleVersion
    Write-Host "Current version: $currentVersion" -ForegroundColor Cyan
} catch {
    Write-Error "Failed to read current version: $_"
    exit 1
}

# Calculate new version
switch ($Type) {
    'Major' {
        $newVersion = [Version]::new($currentVersion.Major + 1, 0, 0)
    }
    'Minor' {
        $newVersion = [Version]::new($currentVersion.Major, $currentVersion.Minor + 1, 0)
    }
    'Patch' {
        $newVersion = [Version]::new($currentVersion.Major, $currentVersion.Minor, $currentVersion.Build + 1)
    }
    'Specific' {
        if ([string]::IsNullOrWhiteSpace($Version)) {
            Write-Error "Version parameter required when Type is Specific"
            exit 1
        }
        try {
            $newVersion = [Version]$Version
        } catch {
            Write-Error "Invalid version format: $Version"
            exit 1
        }
    }
}

Write-Host "New version: $newVersion" -ForegroundColor Green

# Read manifest content
$content = Get-Content $ManifestPath -Raw

# Update version in manifest
$pattern = "ModuleVersion\s*=\s*'([^']+)'"
$replacement = "ModuleVersion = '$newVersion'"

if ($content -match $pattern) {
    $updatedContent = $content -replace $pattern, $replacement
    
    # Write updated content
    $updatedContent | Set-Content $ManifestPath -Encoding UTF8 -NoNewline
    
    Write-Host "✅ Updated module version from $currentVersion to $newVersion" -ForegroundColor Green
    
    # Update release notes
    $releaseNotesPattern = "ReleaseNotes = @'[\s\S]*?'@"
    $newReleaseNotes = @"
ReleaseNotes = @'
## Version $newVersion
- Version bump: $Type update
- Automated release via GitHub Actions
- See CHANGELOG.md for detailed changes
'@
"@
    
    if ($updatedContent -match $releaseNotesPattern) {
        $updatedContent = $updatedContent -replace $releaseNotesPattern, $newReleaseNotes
        $updatedContent | Set-Content $ManifestPath -Encoding UTF8 -NoNewline
        Write-Host "✅ Updated release notes" -ForegroundColor Green
    }
    
} else {
    Write-Error "Could not find ModuleVersion pattern in manifest"
    exit 1
}

# Validate the updated manifest
try {
    $updatedManifest = Test-ModuleManifest -Path $ManifestPath
    Write-Host "✅ Updated manifest is valid" -ForegroundColor Green
    Write-Host "  Version: $($updatedManifest.Version)" -ForegroundColor Gray
} catch {
    Write-Error "Updated manifest is invalid: $_"
    exit 1
}

Write-Host ""
Write-Host "🎉 Version bump completed successfully!" -ForegroundColor Magenta
Write-Host "💡 Commit and push changes to trigger automated publishing:" -ForegroundColor Yellow
Write-Host "   git add src/PSPredictor.psd1" -ForegroundColor Gray
Write-Host "   git commit -m 'Bump version to $newVersion'" -ForegroundColor Gray
Write-Host "   git push origin main" -ForegroundColor Gray