# Session 1: Claude Code in the Lab — Day 1

**Audience:** R-using lab colleagues, mostly new to AI-assisted coding.
**Duration:** ~90 min
**Goal:** Everyone leaves with the tools installed and a public URL of an
analysis they "published" themselves.

---

## Slide 1: Welcome

- Two-session workshop on bringing AI into our R workflow
- Today: install + first taste
- Next time: own the workflow (Git, Quarto, Claude Code)

> **Notes:** Set the tone: we're not doing science today, we're sharpening
> tools. Promise that by the end of the hour they'll have a working setup
> and a public URL.

---

## Slide 2: What you'll leave with today

1. Claude Desktop app
2. Positron — the new R IDE from Posit
3. The Claude extension running inside Positron
4. A published web URL of the iris ANOVA notebook *under your name*

> **Notes:** Lead with the deliverables, not the tools. The URL is the
> "wow" — show one of yours on screen.

---

## Slide 3: Pre-meeting accounts checklist

You should already have:

- [ ] **Anthropic** account (Pro plan required)
- [ ] **GitHub** account
- [ ] **Posit** account (Google or GitHub OAuth — no fourth password)

> **Notes:** If anyone is missing one, they can sit out the relevant part
> rather than block the room. Have your laptop ready to demo what each
> signup looks like for stragglers during break.

---

## Slide 4: The installs (Windows 11)

1. **Git for Windows** — gitforwindows.org
   (includes Git Bash — when asked about line endings, pick
   **"Checkout as-is, commit Unix-style line endings"** so
   `core.autocrlf` is set to `input`)
2. **R** — cran.r-project.org
   After installing, open **R GUI** → pick a CRAN mirror →
   run `install.packages("ggplot2")`
3. **VC++ Redistributable** (x64) —
   https://aka.ms/vc14/vc_redist.x64.exe
4. **Positron** — positron.posit.co
   - Optional: set dark theme — **File → Preferences → Workbench →
     Appearance → Color Theme → Positron Dark**
     (or search `color theme` in Settings)
   - Set default terminal — open Command Palette (**Ctrl+Shift+P**),
     type `Terminal: Select Default Profile`, select **Git Bash**.
     Close the terminal, close Positron, then restart Positron.
5. **Claude Desktop** — anthropic.com/desktop
   Optional: set dark theme — **Settings (gear icon) → Appearance → Dark**
6. **Claude extension** for Positron — from the Extensions marketplace

> **Notes:** Install everything as **64-bit** (R, Git, VC++, Positron).
> Order matters on Windows. Git for Windows gives us Git Bash,
> which we'll set as the default terminal in Positron so all shell commands
> match Mac/Linux. Installing ggplot2 from R GUI before Positron
> bootstraps the personal library folder and sets a CRAN mirror — without
> this step, `install.packages()` fails inside Positron. The VC++
> Redistributable is required by Positron's R supervisor (kcserver.exe);
> without it, R won't start at all in Positron.

---

## Slide 5: Create the project folder

Open the terminal in Positron and run:

```bash
mkdir ~/Desktop/iris-test
ls ~/Desktop
cd ~/Desktop/iris-test
touch iris_anova.R
ls
```

Then **File → Open Folder → `iris-test`**.

> **Notes:** This confirms Git Bash is working. The `iris-test` folder
> becomes their working directory for Session 2 as well. On Mac the
> commands are identical since zsh uses the same syntax.

---

## Slide 6: Payoff #1 — Positron meets iris

Open `iris_anova.R`, paste the contents from the workshop repo,
and step through it with **Cmd+Enter** / **Ctrl+Enter**.

Watch the panes light up:

- **Variables** — `iris`, `fit`, `cld_df`
- **Plots** — boxplot with letters
- **Help** — F1 on `aov`
- **Data Explorer** — `View(iris)` → **"View data table"**
- **Outline** — sectioned headers

> **Notes:** This is the "look how nice this IDE is" moment. Linger here.
> Let them click around. Point out the Data Explorer two modes: **Summary
> view** opens first with column types and distributions, click **"View
> data table"** for the spreadsheet with sorting, filtering, and
> histograms.

---

## Slide 7: Script vs notebook

In the terminal: `touch iris_anova.qmd`

Open `iris_anova.qmd`, paste the notebook version from the workshop
repo, and render it (**Cmd+Shift+K** / **Ctrl+Shift+K**).

Compare:

- `.R` — raw script, you run line by line
- `.qmd` — prose + code + rendered output in one document

> **Notes:** Show them the same analysis in both formats. The `.R` file
> is for interactive exploration; the `.qmd` produces a publishable
> document. This is why we use `.qmd` for the next step.

---

## Slide 8: Payoff #2 — Publish to Connect Cloud

1. In the R console: `install.packages("rsconnect")`
2. With `iris_anova.qmd` open, click the **Publish** button (top-right)
3. Sign in to [connect.posit.cloud](https://connect.posit.cloud)
4. **Publish** → get a URL

> **Notes:** Live demo this on the projector. Each person gets their own
> URL under their own Connect Cloud account.

---

## Slide 9: Payoff #3 — Claude generates a notebook

Open **Claude Desktop → Code tab** and paste this prompt:

> Create a Quarto notebook called `iris_pca.qmd` in my `iris-test`
> folder that does the following with the built-in iris dataset in R:
>
> 1. Load the iris data
> 2. Standardize the features (mean=0, variance=1)
> 3. Run PCA on the four numeric columns
> 4. Plot PC1 vs PC2, colored by species
>
> Use ggplot2 for the plot.

Wait for Claude to write the file, then open it in Positron and
render it (**Cmd+Shift+K** / **Ctrl+Shift+K**).

> **Notes:** Everyone uses the same prompt. Results will vary slightly
> because of AI randomness — that's a feature, not a bug. Walk the room
> while Claude works. On Windows the Code tab path is the same. If
> Claude asks to create the file, say yes.

---

## Slide 10: Gallery — everyone's results

Publish `iris_pca.qmd` to Connect Cloud and share your URL.

Ask Claude to build an HTML page showing everyone's notebooks:

> Make an HTML page with a two-column layout. The left column has the
> person's name, the right column has an iframe of their Connect Cloud
> URL. Here are the names and URLs: [paste list]

> **Notes:** Build this live on the projector. The collective gallery is
> the "wow" closer — everyone sees their AI-generated analysis side by
> side. Save the HTML for the workshop repo.

---

## Slide 11: Recap — what you can do now

- ✅ Run R interactively in a modern IDE
- ✅ Use Claude to generate a complete R analysis
- ✅ Publish to a public URL under your name

What you **can't yet** do (Session 2):

- ❌ Make your own version-controlled project
- ❌ Edit the notebook and republish your version
- ❌ Use Claude Code inside Positron's terminal

> **Notes:** Honest gap framing. The "can't yet" list is the curriculum
> for Session 2.

---

## Slide 12: Before next session

1. Read the **Prerequisites** section of `set_up_git_for_positron.qmd`
   (link in the workshop repo)
2. Make sure your GitHub login still works
3. Bring your Personal Access Token *if* you already have one
   (we'll create a new one together if not)

> **Notes:** Send the workshop repo link as a follow-up email tonight.
> Tell them not to try to set up Git on their own — Session 2 walks
> through it together.

---

## Slide 13: Questions

- Workshop materials: https://github.com/faustovrz/ccgarden
- Slack channel: [your lab Slack]
- Office hours before Session 2: [your slot]

> **Notes:** Reserve 10–15 minutes here. Most questions will be about
> the installs. Common ones to be ready for: PATH issues on Windows,
> antivirus blocking the Positron installer, "where do I find my
> Anthropic API key" (they don't need one with Pro).
