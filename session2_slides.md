# Session 2: Claude Code in the Lab — Day 2

**Audience:** same lab colleagues, after Session 1.
**Duration:** ~90 min
**Goal:** Everyone leaves with their `iris-test` project under Git version
control, pushed to GitHub, published from the repo, and having used Claude
Code in the terminal at least once.

---

## Slide 1: Welcome back

Recap from Session 1:

- Positron installed and explored
- Claude Desktop Code tab used to generate `iris_pca.qmd`
- Published `iris_anova.qmd` and `iris_pca.qmd` to Connect Cloud from the IDE
- `~/Desktop/iris-test` folder with `iris_anova.R`, `iris_anova.qmd`, `iris_pca.qmd`

Today: **add Git to the workflow** — version control, GitHub, and Claude Code
in the terminal.

> **Notes:** Frame as upgrading from manual publish to a durable pipeline.
> Session 1 proved the tools work; Session 2 gives them a repeatable workflow
> for any future project.

---

## Slide 2: Why version control?

- A safety net (undo any change, ever)
- A collaboration substrate (share with reviewers, future you, lab)
- A publishing pipeline (push → Connect Cloud re-renders → URL updates)

> **Notes:** Don't oversell git as a panacea. The pitch is: it's a
> low-cost habit that pays back the moment you make a mistake or want
> to share.

---

## Slide 3: Git setup — configure identity and PAT

From `set_up_git_for_positron.qmd`:

1. Tell Git who you are:
   ```r
   usethis::use_git_config(user.name = "Your Name", user.email = "you@email.com")
   ```
2. Create a GitHub Personal Access Token:
   ```r
   usethis::create_github_token()
   ```
3. Store the PAT in `.Renviron`:
   ```r
   usethis::edit_r_environ()
   # Add: GITHUB_PAT=ghp_xxxxxxxxxxxx
   ```
4. Restart R, then verify:
   ```r
   usethis::git_sitrep()
   ```

> **Notes:** This is the slowest part — budget 25 min. The PAT step
> trips people up: it has to be copied *immediately* because GitHub
> never shows it again. Project this slide while they work.

---

## Slide 4: Turn iris-test into a Git repo

You already have `~/Desktop/iris-test` from Session 1. Open it in Positron
(if not already open), then in the integrated terminal:

```bash
git init -b main
git status
```

You should see your three files as untracked:

```
iris_anova.R
iris_anova.qmd
iris_pca.qmd
```

> **Notes:** Point out that `git status` is their diagnostic tool — run it
> whenever unsure about the state. The Source Control panel in Positron will
> also light up once Git is initialized.

---

## Slide 5: First commit — the project as-is

```bash
git add .
git commit -m "Initial commit: iris ANOVA analysis and PCA notebook"
git log --oneline
```

One commit, three files — everything from Session 1 is now safely versioned.

> **Notes:** Emphasize that this captures the *known-good* state from
> Session 1. If anything breaks from here, they can always get back.

---

## Slide 6: Push to GitHub

With the GitHub CLI (one-liner):

```bash
gh repo create iris-test --public --source=. --remote=origin --push
```

Or the manual way:

```bash
git remote add origin https://github.com/YOU/iris-test.git
git branch -M main
git push -u origin main
```

Refresh your GitHub page — your files are there.

> **Notes:** The CLI version requires `gh auth login` (covered in the Git
> setup tutorial). Show both; use whichever is less scary for the group.

---

## Slide 7: Republish from GitHub

In Session 1 you published from the IDE. Now publish from the repo:

1. connect.posit.cloud → **New Content → Publish from Git Repository**
2. Pick your `YOU/iris-test` repo
3. Pick `iris_anova.qmd`
4. Publish → new URL

From now on, every `git push` triggers a re-render — the URL stays current
without manual republishing.

> **Notes:** This is the payoff of adding Git. They already know how to
> publish; now the *source of truth* is the repo, not the local file.

---

## Slide 8: Install Claude Code

Prerequisites: Node.js must be installed first.

- **Mac:** `brew install node` or download from https://nodejs.org
- **Windows:** download installer from https://nodejs.org

Then install Claude Code:

```bash
npm install -g @anthropic-ai/claude-code
```

Verify it works:

```bash
claude --version
```

> **Notes:** If anyone already has Node.js, they can skip straight to
> the npm install. Have them run `node --version` to check. Claude Code
> requires Node 18+.

---

## Slide 9: Claude Code — edit and commit

In the Positron terminal, from inside `iris-test/`:

```bash
claude
```

Then prompt Claude Code:

> "Add a Petal.Length ANOVA section to iris_anova.qmd"

Watch Claude:

- Read the existing `.qmd`
- Propose changes
- You accept → file is updated

Then back in the terminal:

```bash
git diff
git add iris_anova.qmd
git commit -m "Add Petal.Length ANOVA section"
git push
```

Refresh your Connect Cloud URL — new section appears.

> **Notes:** This is the headline moment of Session 2. Claude wrote
> code, they reviewed it, they pushed it, and the published page updated
> automatically. The full loop in one shot.

---

## Slide 10: The full loop

```
Edit with Claude Code → review diff → commit → push → URL updates
```

This is the workflow for any future analysis:

1. Open your project in Positron
2. Run `claude` in the terminal
3. Ask for what you need
4. Review, commit, push
5. Your published notebook updates automatically

> **Notes:** Reinforce that every step is reversible. `git diff` before
> committing, `git revert` if something goes wrong. The safety net is
> always there.

---

## Slide 11: Recap — what you can do now

- ✅ Version-control your R projects with Git
- ✅ Push to GitHub and publish from a repo
- ✅ Use Claude Code in the terminal to edit code
- ✅ The edit → commit → push → publish loop

> **Notes:** End on momentum. Don't try to teach more features — point
> at where to learn next.

---

## Slide 12: Questions + where to go from here

- Workshop materials: https://github.com/faustovrz/ccgarden
- Tutorials: `set_up_git_for_positron.qmd` and `build_first_repo_with_positron.qmd`
- Office hours: [your slot]

Stick around afterwards if you want help getting your *real* project on
GitHub.

> **Notes:** Soft-sell one-on-one help. The real win for the lab is
> when their actual research repos start using this workflow, not the
> iris demo.
