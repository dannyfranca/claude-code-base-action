#!/bin/bash

# Script 2: Finalize the sync process after successful merge
# This script pushes changes and updates the beta tag

set -e

echo "🚀 Finalizing upstream sync..."

# Push the merged changes
echo "Pushing changes to origin..."
git push origin main

# Update the beta tag
echo "Updating beta tag..."
git tag -f beta
git push origin beta --force

# Update the beta release on GitHub
echo "Updating beta release on GitHub..."
CURRENT_DATE=$(date '+%Y-%m-%d')
REPO_NAME=$(git remote get-url origin | sed 's/.*github.com[:/]\([^/]*\/[^/]*\)\.git/\1/')

# Delete existing beta release if it exists
if gh release view beta --repo "$REPO_NAME" >/dev/null 2>&1; then
    echo "Deleting existing beta release..."
    gh release delete beta --repo "$REPO_NAME" --yes
fi

# Create new beta release
echo "Creating new beta release..."
gh release create beta --repo "$REPO_NAME" \
    --title "Claude Code Github Actions beta" \
    --notes "Beta release with OAuth support for Claude Max subscribers. Synced with upstream $CURRENT_DATE." \
    --target main

# Restore stashed changes if any
if [ -f /tmp/sync-stash-status ]; then
    STASHED=$(cat /tmp/sync-stash-status | cut -d'=' -f2)
    if [ "$STASHED" = "true" ]; then
        echo "Restoring stashed changes..."
        git stash pop
    fi
    rm /tmp/sync-stash-status
fi

echo ""
echo "✅ Upstream sync completed successfully!"
echo "📌 The 'beta' tag and GitHub release have been updated to the latest commit."
echo ""
echo "Summary:"
echo "- Merged latest changes from upstream/main"
echo "- Pushed updates to origin/main"
echo "- Updated 'beta' tag to latest commit"
echo "- Updated 'beta' GitHub release for proper action usage"
