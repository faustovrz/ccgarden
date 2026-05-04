# Building Your First Project Repository in Positron
Your Name
2026-05-04

# Building Your First Project Repository in Positron

In this session we’ll wrap a small statistical analysis (one-way ANOVA
on the `iris` dataset) into a proper version-controlled R project, push
it to GitHub, and end with a reproducible notebook that anyone can clone
and re-run.

## Prerequisites

- Completed the **“Setting Up Git and GitHub for R Users”** tutorial
- Positron installed and configured with Git
- Basic familiarity with R
- GitHub account set up and authenticated from Positron
- Files provided by the instructor: `iris_anova.R` and `iris_anova.qmd`

## Setting Up the Project Repository

### Step 1: Create a new R Project with Git

We’ll start by creating a Positron R project that doubles as a Git
repository.

1.  Open **Positron**
2.  **File → New Project…** (or open the Command Palette with
    `Cmd+Shift+P` / `Ctrl+Shift+P` and search for *New Project*)
3.  Select **New R Project**
4.  Choose a parent directory where the project will live
5.  Enter **`iris_anova`** as the project (directory) name
6.  Check **Initialize as Git repository**
7.  Click **Create**

Positron will open a fresh window scoped to the new `iris_anova/`
folder.

### Step 2: Set up the folder structure

Now we’ll create a tidy folder structure for the project. In Positron,
open the **Terminal** (View → Terminal, or `` Cmd+` `` / `` Ctrl+` ``)
and run:

``` bash
# Create the standard folders
mkdir -p scripts data results

# Create a README.md file
echo "# Iris ANOVA" > README.md
echo "" >> README.md
echo "A small reproducible analysis: one-way ANOVA + Tukey HSD on iris sepal length." >> README.md
```

Then copy the analysis files the instructor provided into the project.
From the same terminal (adjust the source path if your files are
elsewhere):

``` bash
# Copy the script and the notebook into the project
cp ~/Desktop/ccgarden/iris_anova.R   scripts/
cp ~/Desktop/ccgarden/iris_anova.qmd scripts/
```

Your project should now look like:

    iris_anova/
    ├── README.md
    ├── data/
    ├── results/
    └── scripts/
        ├── iris_anova.R
        └── iris_anova.qmd

### Step 3: Add a `.gitignore`

Some files don’t belong in version control (rendered HTML, R history, OS
junk). Create `.gitignore` in the project root:

``` bash
cat > .gitignore <<'EOF'
# R
.Rproj.user/
.Rhistory
.RData
.Ruserdata

# Quarto outputs (regenerated on render)
*.html
*_files/
*_cache/
/.quarto/
/_freeze/

# OS
.DS_Store
Thumbs.db
EOF
```

### Step 4: Make your first commit

Stage and commit the initial project:

``` bash
# See what Git is about to track
git status

# Stage everything that isn't gitignored
git add .

# Commit the initial project state
git commit -m "Initial commit: project structure and iris analysis"
```

### Step 5: Create a GitHub repository and connect it

1.  Go to [GitHub.com](https://github.com)
2.  Click the **+** icon in the top-right corner
3.  Select **New repository**
4.  Name it **`iris_anova`**
5.  Keep it as a **public** repository
6.  **Don’t** initialize with a README, `.gitignore`, or license — we
    already have these locally
7.  Click **Create repository**

GitHub will show you a “push an existing repository” snippet. Run it in
Positron’s terminal (replace `YOUR_USERNAME` with your GitHub username):

``` bash
# Tell your local repo where the remote lives
git remote add origin https://github.com/YOUR_USERNAME/iris_anova.git

# Make sure your local branch is called `main`
git branch -M main

# Push your commits to GitHub and set the upstream
git push -u origin main
```

Refresh the GitHub page — you should see the project structure and the
README.

### Step 6 (optional, faster): use the GitHub CLI

If you have the GitHub CLI (`gh`) installed and authenticated, steps 5
can collapse to a single command from inside the project:

``` bash
gh repo create iris_anova --public --source=. --remote=origin --push
```

This creates the GitHub repo, sets it as the `origin` remote, and pushes
— all in one step.

## Working in the Project

### Run the analysis interactively

Open `scripts/iris_anova.R` in Positron and step through it section by
section (`Cmd+Enter` / `Ctrl+Enter`). Watch the **Plots**,
**Variables**, and **Help** panes update as you go.

### Render the notebook

Open `scripts/iris_anova.qmd` and click **Render** (top of the editor)
to build the HTML. The HTML output is gitignored — that’s intentional;
the source `.qmd` is the source of truth, and the HTML is a build
artifact.

### Make a change and commit it

Edit the boxplot (e.g., change the colour palette), save, then in the
terminal:

``` bash
git status                 # see what changed
git diff                   # see the actual changes
git add scripts/iris_anova.R
git commit -m "Use viridis palette in boxplot"
git push
```

## Troubleshooting

1.  **`git push` asks for username/password**: your PAT isn’t being
    picked up. Re-run `usethis::git_sitrep()` from the previous tutorial
    and confirm the PAT line shows `<found in env var>`.

2.  **`git remote add origin` says “remote origin already exists”**:
    you’ve already linked a remote. Run `git remote -v` to see what’s
    there, and
    `git remote set-url origin https://github.com/YOUR_USERNAME/iris_anova.git`
    to replace it.

3.  **Positron’s Source Control pane shows nothing**: open the Command
    Palette and run *Git: Refresh*, or close and reopen the project
    window.

## Next Steps

- Use **Claude Code** (terminal or extension) to add a new analysis to
  the project — e.g., `iris_anova` on `Petal.Length` instead of
  `Sepal.Length` — then commit and push it.
- Render the `.Rmd` and **publish to Posit Connect Cloud** so the
  rendered notebook gets a public URL.
- Invite a collaborator to the GitHub repo and practise the pull → edit
  → push cycle.

## References

- [Happy Git with R](https://happygitwithr.com/)
- [usethis package documentation](https://usethis.r-lib.org/)
- [GitHub CLI documentation](https://cli.github.com/)
- [Posit Connect Cloud](https://connect.posit.cloud)
