# ccgarden

![Positron running iris_anova.R: editor, Variables pane, and Plots pane all visible at once](Screenshot_ccgarden.png)

A small, walled-garden tutorial for getting an R lab onto **Claude Code** and
**Positron** — the way you'd onboard a kindergarten class to a new playground:
slowly, with everything in arm's reach, and one thing at a time.

The materials are designed for a **two-session lab workshop**, but each file
also stands on its own.

**Demo project:** [faustovrz/iris-test](https://github.com/faustovrz/iris-test) — the analysis files participants create and publish during the workshop.

## Who this is for

R users who:

- already know how to write a bit of R,
- have heard of Git but never quite set it up,
- want to try Claude Code (or Anthropic's Claude Desktop / Claude extension)
  inside a real reproducible-research workflow,
- and would like to publish a notebook on the web at the end.

You do **not** need to know Quarto, GitHub, or any LLM tooling beforehand.

## The two sessions

### Session 1 — Install and first taste (~90 min)

Install the tools and get one quick win in each.

1. Install **Claude Desktop**, **R**, **Positron**, and the **Claude extension**
   for Positron.
2. **Payoff A:** step through `iris_anova.R` in Positron — see the **Plots**,
   **Variables**, **Help**, and **Data Explorer** panes light up.
3. **Payoff B:** render `iris_anova.qmd` and publish it to
   [Posit Connect Cloud](https://connect.posit.cloud).
4. **Payoff C:** use Claude Desktop to generate `iris_pca.qmd`, render it,
   and publish.

### Session 2 — Git and the prompt-to-publish loop (~90 min)

Add version control to the project, push to GitHub, and use Claude Desktop
to edit, commit, and push — with the published page updating automatically.

1. Walk through [`set_up_git_for_positron.qmd`](set_up_git_for_positron.qmd)
   to configure Git and a GitHub Personal Access Token.
2. Turn the `iris-test` folder into a Git repo, commit, and push to GitHub.
3. Publish from the GitHub repo on Connect Cloud (auto-updates on push).
4. Use Claude Desktop to edit the notebook, commit, and push — the published
   page updates without manual republishing.

## Files in this repo

| File | What it is |
|---|---|
| [`set_up_git_for_positron.qmd`](set_up_git_for_positron.qmd) | Tutorial: install Git, configure name/email, create and store a GitHub PAT |
| [`build_first_repo_with_positron.qmd`](build_first_repo_with_positron.qmd) | Tutorial: create an R project in Positron, set up a folder structure, first commit, push to GitHub |
| [`build_first_repo_with_positron.md`](build_first_repo_with_positron.md) | Rendered (GitHub-readable) version of the tutorial above |

The analysis files (`iris_anova.R`, `iris_anova.qmd`, `iris_anova.Rmd`) live in the companion repo [faustovrz/iris-test](https://github.com/faustovrz/iris-test).

## Prerequisites checklist

Send this to participants **before Session 1** so the install party isn't
also a signup party:

- [ ] **GitHub account** created and email-verified
- [ ] **Anthropic account** at [claude.ai](https://claude.ai) (Pro plan
      recommended so Claude Code can use the subscription instead of an API key)
- [ ] **Posit account** at [connect.posit.cloud](https://connect.posit.cloud) —
      sign in with Google or GitHub to skip a fourth password
- [ ] All three passwords/sessions accessible at the start of the workshop

## License

Use freely. Attribution appreciated but not required.
