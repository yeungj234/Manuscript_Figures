#!/bin/bash

# Usage: ./tss_enrichment_score.sh sample.bw tss.bed output_prefix
# based on the following explanation from ENCODE: 
# Transcription Start Site (TSS) Enrichment Score - The TSS enrichment calculation is a signal to noise calculation. The reads around a reference set of TSSs are collected to form an aggregate distribution of reads centered on the TSSs and extending to 2000 bp in either direction (for a total of 4000bp). This distribution is then normalized by taking the average read depth in the 100 bps at each of the end flanks of the distribution (for a total of 200bp of averaged data) and calculating a fold change at each position over that average read depth. This means that the flanks should start at 1, and if there is high read signal at transcription start sites (highly open regions of the genome) there should be an increase in signal up to a peak in the middle. We take the signal value at the center of the distribution after this normalization as our TSS enrichment metric. Used to evaluate ATAC-seq. 

BIGWIG=$1
GENOMIC_REGIONS=$2
PREFIX=$3

MATRIX_FILE="${PREFIX}_matrix.gz"
TSS_SCORE_FILE="${PREFIX}_tss_score.tsv"

# Step 1: computeMatrix
computeMatrix reference-point \
  -S "$BIGWIG" \
  -R "$GENOMIC_REGIONS" \
  -b 2000 -a 2000 \
  --binSize 1 \
  --referencePoint TSS \
  -out "$MATRIX_FILE"

# Step 2: Compute TSS enrichment
zcat "$MATRIX_FILE" | \
# Removes header lines (lines that start with #) from the matrix file.
# Only keeps the actual numeric matrix rows for downstream processing.
  grep -v "^#" | \
# Sets center=2000: bin corresponding to the TSS (0-based index, 2000 = the middle bin in a ±2kb region with 1bp bins).
# Sets flank=100: number of bins on either side used to estimate background.
  awk -v center=2000 -v flank=100 -v sample="$(basename "$BIGWIG")" '
  {
    center_sum += $(7 + center)
    for (i = 0; i < flank; i++) {
      flank_sum += $(7 + i)
      flank_sum += $(7 + 4000 - flank + i)
    }
    rows += 1 
  }
  END {
    avg_center = center_sum / rows
    avg_flank = flank_sum / (rows * flank * 2)
    enrichment = avg_center / avg_flank
    printf "%s\t%.2f\n", sample, enrichment
  }' > "$TSS_SCORE_FILE"

# For each line (row = one TSS), adds the read coverage at the center bin (i.e., TSS) to center_sum. $(7 + center) skips the first 6 columns of metadata (e.g., region, start, end, strand, etc.) and goes to the matrix values.
# Adds up the signal from the first 100 bins (upstream flank) and last 100 bins (downstream flank). This total flank_sum is used as a background estimate.
# rows += 1 Keeps count of how many TSS rows were processed (to later calculate averages).
# At the end, calculate: The average signal at the TSS across all genes. The average background signal across flanking regions.
