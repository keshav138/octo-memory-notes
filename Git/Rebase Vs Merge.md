# Git Rebase vs Merge – Complete Situational Guide

This is **the most important Git concept** to understand. Let me break down exactly **when** and **how** to use each, with real scenarios.

---

## Part 1: The Core Difference (One Simple Mental Model)

```
MERGE: "Combine histories, preserving exactly when each change happened"
REBASE: "Rewind my changes, fast-forward to latest, replay my work on top"
```

### Visual Comparison

**Starting point** (both have same history):
```
      A---B---C  (feature)
     /
D---E---F---G    (main)
```

**MERGE result** (creates merge commit H):
```
      A---B---C
     /         \
D---E---F---G---H  (main)
```

**REBASE result** (linear history, no merge commit):
```
D---E---F---G---A'---B'---C'  (feature, now on top of main)
```

**Then fast-forward merge to main**:
```
D---E---F---G---A'---B'---C'  (main)
```

---

## Part 2: When to Use Each (The Golden Rule)

| Situation | Use | Why |
|-----------|-----|-----|
| **Public/main branch** (shared by team) | NEVER rebase | Rewriting shared history breaks everyone else's work |
| **Your personal feature branch** (not shared) | Rebase | Keeps history clean, no unnecessary merge commits |
| **Integrating feature into main** | Merge (or squash+merge) | Preserves context of when feature was completed |
| **Updating your branch with latest main** | Rebase | Avoids "merge pollution" on your feature branch |
| **Team feature branch** (multiple people) | Merge | Rebase would require force push and coordination |
| **Open source PR** (reviewer wants clean history) | Rebase before merge | Maintainer prefers linear history |

### The Critical Rule:

```
DO NOT rebase branches that others have checked out.
DO rebase your private branches before merging.
```

---

## Part 3: Merge – Deep Dive

### What Merge Actually Does

Merge creates a **new commit** that has two parents (yours and theirs). It preserves:

- Exactly when each change happened
- Branch topology
- Who made each change

### Situation 1: Fast-Forward Merge (No divergent work)

```bash
# Feature branch is ahead of main, but main hasn't changed
git checkout main
git merge feature

# Since main hasn't moved, Git just moves pointer forward
# Result: main now points to same commit as feature
```

**Visual**:
```
Before:
main → E---F---G
                \
feature →        H---I

After fast-forward:
main → E---F---G---H---I
feature →            ↑
```

### Situation 2: Three-Way Merge (Main has new commits)

```bash
# Both branches have new work
git checkout main
git merge feature

# Git creates a merge commit (has 2 parents)
git commit -m "Merge feature into main"
```

**Visual**:
```
Before:
      A---B---C  (feature)
     /
D---E---F---G    (main)

After:
      A---B---C
     /         \
D---E---F---G---M  (main, M is merge commit)
```

### Situation 3: Merge with Conflicts

```bash
# Both branches changed same file
git checkout main
git merge feature

# CONFLICT in app.py

# See conflicts
git status
# both modified: app.py

# Open app.py - shows:
<<<<<<< HEAD
print("Main version")
=======
print("Feature version")
>>>>>>> feature

# Fix by editing (choose one or combine):
print("Combined version")

# Mark resolved
git add app.py

# Complete merge
git commit -m "Merge feature: resolve conflict in app.py"
```

### Merge Options

```bash
# Always create merge commit (even if fast-forward possible)
git merge --no-ff feature

# Squash all feature commits into one commit
git merge --squash feature
git commit -m "Add feature X (squashed)"

# Abort merge if conflicts are too messy
git merge --abort
```

---

## Part 4: Rebase – Deep Dive

### What Rebase Actually Does

Rebase **rewrites history** by:
1. Finding common ancestor between your branch and target
2. Temporarily saving your commits
3. Moving your branch pointer to target's latest commit
4. Replaying your saved commits one by one

### Situation 1: Basic Rebase (Update feature branch)

```bash
# On feature branch, want latest from main
git checkout feature
git rebase main

# Git replays your commits on top of main
```

**What happens step by step**:
```
1. Before:
   main →    E---F---G
              \
   feature →   A---B---C

2. Rebase:
   main →    E---F---G
                      \
   feature →           A'---B'---C'

   Original A,B,C are abandoned (garbage collected eventually)
```

### Situation 2: Rebase with Conflicts

```bash
git checkout feature
git rebase main

# Conflict in app.py
# error: could not apply a1b2c3d... Fix login bug

# Fix the conflict
# Open app.py, resolve, then:
git add app.py

# Continue rebase
git rebase --continue

# Or skip this commit
git rebase --skip

# Or abort entirely
git rebase --abort
```

### Situation 3: Interactive Rebase (Powerful)

```bash
# Reorganize last 3 commits
git rebase -i HEAD~3

# Editor opens:
pick a1b2c3d Add login form
pick e4f5g6h Fix typo in login
pick h7i8j9k Actually implement login

# Change to:
reword a1b2c3d Add login form  # Change message
squash e4f5g6h Fix typo in login  # Combine into previous
fixup h7i8j9k Actually implement login  # Combine, discard message

# Save → Git will:
# 1. Let you edit "Add login form" message
# 2. Combine commits 2 and 3 into commit 1
# Result: 1 commit instead of 3
```

### Interactive Rebase Options

| Command | Effect |
|---------|--------|
| `pick` | Use commit as-is |
| `reword` | Change commit message |
| `edit` | Stop to amend commit content |
| `squash` | Combine with previous commit (keep message) |
| `fixup` | Combine with previous commit (discard message) |
| `drop` | Remove commit entirely |
| `reorder` | Change commit order |

### Situation 4: Rebase Onto (Different Base)

```bash
# You branched from wrong point

# Current:
#   A---B---C (feature-wrong)
#         /
#    D---E (main)
#          \
#           F---G (feature-correct)

# Move feature-wrong to be based on feature-correct
git rebase --onto feature-correct main feature-wrong

# Now feature-wrong sits on top of feature-correct
```

---

## Part 5: Critical Comparison – When to Use Each

### Real-World Scenario 1: Updating your feature branch

```bash
# You're working on feature branch for 2 days
# Meanwhile, main has 10 new commits from other developers

# OPTION A: MERGE (pollutes history)
git checkout feature
git merge main

# Result: feature branch has a "merge from main" commit
# History becomes:
#    A---B---C---M (feature)
#   /          /
# D---E---F---G (main)

# OPTION B: REBASE (clean history)
git checkout feature
git rebase main

# Result: feature appears to have been built on latest main
# History becomes:
# D---E---F---G---A'---B'---C' (feature)

# VERDICT: Use REBASE for private feature branches
```

### Real-World Scenario 2: Merging feature into main

```bash
# Feature is complete, ready to merge to main

# OPTION A: MERGE (preserves context)
git checkout main
git merge --no-ff feature

# Result: Merge commit shows when feature was integrated
#    A---B---C
#   /         \
# D---E---F---G---M (main)

# OPTION B: REBASE then fast-forward (linear but loses context)
git checkout feature
git rebase main
git checkout main
git merge feature  # Fast-forward

# Result: No evidence of when feature was completed
# D---E---F---G---A'---B'---C' (main)

# VERDICT: Use MERGE (or squash+merge) for main branch
```

### Real-World Scenario 3: Team feature branch

```bash
# You and teammate are both pushing to same feature branch

# DO NOT REBASE (would cause chaos)
# Use MERGE when pulling

git checkout feature-team
git pull origin feature-team  # This does fetch + merge
# Or manually:
git fetch origin
git merge origin/feature-team

# REBASE would require force push, breaking teammate's work
```

---

## Part 6: Practical Workflows (Copy-Paste Ready)

### Workflow A: Solo Developer (Clean History)

```bash
# Start new feature
git checkout main
git pull origin main
git checkout -b feature/new-thing

# Work... commit multiple times
git commit -am "WIP: partial work"
git commit -am "Complete feature"

# Before merging, update with latest main (use REBASE)
git fetch origin
git rebase origin/main

# Now merge to main (use MERGE --no-ff)
git checkout main
git merge --no-ff feature/new-thing

# Push
git push origin main

# Delete feature branch
git branch -d feature/new-thing
```

### Workflow B: Team Project (Merge-Based)

```bash
# Start feature
git checkout develop
git pull origin develop
git checkout -b feature/user-auth

# Work... commit
git commit -am "Add login"

# Get team's latest changes (use MERGE)
git checkout develop
git pull origin develop
git checkout feature/user-auth
git merge develop  # NOT rebase

# Resolve conflicts if any
# Continue work...

# When ready for PR
git push origin feature/user-auth

# After PR approved (on GitHub, use "Merge pull request")
# Then locally:
git checkout develop
git pull origin develop
git branch -d feature/user-auth
```

### Workflow C: Open Source Contribution

```bash
# Fork repo on GitHub, then:

# Clone your fork
git clone https://github.com/yourname/repo.git
cd repo

# Add upstream remote
git remote add upstream https://github.com/original/repo.git

# Create feature branch from latest upstream
git fetch upstream
git checkout -b feature/bug-fix upstream/main

# Work...
git commit -am "Fix bug"

# Update with latest upstream (use REBASE for clean PR)
git fetch upstream
git rebase upstream/main

# Push to your fork
git push origin feature/bug-fix

# Create Pull Request on GitHub

# If maintainer requests changes
git commit -am "Address review feedback"
git rebase upstream/main  # Again, before pushing
git push origin feature/bug-fix --force-with-lease
```

---

## Part 7: Merge vs Rebase Decision Tree

```
START: Are you updating your local branch with upstream changes?

    │
    ├── Is this branch shared with others (pushed to remote)?
    │       │
    │       ├── YES → Use MERGE (or git pull)
    │       │
    │       └── NO  → Use REBASE (cleaner history)
    │
    └── Are you integrating branch into main (via PR)?
            │
            ├── Does team prefer linear history?
            │       ├── YES → Rebase then fast-forward (rare)
            │       └── NO  → Merge (standard)
            │
            └── Does team want single commit per feature?
                    └── YES → Squash and merge (GitHub option)
```

---

## Part 8: Common Mistakes and How to Fix

### Mistake 1: Rebased shared branch, now it's broken

```bash
# You rebased feature that teammate had pulled
git checkout feature
git rebase main  # Oops, feature now has new commit SHAs
git push --force  # Double oops

# Teammate now has diverged history

# FIX: On your machine, force push is already done
# Teammate must recover:
git fetch origin
git checkout feature
git reset --hard origin/feature  # Discard their local work

# OR to save their work:
git checkout feature
git branch feature-backup  # Backup
git fetch origin
git reset --hard origin/feature
# Then reapply their changes manually
```

### Mistake 2: Merge instead of rebase (dirty history)

```bash
# You did this:
git checkout feature
git merge main  # Created merge commit on feature

# Now feature has unnecessary merge commits

# FIX (if not pushed):
git checkout feature
git reset --hard HEAD~1  # Remove merge commit
git rebase main  # Do it correctly

# If already pushed:
git checkout feature
git rebase main
git push --force-with-lease  # Force push (warn team)
```

### Mistake 3: Confused during rebase

```bash
# You're in middle of rebase, conflicts are too complex

# Option 1: Abort and try merge instead
git rebase --abort
git merge main  # Use merge instead

# Option 2: Skip problematic commit
git rebase --skip

# Option 3: Continue after fixing
# Fix conflicts
git add .
git rebase --continue
```

---

## Part 9: Advanced Rebase Tricks

### Trick 1: Auto-squash commits

```bash
# Make commits with special message format
git commit -m "Add login feature"
git commit -m "fixup! Add login feature"  # Will auto-squash
git commit -m "WIP: email validation"

# Later, interactive rebase with --autosquash
git rebase -i --autosquash HEAD~3

# Git automatically marks fixup commits to be squashed
```

### Trick 2: Rebase multiple branches

```bash
# After rebasing feature1 on main, feature2 (based on old feature1) also needs update

# Before:
# main → A---B
#          \
# feature1 → C---D (old)
#                \
# feature2 →      E---F

# After rebasing feature1:
# main → A---B
#          \
# feature1 → C'---D'

# Update feature2:
git checkout feature2
git rebase --onto feature1 C D  # feature2's base moves from C to C'
```

### Trick 3: Rebase with exec (run commands between commits)

```bash
# Test each commit individually
git rebase -i HEAD~3 --exec "pytest"

# In editor, each commit will be followed by test execution
```

---

## Part 10: Team Agreement Template

Share this with your team to avoid conflicts:

```markdown
# Git Workflow Agreement

## Main/Develop branches
- NEVER rebase
- ONLY merge via PR (no direct pushes)
- Use Squash and Merge for PRs (GitHub) or --squash

## Feature branches
- REBASE on main/develop before creating PR
- NEVER rebase after others have started working on it
- Push frequently to remote (backup)

## Before pushing to shared feature branch
- git pull --rebase (if team agrees)
- OR git merge (safer for beginners)

## When in doubt
- git merge (safe, never rewrites history)
- git rebase (only on local/unpushed commits)
```

---

## Quick Reference Card

| Action | Command | Safe for shared branch? |
|--------|---------|------------------------|
| Update feature with main | `git rebase main` (on feature) | NO (unless exclusive) |
| Update feature with main | `git merge main` (on feature) | YES |
| Merge feature to main | `git merge --no-ff feature` (on main) | YES |
| Merge with linear history | `git rebase main` then `git merge` | NO (rewrites feature) |
| Abort in-progress rebase | `git rebase --abort` | N/A |
| Continue after conflict | `git add .` then `git rebase --continue` | N/A |
| Skip problematic commit | `git rebase --skip` | N/A |

---

**The Bottom Line**:
- **Use MERGE** when others might have your branch
- **Use REBASE** to clean up your work before sharing
- **When on a team**, default to merge unless you know rebase won't cause problems

Now you're ready for any real-world Git situation involving rebase or merge!