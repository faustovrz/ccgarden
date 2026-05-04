# Session 2: Claude Code in the Lab — Day 2

**Audience:** same lab colleagues, after Session 1.
**Duration:** ~90 min
**Goal:** Everyone leaves with their *own* GitHub repo containing a
Quarto notebook they can edit and republish, having used Claude Code
inside Positron at least once.

---

## Slide 1: Welcome back

Recap from Session 1:

- Tools installed and verified
- Positron's IDE features felt out
- Claude Desktop interrogated `sawers-targseq`
- Published someone else's notebook to your Connect Cloud account

Today: **make it your own.**

> **Notes:** Frame as ownership transfer. Last time you "rented" a URL;
> today you build the whole stack from your own GitHub.

---

## Slide 2: Why version control?

- A safety net (undo any change, ever)
- A collaboration substrate (share with reviewers, future you, lab)
- A publishing pipeline (push → Connect Cloud re-renders → URL updates)

> **Notes:** Don't oversell git as a panacea. The pitch is: it's a
> low-cost habit that pays back the moment you make a mistake or want
> to share.

---

## Slide 3: The two tutorials we'll work through

1. **`set_up_git_for_positron.qmd`** — install + configure + auth
2. **`build_first_repo_with_positron.qmd`** — make your own iris ANOVA repo

Both live at https://github.com/faustovrz/ccgarden — open them now.

> **Notes:** They follow along on their own laptops; you project the
> tutorial on the screen. Pause at every numbered step to make sure
> nobody's stuck.

---

## Slide 4: Git setup — the human bits

From `set_up_git_for_positron.qmd`:

- Tell Git who you are (`use_git_config`)
- Make a GitHub Personal Access Token (PAT)
- Store the PAT in `.Renviron` so commands don't keep asking
- Restart R and verify with `git_sitrep()`

> **Notes:** This is the slowest part — budget 25 min. The PAT step
> trips people up: it has to be copied *immediately* because GitHub
> never shows it again. Project this slide while they work.

---

## Slide 5: Build your first repo — the bootstrap

From `build_first_repo_with_positron.qmd`:

1. Make an empty `iris_anova` folder on your Desktop (Finder/Explorer)
2. Open it in Positron
3. Open the integrated terminal — note it's already inside `iris_anova/`
4. `git init -b main`

> **Notes:** This is the moment to introduce "everything happens inside
> Positron from here on." Bootstrap once with the file manager, then
> stay in the IDE.

---

## Slide 6: Build your first repo — folder structure

```bash
mkdir scripts
mkdir data
mkdir results

echo "# Iris ANOVA" > README.md
cp ~/Desktop/ccgarden/iris_anova.R scripts/
```

Then create `.gitignore` in the editor (right-click → New File).

> **Notes:** Walk through *why* each folder exists. `data/` is empty
> here because iris is built into R, but it's there as a placeholder
> for future projects.

---

## Slide 7: Two commits, one for each idea

Commit 1 — the project skeleton + analysis script:

```bash
git add .
git commit -m "Initial commit: project structure and analysis script"
```

Commit 2 — add the Quarto notebook on its own:

```bash
cp ~/Desktop/ccgarden/iris_anova.qmd scripts/
git add scripts/iris_anova.qmd
git commit -m "Add Quarto notebook version of the analysis"
```

> **Notes:** This is the "good Git hygiene" lesson. Two commits, two
> clear purposes. `git log --oneline` shows two readable lines.

---

## Slide 8: Push to GitHub

Either the manual way:

```bash
git remote add origin https://github.com/YOU/iris_anova.git
git branch -M main
git push -u origin main
```

…or the one-line way with the GitHub CLI:

```bash
gh repo create iris_anova --public --source=. --remote=origin --push
```

> **Notes:** Show both. The CLI version is faster but requires
> `gh auth login` (covered in the Git setup tutorial). Refresh the
> GitHub page so they see their own repo appear.

---

## Slide 9: Re-publish — but now it's your repo

Same flow as Session 1:

1. connect.posit.cloud → **New Content → Publish from Git Repository**
2. Pick your new `YOU/iris_anova` repo
3. Pick `scripts/iris_anova.qmd`
4. Publish → URL

> **Notes:** Closes the loop from Session 1. Same publishing flow,
> different repo — it's theirs now. Have them post their URL in Slack.

---

## Slide 10: Claude Code inside Positron — the demo

Open the Claude extension in Positron's sidebar. Ask:

> "Add a second analysis to `iris_anova.qmd` that does the same ANOVA on
> `Petal.Length` instead of `Sepal.Length`. Keep it as a new section."

Watch Claude:

- Read the existing `.qmd`
- Propose a diff
- You accept, the file changes, you save

Then in the terminal:

```bash
git status
git diff
git add scripts/iris_anova.qmd
git commit -m "Add Petal.Length analysis"
git push
```

> **Notes:** This is the headline moment of Session 2. Claude wrote
> code, they reviewed it, they pushed it. Connect Cloud re-renders
> automatically — refresh the URL, see the new section live.

---

## Slide 11: Where to go from here

- **Use this pattern in your own work**: `git init` + Claude Code = a
  durable workflow for any new analysis
- **Read** the references at the bottom of each tutorial
- **Office hours** weekly for Git/Claude questions
- **Deeper Claude Code** — see the Anthropic docs (link in repo)

> **Notes:** End on momentum. Don't try to teach more features — point
> at where to learn next.

---

## Slide 12: Questions

- Workshop materials: https://github.com/faustovrz/ccgarden
- Slack channel: [your lab Slack]
- Office hours: [your slot]

Stick around afterwards if you want help getting your *real* project on
GitHub.

> **Notes:** Soft-sell one-on-one help. The real win for the lab is
> when their actual research repos start using this workflow, not the
> iris demo.
