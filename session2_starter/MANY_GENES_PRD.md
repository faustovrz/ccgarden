# Stage 5 PRD: extend the pipeline to many genes

## Context

By the end of stage 4, the project renders `annotate_<gene>.qmd` for one
gene (`nmx`) using inputs in `data/nmx/` and writes a GenBank file to
`results/nmx/`. The repo is on GitHub, GitHub Pages serves `docs/` from
`main`.

## Goal

Run the same annotation pipeline for every gene present in the bundled
warehouse `data/all/`. Produce **one** rendered HTML page at
`docs/annotate_all.html` containing all genes as `## <gene>` sections,
with a Quarto sidebar TOC linking to each gene. **No tutorial prose**:
each gene section carries only the unified annotation table (as a
kable) and the annotation map. Plus one GenBank file per gene in
`results/<gene>/`. The HTML must follow the same redaction rules as
the single-gene render: no nucleotide content, only IDs, coordinates,
and feature counts.

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

- `docs/annotate_all.html`: single HTML with one `## <gene>` section
  per gene, each section showing the unified annotation table and the
  annotation map figure. Quarto TOC (`toc: true`, `toc-depth: 2`)
  gives the sidebar navigation.
- `results/<gene>/<locus_id>_<gene>.gbk` per gene
- A single commit per batch, message format
  `"render annotation maps for N genes (gene, gene, ...)"`

## Constraints

- The helpers in `helpers.R` are the source of truth for the
  pipeline (`search_cdna`, `search_guides`, `search_primer_pairs`,
  `build_annotation_table`, `plot_annotation`,
  `build_genbank_features`, `write_genbank`). The batch qmd calls
  them directly inside a `for` loop over genes; it does not paste or
  duplicate logic from the single-gene source slices.
- Per-gene data is read directly from `data/all/` in memory. The
  runner does not need to materialize temporary `data/<gene>/`
  folders unless that turns out to be simpler.
- Set `echo: false` at the document level (or per chunk) so the
  output is figures + tables only, no R code.
- No regressions on the redaction rules. The rendered HTML must not
  contain any FASTA, GenBank, BLAST output, or printed nucleotide
  sequence.
- Skip gracefully if a gene is missing from any input source in
  `data/all/`, logging which gene was skipped and why. A gene with
  no primer-pair row in `primer_pairs.sts` is not a skip; it just
  renders without an amplicon span.
- Total render time on a workshop laptop should stay under five
  minutes for the 19 genes.

## Acceptance check

- `docs/annotate_all.html` opens in a browser with a sidebar TOC
  showing every gene by short name. Clicking a TOC entry jumps to
  that gene's section.
- Each gene section shows the unified annotation table (kable) and
  the annotation map figure. No tutorial prose, no nucleotide
  sequence anywhere.
- Each `results/<gene>/*.gbk` is produced (file exists, nonzero
  size). We do not parse-validate inside the pipeline; R lost its
  maintained GenBank reader (`genbankr` was removed from
  Bioconductor) and the alternatives are not worth the dependency
  cost. Downstream consumers verify by opening the file in SnapGene,
  ApE, or Benchling.
- `git status` after the run shows changes only under `docs/`
  (`data/` and `results/` are gitignored).

## Prompt template for stage 5

Suggested prompt for the student to give Claude in the terminal:

> Read `MANY_GENES_PRD.md` in the project root. Write a single
> `annotate_all.qmd` that loops over every gene in `data/all/` and
> renders one HTML with a `## <gene>` section per gene, each section
> showing the unified annotation table and the annotation map. Use
> the helpers in `helpers.R` directly inside the loop; do not paste
> chunks from `source_qmds/`. Set `echo: false` so the output is
> figures and tables only. Also write one GenBank file per gene to
> `results/<gene>/`. When `docs/annotate_all.html` renders cleanly
> with a sidebar TOC of all genes, commit the new files with a
> message that names the genes rendered, then push.
