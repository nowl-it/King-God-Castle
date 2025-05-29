#!/bin/bash

# Release Configuration for KGC Toolkit

# This file defines the release process configuration
# Edit these values to customize your release behavior

# Release settings
RELEASE_BRANCH_PATTERN="v*"
PRERELEASE_PATTERNS=("alpha" "beta" "rc" "dev")

# Archive settings
ARCHIVE_EXCLUDE_PATTERNS=(
    ".git*"
    "dist/*"
    ".github/*"
    "*.tmp"
    "*.log"
    "node_modules/*"
    ".DS_Store"
    "Thumbs.db"
)

# Files to include in release assets
RELEASE_ASSETS=(
    "install.sh"
    "README.md"
    "LICENSE"
)

# Changelog settings
CHANGELOG_SECTIONS=(
    "Features"
    "Bug Fixes"
    "Documentation"
    "Dependencies"
    "Breaking Changes"
)

# Commit message conventions for changelog generation
COMMIT_TYPES=(
    "feat:Features"
    "fix:Bug Fixes"
    "docs:Documentation"
    "deps:Dependencies"
    "breaking:Breaking Changes"
    "chore:Maintenance"
)

# Security patterns to check in install.sh
SECURITY_PATTERNS=(
    "rm -rf /"
    "sudo rm"
    "chmod 777"
    "curl.*|.*sh"
    "wget.*|.*sh"
    "eval.*\$"
)

# Release validation requirements
REQUIRED_FILES=(
    "install.sh"
    "README.md"
    "LICENSE"
)

# Documentation update patterns
DOC_VERSION_PATTERNS=(
    "version-[^-]*-blue"
    "curl.*install\.sh"
    "wget.*releases/download"
)
