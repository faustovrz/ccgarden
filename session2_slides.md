# Session 2: Git and Claude Desktop in the Lab - Day 2

**Audience:** same lab colleagues, after Session 1.
**Duration:** ~90 min
**Goal:** Everyone leaves with their `iris-test` project under Git version
control, pushed to GitHub, published from the repo, and having used Claude
Desktop's Code tab to edit and commit at least once.

---

## Slide 1: Welcome back

Recap from Session 1:

- Positron installed and explored
- Claude Desktop Code tab used to generate `iris_pca.qmd`
- Published `iris_anova.qmd` and `iris_pca.qmd` to Connect Cloud from the IDE
- `~/Desktop/iris-test` folder with `iris_anova.R`, `iris_anova.qmd`, `iris_pca.qmd`

Today: **add Git to the workflow** - version control, GitHub, and Claude
Desktop to edit code.

> **Notes:** Frame as upgrading from manual publish to a durable pipeline.
> Session 1 proved the tools work; Session 2 gives them a repeatable workflow
> for any future project.

---

## Slide 2: Why version control?

- A safety net (undo any change, ever)
- A collaboration substrate (share with reviewers, future you, lab)
- A publishing pipeline (push > Connect Cloud re-renders > URL updates)

> **Notes:** Don't oversell git as a panacea. The pitch is: it's a
> low-cost habit that pays back the moment you make a mistake or want
> to share.

---

## Slide 3: Git setup - configure identity and PAT

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

> **Notes:** This is the slowest part - budget 25 min. The PAT step
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

> **Notes:** Point out that `git status` is their diagnostic tool - run it
> whenever unsure about the state. The Source Control panel in Positron will
> also light up once Git is initialized.

---

## Slide 5: First commit - the project as-is

```bash
git add .
git commit -m "Initial commit: iris ANOVA analysis and PCA notebook"
git log --oneline
```

One commit, three files - everything from Session 1 is now safely versioned.

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

Refresh your GitHub page - your files are there.

> **Notes:** The CLI version requires `gh auth login` (covered in the Git
> setup tutorial). Show both; use whichever is less scary for the group.

---

## Slide 7: Republish from GitHub

In Session 1 you published from the IDE. Now publish from the repo:

1. [connect.posit.cloud](https://connect.posit.cloud) > **New Content > Publish from Git Repository**
2. Pick your `YOU/iris-test` repo
3. Pick `iris_anova.qmd`
4. Publish > new URL

From now on, every `git push` triggers a re-render - the URL stays current
without manual republishing.

> **Notes:** This is the payoff of adding Git. They already know how to
> publish; now the *source of truth* is the repo, not the local file.

---

## Slide 8: Edit with Claude Desktop

You already have Claude Desktop from Session 1. Prompt it:

```
Add a Petal.Length ANOVA section to iris_anova.qmd in ~/Desktop/iris-test,
then commit and push
```

Watch Claude:

- Read the existing `.qmd`
- Edit the file
- `git add`, `git commit`, `git push` - all automatic

> **Notes:** No extra install needed. Everyone already has Claude Desktop.
> The key insight: Claude handles the git commands too. They just prompt
> and approve.

---

## Slide 9: Check the results in Positron

After Claude commits and pushes:

1. Open `iris_anova.qmd` in Positron - see the new section
2. Check `git log --oneline` in the terminal - see the commit
3. Refresh your Connect Cloud URL - the published page updated

> **Notes:** This is the headline moment of Session 2. Claude wrote
> code, committed it, pushed it - and the published page updated
> automatically. They just had to say yes.

---

## Slide 10: The full loop

```
Prompt Claude Desktop > approve > URL updates
```

That's it. Under the hood:

1. Claude reads your files
2. Claude edits the code
3. Claude commits and pushes
4. Connect Cloud re-renders

You check the results in Positron whenever you want.

> **Notes:** Reinforce that they can always review before approving.
> Claude shows what it's about to do. `git revert` if something goes
> wrong. For advanced usage, Claude Code can be installed in the
> terminal for a tighter integration.

---

## Slide 11: Recap - what you can do now

- ✅ Version-control your R projects with Git
- ✅ Push to GitHub and publish from a repo
- ✅ Use Claude Desktop to edit, commit, and push
- ✅ The prompt > check > commit > push > publish loop

> **Notes:** End on momentum. Don't try to teach more features - point
> at where to learn next.

---

## Slide 12: Questions + where to go from here

- Workshop materials: [github.com/faustovrz/ccgarden](https://github.com/faustovrz/ccgarden)
- Tutorials: `set_up_git_for_positron.qmd` and `build_first_repo_with_positron.qmd`
- Office hours: [your slot]

Stick around afterwards if you want help getting your *real* project on
GitHub.

> **Notes:** Soft-sell one-on-one help. The real win for the lab is
> when their actual research repos start using this workflow, not the
> iris demo.
