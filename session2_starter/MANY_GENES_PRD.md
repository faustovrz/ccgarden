# Stage 5 PRD: extend the pipeline to many genes

## Context

By the end of stage 4, the project renders `R/annotation_map.qmd` for one
gene (`nmx`) using inputs in `data/nmx/` and writes a GenBank file to
`results/nmx/`. The repo is on GitHub, GitHub Pages serves `docs/` from `main`.

## Goal

Run the same annotation pipeline for a list of N genes. For each gene,
produce a rendered HTML page in `docs/<gene_id>/` and a GenBank file in
`results/<gene_id>/`. The HTML pages must follow the same redaction rules
as the single-gene render: no nucleotide content, only IDs, coordinates,
and feature counts.

## Inputs

- `data/<gene_id>/` for each gene_id in the list, with the same four files
  the single-gene pipeline expects: `genomic.fa`, `cdna.fa`, `oligos.fa`,
  `meta.yml`.
- A list of gene_ids. Either:
  - a plain text file `data/genes.txt` with one gene_id per line, or
  - a positional argument or list passed to the runner.

## Outputs

- `docs/<gene_id>/annotation_map.html` for each gene
- `docs/index.html` linking to each per-gene page, with the gene name and
  feature counts shown in a table
- `results/<gene_id>/<locus_id>_<gene_name>.gbk` for each gene
- A single commit per render batch, message format
  `"render annotation maps for N genes (gene_id, gene_id, ...)"`

## Constraints

- The single-gene `R/annotation_map.qmd` is the source of truth for the
  pipeline. The many-gene runner must call the same logic, not duplicate it.
  Either parameterize the qmd via `params: gene` and call
  `quarto render R/annotation_map.qmd -P gene:<gene_id> --output-dir docs/<gene_id>`
  in a loop, or refactor the chunks into a function the loop calls.
- No regressions on the redaction rules. The published `docs/` tree must not
  contain any FASTA, GenBank, BLAST output, or printed nucleotide sequence.
- The run must skip gracefully if a gene's data folder is missing files,
  logging which gene was skipped and why.
- Total render time on a workshop laptop should stay under 5 minutes for
  the demo set.

## Acceptance check

- `docs/index.html` opens in a browser and links to each per-gene page
- Each per-gene page shows the gene name, locus ID, length, exon count,
  guide count, primer count, and the annotation map figure
- Each `results/<gene_id>/*.gbk` parses as a valid GenBank file (e.g., via
  `python -c "from Bio import SeqIO; SeqIO.read(open('...'), 'genbank')"`)
- `git status` after the run shows changes only under `docs/` (results/
  and data/ are gitignored)

## Prompt template for stage 5

Suggested prompt for students to give Claude in the Code tab:

> Read `MANY_GENES_PRD.md` in the project root. Implement the many-genes
> stage that meets the spec. The single-gene pipeline lives in
> `R/annotation_map.qmd`. Do not duplicate its logic. After the runner
> works for the gene IDs listed in `data/genes.txt`, commit the new files
> with a message that names the genes rendered, then push.
