#!/bin/bash

set -e

echo "🔄 Starting upstream sync process..."

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
    STASHED=true
else
    STASHED=false
fi

# Attempt to merge upstream
echo "Attempting to merge upstream/main..."
if git merge upstream/main --no-edit; then
    echo "✅ Merge completed successfully!"
else
    echo "⚠️  Merge conflicts detected!"
    echo ""
    echo "CONFLICT RESOLUTION NEEDED:"
    echo "=========================="
    echo ""
    echo "The following files have conflicts:"
    git diff --name-only --diff-filter=U
    echo ""
    echo "Please resolve the conflicts manually. The fork adds OAuth support,"
    echo "so when resolving conflicts, ensure OAuth-related changes are preserved."
    echo ""
    echo "After resolving conflicts:"
    echo "1. Stage the resolved files: git add <resolved-files>"
    echo "2. Complete the merge: git commit"
    echo "3. Push to origin: git push origin main"
    echo "4. Update the beta tag: git tag -f beta && git push origin beta --force"
    echo ""
    echo "If you're unsure how to resolve specific conflicts, please ask for guidance."
    exit 1
fi

# Push the merged changes
echo "Pushing changes to origin..."
git push origin main

# Update the beta tag
echo "Updating beta tag..."
git tag -f beta
git push origin beta --force

# Restore stashed changes if any
if [ "$STASHED" = true ]; then
    echo "Restoring stashed changes..."
    git stash pop
fi

echo ""
echo "✅ Upstream sync completed successfully!"
echo "📌 The 'beta' tag has been updated to the latest commit."
echo ""
echo "Summary:"
echo "- Merged latest changes from upstream/main"
echo "- Pushed updates to origin/main"
echo "- Updated 'beta' tag to latest commit"