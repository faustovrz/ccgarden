# Session 2: Git and Claude Code in a real lab project

**Audience:** same colleagues from Session 1, who ran the primercrisp setup at home.
**Duration:** ~90 min.
**Goal:** Each of you leaves with the **primercrisp** primer + guide analysis under
Git control, in your **own** GitHub repo, published at a public GitHub Pages URL,
with Claude Code committing on your behalf at each stage.

---

## 1. Welcome back

Session 1 deliverables, recap:

- Positron, Claude Code, Git, and `gh` installed and authenticated
- A published Connect Cloud URL of the iris analysis under your name

The pre-session setup for today (the `curl … | bash` bootstrap) should have left
you with, in `~/primercrisp`:

- the toolchain in a `primercrisp` conda env
- the LH244 genome staged under `data/`
- the project **detached** from my repo (no `.git`) — it is yours to initialize
- the `.gitignore` set aside at `setup/gitignore` — you will install it yourself

Three things are different from Session 1:

- **Real analysis.** We check a genotyping primer pair and a CRISPR guide against the
  whole LH244 maize genome — e-PCR specificity, guide BLAST, gene overlap, and
  `gggenomes` maps — the same pipeline you would run in production.
- **Git is the spine.** Every section ends in a commit, so you have a paper trail you
  can share or roll back.
- **Claude Code under a sandbox.** Claude proposes, you approve. Every action.

> **Notes:** If anyone's bootstrap did not finish, seat them with a neighbour and
> use the `AGENT_SETUP_PROMPT.md` fallback during the pre-flight check.

---

## 2. What you'll leave with today

1. A working `~/primercrisp` analysis under Git
2. In your **own** GitHub repo (created live with `gh`, not a fork)
3. Published at a public GitHub Pages URL with the rendered annotation maps
4. A commit history where Claude wrote the messages and ran the pushes

> **Notes:** Lead with the URL — it is the wow. The commit history is the proof
> that you stayed in control the whole time.

---

## 3. The analysis, briefly

For one primer set (`mgd`) defined in `data/primers.xlsx`:

- **§1** e-PCR the primers over the whole genome; BLAST the guide (`blastn-short`)
- **§2** intersect every amplicon and guide site with the gene annotation (`bedtools`)
- **§3** draw it all as `gggenomes` maps — the target locus, an exon zoom, and every
  likely amplicon side by side
- **§4** redesign the primers around the guide with Primer3 and re-check specificity

The pipeline ships as five `cat`-able slices in `source_qmds/`. Each slice is one
section; we assemble the notebook one section at a time and commit after each.

> **Notes:** Show a rendered `docs/primer_check.html` from your own run on the
> projector first. That is the target. Point out that the primers/guide come from
> the spreadsheet, not the code.

---

## 4. Pre-flight check

Everyone, in a fresh terminal from `~/primercrisp`:

```bash
conda activate primercrisp
samtools --version | head -1
blastn -version
e-PCR 2>&1 | head -1        # usage banner = success (no --version)
bedtools --version
primer3_core --version
Rscript -e 'library(gggenomes); library(pwalign); loadNamespace("rmarkdown"); loadNamespace("knitr"); cat("R OK\n")'
ls data/ref data/blastdb data/primers.xlsx
```

All of it should print without errors, and the `ls` should list the staged genome,
the BLAST database, and the primer spreadsheet. If yours fails, raise your hand now.

> **Notes:** Do not skip this even if everyone replied "all green" to the setup
> message. Five minutes here saves a derailed workshop. Keep one backup laptop with
> the env + genome staged for whoever's setup is broken.

---

## 5. One-time IDE settings (set them in the WSL window)

You set these in Session 1 — but that was the **local** Positron. Today you are in a
**WSL-connected** window (title bar shows `WSL: Ubuntu`), so confirm each one is active
*here* by opening Settings from this window.

- **Inline chunk output** — so a chunk's result appears **beneath the chunk** in the
  editor, not only in the Console. Settings → search **Inline Output** → enable
  **Positron › Quarto › Inline Output**. Verify: open a `.qmd`, put the cursor in a
  chunk, press **Ctrl+Shift+Enter**, and the output should appear under the chunk.
- **Claude Code opens in the terminal** — the button at the top-right of an editor
  (the Claude Code extension) should open the **terminal CLI**, not the graphical chat
  panel — the whole session runs through the terminal with per-action approval.
  Settings → **Extensions → Claude Code → check "Use Terminal"** (key
  `claudeCode.useTerminal: true`).
- **Claude Code terminal newline** — so **Shift+Enter** inserts a newline in Claude
  Code prompts instead of submitting. In Claude Code, run **`/terminal-setup`** once
  (it writes the keybinding for VS Code–family editors; Positron is a VS Code fork, so
  it should apply — the docs do not name Positron explicitly). If Shift+Enter still
  submits, use the always-works fallbacks: **Ctrl+J**, or type **`\`** then **Enter**.
  Run it in the host terminal, not inside `tmux`/`screen`.
- **Dark theme (optional)** — Settings (gear) → **Color Theme** → **Positron Dark**.

> **Notes:** The WSL gotcha: a setting flipped in the *local* window does not always
> carry into the *remote* window. If inline output "worked last week" but not today,
> it is almost always this — re-enable it in the WSL window before anyone runs a chunk.

---

## 6. Make it your repo: `git init` and the `.gitignore`

The bootstrap detached the project from my repo. You now turn it into *your own*.
Do this one yourself so you see plain git, no agent in the way.

```bash
git init -b main
```

Now install the `.gitignore` **before** you stage anything — this is the step that
keeps the 3.5 GB genome out of your commits:

```bash
cat setup/gitignore          # read what it excludes, and why
cp  setup/gitignore .gitignore
git status                   # data/ and results/ should NOT appear
```

> **Notes:** Make them read the `.gitignore` first. Ask: "what happens if you
> `git add .` without this?" (Answer: you try to commit a 2.3 GB file and the push
> is rejected at GitHub's 100 MB limit.) The ignore file is a conscious choice, not
> boilerplate.

---

## 7. Build section 1 (create the notebook, run the chunks)

Create the notebook once, then build it up by pasting slices and running each chunk,
so you see what every step produces:

```bash
touch primer_check.qmd     # create the empty notebook
```

Open `primer_check.qmd` in Positron. Copy the contents of `source_qmds/01_setup.qmd`,
then `source_qmds/02_epcr.qmd`, into it (in that order). Run the code chunks **one at a
time** — cursor in a chunk, **Ctrl+Shift+Enter** — and read each result **inline**
before moving on (this is why you enabled inline output in §5). The `.Rprofile` puts
the tools (`samtools`, `e-PCR`, …) on `PATH` for the editor's R session.

When section 1 runs top to bottom, render the HTML for the published site. Run this
in **Positron's integrated terminal** (Terminal menu, or `` Ctrl+` ``) — Positron
bundles `quarto`, so it is on `PATH` there; a plain external terminal is not:

```bash
conda activate primercrisp
quarto render primer_check.qmd     # output → docs/primer_check.html
```

Open `docs/primer_check.html`. You should see the e-PCR amplicon table, the likely
(0-gap) products, and the guide's genome-wide candidate sites.

> **Notes:** All the later `quarto render` steps are the same — always Positron's
> integrated terminal, where `quarto` resolves. (Or just use the **Preview** button.)

> **Notes:** Running the chunks one by one is the smoke test — a wrong input or env
> surfaces on that chunk, not three sections later. The render at the end is the
> artifact for GitHub Pages.

---

## 8. First commit, by hand

You do this one yourself so you see plain git.

```bash
git add .gitignore primercrisp.yml _quarto.yml README.md setup/ source_qmds/ \
        data/primers.xlsx primer_check.qmd docs/
git commit -m "first commit: setup + e-PCR/guide section renders"
git log --oneline
```

Note what is **not** in the commit: `data/ref/`, `data/blastdb/`, `results/`. The
`.gitignore` keeps them out — the genome stays on your laptop.

> **Notes:** Point at Positron's Source Control panel lighting up alongside the
> terminal. Same information, two views.

---

## 9. Create your GitHub repo with `gh`

No fork, no web UI — one command turns your local repo into a GitHub repo and pushes:

```bash
gh repo create primercrisp --public --source=. --remote=origin --push
```

Refresh your GitHub profile — `primercrisp` is there, with your first commit. Then
enable Pages:

1. **Settings > Pages**. Source: **Deploy from a branch**. Branch **main**, folder
   **/docs**. Save.
2. Wait 1–2 min. Your URL appears:
   `https://YOU.github.io/primercrisp/primer_check.html`.

> **Notes:** Pages on a public repo is free. `--source=.` is what makes this *your*
> independent repo rather than a fork — good moment to contrast with forking.

---

## 10. Section 2 (gene overlap), Claude commits

From here, Claude writes the commits. Paste the next slice and run it: copy
`source_qmds/03_overlap.qmd` into `primer_check.qmd`, run its new chunks one at a time
(**Ctrl+Shift+Enter**, reading each result inline), then render:

```bash
conda activate primercrisp && quarto render primer_check.qmd
```

Now start Claude Code in the project and let it commit:

```
claude
```

Then tell it:

```
I added the gene-annotation overlap section (source_qmds/03_overlap.qmd) to
primer_check.qmd, ran the chunks, and re-rendered. Commit with a clear message
describing what changed, then push.
```

Approve each action. Watch it `git add`, write a message from the diff, `git commit`,
`git push`. Refresh your Pages URL after a minute.

> **Notes:** You paste the slice and run its chunks; Claude writes the commit message
> and runs git. That separation is the point. Read each sandbox prompt before approving.

---

## 11. Section 3 (the maps), Claude commits

Paste `source_qmds/04_maps.qmd` into `primer_check.qmd`, run its chunks one at a time,
then render:

```bash
conda activate primercrisp && quarto render primer_check.qmd
```

The annotation maps appear: the target locus with exons/CDS/amplicon/guide, the
exon-1 zoom, and every likely amplicon side by side with its repeat and homology
tracks. In Claude:

```
I added the gggenomes annotation maps section. Commit and push.
```

> **Notes:** This is the visual climax — the maps look like real annotation now.
> Linger here; refresh the Pages URL so they see it live.

---

## 12. Section 4 (Primer3 redesign), Claude commits

Paste `source_qmds/05_primer3.qmd` into `primer_check.qmd`, run its chunks one at a
time, then render:

```bash
conda activate primercrisp && quarto render primer_check.qmd
```

The notebook now designs new primers around the guide, filters to single-copy oligos,
and re-checks specificity by e-PCR. In Claude:

```
I added the Primer3 redesign section. Commit and push.
```

Your finished `primer_check.qmd` is just the five slices in order — identical to
`cat source_qmds/*.qmd`.

That is the finish: you found the primer set that makes multiple bands, saw exactly
why (a shared repeat), and designed a specific replacement — all under version
control and published.

> **Notes:** This is the ending. If the room ran long, §4 can be homework, since each
> section is already its own commit. Don't manufacture a further task — the story is
> complete here.

---

## 13. Recap and where to go

You can now:

- Turn a folder into your own version-controlled GitHub repo with plain `git` + `gh`
- Drive Claude Code from Positron's terminal under a sandbox, approving each action
- Publish a rendered analysis at a public GitHub Pages URL

Materials and follow-ups:

- Workshop repo: https://github.com/faustovrz/ccgarden
- The starter you used: https://github.com/faustovrz/primercrisp
- Office hours: [your slot]

Stick around if you want help getting your *own* lab analysis onto this flow.

> **Notes:** The real win is when their actual research repos start using this loop.
> Soft-sell one-on-one help here.
