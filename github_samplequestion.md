git checkout main
git checkout -b release-cleanup
Task 2: Create Three Commits
Commit 1: Add project docs

Bash
echo "Added documentation" >> README.md
git add README.md
git commit -m "Add project docs"
Commit 2: Add temporary configuration

Bash
echo "Temporary configs" > config.txt
git add config.txt
git commit -m "Add temporary configuration"
Commit 3: Improve documentation examples

Bash
echo "Updated examples" >> README.md
git add README.md
git commit -m "Improve documentation examples"
Task 3: Squash Commits (Commit 1 + Commit 3)
Since Commit 1 and Commit 3 are separated by Commit 2, the cleanest way to combine them without touching Commit 2 yet is via an interactive rebase.

Start an interactive rebase for the last 3 commits:

Bash
git rebase -i HEAD~3
Your text editor will open showing the commits in chronological order (oldest at the top):

Plaintext
pick 1111111 Add project docs
pick 2222222 Add temporary configuration
pick 3333333 Improve documentation examples
Reorder the lines so the documentation commits are together, and change pick to squash (or s) for the second documentation commit:

Plaintext
pick 1111111 Add project docs
squash 3333333 Improve documentation examples
pick 2222222 Add temporary configuration
Save and close the editor. A second editor window will open asking for the commit message for the squashed commits. Delete the old messages and type the new required message:

Plaintext
Documentation updates
Save and close. Git will now apply the squashed documentation commit first, followed by the configuration commit.

Task 4: Revert Commit
Now you need to undo the changes made by the temporary configuration commit while keeping a record of the revert in the history.

Find the commit hash for "Add temporary configuration" using git log --oneline.

Run the revert command:

Bash
git revert <commit-hash-of-temporary-configuration>
A text editor will prompt you for a commit message. Ensure it matches the expected message exactly:

Plaintext
Revert "Add temporary configuration"
Save and close.

Task 5: Verify Git History
To verify that your history matches the requirements, run:

Bash
git log --oneline
Your final history on the release-cleanup branch should look similar to this (from newest to oldest):

Plaintext
a1b2c3d Revert "Add temporary configuration"
e5f6g7h Add temporary configuration
i9j8k7l Documentation updates