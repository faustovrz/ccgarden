# Helpers for the CRISPR target gene annotation pipeline.
# Sourced from annotate_<gene>.qmd. Kept here so the rendered notebook
# focuses on the pipeline, not on string formatting or feature plumbing.

# ---------------------------------------------------------------------
# FASTA parsing

parse_fasta <- function(fasta_file) {
  lines <- readLines(fasta_file, warn = FALSE)
  idx   <- grep("^>", lines)
  lapply(seq_along(idx), function(i) {
    start <- idx[i]
    end   <- if (i < length(idx)) idx[i + 1] - 1 else length(lines)
    hdr   <- sub("^>", "", lines[start])
    seq_text <- paste(lines[(start + 1):end], collapse = "")
    parts <- strsplit(hdr, "\\s+")[[1]]
    list(
      header   = hdr,
      name     = parts[1],
      sequence = seq_text,
      length   = nchar(seq_text)
    )
  })
}

parse_oligo_meta <- function(fasta_file) {
  hdrs <- grep("^>", readLines(fasta_file, warn = FALSE), value = TRUE)
  do.call(rbind, lapply(hdrs, function(h) {
    h <- sub("^>", "", h)
    parts  <- strsplit(h, "\\s+")[[1]]
    type_f <- sub("^type=", "", grep("^type=", parts, value = TRUE))
    data.frame(
      oligo_id   = parts[1],
      oligo_type = ifelse(length(type_f) > 0, type_f, NA_character_),
      stringsAsFactors = FALSE
    )
  }))
}

# Read the per-gene primer-pair STS file in NCBI e-PCR native format:
#   STS_ID  FWD_SEQ  REV_SEQ  SIZE_RANGE
# Comments (lines starting with #) and blank lines are skipped.
parse_sts_file <- function(sts_path) {
  lines <- readLines(sts_path, warn = FALSE)
  lines <- lines[!grepl("^#", lines) & nzchar(lines)]
  if (length(lines) == 0) {
    return(data.frame(sts_id = character(0), fwd_seq = character(0),
                      rev_seq = character(0), size_range = character(0),
                      stringsAsFactors = FALSE))
  }
  parts <- strsplit(lines, "\t")
  do.call(rbind, lapply(parts, function(p) {
    data.frame(sts_id = p[1], fwd_seq = p[2], rev_seq = p[3],
               size_range = p[4], stringsAsFactors = FALSE)
  }))
}

# Parse the structured STS_ID `<cultivar>_<gene>|<fwd_short>:<rev_short>`
# into its components. fwd_id and rev_id are reconstructed by prefixing
# the short forms with `gene_short` (e.g. "pg1f1" + "nmx" -> "nmxpg1f1").
parse_sts_id <- function(sts_id, gene_short) {
  left_right <- strsplit(sts_id, "\\|", fixed = FALSE)[[1]]
  prefix     <- left_right[1]
  pair_part  <- if (length(left_right) > 1) left_right[2] else NA_character_

  cultivar_gene <- strsplit(prefix, "_", fixed = TRUE)[[1]]
  cultivar      <- cultivar_gene[1]

  pair_shorts <- if (!is.na(pair_part)) strsplit(pair_part, ":", fixed = TRUE)[[1]]
                  else c(NA_character_, NA_character_)
  fwd_short <- pair_shorts[1]
  rev_short <- if (length(pair_shorts) > 1) pair_shorts[2] else NA_character_

  list(
    cultivar  = cultivar,
    gene      = gene_short,
    fwd_short = fwd_short,
    rev_short = rev_short,
    fwd_id    = if (!is.na(fwd_short)) paste0(gene_short, fwd_short) else NA_character_,
    rev_id    = if (!is.na(rev_short)) paste0(gene_short, rev_short) else NA_character_
  )
}

read_gene_record <- function(gff_file) {
  gff <- read.table(gff_file, sep = "\t", quote = "", comment.char = "#",
                    stringsAsFactors = FALSE, fill = TRUE,
                    col.names = c("chr", "source", "type", "start", "end",
                                  "score", "strand", "phase", "attributes"))
  gene <- gff[gff$type == "gene", ][1, ]
  stopifnot("No 'gene' record in gene.gff3" = nrow(gene) == 1 && !is.na(gene$chr))
  list(
    chromosome = gene$chr,
    strand     = gene$strand,
    gene_start = as.integer(gene$start),
    gene_end   = as.integer(gene$end)
  )
}

# ---------------------------------------------------------------------
# Search helpers
#
# Each helper runs one BLAST or e-PCR query and returns the hits as a
# data frame ready for build_annotation_table. The chunk that calls
# them is one line of work plus a cat() summary.

BLAST_COL_NAMES <- c("Query", "Subject", "Identity", "Aln.Length",
                     "Mismatches", "Gaps", "Q.start", "Q.end",
                     "S.start", "S.end", "E.value", "Bit.score",
                     "Q.len", "S.len")

# Find exons by BLASTing the padded genomic against the gene's cDNA.
# Returns a data frame with BLAST tabular columns; Q.start/Q.end are the
# exon's coords on the gene-forward genomic axis.
search_cdna <- function(genomic_path, cdna_path) {
  cmd <- sprintf(
    paste(
      'blastn -task megablast -query %s -subject %s',
      '-max_hsps 50',
      '-outfmt "6 qseqid sseqid pident length mismatch gapopen',
      'qstart qend sstart send evalue bitscore qlen slen"'
    ),
    shQuote(genomic_path), shQuote(cdna_path)
  )
  out <- system(cmd, intern = TRUE)
  if (length(out) == 0) return(data.frame())
  read.table(text = out, sep = "\t", stringsAsFactors = FALSE,
             col.names = BLAST_COL_NAMES)
}

# Place CRISPR guides on the gene with blastn-short. Keeps only
# near-full-length hits at >= 95% identity.
search_guides <- function(genomic_path, guides_path) {
  cmd <- sprintf(
    paste(
      'blastn -task blastn-short -query %s -subject %s',
      '-word_size 7 -evalue 1000 -dust no -soft_masking false',
      '-ungapped -perc_identity 85 -max_target_seqs 50',
      '-outfmt "6 qseqid sseqid pident length mismatch gapopen',
      'qstart qend sstart send evalue bitscore qlen slen"'
    ),
    shQuote(genomic_path), shQuote(guides_path)
  )
  out <- system(cmd, intern = TRUE)
  if (length(out) == 0) return(data.frame())
  hits <- read.table(text = out, sep = "\t", stringsAsFactors = FALSE,
                     col.names = BLAST_COL_NAMES)
  hits$strand <- ifelse(hits$S.start <= hits$S.end, "+", "-")
  hits[hits$Aln.Length >= (hits$S.len - 2) & hits$Identity >= 95, ]
}

# Search for primer-pair amplicons with e-PCR. Builds the famap+fahash
# index from the padded genomic, runs `re-PCR -S` against the gene's
# primer_pairs.sts, and decodes each STS_ID into fwd_id / rev_id plus
# primer sequence lengths drawn from sts_table.
search_primer_pairs <- function(genomic_path, sts_path, sts_table, gene_id) {
  famap_file <- tempfile(fileext = ".famap")
  hash_file  <- tempfile(fileext = ".hash")
  system2("famap",  c("-t", "N", "-b", famap_file, genomic_path),
          stdout = FALSE, stderr = FALSE)
  system2("fahash", c("-b", hash_file, famap_file),
          stdout = FALSE, stderr = FALSE)
  out <- system2("re-PCR", c("-S", hash_file, sts_path),
                 stdout = TRUE, stderr = FALSE)
  unlink(c(famap_file, hash_file))

  empty <- data.frame(seq_id = character(0), sts_id = character(0),
                      strand = character(0), start = integer(0),
                      end = integer(0), size = integer(0),
                      fwd_id = character(0), rev_id = character(0),
                      fwd_len = integer(0), rev_len = integer(0),
                      stringsAsFactors = FALSE)

  data_lines <- out[!grepl("^#", out) & nzchar(out)]
  if (length(data_lines) == 0) return(empty)
  raw <- read.table(text = data_lines, sep = "\t", fill = TRUE,
                    stringsAsFactors = FALSE)

  decoded   <- lapply(raw$V1, parse_sts_id, gene_short = gene_id)
  fwd_ids   <- vapply(decoded, function(d) d$fwd_id, character(1))
  rev_ids   <- vapply(decoded, function(d) d$rev_id, character(1))
  sts_idx   <- setNames(seq_len(nrow(sts_table)), sts_table$sts_id)
  fwd_lens  <- vapply(raw$V1, function(id) {
    i <- sts_idx[[id]]; if (is.null(i)) NA_integer_ else nchar(sts_table$fwd_seq[i])
  }, integer(1))
  rev_lens  <- vapply(raw$V1, function(id) {
    i <- sts_idx[[id]]; if (is.null(i)) NA_integer_ else nchar(sts_table$rev_seq[i])
  }, integer(1))

  data.frame(
    seq_id  = raw$V2,
    sts_id  = raw$V1,
    strand  = raw$V3,
    start   = as.integer(raw$V4),
    end     = as.integer(raw$V5),
    size    = as.integer(raw$V5) - as.integer(raw$V4) + 1L,
    fwd_id  = fwd_ids,
    rev_id  = rev_ids,
    fwd_len = fwd_lens,
    rev_len = rev_lens,
    stringsAsFactors = FALSE
  )
}

# ---------------------------------------------------------------------
# Unified annotation table
#
# One row per feature on the gene-forward padded genomic sequence.
# Columns:
#   seq_id     character    FASTA ID of the padded genomic record
#   feat_type  character    gene | exon | CRISPR_guide | Amplicon |
#                            forward_primer | reverse_primer
#   start      integer      1-based, start <= end
#   end        integer      1-based, end >= start
#   strand     character    "+" or "-"
#   name       character    label
#   note       character    freeform note (may be empty)

empty_annotation_row <- function() {
  data.frame(seq_id = character(0), feat_type = character(0),
             start = integer(0), end = integer(0),
             strand = character(0), name = character(0), note = character(0),
             stringsAsFactors = FALSE)
}

build_annotation_table <- function(q, meta, exon_hits = NULL,
                                   guide_hits = NULL, amp_hits = NULL) {
  rows <- list()

  # gene (on the gene-forward genomic.fa, the gene runs "+")
  if (!is.null(meta$gene_offset) && meta$gene_offset > 0) {
    rows[[length(rows) + 1]] <- data.frame(
      seq_id = q$name, feat_type = "gene",
      start  = meta$gene_offset + 1L,
      end    = meta$gene_offset + meta$gene_length,
      strand = "+", name = q$gene_name,
      note   = sprintf("locus_tag=%s", q$name),
      stringsAsFactors = FALSE
    )
  }

  # exons
  if (!is.null(exon_hits) && nrow(exon_hits) > 0) {
    ordered <- exon_hits[order(pmin(exon_hits$Q.start, exon_hits$Q.end)), ]
    for (j in seq_len(nrow(ordered))) {
      ex <- ordered[j, ]
      rows[[length(rows) + 1]] <- data.frame(
        seq_id = ex$Query, feat_type = "exon",
        start  = min(ex$Q.start, ex$Q.end),
        end    = max(ex$Q.start, ex$Q.end),
        strand = "+", name = sprintf("exon_%d", j),
        note   = sprintf("identity=%.1f%%", ex$Identity),
        stringsAsFactors = FALSE
      )
    }
  }

  # CRISPR guides
  if (!is.null(guide_hits) && nrow(guide_hits) > 0) {
    for (j in seq_len(nrow(guide_hits))) {
      g <- guide_hits[j, ]
      rows[[length(rows) + 1]] <- data.frame(
        seq_id = g$Query, feat_type = "CRISPR_guide",
        start  = min(g$Q.start, g$Q.end),
        end    = max(g$Q.start, g$Q.end),
        strand = g$strand, name = g$Subject, note = "",
        stringsAsFactors = FALSE
      )
    }
  }

  # Amplicons + derived primer_bind rows. amp_hits is expected to carry
  # sts_id, fwd_id, rev_id, fwd_len, rev_len already filled in.
  if (!is.null(amp_hits) && nrow(amp_hits) > 0) {
    for (j in seq_len(nrow(amp_hits))) {
      a <- amp_hits[j, ]
      amp_strand <- if (is.na(a$strand) || a$strand == "+") "+" else "-"
      amp_lo <- min(a$start, a$end)
      amp_hi <- max(a$start, a$end)

      rows[[length(rows) + 1]] <- data.frame(
        seq_id = a$seq_id, feat_type = "Amplicon",
        start = amp_lo, end = amp_hi, strand = amp_strand,
        name = a$sts_id,
        note = sprintf("e-PCR predicted product, %d bp", a$size),
        stringsAsFactors = FALSE
      )

      fwd_len <- if (!is.null(a$fwd_len) && !is.na(a$fwd_len)) a$fwd_len else 20L
      rev_len <- if (!is.null(a$rev_len) && !is.na(a$rev_len)) a$rev_len else 20L

      if (amp_strand == "+") {
        fwd_start <- amp_lo
        fwd_end   <- amp_lo + fwd_len - 1L
        rev_start <- amp_hi - rev_len + 1L
        rev_end   <- amp_hi
        fwd_str   <- "+"
        rev_str   <- "-"
      } else {
        fwd_start <- amp_hi - fwd_len + 1L
        fwd_end   <- amp_hi
        rev_start <- amp_lo
        rev_end   <- amp_lo + rev_len - 1L
        fwd_str   <- "-"
        rev_str   <- "+"
      }

      rows[[length(rows) + 1]] <- data.frame(
        seq_id = a$seq_id, feat_type = "forward_primer",
        start = fwd_start, end = fwd_end, strand = fwd_str,
        name = a$fwd_id, note = sprintf("sts=%s", a$sts_id),
        stringsAsFactors = FALSE
      )
      rows[[length(rows) + 1]] <- data.frame(
        seq_id = a$seq_id, feat_type = "reverse_primer",
        start = rev_start, end = rev_end, strand = rev_str,
        name = a$rev_id, note = sprintf("sts=%s", a$sts_id),
        stringsAsFactors = FALSE
      )
    }
  }

  if (length(rows) == 0) return(empty_annotation_row())
  do.call(rbind, rows)
}

# ---------------------------------------------------------------------
# GenBank flat-file writer

gbk_location <- function(start, end, strand = "+") {
  s <- min(start, end)
  e <- max(start, end)
  if (strand == "-") sprintf("complement(%d..%d)", s, e)
  else               sprintf("%d..%d", s, e)
}

# GenBank feature type for each annotation feat_type. Anything not in the
# map falls back to "misc_feature".
GBK_TYPE_MAP <- c(
  gene            = "gene",
  exon            = "exon",
  CRISPR_guide    = "misc_binding",
  Amplicon        = "misc_feature",
  forward_primer  = "primer_bind",
  reverse_primer  = "primer_bind"
)

build_genbank_comments <- function(meta) {
  c(
    sprintf("Chromosome: %s", meta$chromosome),
    sprintf("Strand: %s", meta$strand),
    sprintf("Padded region: %s:%d..%d (+/-%d bp flanking)",
            meta$chromosome, meta$padded_start, meta$padded_end, meta$flank_bp)
  )
}

# Build the GenBank features list from the unified annotation table plus
# a source feature derived from `meta` and `q`. Each annotation row
# becomes one GenBank feature; the gbk feature type comes from
# GBK_TYPE_MAP.
build_genbank_features <- function(annotation, q, meta) {
  features <- list()

  # source (not in the annotation table; describes the whole record)
  features[[length(features) + 1]] <- list(
    type = "source",
    location = sprintf("1..%d", q$length),
    qualifiers = list(
      list(key = "organism", value = "Zea mays"),
      list(key = "mol_type", value = "genomic DNA"),
      list(key = "cultivar", value = "LH244"),
      list(key = "db_xref",  value = "taxon:4577"),
      list(key = "chromosome", value = meta$chromosome),
      list(key = "note",     value = sprintf("LH244 CAU padded region: %s:%d..%d(%s)",
                                             meta$chromosome, meta$padded_start,
                                             meta$padded_end, meta$strand))
    )
  )

  for (i in seq_len(nrow(annotation))) {
    row <- annotation[i, ]
    gbk_type <- GBK_TYPE_MAP[row$feat_type]
    if (is.na(gbk_type)) gbk_type <- "misc_feature"

    quals <- list(list(key = "label", value = row$name))
    # Special-case the gene feature so it carries /gene and /locus_tag like a
    # canonical NCBI gene record.
    if (row$feat_type == "gene") {
      quals <- list(
        list(key = "gene",      value = row$name),
        list(key = "locus_tag", value = sub("^locus_tag=", "", row$note))
      )
    } else if (nzchar(row$note)) {
      quals <- c(quals, list(list(key = "note", value = row$note)))
    }

    features[[length(features) + 1]] <- list(
      type = gbk_type,
      location = gbk_location(row$start, row$end, row$strand),
      qualifiers = quals
    )
  }
  features
}

write_genbank <- function(filepath, gene_name, locus_id, sequence, features,
                          comment_lines = character(0)) {
  seq_len_val <- nchar(sequence)
  date_str    <- toupper(format(Sys.Date(), "%d-%b-%Y"))
  lines <- character(0)

  lines <- c(lines, sprintf("LOCUS       %-16s %7d bp    DNA     linear   PLN %s",
                            locus_id, seq_len_val, date_str))
  lines <- c(lines, sprintf("DEFINITION  Zea mays cultivar LH244 %s (%s) genomic sequence.",
                            locus_id, gene_name))
  lines <- c(lines, sprintf("ACCESSION   %s", locus_id))
  lines <- c(lines, sprintf("VERSION     %s", locus_id))
  lines <- c(lines, "KEYWORDS    .")
  lines <- c(lines, "SOURCE      Zea mays (maize)")
  lines <- c(lines, "  ORGANISM  Zea mays")
  lines <- c(lines, "            Eukaryota; Viridiplantae; Streptophyta; Embryophyta;")
  lines <- c(lines, "            Tracheophyta; Spermatophyta; Magnoliopsida; Liliopsida;")
  lines <- c(lines, "            Poales; Poaceae; PACMAD clade; Panicoideae;")
  lines <- c(lines, "            Andropogonodae; Andropogoneae; Tripsacinae; Zea.")

  if (length(comment_lines) > 0) {
    lines <- c(lines, sprintf("COMMENT     %s", comment_lines[1]))
    for (cl in comment_lines[-1]) {
      lines <- c(lines, sprintf("            %s", cl))
    }
  }

  lines <- c(lines, "FEATURES             Location/Qualifiers")
  for (feat in features) {
    lines <- c(lines, sprintf("     %-16s%s", feat$type, feat$location))
    for (qual in feat$qualifiers) {
      lines <- c(lines, sprintf("                     /%s=\"%s\"", qual$key, qual$value))
    }
  }

  seq_lower <- tolower(sequence)
  lines <- c(lines, "ORIGIN")
  for (start_pos in seq(1, seq_len_val, by = 60)) {
    end_pos <- min(start_pos + 59, seq_len_val)
    chunk   <- substr(seq_lower, start_pos, end_pos)
    groups  <- regmatches(chunk, gregexpr(".{1,10}", chunk))[[1]]
    lines <- c(lines, sprintf("%9d %s", start_pos, paste(groups, collapse = " ")))
  }
  lines <- c(lines, "//")
  writeLines(lines, filepath)
}

# ---------------------------------------------------------------------
# Plot

# Build the gggenomes annotation map directly from the unified annotation
# table. Returns a ggplot object the chunk just prints.
plot_annotation <- function(annotation, q, meta) {
  gene_seq <- data.frame(seq_id = q$name, length = q$length)

  pick <- function(types) {
    rows <- annotation[annotation$feat_type %in% types,
                        c("seq_id", "start", "end", "feat_type", "name")]
    if (nrow(rows) == 0) {
      data.frame(seq_id = character(0), start = integer(0), end = integer(0),
                 feat_type = character(0), name = character(0),
                 stringsAsFactors = FALSE)
    } else rows
  }

  exon_feats  <- pick("exon")
  if (nrow(exon_feats) > 0) exon_feats$feat_type <- "Exon"

  guide_feats <- pick("CRISPR_guide")
  amp_feats   <- pick("Amplicon")

  # Primers: gggenomes draws "genes" as arrows; flip start/end for "-" strand
  # rows so the arrow points the right way.
  primer_rows <- annotation[annotation$feat_type %in% c("forward_primer", "reverse_primer"), ]
  primer_genes <- if (nrow(primer_rows) > 0) {
    is_rev <- primer_rows$strand == "-"
    data.frame(
      seq_id    = primer_rows$seq_id,
      start     = ifelse(is_rev, primer_rows$end,   primer_rows$start),
      end       = ifelse(is_rev, primer_rows$start, primer_rows$end),
      feat_type = primer_rows$feat_type,
      name      = primer_rows$name,
      stringsAsFactors = FALSE
    )
  } else {
    data.frame(seq_id = character(0), start = integer(0), end = integer(0),
               feat_type = character(0), name = character(0),
               stringsAsFactors = FALSE)
  }

  p <- gggenomes(
    seqs  = gene_seq,
    genes = primer_genes,
    feats = list(exons = exon_feats, guides = guide_feats, amplicons = amp_feats)
  ) +
    geom_seq() +
    geom_feat(data = feats(exons),
              aes(y = y - 0.18, yend = y - 0.18, color = feat_type),
              position = "identity", linewidth = 5, alpha = 0.85) +
    geom_feat(data = feats(amplicons),
              aes(y = y + 0.22, yend = y + 0.22, color = feat_type),
              position = "identity", linewidth = 2.5, alpha = 0.7) +
    geom_feat(data = feats(guides),
              aes(color = feat_type), linewidth = 2) +
    geom_feat_label(data = feats(guides),
                    aes(label = name),
                    size = 2.4, nudge_y = 0.05, color = "#D94040") +
    geom_gene(aes(fill = feat_type), color = NA, size = 6) +
    geom_gene_label(aes(label = name), size = 2.4, nudge_y = -0.07) +
    scale_color_manual(
      name   = NULL,
      values = c("Exon" = "#DAA520",
                 "CRISPR_guide" = "#D94040",
                 "Amplicon" = "#40A0D0"),
      labels = c("Exon" = "Exon",
                 "CRISPR_guide" = "CRISPR guide",
                 "Amplicon" = "PCR amplicon")
    ) +
    scale_fill_manual(
      name   = NULL,
      values = c("forward_primer" = "#40A040",
                 "reverse_primer" = "#9060C0"),
      labels = c("forward_primer" = "Forward primer",
                 "reverse_primer" = "Reverse primer")
    ) +
    labs(title = sprintf("%s (%s)", q$gene_name, q$name)) +
    theme(legend.position = "bottom",
          legend.box = "horizontal",
          legend.margin = margin(0, 0, 0, 0))

  if (!is.null(meta$gene_offset) && meta$gene_offset > 0) {
    gene_start <- meta$gene_offset + 1
    gene_end   <- meta$gene_offset + meta$gene_length
    p <- p +
      geom_vline(xintercept = gene_start, linetype = "dashed",
                 color = "grey40", linewidth = 0.4) +
      geom_vline(xintercept = gene_end, linetype = "dashed",
                 color = "grey40", linewidth = 0.4)
  }

  p
}
