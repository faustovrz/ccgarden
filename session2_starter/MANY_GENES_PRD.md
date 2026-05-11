# Stage 5 PRD: extend the pipeline to many genes

## Context

By the end of stage 4, the project renders `annotate_<gene>.qmd` for one
gene (`nmx`) using inputs in `data/nmx/` and writes a GenBank file to
`results/nmx/`. The repo is on GitHub, GitHub Pages serves `docs/` from
`main`.

## Goal

Run the same annotation pipeline for every gene present in the bundled
warehouse `data/all/`. For each gene, produce a rendered HTML page in
`docs/<gene>/` and a GenBank file in `results/<gene>/`. The HTML pages
must follow the same redaction rules as the single-gene render: no
nucleotide content, only IDs, coordinates, and feature counts.

## Inputs

A single bundled warehouse at `data/all/`:

| File         | Content                                                            |
|--------------|---------------------------------------------------------------------|
| `genomic.fa` | Multi-FASTA. One padded genomic record per gene. Headers carry `gene=<short>` and `chr=<chr>:<start>-<end>:<strand>` tags. The FASTA ID is the locus_id. |
| `cdna.fa`    | Multi-FASTA. One cDNA transcript per gene. Headers carry `gene=<short>`. |
| `guides.fa`         | Multi-FASTA. CRISPR guides only. Headers carry `gene=<short>` and `type=CRISPR_guide`. |
| `primer_pairs.sts`  | NCBI e-PCR native format. One line per primer pair, STS_ID encoded as `<cultivar>_<gene>|<fwd_short>:<rev_short>`. |
| `genes.gff3`        | GFF3 subset with one `gene` record per target plus its child `exon` and `CDS` records. |

The list of genes is the set of `gene=<short>` tags that appears
consistently across `genomic.fa`, `cdna.fa`, and `guides.fa`, plus
matching STS_ID prefixes in `primer_pairs.sts`. A gene that is missing
from any of those is skipped.

## Outputs

- `docs/<gene>/annotate_<gene>.html` per gene
- `docs/index.html` listing every per-gene page, showing the gene short
  name, locus_id, padded length, and a feature count summary
- `results/<gene>/<locus_id>_<gene>.gbk` per gene
- A single commit per batch, message format
  `"render annotation maps for N genes (gene, gene, ...)"`

## Constraints

- The single-gene `annotate_<gene>.qmd` is the source of truth for the
  pipeline. The many-gene runner must not duplicate its logic. Either:
  - parameterize the qmd via `params: gene` and call
    `quarto render annotate_<gene>.qmd -P gene:<gene>` in a loop with the
    per-gene folder already populated, or
  - refactor the chunks into a function the loop calls directly.
- For each gene, the runner produces a `data/<gene>/` folder by
  splitting the relevant records out of `data/all/`. That folder
  contains `genomic.fa`, `cdna.fa`, `guides.fa`, `primer_pairs.sts`,
  and `gene.gff3`, the same layout the single-gene qmd already expects.
- No regressions on the redaction rules. The published `docs/` tree
  must not contain any FASTA, GenBank, BLAST output, or printed
  nucleotide sequence.
- Skip gracefully if a gene is missing from any input file in
  `data/all/`, logging which gene was skipped and why.
- Total render time on a workshop laptop should stay under five minutes
  for the demo set.

## Acceptance check

- `docs/index.html` opens in a browser and links to each per-gene page.
- Each per-gene page shows the gene short name, locus_id, length, exon
  count, guide count, primer-pair count, and the annotation map figure.
- Each `results/<gene>/*.gbk` parses as a valid GenBank file (e.g., via
  `python -c "from Bio import SeqIO; SeqIO.read(open('...'), 'genbank')"`).
- `git status` after the run shows changes only under `docs/` (data/
  and results/ are gitignored).

## Prompt template for stage 5

Suggested prompt for the student to give Claude in the Code tab:

> Read `MANY_GENES_PRD.md` in the project root. Implement the stage 5
> many-genes runner that meets the spec. The bundled inputs are at
> `data/all/`. The single-gene pipeline lives in `annotate_<gene>.qmd`.
> Do not duplicate its logic; split per gene and call it. When the
> runner has produced `docs/<gene>/annotate_<gene>.html` for every gene
> present in `data/all/`, commit the new files with a message that
> names the genes rendered, then push.
