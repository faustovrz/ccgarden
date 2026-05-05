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

## Slide 4: The four installs

1. **Claude Desktop** — anthropic.com/desktop
2. **R** — cran.r-project.org
3. **Positron** — positron.posit.co
4. **Claude extension** for Positron — from the Extensions marketplace

> **Notes:** Walk through each one in turn. Show the download page on the
> projector. Mention the order: Claude Desktop → R → Positron → extension.

---

## Slide 5: Smoke tests after each install

Open a terminal and run:

```bash
R --version
positron --version    # if PATH set up
```

Open Claude Desktop → sign in → ask "what's 2+2?"

> **Notes:** Catching broken installs *now* is the whole point. Don't move
> on until everyone's smoke test passes.

---

## Slide 6: Windows troubleshooting

**Positron won't start R** ("supervisor process exited unexpectedly"):

- Install the **Microsoft Visual C++ Redistributable** (x64):
  https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist
- Restart Positron after installing

**`install.packages()` fails in Positron** (can't write to personal library):

- Open **R GUI** (not Positron) once
- Run `install.packages("rlang")` — pick a CRAN mirror when prompted
- This creates your personal library folder and sets the mirror
- After that, package installs work normally in Positron

> **Notes:** Both issues hit Windows users who have never run R before.
> The VC++ Redistributable is not bundled with Positron. The personal
> library problem happens because R needs an interactive session to
> create `~/R/win-library/` and write a default mirror the first time.
> Walk through these fixes on the projector if anyone is stuck.

---

## Slide 7: Payoff #1 — Positron meets iris

Open `iris_anova.R` from the workshop materials. Step through it
section by section with **Cmd+Enter** / **Ctrl+Enter**.

Watch the panes light up:

- **Variables** — `iris`, `fit`, `cld_df`
- **Plots** — boxplot with letters
- **Help** — F1 on `aov`
- **Outline** — sectioned headers

> **Notes:** This is the "look how nice this IDE is" moment. Linger here
> 15 minutes. Let them try clicking around. Show off the Data Explorer
> on `iris` (`View(iris)` or click the row in Variables). Point out the
> two modes: the **Summary view** opens first and shows column types and
> distributions; click **"View data table"** to switch to the
> spreadsheet view where you can sort, filter, and browse rows.

---

## Slide 8: Payoff #2 — Publish a notebook in 60 seconds

We'll publish the iris notebook from a pre-built repo to give you a
public URL *right now*. Later sessions teach how to make it your own.

1. Open [connect.posit.cloud](https://connect.posit.cloud) in a browser
2. Sign in (Google or GitHub)
3. **New Content → Publish from Git Repository**
4. Paste: `https://github.com/faustovrz/iris-demo`
5. Pick `iris_analysis.qmd`
6. **Publish** → get a URL

> **Notes:** Live demo this in under a minute. The URL appears in their
> own Connect Cloud account — they "own" it. The fact that the analysis
> isn't theirs *yet* is the hook into Session 2.

---

## Slide 9: What just happened?

- Posit Connect Cloud cloned the repo
- It detected R 4.5.2 from the publisher config
- Installed 55 R packages on its end
- Re-rendered the Quarto notebook
- Hosted the HTML at a public URL — yours

> **Notes:** Demystify briefly. They don't need to understand the
> manifest.json yet — that comes in Session 2. The point: it's not magic,
> it's reproducible.

---

## Slide 10: Payoff #3 — Claude Desktop on a real repo

Demo: open Claude Desktop, attach the **sawers-targseq** repo, and ask:

- "What does this pipeline do at a high level?"
- "Where is the variant calling step?"
- "Explain the `02_align.sh` script line by line."

> **Notes:** This is the "AI knows our code" moment. Pick questions that
> would take a new lab member 30 min to answer themselves. Stress that
> the repo never leaves their machine — Claude reads it locally.

---

## Slide 11: Recap — what you can do now

- ✅ Run R interactively in a modern IDE
- ✅ Use Claude Desktop to interrogate code
- ✅ Have a public web URL of a reproducible analysis

What you **can't yet** do (Session 2):

- ❌ Make your own version-controlled project
- ❌ Edit the notebook and republish your version
- ❌ Use Claude inside Positron to write code

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
