# sync-upstream

Sync this fork with the upstream Anthropic repository, merge changes, and update the beta tag.

## Two-step process:

### Step 1: Attempt merge
```bash
./.claude/commands/sync-upstream-merge.sh
```

**If successful (exit code 0)**: Automatically proceed to Step 2.

**If conflicts (exit code 1)**: 
1. Show conflicting files from script output
2. Show conflict details using `git diff`
3. Remind user: "This fork adds OAuth support. When resolving conflicts, ensure OAuth-related changes are preserved."
4. Ask: "The merge has conflicts in these files: [list]. How would you like me to resolve them? You can:
   - Show you the conflicting sections for review
   - Provide specific resolution instructions
   - Guide me through accepting certain changes"
5. After resolving conflicts:
   - Stage resolved files: `git add <files>`
   - Complete merge: `git commit`
   - Proceed to Step 2

**If other errors (exit code 2)**: Report error and ask for guidance.

### Step 2: Finalize sync
```bash
./.claude/commands/sync-upstream-finalize.sh
```

This script:
- Pushes changes to origin/main
- Updates the beta tag
- Restores any stashed changes
- Reports completion summary