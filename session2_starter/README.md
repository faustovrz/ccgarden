# `session2_starter/`

Project skeleton for the ccgarden Session 2 workshop. Copy this folder
into your own working directory and follow the slides.

## Layout

```
_quarto.yml           # quarto project config (output goes to docs/)
crisprpen.yml         # conda env: blast + e-pcr
.gitignore            # keeps env/, data/, results/ out of your repo
annotation_map.qmd    # the qmd you render
source_qmds/          # paste sources for stages 2 to 4
  02_cdna.qmd
  03_oligos.qmd
  04_genbank.qmd
MANY_GENES_PRD.md     # spec for the final many-genes prompt
```

The pipeline expects per-gene inputs under `data/<gene_id>/`. The
`data/` folder is gitignored, so nothing in it is tracked. Populate it
yourself or via Claude during the workshop.

## Per-gene inputs

For each gene, `data/<gene_id>/` should contain:

| File          | What it is                                                       |
|---------------|------------------------------------------------------------------|
| `genomic.fa`  | Pre-extracted padded genomic sequence, single FASTA record. The FASTA ID is taken as the locus_id. |
| `cdna.fa`     | cDNA transcript(s) for the gene. One or more FASTA records.      |
| `oligos.fa`   | sgRNAs and primers as FASTA. Header tags: `gene=`, `type=`, `pair=`. |
| `gene.gff3`   | A subset of the genome GFF3 containing the gene record and its child features (mRNA, exon, CDS). The qmd reads the `gene` row to get chromosome, strand, and gene coordinates. |

### `oligos.fa` header convention

Space-separated `key=value` tags after the oligo ID.

```
>nmx_g1 gene=nmx type=CRISPR_guide
>nmx_F1 gene=nmx type=forward_primer pair=1
>nmx_R1 gene=nmx type=reverse_primer pair=1
>nmx_F2 gene=nmx type=forward_primer pair=2
>nmx_R2 gene=nmx type=reverse_primer pair=2
```

- `type` must be one of `CRISPR_guide`, `forward_primer`, `reverse_primer`.
- `pair` is required for primers, ignored for guides. The forward and
  reverse that should amplify together share the same `pair` value.
- The pipeline searches guides against `genomic.fa` with
  `blastn -task blastn-short` and searches primer pairs with e-PCR
  (`re-PCR -s`).

### `gene.gff3` shape

A minimal GFF3 fragment for one gene, e.g.:

```
chr9	EVM	gene	160874120	160879319	.	-	.	ID=Zm00116aa461920
chr9	EVM	exon	160874120	160874329	.	-	.	ID=...;Parent=Zm00116aa461920_T001
chr9	EVM	CDS	160874120	160874329	.	-	0	ID=...;Parent=Zm00116aa461920_T001
...
```

Only the `gene` row is required by the qmd. The other rows are useful
when the GenBank export and the annotation map round-trip back into
SnapGene or Benchling. Extract from your genome's full GFF3 with
something like:

```bash
grep -P '(ID|Parent)=<locus_id>($|;|_T|\.exon|\.cds)' \
  full_genome.gff3 > data/<gene_id>/gene.gff3
```

### Gene name

The gene name is taken from the folder name (`data/<gene_id>/`), so put
the gene under `data/nmx/`, `data/hpc1/`, etc. The qmd's `params: gene`
defaults to `nmx`; render with `quarto render R/annotation_map.qmd -P gene:hpc1`
to switch.

### Padded genomic sequence

The `genomic.fa` you supply is expected to be the gene plus a symmetric
flank (default 500 bp) on each side, reverse-complemented if the gene
is on the minus strand so the sequence is always gene-forward. The qmd
infers `gene_offset` and `flank_bp` from `(padded_length - gene_length) / 2`.
