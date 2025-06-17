#!/bin/bash

# Script 1: Attempt to sync and merge with upstream
# Exit codes: 0 = success, 1 = merge conflicts, 2 = other error

set -e

echo "🔄 Starting upstream sync and merge..."

# Check if upstream remote exists
if ! git remote | grep -q "^upstream$"; then
    echo "Adding upstream remote..."
    git remote add upstream https://github.com/anthropics/claude-code-base-action.git
fi

# Fetch latest from upstream
echo "Fetching latest changes from upstream..."
git fetch upstream

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)

# Ensure we're on main branch
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "Switching to main branch..."
    git checkout main
fi

# Stash any local changes
if ! git diff-index --quiet HEAD --; then
    echo "Stashing local changes..."
    git stash push -m "Auto-stash before upstream sync"
    echo "STASHED=true" > /tmp/sync-stash-status
else
    echo "STASHED=false" > /tmp/sync-stash-status
fi

# Attempt to merge upstream
echo "Attempting to merge upstream/main..."
if git merge upstream/main --no-edit; then
    echo "✅ Merge completed successfully!"
    exit 0
else
    echo "⚠️  Merge conflicts detected!"
    echo ""
    echo "Conflicting files:"
    git diff --name-only --diff-filter=U
    exit 1
fi