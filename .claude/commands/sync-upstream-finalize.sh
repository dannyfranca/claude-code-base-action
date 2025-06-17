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
echo "📌 The 'beta' tag has been updated to the latest commit."
echo ""
echo "Summary:"
echo "- Merged latest changes from upstream/main"
echo "- Pushed updates to origin/main"
echo "- Updated 'beta' tag to latest commit"