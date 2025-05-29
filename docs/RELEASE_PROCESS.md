# Release Process Documentation

This document describes the automated release process for the KGC Toolkit project.

## Overview

The project uses GitHub Actions to automatically create releases when version branches are pushed. The process supports semantic versioning and automatic changelog generation.

## Release Workflow

### 1. Automatic Release Creation

When you push a branch with the pattern `v*` (e.g., `v1.2.3`, `v2.0.0-beta.1`), the following happens automatically:

1. **Validation**: The branch name is validated for proper semantic versioning
2. **Tag Creation**: A git tag is created with the version number
3. **Changelog Generation**: Automatic changelog based on commit messages since the last release
4. **Asset Building**: Release archives (`.tar.gz` and `.zip`) are created
5. **GitHub Release**: A GitHub release is published with assets and changelog

### 2. Branch Validation

Before creating a release, the validation workflow checks:

- ✅ Branch name follows semantic versioning (`v1.2.3`, `v2.0.0-beta.1`)
- ✅ Required files exist (`install.sh`, `README.md`, `LICENSE`)
- ✅ `install.sh` has valid bash syntax
- ✅ No obvious security issues in scripts
- ✅ README.md has required sections

### 3. Documentation Updates

After a release is published:

- 📝 README.md is automatically updated with new version references
- 🔗 Installation commands are updated to point to the latest release
- 🏷️ Version badges are updated

## Creating a Release

### Method 1: Using the Helper Script (Recommended)

```bash
# Make the script executable (first time only)
chmod +x scripts/create-release.sh

# Create a release
./scripts/create-release.sh 1.2.3

# Create a pre-release
./scripts/create-release.sh 2.0.0-beta.1
```

### Method 2: Manual Process

```bash
# 1. Ensure you're on the main branch with latest changes
git checkout main
git pull origin main

# 2. Create and push a version branch
git checkout -b v1.2.3
git push -u origin v1.2.3

# 3. Monitor GitHub Actions for automatic release creation
```

## Version Naming Convention

Follow [Semantic Versioning](https://semver.org/):

- **Major.Minor.Patch** (e.g., `1.2.3`)
- **Pre-releases** with identifiers (e.g., `2.0.0-beta.1`, `1.3.0-rc.2`)

### Examples:

- `v1.0.0` - First stable release
- `v1.1.0` - Minor update with new features
- `v1.1.1` - Patch release with bug fixes
- `v2.0.0-beta.1` - Beta pre-release for major version
- `v1.2.0-rc.1` - Release candidate

## Pre-releases

Releases containing the following keywords are automatically marked as pre-releases:

- `alpha`
- `beta`
- `rc` (release candidate)
- `dev`

## Release Assets

Each release includes:

- 📦 `kgc-toolkit-{version}.tar.gz` - Compressed source archive
- 📦 `kgc-toolkit-{version}.zip` - ZIP source archive
- 📄 `install.sh` - Installation script
- 📋 Automatic changelog based on commits

## Changelog Generation

Changelogs are automatically generated from commit messages. For better changelogs, use conventional commit messages:

```bash
feat: add new APK extraction feature
fix: resolve issue with config parsing
docs: update installation instructions
chore: update dependencies
```

## Monitoring Releases

- 👀 **Actions Tab**: Monitor workflow progress at `https://github.com/your-repo/actions`
- 📋 **Releases Page**: View all releases at `https://github.com/your-repo/releases`
- 🔔 **Notifications**: Watch the repository for release notifications

## Troubleshooting

### Release Not Created

1. **Check branch name**: Must follow `v*` pattern with semantic versioning
2. **Check validation**: Review the validation workflow logs
3. **Check permissions**: Ensure GitHub Actions has write permissions
4. **Check for existing tag**: Tags must be unique

### Validation Failures

1. **Syntax errors**: Fix any issues in `install.sh`
2. **Missing files**: Ensure all required files exist
3. **Security warnings**: Review and fix flagged security issues

### Manual Cleanup

If you need to clean up a failed release:

```bash
# Delete local branch
git branch -D v1.2.3

# Delete remote branch
git push origin --delete v1.2.3

# Delete tag (if created)
git tag -d v1.2.3
git push origin --delete v1.2.3
```

## Security Considerations

The validation workflow checks for common security issues:

- ⚠️ Dangerous `rm` commands
- ⚠️ Uncontrolled `sudo` usage
- ⚠️ Pipe-to-shell patterns
- ⚠️ Overly permissive file permissions

Always review security warnings before proceeding with releases.

## Best Practices

1. **Test First**: Always test your changes before creating a release
2. **Clear Commits**: Use descriptive commit messages for better changelogs
3. **Version Bumps**: Follow semantic versioning strictly
4. **Review Changes**: Check the generated changelog before finalizing
5. **Clean Branches**: Delete release branches after successful releases

## Configuration

Release behavior can be customized by editing:

- `.github/workflows/release.yml` - Main release workflow
- `.github/workflows/validate.yml` - Validation workflow
- `.github/workflows/update-docs.yml` - Documentation updates
- `.github/release-config.sh` - Release configuration

## Support

For issues with the release process:

1. Check the GitHub Actions logs
2. Review this documentation
3. Open an issue with details about the problem
