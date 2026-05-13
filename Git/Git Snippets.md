# Git – Complete Situational Guide with Examples

Not just commands — **real situations** you'll face, with exact solutions.

---

## Part 1: Basic Setup & Initialization

### Situation 1: Starting a new project locally

```bash
# Create project directory
mkdir my-flask-app
cd my-flask-app

# Initialize git repository
git init

# Check status (see what git sees)
git status

# Output: 
# On branch master
# No commits yet
# nothing to commit
```

### Situation 2: First commit (after creating files)

```bash
# Create a file
echo "print('Hello World')" > app.py

# See what changed
git status
# On branch master
# Untracked files: app.py

# Stage the file (prepare for commit)
git add app.py

# Or stage all files
git add .

# Check staged changes
git status
# Changes to be committed: new file: app.py

# Commit (save to history)
git commit -m "Initial commit: add app.py"

# See commit history
git log --oneline
# a1b2c3d Initial commit: add app.py
```

### Situation 3: Connecting to remote repository (GitHub)

```bash
# After creating empty repo on GitHub (no README, no .gitignore)

# Add remote origin
git remote add origin https://github.com/yourusername/my-flask-app.git

# Verify remote
git remote -v
# origin  https://github.com/yourusername/my-flask-app.git (fetch)
# origin  https://github.com/yourusername/my-flask-app.git (push)

# Push to GitHub (first time)
git push -u origin main

# After this, just use:
git push
```

### Situation 4: Cloning existing repository

```bash
# Clone someone else's repo
git clone https://github.com/username/repo-name.git

# Clone into specific directory
git clone https://github.com/username/repo-name.git my-custom-folder

# Clone specific branch
git clone -b develop https://github.com/username/repo-name.git

# After cloning, you automatically have remote set up
git remote -v
# Shows origin pointing to cloned URL
```

---

## Part 2: Daily Workflow (Add, Commit, Push)

### Situation 5: Making multiple changes (best practices)

```bash
# You've edited 3 files: app.py, README.md, and added config.py

# See what changed
git status
# modified: app.py
# modified: README.md
# new file:   config.py

# See actual changes
git diff app.py  # Shows what changed in app.py
git diff --staged  # Shows staged changes

# Stage files individually (recommended for clarity)
git add app.py
git commit -m "Update app.py with error handling"

git add README.md
git commit -m "Update README with setup instructions"

git add config.py
git commit -m "Add config.py with environment variables"

# Or stage and commit together
git commit -am "Update all files"  # Only works for modified files (not new)

# Push all commits
git push
```

### Situation 6: Forgot to add a file to last commit

```bash
# You committed but forgot to include database.py

git add database.py
git commit --amend --no-edit  # Add to previous commit without changing message

# Or change message as well
git commit --amend -m "Add database.py and fix app routing"
```

### Situation 7: Wrong commit message

```bash
# Last commit has typo in message
git commit --amend -m "Fix authentication bug (was 'authetnication')"

# For older commits (interactive rebase)
git rebase -i HEAD~3  # Last 3 commits
# Change 'pick' to 'reword' for the commit you want to change
```

---

## Part 3: Branching Fundamentals

### Situation 8: Creating and switching branches

```bash
# List all branches (* shows current branch)
git branch
# * main

# Create new branch (stays on current branch)
git branch feature-login

# Switch to new branch
git checkout feature-login
# Or create and switch in one command
git checkout -b feature-login

# Now you're on feature-login branch
git branch
#   main
# * feature-login

# Make changes on this branch
echo "def login(): pass" >> auth.py
git add auth.py
git commit -m "Add login function"

# Switch back to main
git checkout main
# Notice: auth.py is NOT in main (good - branches are isolated)
```

### Situation 9: Branch visualization (understand what's happening)

```bash
# See branch graph
git log --oneline --graph --all

# Output:
# * a1b2c3d (feature-login) Add login function
# * e4f5g6h (main) Initial commit

# Better visualization
git log --oneline --graph --all --decorate

# Or use alias (set once)
git config --global alias.tree "log --oneline --graph --all --decorate"
git tree
```

### Situation 10: Switching branches with uncommitted changes

#### Case A: You want to keep changes (stash them)

```bash
# On feature-login branch, you have uncommitted changes
git status
# modified: auth.py (not staged)

# You need to switch to main urgently

# Save changes temporarily
git stash save "WIP: login validation"

# Now switch safely
git checkout main

# Do what you need on main...

# Return to feature-login
git checkout feature-login

# Restore your changes
git stash pop  # Applies and removes from stash
# Or keep in stash: git stash apply
```

#### Case B: You want to discard changes (start fresh)

```bash
# On feature-login, you messed up auth.py
git status
# modified: auth.py

# Discard changes completely (CANNOT recover)
git checkout -- auth.py
# Or discard all changes
git restore .

# Verify it's gone
git status
# nothing to commit, working tree clean
```

#### Case C: You want to commit changes first

```bash
# Finish what you're doing
git add auth.py
git commit -m "Complete login validation"

# Now switch branches safely
git checkout main
```

#### Case D: You want to move changes to a different branch

```bash
# On main, you started working but realized you should be on feature-login

# Stash changes
git stash

# Switch to correct branch
git checkout -b feature-login

# Apply stashed changes
git stash pop

# Now commit on correct branch
git add .
git commit -m "Add login feature"
```

---

## Part 4: Branch Workflows (Common Patterns)

### Situation 11: Feature branch workflow (standard dev process)

```bash
# Start from updated main
git checkout main
git pull origin main  # Get latest changes from remote

# Create feature branch
git checkout -b feature-payment-integration

# Work on feature (multiple commits)
echo "def process_payment(): pass" >> payment.py
git add payment.py
git commit -m "Add payment processing stub"

echo "def validate_card(): pass" >> payment.py
git add payment.py
git commit -m "Add card validation"

# Push feature branch to remote (for backup or collaboration)
git push -u origin feature-payment-integration

# Continue working...

# When feature is complete, merge back to main
git checkout main
git pull origin main  # Get any new changes from team

git merge feature-payment-integration

# Delete feature branch (local)
git branch -d feature-payment-integration

# Delete remote branch
git push origin --delete feature-payment-integration
```

### Situation 12: Multiple people working on same feature

```bash
# You're on feature-payment with a teammate

# Start with latest
git checkout feature-payment
git pull origin feature-payment  # Get teammate's changes

# Make your changes
echo "def calculate_tax(): pass" >> payment.py
git commit -am "Add tax calculation"

# Push your changes
git push origin feature-payment

# If teammate pushed before you:
git push
# ERROR: rejected (non-fast-forward)

# Pull their changes first
git pull origin feature-payment

# Git might auto-merge or show conflict
# If conflicts:
git status  # Shows conflicted files
# Edit files to resolve conflicts (remove <<<<, ====, >>>>)
git add .
git commit -m "Merge teammate's changes"

# Now push
git push origin feature-payment
```

### Situation 13: Hotfix branch (urgent production fix)

```bash
# Production has a bug, you're on feature branch

# Stash or commit current work
git stash  # Save incomplete work

# Create hotfix from main (production branch)
git checkout main
git pull origin main
git checkout -b hotfix-critical-bug

# Fix the bug
echo "FIX: null pointer exception" >> app.py
git commit -am "Fix critical null pointer bug"

# Deploy hotfix (merge to main)
git checkout main
git merge hotfix-critical-bug
git push origin main

# Also merge to develop (if you have one)
git checkout develop
git merge hotfix-critical-bug

# Delete hotfix branch
git branch -d hotfix-critical-bug

# Go back to your feature work
git checkout feature-payment
git stash pop  # Restore saved work
```

### Situation 14: Release branch (preparing for deployment)

```bash
# Develop branch is ready for release
git checkout -b release/v1.2.0 develop

# Final tweaks (version numbers, docs)
echo "version='1.2.0'" >> version.py
git commit -am "Bump version to 1.2.0"

# Fix last-minute bugs
echo "FIX: release-blocker" >> app.py
git commit -am "Fix release blocker"

# Merge to main (production)
git checkout main
git merge release/v1.2.0
git tag -a v1.2.0 -m "Release version 1.2.0"
git push origin main --tags

# Merge back to develop
git checkout develop
git merge release/v1.2.0

# Delete release branch
git branch -d release/v1.2.0
```

---

## Part 5: Complex Branch Situations

### Situation 15: Accidentally committed to wrong branch

```bash
# You made commits on main but meant to be on feature branch

# Before pushing to remote:
git log --oneline -3
# a1b2c3d (HEAD -> main) Add payment feature
# e4f5g6h Add login feature
# h7i8j9k Initial commit

# Create new branch at current position
git branch feature-payment

# Reset main to previous state (remove last 2 commits)
git reset --hard HEAD~2

# Now main is clean, commits are only on feature-payment
git checkout feature-payment
git log --oneline -2
# a1b2c3d Add payment feature
# e4f5g6h Add login feature

# Push feature branch
git push -u origin feature-payment
```

### Situation 16: Multiple commits, need to reorganize

```bash
# You have 4 messy commits on feature branch

git log --oneline -4
# d1e2f3g Fix typo in login
# c9d8e7f Actually fix null pointer
# b5c6d7e Fix bug (temporary)
# a1b2c3d Add login feature

# Reorganize last 4 commits
git rebase -i HEAD~4

# In editor, reorder/squash:
# pick a1b2c3d Add login feature
# squash b5c6d7e Fix bug (temporary)
# squash c9d8e7f Actually fix null pointer
# fixup d1e2f3g Fix typo in login

# After saving, you have 1 clean commit
git log --oneline -1
# x1y2z3w Add login feature with bug fixes
```

### Situation 17: Merge conflicts (real example)

```bash
# Trying to merge feature into main
git checkout main
git merge feature-login

# CONFLICT in app.py
# Automatic merge failed; fix conflicts and then commit

# See conflicted files
git status
# both modified: app.py

# Open app.py, you'll see:
<<<<<<< HEAD
print("Welcome to main")
=======
print("Welcome to login feature")
>>>>>>> feature-login

# Edit file to resolve (choose one or combine):
print("Welcome to the app")

# Mark as resolved
git add app.py

# Complete merge
git commit -m "Merge feature-login: resolve conflict in app.py"
```

### Situation 18: Rebase (cleaner history than merge)

```bash
# Instead of merge (which creates merge commit), use rebase

# On feature branch
git checkout feature-login
git rebase main

# Git replays your commits on top of main
# If conflicts:
git status  # Shows conflicted files
# Fix conflicts
git add .
git rebase --continue

# When done, feature branch is now ahead of main
git checkout main
git merge feature-login  # Fast-forward (no merge commit)
```

### Situation 19: Cherry-picking (copy specific commits)

```bash
# You need only one commit from another branch

# Find the commit hash
git log feature-payment --oneline
# a1b2c3d Fix payment rounding bug
# e4f5g6h Add tax calculation

# Copy only the bug fix to current branch
git cherry-pick a1b2c3d

# Cherry-pick multiple commits
git cherry-pick a1b2c3d e4f5g6h

# Cherry-pick range
git cherry-pick a1b2c3d..e4f5g6h
```

### Situation 20: Lost commit (reflog to rescue)

```bash
# You did git reset --hard and lost commits

# Find lost commits
git reflog
# a1b2c3d HEAD@{0}: reset: moving to HEAD~2
# e4f5g6h HEAD@{1}: commit: Fix login bug
# h7i8j9k HEAD@{2}: commit: Add password reset

# Create branch at lost commit
git branch rescue-branch e4f5g6h

# Or reset back
git reset --hard e4f5g6h
```

---

## Part 6: Remote Branch Operations

### Situation 21: See all remote branches

```bash
# Fetch latest from remote
git fetch --all

# List remote branches
git branch -r
# origin/main
# origin/develop
# origin/feature-login
# origin/feature-payment

# List all branches (local + remote)
git branch -a
```

### Situation 22: Track remote branch

```bash
# Remote has feature-api branch, you want to work on it

# Fetch remote branches
git fetch origin

# Create local branch tracking remote
git checkout -b feature-api origin/feature-api
# Or shorthand
git checkout --track origin/feature-api

# Now git pull/push will know remote
git pull  # Pulls from origin/feature-api
git push  # Pushes to origin/feature-api
```

### Situation 23: Delete remote branch

```bash
# Delete from remote
git push origin --delete feature-old

# Delete local tracking branch
git branch -d feature-old  # Only if merged
git branch -D feature-old  # Force delete (even if not merged)

# Clean up remote-tracking references
git remote prune origin
```

### Situation 24: Force push (be careful!)

```bash
# You rebased feature branch and now history differs

git checkout feature-login
git rebase main

# Now push fails
git push origin feature-login
# rejected: non-fast-forward

# Force push (overwrites remote)
git push origin feature-login --force
# Or safer: force with lease (fails if others pushed)
git push origin feature-login --force-with-lease
```

---

## Part 7: Undoing Changes (Different Levels)

### Situation 25: Undo local changes (before commit)

```bash
# File level: discard changes
git checkout -- app.py
# Or using restore (newer git)
git restore app.py

# All files: discard all changes
git restore .
git clean -fd  # Remove untracked files/directories
```

### Situation 26: Unstage files (before commit)

```bash
# You added file by mistake
git add app.py  # Oops, shouldn't have staged this

# Unstage (keep changes)
git reset app.py
git restore --staged app.py  # Newer syntax

# Unstage everything
git reset
```

### Situation 27: Undo last commit (keep changes)

```bash
# Last commit was wrong, but keep changes in working directory
git reset --soft HEAD~1

# Changes are now staged (git add was done)
# Edit, then re-commit
git commit -m "Fixed commit message"
```

### Situation 28: Undo last commit (discard changes completely)

```bash
# Last commit was trash, delete it and changes
git reset --hard HEAD~1

# Commit is gone, changes are gone
```

### Situation 29: Revert (safe undo after pushing)

```bash
# You pushed bad commit, others may have pulled

# Create inverse commit (keeps history)
git revert a1b2c3d

# Git creates new commit that undoes a1b2c3d
git push origin main

# Now history shows both bad commit and revert commit
```

---

## Part 8: Stashing Deep Dive

### Situation 30: Multiple stashes

```bash
# Work on feature A
echo "code A" >> app.py
git stash save "WIP: Feature A"

# Work on feature B
echo "code B" >> app.py
git stash save "WIP: Feature B"

# List stashes
git stash list
# stash@{0}: WIP: Feature B
# stash@{1}: WIP: Feature A

# Apply specific stash
git stash apply stash@{1}  # Feature A

# Diff between stash and current
git stash show -p stash@{0}
```

### Situation 31: Stash untracked files

```bash
# You have new files not yet added
git status
# Untracked files: newfile.txt

# Normal stash ignores untracked
git stash  # newfile.txt still there

# Stash including untracked
git stash -u  # or --include-untracked

# Stash everything (including ignored)
git stash -a  # --all
```

### Situation 32: Create branch from stash

```bash
# You stashed work but need to branch it

git stash branch new-feature stash@{0}
# Creates branch, checks it out, applies stash
```

---

## Part 9: Real-World Team Workflows

### Workflow 1: Feature Branch (Standard)

```bash
# Daily routine
git checkout main
git pull origin main           # Get latest
git checkout -b feature/abc-123 # New branch for ticket

# Work, commit multiple times
git add .
git commit -m "Partial work"

git add .
git commit -m "Complete feature"

# Push to remote for backup/PR
git push -u origin feature/abc-123

# After PR approved, merge
git checkout main
git pull origin main
git merge feature/abc-123
git push origin main
git branch -d feature/abc-123
```

### Workflow 2: GitFlow (Structured)

```bash
# Start feature from develop
git checkout develop
git pull origin develop
git checkout -b feature/user-auth

# ... work ...

# Finish feature (merge to develop)
git checkout develop
git merge --no-ff feature/user-auth
git push origin develop

# Start release
git checkout -b release/1.2.0 develop

# ... bug fixes ...

# Finish release
git checkout main
git merge --no-ff release/1.2.0
git tag -a v1.2.0 -m "Release 1.2.0"

git checkout develop
git merge --no-ff release/1.2.0

# Hotfix from main
git checkout -b hotfix/critical main
# ... fix ...
git checkout main
git merge --no-ff hotfix/critical
git tag -a v1.2.1 -m "Hotfix 1.2.1"

git checkout develop
git merge --no-ff hotfix/critical
```

### Workflow 3: Pull Request Flow (GitHub/GitLab)

```bash
# Developer
git checkout -b feature/new-thing main
git commit -am "Add new thing"
git push origin feature/new-thing

# Create PR on GitHub

# After approval (on PR page, squash merge)
# Then locally:
git checkout main
git pull origin main
git branch -d feature/new-thing
```

---

## Part 10: Git Aliases (Save Time)

```bash
# Set aliases (once)
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.tree 'log --oneline --graph --all'

# Use them
git co main
git br feature-x
git ci -m "Message"
git st
git unstage app.py
git last
git tree
```

---

## Cheat Sheet: When to Use What

| I want to... | Command |
|--------------|---------|
| Start tracking this folder | `git init` |
| See what changed | `git status` |
| Stage file for commit | `git add <file>` |
| Save staged changes | `git commit -m "msg"` |
| Upload to remote | `git push` |
| Download from remote | `git pull` |
| Create branch | `git branch <name>` |
| Switch to branch | `git checkout <name>` |
| Create + switch | `git checkout -b <name>` |
| Merge branch into current | `git merge <branch>` |
| Save work temporarily | `git stash` |
| Restore stashed work | `git stash pop` |
| Discard file changes | `git restore <file>` |
| Unstage file | `git restore --staged <file>` |
| Undo last commit (keep changes) | `git reset --soft HEAD~1` |
| Undo last commit (discard) | `git reset --hard HEAD~1` |
| Safely undo pushed commit | `git revert <commit>` |
| See lost commits | `git reflog` |
| Copy commit from elsewhere | `git cherry-pick <commit>` |
| See branch history visually | `git log --oneline --graph --all` |

---

**Ready for the Jenkins + Git + Docker + AWS integration practice?** You now have all the Git situations covered for real team work.