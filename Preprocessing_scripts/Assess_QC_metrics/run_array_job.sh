#!/bin/bash
#SBATCH --job-name=tss_enrich
#SBATCH --output=logs/tss_enrich_%A_%a.out
#SBATCH --error=logs/tss_enrich_%A_%a.err
#SBATCH --array=1-54

# Load required modules
source activate ATACseq

# Input files
BW_FILES=($(ls /lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/Tn5_offset_allreps_bigwigs/workspaces/*_scaleFactornorm_cutsCoverage.bw))  # bigWig files with specific pattern
TSS_BED=/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/Tn5_offset_allreps_bigwigs/TSS_cov/gencode.v41.GRCh38.p13.genes.bed  # your reference TSS regions in BED format

# Get the bigWig file for this SLURM array task
BW_FILE="${BW_FILES[$SLURM_ARRAY_TASK_ID]}"
BASENAME=$(basename "$BW_FILE" _scaleFactornorm_cutsCoverage.bw)

# Create output directory for the sample
OUT_DIR="/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/Tn5_offset_allreps_bigwigs/TSS_cov/TSS_enrichmentScore/output/${BASENAME}"
mkdir -p "$OUT_DIR"

# Run the computeMatrix + TSS scoring script
/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/Tn5_offset_allreps_bigwigs/TSS_cov/TSS_enrichmentScore/tss_enrichment_score.sh "$BW_FILE" "$TSS_BED" "$OUT_DIR"