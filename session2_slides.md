# Session 2: Git and Claude Code in a real lab project

**Audience:** same colleagues from Session 1, with the prerequisite email done.
**Duration:** ~90 min.
**Goal:** Each of you leaves with a CRISPR annotation project under Git
control, pushed to your own GitHub repo, published via GitHub Pages, with
Claude Code committing on your behalf at every stage.

---

## 1. Welcome back

Session 1 deliverables, recap:

- Positron installed
- Claude Desktop installed
- A published Connect Cloud URL of the iris analysis under your name

Today is different in three ways:

- **Real project.** We are annotating a CRISPR target gene from the LH244 line, using the same `ggplot2` map you would build in production.
- **Git is the spine.** Every step ends in a commit, so you have a paper trail you can share or roll back.
- **Claude Code, not Claude Desktop.** We are using the CLI, run from inside Positron's integrated terminal. The sandbox is on. You approve every action.

> **Notes:** Don't apologize for the swap from Desktop to CLI. Frame it as
> "the right tool for shell-heavy work." The sandbox is the safety story
> they should believe in: Claude proposes, you approve.

---

## 2. What you'll leave with today

1. A working `~/crisprpen` project under Git
2. Pushed to your own GitHub repo
3. Published at a public GitHub Pages URL with the rendered annotation map
4. A commit history where Claude wrote the messages and ran the pushes

> **Notes:** Lead with the URL again, like Session 1. The Pages URL is the
> wow. The commit history is the proof that you stayed in control.

---

## 3. The project, briefly

For one gene (`nmx`):

- Pull exon positions by BLASTing the gene against its cDNA
- Place CRISPR guides on the gene with `blastn -task blastn-short`
- Predict primer-pair amplicons with `e-PCR`
- Draw all of that on a `gggenomes` annotation map
- Export a GenBank file with every feature, for opening in SnapGene or Benchling later

The pipeline is split into four stages. Each stage ends with a render and a
commit. We add features to the map one stage at a time.

> **Notes:** Show one of the rendered annotation maps from your real LH244
> work on the projector. That is the target.

---

## 4. Pre-flight check

Everyone, in `~/crisprpen`:

```bash
claude --version
./env/bin/blastn -version
./env/bin/re-PCR -h 2>&1 | head -3
R -e 'library(gggenomes); cat("ok\n")'
```

All four should print without errors. If yours fails, raise your hand now.

> **Notes:** Do not skip this even if everyone replied "all green" to the
> prereq email. Five minutes here saves a derailed workshop. Have one
> backup laptop ready for whoever's setup is broken.

---

## 5. Git setup, identity and PAT

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

> **Notes:** Same advice as the original Session 2 outline. The PAT step
> is the slowest. Project this slide while they work. Budget 15 min.
> The PAT must be copied immediately because GitHub never shows it again.

---

## 6. Open the project, start Claude Code

**Mac:** File > Open Folder > `~/crisprpen`.

**Windows:** click the green Remote button (bottom-left of Positron),
pick `Connect to WSL`, then open `~/crisprpen` from inside the WSL
connection.

Open the integrated terminal. Type:

```bash
claude
```

Approve the sandbox prompt. Leave Claude running. You now have a
two-pane workspace: editor on the left, Claude in the terminal on the
right.

> **Notes:** Sandbox approval prompts will appear before any tool call.
> Tell them: read the prompt, then approve. Approving "yes for this
> session" is fine for `git`, `R`, and the conda env's tools. Anything
> outside the project tree, decline.

---

## 7. First prompt, Claude downloads the gene data

Prompt Claude:

```
Download the nmx gene data from this Drive folder into data/nmx/:
<paste the link>

Confirm afterwards that genomic.fa, cdna.fa, oligos.fa, and meta.yml
are present.
```

Approve the network request. Wait for Claude to confirm the four files.

> **Notes:** Drive direct-download links can require auth. Use a "anyone
> with the link" share. If Claude gets a permission wall, fall back to a
> manual browser download and tell Claude where the files landed.

---

## 8. Render stage 1, see the gene

Open `R/annotation_map.qmd`. The setup chunk is already there; it loads
the gene and prints its name and length.

Render with **Cmd+Shift+K** (Mac) or **Ctrl+Shift+K** (Windows). The
output goes to `docs/annotation_map.html`.

Open `docs/annotation_map.html` in a browser. You should see the gene
name, locus ID, length, and a count of exons, guides, and primer pairs.

> **Notes:** This first render is the smoke test. If anything is broken
> in the inputs or the env, it surfaces here, not three stages later.

---

## 9. First commit, by hand

You do this one yourself so you see plain git, no agent in the way.

```bash
git init -b main
git status
git add R/ source_qmds/ MANY_GENES_PRD.md crisprpen.yml .gitignore docs/
git commit -m "first commit: setup chunk renders for nmx"
git log --oneline
```

Note what is **not** in the commit: `data/`, `results/`, `env/`. They
are in `.gitignore` and will never be tracked.

> **Notes:** Point at the Source Control panel in Positron lighting up
> alongside the terminal output. Same information, two views. They will
> learn to use whichever they prefer.

---

## 10. Create the GitHub repo via the web UI

We use the web UI on purpose, so you see what `gh repo create` is
automating later.

1. Go to https://github.com, click **New repository**.
2. Name it `crisprpen-workshop`. **Public**. **Do not** add a README,
   `.gitignore`, or license. We have those locally already.
3. Click **Create repository**.
4. Follow GitHub's "**push an existing repository from the command line**"
   block, copy-paste the three commands into your Positron terminal.
5. Refresh the GitHub page. Your files appear.

Then enable Pages:

6. **Settings > Pages**. Source: **Deploy from a branch**. Branch:
   **main**, folder: **/docs**. Save.
7. Wait 1 to 2 minutes. Your URL appears at the top of the Pages
   settings: `https://YOU.github.io/crisprpen-workshop/annotation_map.html`.

> **Notes:** Pages on a public repo is free. If anyone wants their repo
> private, they need a Pro account for Pages to serve. Stick to public
> today.

---

## 11. Stage 2, cDNA annotation, Claude commits

Open `source_qmds/02_cdna.qmd` in a second editor tab. Copy the two
chunks shown there into `R/annotation_map.qmd` after the `## Gene`
section. Render.

The map now shows the gene line with exon ribbon.

In the Claude terminal:

```
I just added the cDNA exon annotation chunks to R/annotation_map.qmd
and re-rendered. Commit with a clear message that describes what
changed, then push.
```

Approve. Watch Claude run `git add`, write a commit message based on
the diff, `git commit`, `git push`. Refresh your Pages URL after a
minute. The new exon track is live.

> **Notes:** Claude does not write the qmd code. You paste it. Claude
> writes the commit message and runs the git commands. That separation
> is the point.

---

## 12. Stage 3, oligos, Claude commits

Open `source_qmds/03_oligos.qmd`. Copy the **three** chunks in. The
third chunk **replaces** the existing `plot-exons` chunk with the
expanded plot. Render.

The map now adds CRISPR guide bars and PCR amplicons (predicted by
e-PCR).

In the Claude terminal:

```
I added guide and amplicon annotation. Commit and push.
```

Approve. Refresh your Pages URL.

> **Notes:** This is the visual climax. The map looks like a real
> annotation now. Linger here.

---

## 13. Stage 4, GenBank export, Claude commits

Open `source_qmds/04_genbank.qmd`. Copy the two chunks in. Render.

You should see `Wrote ../results/nmx/<locus>_nmx.gbk`. Open the file
locally. Every feature you saw on the map is in there.

The `.gbk` file lives under `results/`, which is gitignored. It does
not get pushed and does not reach Pages. The nucleotide content stays
on your laptop.

In the Claude terminal:

```
I added the GenBank export step. Commit and push.
```

Approve.

> **Notes:** Show one of the resulting `.gbk` files in SnapGene or
> Benchling on the projector if you have one running. The wow is that
> they wrote a real ready-for-cloning artifact.

---

## 14. Stage 5, many genes

Hand Claude the spec:

```
Read MANY_GENES_PRD.md in the project root. Implement what it asks.
The single-gene pipeline is in R/annotation_map.qmd. Do not duplicate
its logic. When the runner works for the gene IDs in data/genes.txt,
commit and push.
```

This is the part where Claude works on its own from a written
specification, not a hand-held step. Watch what it does. Read each
proposed action before approving. If it goes off-spec, redirect it in
plain English.

> **Notes:** This slide is intentionally open-ended. There is no fixed
> right answer to demonstrate. The teaching point is that a written PRD
> plus an agent on a sandbox is a productive pattern, and that you stay
> in the loop because of the sandbox prompts.

---

## 15. Recap and where to go

You can now:

- Version-control a real R + bioinformatics project with Git
- Drive Claude Code from Positron's terminal under a sandbox
- Publish a rendered notebook at a public GitHub Pages URL
- Hand Claude a written spec and review its work before approving

Materials and follow-ups:

- Workshop repo: https://github.com/faustovrz/ccgarden
- Tutorials: `set_up_git_for_positron.qmd`, `build_first_repo_with_positron.qmd`
- Office hours: [your slot]

Stick around if you want help getting your *own* lab repo onto this
flow.

> **Notes:** The real win is when their actual research repos start
> using this loop. Soft-sell one-on-one help here.
