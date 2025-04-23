#!/bin/bash
#SBATCH -n 1
#SBATCH -c 20
#SBATCH --verbose
#SBATCH -J TSS_Coverage
#SBATCH -e %x-%j-%a.err
#SBATCH -o %x-%j-%a.out

source activate ATACseq

# plot coverage over TSS

# Define the variable for BigWig files
BIGWIG_FILES=$bigwigs
# Define the path to the annotation file (BED, GTF, etc.)
GENOMIC_REGIONS="/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/Tn5_offset_allreps_bigwigs/TSS_cov/gencode.v41.GRCh38.p13.genes.bed"

# Output prefix for the results
OUTPUT_PREFIX="1kb_coverage"


computeMatrix reference-point \
	-S $BIGWIG_FILES \
	-R $GENOMIC_REGIONS \
	-b 1000 -a 1000 -bs=1 -p=max  \
	--referencePoint TSS \
	--binSize 1 \
 	-out $filename\_${OUTPUT_PREFIX}_matrix.gz 
 	
plotProfile -m $filename\_${OUTPUT_PREFIX}_matrix.gz \
    -out $profile_outdir\/$filename\_${OUTPUT_PREFIX}_profile.pdf \
    --perGroup \
    --colors "#F8766D" "#EBD599" "#D1DC8E" "#B3C543" "#6F7835" "#9D8E8A" "#ECCEE1" "#E0ADCD" "#B23282" "#732154" \
    --samplesLabel $samplenames \
    --refPointLabel "centre" \
    --plotTitle "$plotTitle"

plotHeatmap -m $filename\_${OUTPUT_PREFIX}_matrix.gz \
    -out  $heatmap_outdir\/$filename\_${OUTPUT_PREFIX}_heatmap.pdf \
    --colorMap inferno \
    --samplesLabel $samplenames \
    --refPointLabel 'centre' \
    --plotTitle "$plotTitle"

#NOTES:

# define file paths for multiple bigwig files
# bigwigs="/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/Tn5_offset_allreps_bigwigs/workspaces/Cycling_1_2_scaleFactornorm_cutsCoverage.bw /lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/Tn5_offset_allreps_bigwigs/workspaces/Cycling_1_3_scaleFactornorm_cutsCoverage.bw /lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/Tn5_offset_allreps_bigwigs/workspaces/Cycling_2_1_scaleFactornorm_cutsCoverage.bw /lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/Tn5_offset_allreps_bigwigs/workspaces/Cycling_2_2_scaleFactornorm_cutsCoverage.bw /lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/Tn5_offset_allreps_bigwigs/workspaces/Cycling_2_3_scaleFactornorm_cutsCoverage.bw /lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/Tn5_offset_allreps_bigwigs/workspaces/Cyc1day10_scaleFactornorm_cutsCoverage.bw /lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/Tn5_offset_allreps_bigwigs/workspaces/Cyc2day10_scaleFactornorm_cutsCoverage.bw /lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/Tn5_offset_allreps_bigwigs/workspaces/Cyc1day14_scaleFactornorm_cutsCoverage.bw /lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/Tn5_offset_allreps_bigwigs/workspaces/Cyc2day14_scaleFactornorm_cutsCoverage.bw /lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/Tn5_offset_allreps_bigwigs/workspaces/Cyc3day14_scaleFactornorm_cutsCoverage.bw"
# define sample names for each bigwig file
# samplenames="Cycling_1_2 Cycling_1_3 Cycling_2_1 Cycling_2_2 Cycling_2_3 Cyc1day10 Cyc2day10 Cyc1day14 Cyc2day14 Cyc3day14"

# example of sbatch script
# sbatch -p risc,hpc \
#--export=bigwigs="$bigwigs",\
#samplenames="$samplenames",\
#profile_outdir=/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/Tn5_offset_allreps_bigwigs/TSS_cov/Figures,\
#heatmap_outdir=/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/Tn5_offset_allreps_bigwigs/TSS_cov/Figures,\
#filename="Cycling_TSS",\
#plotTitle="Cycling_TSS" \
#/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/Tn5_offset_allreps_bigwigs/deeptools_TSS_Cov_1kb.slurm
