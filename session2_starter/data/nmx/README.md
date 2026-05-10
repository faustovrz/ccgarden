# `data/nmx/`

This folder is **not tracked in git** (see `.gitignore`). Place per-gene input
files here before rendering. Files expected for the workshop demo gene `nmx`:

| File          | What it is                                                      |
|---------------|------------------------------------------------------------------|
| `genomic.fa`  | Pre-extracted padded genomic sequence, single FASTA record.      |
| `cdna.fa`     | cDNA transcript(s) for the gene. One or more FASTA records.      |
| `oligos.fa`   | sgRNAs and primers as FASTA. Header tags: `gene=`, `type=`, `pair=`. |
| `meta.yml`    | Gene metadata. See `meta.yml` in this folder for the schema.     |

## `oligos.fa` header convention

Header tags are space-separated `key=value` pairs after the oligo ID.

```
>nmx_g1 gene=nmx type=CRISPR_guide
>nmx_F1 gene=nmx type=forward_primer pair=1
>nmx_R1 gene=nmx type=reverse_primer pair=1
>nmx_F2 gene=nmx type=forward_primer pair=2
>nmx_R2 gene=nmx type=reverse_primer pair=2
```

- `type` must be one of `CRISPR_guide`, `forward_primer`, `reverse_primer`.
- `pair` is required for primers and ignored for guides. The forward and
  reverse primer that should amplify together share the same `pair` value.
- The pipeline searches guides against `genomic.fa` with `blastn -task blastn-short`
  and searches primer pairs with e-PCR (`re-PCR -s`), so amplicon spans come
  from valid primer pairs, not from each primer placed independently.

## How to generate from the LH244 sources

The padded `genomic.fa` is pulled from the LH244 genome BLAST DB once with
`blastdbcmd`, taking the gene start and end from the GFF3 with the project's
default flank size and reverse-complementing minus-strand genes so the padded
sequence is gene-forward. The cDNA is the matching transcript record extracted
from the LH244 cDNA FASTA. The oligos are the subset of `crispr_oligos.fa`
where `gene=nmx`, with `pair=` tags added to the primer headers. Update
`meta.yml` with the resulting coordinates.
