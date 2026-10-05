# Hope Foundation: Git Protocol and Cheat Sheet

Version 1.0, 5 October 2026. Branch model, daily loop, VS Code steps and recovery commands for this repository. Mian also has this as a PDF.

# 1. The branch model

```
main      production. Only Nadeem merges into it (develop -> main). You never touch it.
  ^
develop   integration. Your pull requests land here after Nadeem reviews them.
  ^
feature/mian/<what-you-are-doing>   one branch per task, created from develop, deleted after merge.
```

Rules:

- One task, one branch, named `feature/mian/<short-kebab-case-description>`. Examples: `feature/mian/fix-web-defects`, `feature/mian/schema-dump`, `feature/mian/bcrypt-passwords`, `feature/mian/ci-pipeline`.
- Branches start from an up-to-date `develop`, never from another feature branch and never from `main`.
- Work reaches `develop` only through a pull request that Nadeem approves. You may merge the PR once it is approved and checks are green.
- Never commit directly on `develop` or `main`. GitHub rules block it; if you try, the push is rejected.
- `develop` to `main` is Nadeem's job.
- Repository layout: `client.hope-foundation/` is the Expo mobile app, `service.hope-foundation/` is the Next.js website and backend. Both live in one repository, so one branch and one PR can touch both when a change needs it.

# 2. Local versus origin

`origin` is the copy on GitHub. Your Mac has its own copy. They drift apart every time someone commits, and Git never syncs them for you.

| Name | What it is |
|---|---|
| `develop` | Your local branch. Only changes when you commit or pull. |
| `origin/develop` | Your Mac's last known picture of GitHub's `develop`. Updated by fetch or pull. |
| Fetch | Download what changed on GitHub without touching your files. Safe, always. |
| Pull | Fetch, then merge GitHub's commits into your current branch. |
| Push | Upload your commits to GitHub. Rejected if GitHub has commits you do not have yet (pull first). |

What the VS Code status bar is telling you:

| You see | Meaning | Do |
|---|---|---|
| `↓ 3` next to the sync icon | GitHub has 3 commits you do not have | Pull (click the sync icon) |
| `↑ 2` | You have 2 commits not on GitHub | Push (click the sync icon) |
| `↓ 3 ↑ 2` | Both moved; the branches diverged | Pull first, resolve any conflict, then push |
| A cloud icon with an arrow ("Publish Branch") | Your branch exists only on your Mac | Publish it |
| "Your branch is behind 'origin/develop'" in the terminal | Same as `↓ n` | `git pull` |

Protocol: pull before you start, pull before you push, and update your feature branch from `develop` before opening a pull request.

# 3. One-time setup on your Mac

1. Install the command-line tools (includes Git): open Terminal and run `xcode-select --install`.
2. Install VS Code and these extensions: GitHub Pull Requests (by GitHub), GitLens (optional, shows who changed what), ESLint, Prettier, Expo Tools.
3. Identify yourself (use the same email as your GitHub account):

```bash
git config --global user.name "Mian <Surname>"
git config --global user.email "you@example.com"
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global credential.helper osxkeychain
```

4. Sign in to GitHub inside VS Code (Accounts icon, bottom left). Accept Nadeem's collaborator invitation first.
5. Clone with HTTPS and open the folder:

```bash
cd ~/Developer
git clone https://github.com/DeemTheDev/Full-Stack---Web-Mobile.git
cd Full-Stack---Web-Mobile
git checkout develop
code .
```

6. Install dependencies: `cd service.hope-foundation && npm install`, then `cd ../client.hope-foundation && npm install`.
7. Create your local secret files from the tracked placeholders: copy `service.hope-foundation/.env` to `service.hope-foundation/.env.local` and fill in the real values Nadeem gives you; for the mobile app put real values in `client.hope-foundation/.env.local`. The `.local` files are ignored by Git.

# 4. The daily loop

Every step shows the terminal command and the VS Code equivalent. Use whichever you prefer; the result is the same.

| Step | Terminal | VS Code |
|---|---|---|
| 1. Start on fresh `develop` | `git checkout develop` then `git pull` | Click the branch name in the status bar, pick `develop`, click the sync icon |
| 2. Create your task branch | `git checkout -b feature/mian/schema-dump` | Branch name in status bar → Create new branch from… → type the name → choose `develop` |
| 3. Work and commit small | `git add -p` (review hunks) then `git commit -m "feat(service): dump schema to db/schema.sql"` | Source Control view: hover a file, click `+` to stage, type the message, click Commit |
| 4. Push the branch | first time `git push -u origin feature/mian/schema-dump`; afterwards `git push` | Click Publish Branch the first time; afterwards click the sync icon |
| 5. Before the PR, update from develop | `git pull origin develop` (resolve conflicts if any, see Section 6), then `npx tsc --noEmit` and `npm run lint` in the app you changed | Terminal panel inside VS Code (Ctrl+`) |
| 6. Open the pull request to `develop` | `gh pr create --base develop` if you install the GitHub CLI | GitHub Pull Requests view → Create Pull Request → base `develop`, compare your branch; or the "Create Pull Request" button that appears after publishing |
| 7. Respond to review | Commit and push again; the PR updates by itself | Same |
| 8. After the merge, clean up | `git checkout develop`, `git pull`, `git branch -d feature/mian/schema-dump` | Status bar → `develop` → sync; delete the old branch from the branch picker |

Commit messages follow Conventional Commits: `type(scope): short imperative summary`. Types: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`. Scopes: `client`, `service`, `repo`. Example: `fix(client): throw on non-OK responses in fetchAPI (M-06)`. Mention the issue ID from the Project Brief when there is one.

Pull request description: What changed, Why (issue ID), How you tested it, Screenshots for UI. Keep PRs small (under 300 changed lines when you can). Draft PRs are welcome for early feedback.

# 5. Where things are in VS Code

| You want to | Where |
|---|---|
| See changed files, stage, commit | Source Control view (icon in the left bar, or Ctrl+Shift+G) |
| Stage one file / all files | `+` on the file / `+` on the "Changes" header |
| Stage only part of a file | Open the file diff, select lines, right-click → Stage Selected Ranges |
| Switch or create branches | Click the branch name in the bottom-left status bar |
| Push, pull, publish | Sync icon in the status bar, or the `…` menu in Source Control → Pull / Push |
| See what a commit changed | Source Control → Graph (or GitLens → Commits) |
| Compare your file with `develop` | GitLens → Compare, or the file's timeline view |
| See incoming and outgoing commits | Source Control → Graph shows `origin/…` labels; `↓ ↑` in the status bar |
| Open the repository on GitHub | `…` menu → Open on GitHub (GitHub Pull Requests extension) |
| Resolve a merge conflict | Open the file, use the Merge Editor button at the bottom right |

# 6. Resolving a conflict

A conflict happens when you and `develop` changed the same lines. Git stops the merge and marks the file.

1. VS Code lists the conflicted files under "Merge Changes". Open one and click **Resolve in Merge Editor**.
2. The editor shows Incoming (from `develop`), Current (yours) and the Result below. For each conflict choose Accept Incoming, Accept Current, or Accept Both, then fix the Result by hand so the code is correct.
3. Click **Complete Merge**, stage the file, repeat for the others.
4. Run the app or `npx tsc --noEmit` to confirm nothing broke, then commit (the merge commit message is prefilled) and push.
5. Stuck? `git merge --abort` returns to the state before the merge, and you can ask Nadeem to look with you.

# 7. Command cheat sheet

```bash
# Where am I?
git status                      # branch, staged, unstaged, untracked
git log --oneline -10           # last 10 commits
git branch -vv                  # local branches and what they track
git diff                        # unstaged changes; add --staged to see staged ones

# Branches
git checkout develop && git pull
git checkout -b feature/mian/<task>
git branch -d feature/mian/<task>          # delete after merge (-D forces, be careful)

# Sync
git fetch                        # update origin/* without touching files
git pull                         # fetch + merge into the current branch
git push -u origin HEAD          # publish the current branch the first time
git pull origin develop          # bring develop into your feature branch before a PR

# Committing
git add -p                       # stage hunk by hunk, reviewing each
git commit -m "feat(service): add bcrypt hashing (W-02)"
git commit --amend --no-edit     # fold a fix into your last commit (only if not pushed yet)

# Undo (safe versions)
git restore <file>               # discard unstaged changes in a file
git restore --staged <file>      # unstage, keep the edit
git reset --soft HEAD~1          # undo the last commit, keep the changes staged
git stash && git stash pop       # park changes, switch branches, bring them back
git merge --abort                # back out of a conflicted merge
```

# 8. Getting out of trouble

| Problem | Fix |
|---|---|
| I committed on `develop` or `main` by mistake (not pushed) | `git branch feature/mian/<task>` to save the work, then `git checkout develop` and `git reset --hard origin/develop`. Your commit is safe on the new branch. |
| I am on the wrong branch with uncommitted edits | `git stash`, switch to the right branch (create it if needed), `git stash pop`. |
| Push rejected: "non-fast-forward" or "fetch first" | Someone pushed to your branch or you pulled the wrong thing: `git pull`, resolve, `git push`. Never `--force`. |
| I want to undo my last commit but keep the code | `git reset --soft HEAD~1`. |
| I need to throw away everything since the last commit | `git restore .` (unstaged) and `git restore --staged .` first if staged. Check `git status` before and after. |
| "detached HEAD" after clicking a commit in the graph | `git checkout develop` (or your feature branch). Nothing is lost if you had committed. |
| I committed a secret or a `.env.local` | Tell Nadeem the same hour so the key gets rotated. Then `git rm --cached <file>`, commit, push. Rotation is what matters; history cleanup is secondary. |
| Merge conflict I cannot understand | `git merge --abort`, then ask. Share a screenshot of the Merge Editor. |

# 9. Files that never go into Git

- Real secret values: `.env.local` in both apps, anything with a key, token, password or connection string. The tracked `.env` files contain placeholder values only; if you need to add a variable, add its name and a comment there and the real value in your `.env.local`.
- `node_modules/`, `.next/`, `.expo/`, `dist/`, build outputs, `.DS_Store`, editor folders (`.idea/`, `.vscode/` except shared settings we agree on).
- Database dumps and backups (`*.sql` under `backups/`), APK files (they go to GitHub Releases or storage, not the repo).

Before every commit, read the staged list in Source Control. If a file surprises you, unstage it and ask.

# 10. Your first pull request (today)

1. `git checkout develop && git pull`
2. `git checkout -b feature/mian/add-ai-context`
3. Copy `Hope-Foundation-AI-Context.md` from Nadeem into the repository root as `AI_CONTEXT.md`. Create `CLAUDE.md` containing one line: `Read AI_CONTEXT.md before any task. It is authoritative; the READMEs are outdated.`
4. Commit: `docs(repo): add AI context file and CLAUDE.md`
5. Publish the branch and open a pull request to `develop` with a two-line description.
6. Send Nadeem the link. When it is approved, merge it, then do Step 8 of the daily loop.

That single PR proves the whole loop works before you touch any code.

# 11. Never

- Never `git push --force` or `--force-with-lease` on a shared branch.
- Never rebase `develop` or `main`.
- Never commit on `develop` or `main`.
- Never merge your own PR before Nadeem approved it.
- Never commit secrets, dumps or build outputs.
- Never `git add .` without reading the staged list first.
