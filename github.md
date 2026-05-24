commands with one line
Command	One-line Description
git init	Initialize a new Git repository
git clone <url>	Copy a GitHub repository to local system
git status	Show changed and untracked files
git add <file>	Add a specific file to staging area
git add .	Add all files to staging area
git commit -m "msg"	Save staged changes with message
git log	Show full commit history
git log --oneline	Show short commit history
git branch	List all branches
git branch <name>	Create a new branch
git checkout <branch>	Switch to another branch
git checkout -b <name>	Create and switch branch together
git merge <branch>	Merge branch into current branch
git branch -d <branch>	Delete a branch
git remote add origin <url>	Connect local repo to GitHub
git remote -v	Show connected remote repositories
git push origin main	Upload code to GitHub
git pull origin main	Download and merge latest changes
git fetch	Download latest changes without merging
git diff	Show file changes line by line
git restore <file>	Discard changes in a file
git reset --soft HEAD~1	Undo last commit but keep changes
git reset --hard HEAD~1	Delete last commit and changes
git revert <id>	Reverse a commit safely
git stash	Temporarily save uncommitted changes
git stash pop	Restore stashed changes
git stash list	Show all saved stashes
git tag	Show all tags
git tag v1.0	Create a version tag
git push origin v1.0	Push tag to GitHub
git show	Show details of a commit
git clean -f	Remove untracked files
git cherry-pick <id>	Copy commit from another branch
git rebase main	Move commits on top of main branch
git config --global user.name "Name"	Set global Git username
git config --global user.email "mail"	Set global Git email