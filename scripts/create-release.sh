#!/bin/bash

# Manual Release Creation Script for KGC Toolkit
# Usage: ./create-release.sh <version>
# Example: ./create-release.sh 1.2.3

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to display usage
usage() {
    echo "Usage: $0 <version>"
    echo "  version: Semantic version number (e.g., 1.2.3, 2.0.0-beta.1)"
    echo ""
    echo "Examples:"
    echo "  $0 1.2.3          # Create release v1.2.3"
    echo "  $0 2.0.0-beta.1   # Create pre-release v2.0.0-beta.1"
    echo ""
    echo "This script will:"
    echo "  1. Validate the version format"
    echo "  2. Create a release branch"
    echo "  3. Push the branch to trigger GitHub Actions"
    exit 1
}

# Validate input
if [ $# -ne 1 ]; then
    print_error "Version number is required"
    usage
fi

VERSION="$1"
BRANCH_NAME="v${VERSION}"

# Validate version format
if [[ ! $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.-]+)?$ ]]; then
    print_error "Invalid version format. Use semantic versioning (e.g., 1.2.3, 2.0.0-beta.1)"
    exit 1
fi

print_status "Creating release for version: $VERSION"

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    print_error "Not in a git repository"
    exit 1
fi

# Check if branch already exists
if git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
    print_error "Branch $BRANCH_NAME already exists"
    exit 1
fi

# Check if tag already exists
if git show-ref --verify --quiet "refs/tags/v$VERSION"; then
    print_error "Tag v$VERSION already exists"
    exit 1
fi

# Ensure we're on main/master branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ] && [ "$CURRENT_BRANCH" != "master" ]; then
    print_warning "Not on main/master branch. Current branch: $CURRENT_BRANCH"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Aborted"
        exit 1
    fi
fi

# Check for uncommitted changes
if [ -n "$(git status --porcelain)" ]; then
    print_warning "You have uncommitted changes"
    git status --short
    read -p "Commit changes and continue? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git add .
        git commit -m "chore: prepare for release v$VERSION"
        print_success "Changes committed"
    else
        print_error "Please commit or stash your changes first"
        exit 1
    fi
fi

# Create and switch to release branch
print_status "Creating release branch: $BRANCH_NAME"
git checkout -b "$BRANCH_NAME"

# Update version in files if they exist
if [ -f "install.sh" ]; then
    print_status "Updating version references in install.sh..."
    # You can add version updates here if your install.sh contains version info
fi

if [ -f "README.md" ]; then
    print_status "Checking README.md for version references..."
    # You can add version updates here if needed
fi

# Commit any version updates
if [ -n "$(git status --porcelain)" ]; then
    git add .
    git commit -m "chore: update version to $VERSION"
    print_success "Version updated in project files"
fi

# Push the branch
print_status "Pushing release branch to origin..."
git push -u origin "$BRANCH_NAME"

print_success "Release branch created and pushed!"
print_status "GitHub Actions will now:"
print_status "  1. Validate the release branch"
print_status "  2. Create the release tag"
print_status "  3. Generate release notes"
print_status "  4. Build and upload release assets"
print_status ""
print_status "Monitor the progress at:"
print_status "  https://github.com/$(git config --get remote.origin.url | sed 's/.*github.com[:/]\([^/]*\/[^/]*\)\.git/\1/')/actions"
print_status ""
print_warning "Remember to delete the release branch after the release is created:"
print_warning "  git checkout main && git branch -D $BRANCH_NAME && git push origin --delete $BRANCH_NAME"
