# Session 1: Claude Code in the Lab - Day 1

**Audience:** R-using lab colleagues, mostly new to AI-assisted coding.
**Duration:** ~90 min
**Goal:** Everyone leaves with the tools installed and a public URL of an
analysis they "published" themselves.

---

## 1. Welcome

- Two-session workshop on bringing AI into an R workflow
- Today: install + first taste
- Next time: own the workflow (Git, Quarto, Claude Desktop)

> **Notes:** Set the tone: we're not doing science today, we're sharpening
> tools. Promise that by the end of the hour they'll have a working setup
> and a public URL.

---

## 2. What you'll leave with today

1. Claude Desktop app
2. Positron - the new R IDE from Posit
3. A published web URL of the iris ANOVA notebook *under your name*

> **Notes:** Lead with the deliverables, not the tools. The URL is the
> "wow" - show one of yours on screen.

---

## 3. Pre-meeting accounts checklist

Use your UnityID email when possible.

- [ ] **Anthropic** account (Pro plan required)
  [claude.ai](https://claude.ai)

- [ ] **GitHub** account
  [github.com](https://github.com)

- [ ] **Posit** account (Google or GitHub OAuth, no fourth password)
  [connect.posit.cloud](https://connect.posit.cloud)

> **Notes:** If anyone is missing one, they can sit out the relevant part
> rather than block the room. Have your laptop ready to demo what each
> signup looks like for stragglers during break.

---

## 4. The installs (Windows 11)

1. **Git for Windows**
   [gitforwindows.org](https://gitforwindows.org)

   When asked about line endings, pick
   **"Checkout as-is, commit Unix-style line endings"** so
   `core.autocrlf` is set to `input`.

2. **R**
   [cran.r-project.org](https://cran.r-project.org)

   After installing, open **R GUI**, pick a CRAN mirror,
   run `install.packages("ggplot2")`

3. **VC++ Redistributable** (x64)
   [aka.ms/vc14/vc_redist.x64.exe](https://aka.ms/vc14/vc_redist.x64.exe)

4. **Positron**
   [positron.posit.co](https://positron.posit.co)

   - Optional: set dark theme - **File > Preferences > Workbench >
     Appearance > Color Theme > Positron Dark**
     (or search `color theme` in Settings)
   - Set default terminal - open Command Palette (**Ctrl+Shift+P**),
     type `Terminal: Select Default Profile`, select **Git Bash**.
     Close the terminal, close Positron, then restart Positron.

5. **Claude Desktop**
   [anthropic.com/desktop](https://anthropic.com/desktop)

   Log in with your NCSU Gmail account.
   Optional: set dark theme - **Settings (gear icon) > Appearance > Dark**

> **Notes:** Install everything as **64-bit** (R, Git, VC++, Positron).
> Order matters on Windows. Git for Windows gives us Git Bash,
> which we'll set as the default terminal in Positron so all shell commands
> match Mac/Linux. Installing ggplot2 from R GUI before Positron
> bootstraps the personal library folder and sets a CRAN mirror - without
> this step, `install.packages()` fails inside Positron. The VC++
> Redistributable is required by Positron's R supervisor (kcserver.exe);
> without it, R won't start at all in Positron.

---

## 5. The installs (Mac)

1. **iTerm2**
   [iterm2.com](https://iterm2.com)
   (recommended terminal replacement)

2. **R**
   [cran.r-project.org](https://cran.r-project.org)

3. **Positron**
   [positron.posit.co](https://positron.posit.co)

   - Optional: set dark theme - **File > Preferences > Workbench >
     Appearance > Color Theme > Positron Dark**
     (or search `color theme` in Settings)
   - Set default terminal - open Command Palette (**Cmd+Shift+P**),
     type `Terminal: Select Default Profile`, select **zsh**.

4. **Claude Desktop**
   [anthropic.com/desktop](https://anthropic.com/desktop)

   Log in with your NCSU Gmail account.
   Optional: set dark theme - **Settings (gear icon) > Appearance > Dark**

> **Notes:** Mac doesn't need VC++ Redistributable or Git Bash - Git
> and zsh come pre-installed. iTerm2 is optional but gives a better
> terminal experience outside of Positron. Steps 3-4 are the same as
> Windows.

---

## 6. Create the project folder

Open the terminal in Positron and run:

```bash
mkdir -p ~/iris-test
cd ~/iris-test
touch iris_anova.R
ls
```

Then **File > Open Folder > `iris-test`**.

Open `iris_anova.R`, paste the contents from the
[iris-test](https://github.com/faustovrz/iris-test/blob/main/iris_anova.R) repo,
and step through it with **Cmd+Enter** / **Ctrl+Enter**.

> **Notes:** This confirms Git Bash is working. The `iris-test` folder is
> just for Session 1 — Session 2 uses its own `~/primercrisp` project
> (created by the bootstrap). On Mac the commands are identical since zsh
> uses the same syntax.

---

## 7. The Positron layout

1. **Activity Bar** - narrow icon strip on the far left
2. **Side Bar** - file **Explorer**, Search, Source Control, Extensions
3. **Editor** - the central area where you edit files
4. **Panel** (below the Editor) - tabs for **Console** (R) and **Terminal** (shell)
5. **Session panes** (right side) - **Variables**, **Plots**, **Help**, **Data Explorer**

Move the **Terminal** tab from the Panel to the Session panes:
grab the Terminal tab and drag it before the Session tab on the right.

> **Notes:** Point at each area on the projector. The Panel vs Session
> panes distinction matters: Console is where R runs, Terminal is where
> shell/Git commands run. The Session panes on the right are
> Positron-specific and don't exist in regular VS Code.

---

## 8. Payoff #1 - Positron meets iris

Focus on the **Editor** (center) and the **Session panes** (right).
As you step through the script, the Session panes update in real time.
The **Data Explorer** opens as a tab in the Editor section.

Watch the panes light up:

- **Variables** - `iris`, `fit`, `cld_df`
- **Plots** - boxplot with letters
- **Help** - F1 on `aov`
- **Data Explorer** - `View(iris)` > **"View data table"**
- **Outline** - sectioned headers

> **Notes:** This is the "look how nice this IDE is" moment. Linger here.
> Let them click around. Point out the Data Explorer two modes: **Summary
> view** opens first with column types and distributions, click **"View
> data table"** for the spreadsheet with sorting, filtering, and
> histograms.

---

## 9. Script vs notebook

In the terminal: `touch iris_anova.qmd`

Open `iris_anova.qmd`, paste the notebook version from the
[iris-test](https://github.com/faustovrz/iris-test/blob/main/iris_anova.qmd)
repo, and render it (**Cmd+Shift+K** / **Ctrl+Shift+K**).

Compare:

- `.R`: a program. Designed to be executed, either interactively or in
  batch. Comments annotate the code. Output is primarily ephemeral in
  interactive mode (console, plot pane) but written to files in batch
  mode.
- `.qmd`: a document, intended as a guide or a notebook for
  reproducible science. The narrative comes first; code lives in chunks
  that interrupt the prose; rendering executes the chunks and captures
  their output (tables, figures) inline. The artifact itself is the
  record of the analysis.

Allow for inline output in quarto:

- **(Cmd/CTRL)+Shift+P**  Preferences: Open Workspace Settings 
- Positron >Quarto >Inline Output: Enabled

> **Notes:** Show them the same analysis in both formats. Both can be
> stepped through one line at a time while exploring; the difference is
> the finished artifact, a program you run versus a document you
> render. This is why we use `.qmd` for the next step.

---

## 10. Payoff #2 - Publish to Connect Cloud

1. In the R console: `install.packages("rsconnect")`
2. Hit the **Preview** button on the top-left of the editor to render the document. The rendered HTML will appear in the Viewer pane.
3. With the **rendered HTML file** open in the editor, click the **Publish** button (top-right).
4. Sign in to [connect.posit.cloud](https://connect.posit.cloud)
5. Press **Deploy with Posit Publisher**. Be aware of the command bar!
6. Authenticate.
7. In the command bar: give a title for the notebook and your account alias.
8. The editor will open a panel on the left — click **Deploy Your Project**.

> **Notes:** Live demo this on the projector. Each person gets their own URL under their own Connect Cloud account. Make sure to publish from the **rendered HTML**, not the `.qmd` — publishing from the `.qmd` requires additional R version configuration.

---

## 11. Payoff #3 - Claude generates a notebook

Open **Claude Desktop > Code tab** and paste this prompt:

```
Create a Quarto notebook called iris_pca.qmd in my iris-test
folder that does the following with the built-in iris dataset in R:

1. Load the iris data
2. Standardize the features (mean=0, variance=1)
3. Run PCA on the four numeric columns
4. Plot PC1 vs PC2, colored by species

Use ggplot2 for the plot.
Write the four steps are in separate labeled chunks with section headers.
Leave editor field in the YAML unspecified.
```

Wait for Claude to write the file, then open it in Positron and
render it (**Cmd+Shift+K** / **Ctrl+Shift+K**).

> **Notes:** Everyone uses the same prompt. Results will vary slightly
> because of AI randomness - that's a feature, not a bug. Walk the room
> while Claude works. On Windows the Code tab path is the same. If
> Claude asks to create the file, say yes.

---

## 12. Gallery - everyone's results

Publish `iris_pca.qmd` to Connect Cloud and share your URL.

Ask Claude to build an HTML page showing everyone's notebooks:

```
Make an HTML page with two frames. The left frame is narrow, just
wide enough for a list of names. Each name is a hyperlink. Clicking
a name loads that person's Connect Cloud notebook URL in the right
frame as an iframe. Here are the names and URLs: [paste list]
```

> **Notes:** Build this live on the projector. The collective gallery is
> the "wow" closer - everyone sees their AI-generated analysis side by
> side. Save the HTML for the workshop repo.

---

## 13. Recap - what you can do now

- ✅ Run R interactively in an IDE based on VS Code
- ✅ Use Claude to generate a complete R analysis
- ✅ Publish to a public URL under your name

What you **can't yet** do (Session 2):

- ❌ Make your own version-controlled project
- ❌ Edit the notebook and republish your version
- ❌ Use Claude Desktop to commit and push changes

> **Notes:** Honest gap framing. The "can't yet" list is the curriculum
> for Session 2.

---

## 14. Before next session

1. Read the **Prerequisites** section of `set_up_git_for_positron.qmd`
   (link in the workshop repo)
2. Make sure your GitHub login still works
3. Bring your Personal Access Token *if* you already have one
   (we'll create a new one together if not)

> **Notes:** Send the workshop repo link as a follow-up email tonight.
> Tell them not to try to set up Git on their own - Session 2 walks
> through it together.

---

## 15. Questions

- Workshop materials: [github.com/faustovrz/ccgarden](https://github.com/faustovrz/ccgarden)
- Slack channel: [your lab Slack]
- Office hours before Session 2: [your slot]

> **Notes:** Reserve 10-15 minutes here. Most questions will be about
> the installs. Common ones to be ready for: PATH issues on Windows,
> antivirus blocking the Positron installer, "where do I find my
> Anthropic API key" (they don't need one with Pro).
