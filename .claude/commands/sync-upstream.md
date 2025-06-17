# sync-upstream

Sync this fork with the upstream Anthropic repository, merge changes, and update the beta tag.

## Steps to execute:

1. Check if upstream remote exists, add if needed:
   ```bash
   git remote add upstream https://github.com/anthropics/claude-code-base-action.git
   ```

2. Fetch latest from upstream:
   ```bash
   git fetch upstream
   ```

3. Ensure on main branch and stash any local changes

4. Merge upstream/main:
   ```bash
   git merge upstream/main --no-edit
   ```

5. If merge conflicts occur:
   - List conflicting files
   - Remind user: "This fork adds OAuth support. When resolving conflicts, ensure OAuth-related changes are preserved."
   - Ask user: "How would you like to resolve the conflicts in [file]? Please provide guidance."
   - Wait for user input before proceeding

6. After successful merge:
   - Push to origin/main
   - Update beta tag: `git tag -f beta && git push origin beta --force`

7. Report success with summary of changes merged