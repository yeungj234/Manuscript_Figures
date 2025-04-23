#!/bin/bash
#SBATCH -n 1
#SBATCH -c 20
#SBATCH --verbose
#SBATCH -J deeptools_Coverage
#SBATCH -e %x-%j-%a.err
#SBATCH -o %x-%j-%a.out

source activate encode-atac-seq-pipeline

# Define the variable for BigWig files
BIGWIG_FILES=$bigwigs
# Define the path to the annotation file (BED, GTF, etc.)
GENOMIC_REGIONS=$regions

# Output prefix for the results
OUTPUT_PREFIX="1kb_coverage"

GENOMIC_REGIONS=$(head -n $SLURM_ARRAY_TASK_ID $regions | tail -n 1) # text file containing paths to fasta files
NAME=$(head -n $SLURM_ARRAY_TASK_ID $filename | tail -n 1) # text file containing names of future output directories

computeMatrix reference-point \
	-S $BIGWIG_FILES \
	-R $GENOMIC_REGIONS \
	-b 1000 -a 1000 -bs=10 -p=max  \
	--referencePoint center \
 	-out $NAME\_${OUTPUT_PREFIX}_matrix.gz \
 	--numberOfProcessors "max" \
 	--skipZeros \
        --outFileSortedRegions $NAME\_${OUTPUT_PREFIX}_sorted_regions.bed 

plotProfile -m $NAME\_${OUTPUT_PREFIX}_matrix.gz \
    -out $profile_outdir\/$NAME\_${OUTPUT_PREFIX}_profile.pdf \
    --perGroup \
    --colors "#F8766D" "#EBD599" "#D1DC8E" "#B3C543" "#6F7835" "#9D8E8A" "#ECCEE1" "#E0ADCD" "#B23282" "#732154" \
    --samplesLabel $samplenames \
    --refPointLabel "centre" \
    --plotTitle "$NAME" \
    --plotHeight 8 \
    --plotWidth 10 \
    --yMin 0 \
    --yMax 1.5 \

plotHeatmap -m $NAME\_${OUTPUT_PREFIX}_matrix.gz \
    -out  $heatmap_outdir\/$NAME\_${OUTPUT_PREFIX}_heatmap.pdf \
    --colorMap inferno \
    --samplesLabel $samplenames \
    --refPointLabel 'centre' \
    --plotTitle "$NAME"
    --plotTitle "$NAME" \
    --plotHeight 8 \
    --plotWidth 10 \
    --yMin 0 \
    --yMax 1.5 \

#NOTES:

# define file paths for multiple bigwig files
# bigwigs="/lustre/fs4/risc_lab/scratch/jyeung/merged_LSPDvsDoxo_1and2/merged_bigwigs/Cycling_merged_RPGCnorm.bw /lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/3022023_run_Deep_Justin_scripts/atac_4_bam_markduplicates/merged_bigwigs/day3_Doxo_merged_RPGCnorm.bw /lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_1/ATACseq/5182022_run_Deep_Justin_scripts/4markduplicates_output/merged_bigwigs/day10Doxo_merged_RPGCnorm.bw /lustre/fs4/risc_lab/scratch/jyeung/merged_LSPDvsDoxo_1and2/merged_bigwigs/day14_Doxo_merged_RPGCnorm.bw /lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/3022023_run_Deep_Justin_scripts/atac_4_bam_markduplicates/merged_bigwigs/day21_Doxo_merged_RPGCnorm.bw /lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/3022023_run_Deep_Justin_scripts/atac_4_bam_markduplicates/merged_bigwigs/day3_Palbo_merged_RPGCnorm.bw /lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_1/ATACseq/5182022_run_Deep_Justin_scripts/4markduplicates_output/merged_bigwigs/day10Palbo_merged_RPGCnorm.bw /lustre/fs4/risc_lab/scratch/jyeung/merged_LSPDvsDoxo_1and2/merged_bigwigs/day14_Palbo_merged_RPGCnorm.bw /lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/3022023_run_Deep_Justin_scripts/atac_4_bam_markduplicates/merged_bigwigs/day21_Palbo_merged_RPGCnorm.bw /lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/3022023_run_Deep_Justin_scripts/atac_4_bam_markduplicates/merged_bigwigs/day28_Palbo_merged_RPGCnorm.bw"

# define sample names for each bigwig file
# samplenames="Cycling day3_Doxo day10Doxo day14_Doxo day21_Doxo day3_Palbo day10Palbo day14_Palbo day21_Palbo day28_Palbo"

# example of sbatch script
# sbatch --export=bigwigs=$bigwigs,peaks=/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/post_peakcalling_analysis/06222024/motif_analysis/motif_beds_for_CoveragePlots/all_NFKB_motifs_TargetGeneBodies.bed,samplenames=$samplenames,profile_outdir=/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/post_peakcalling_analysis/06222024/deepTools/plotProfile,heatmap_outdir=/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/post_peakcalling_analysis/06222024/deepTools/plotHeatmap,NAME="Accessibility_all_NFKB_motifs_TargetGeneBodies",plotTitle="Accessibility_around_all_NFKB_motifs_in_genebodies_of_their_target_genes" deeptools_Coverage.slurm
