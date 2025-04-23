#! /bin/bash
#SBATCH -n 1
#SBATCH -c 4
#SBATCH --verbose
#SBATCH -J manageMito
#SBATCH -e %x-%j-%a.err
#SBATCH -o %x-%j-%a.out

# example of sbatch command to run this script:
# sbatch -p risc --array=1-37 --export=outdir=/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/3022023_run_Deep_Justin_scripts,samplelist=/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/3022023_run_Deep_Justin_scripts/samplenames.txt /lustre/fs4/risc_lab/scratch/jyeung/scripts/pipelines/Justin_ATACpipeline/atac_3_bam_managemito.slurm

# make output directory for removing mitochondrial reads step
mkdir $outdir\/atac_3_bam_managemito/

# create text file with directory paths to input read 1 & read 2 trimmed fastq files. 
find $outdir\/atac_2_fastq_align/ -name '*.bam'|sort > $outdir\/atac_3_bam_managemito/inputfiles.txt

# create variables for inputfiles
inputfiles=$outdir\/atac_3_bam_managemito/inputfiles.txt

INPUT=$(head -n $SLURM_ARRAY_TASK_ID $inputfiles | tail -n 1)
# samplelist=text file containing desired sample names
NAME=$(head -n $SLURM_ARRAY_TASK_ID $samplelist | tail -n 1)
OUTPUT=$outdir\/atac_3_bam_managemito/$NAME

source activate fastq2bam

samtools sort -n --threads 4 $INPUT -O SAM  | samtools flagstat -@ 4 - > $OUTPUT\.flagstat

# make a mito-free BAM to calculate fraction of mito reads in BAM later
#non_mito_bam="$prefix.non_mito.bam"
#nth=2
#samtools idxstats $INPUT | cut -f 1 | grep -v -P "^chrM$" | xargs samtools view $INPUT -@ 4 -b> $OUTPUT\nonMito.bam
#samtools idxstats $INPUT | cut -f 1 | grep -v "chrM" | xargs samtools view -@ 4 -b $INPUT > $OUTPUT\nonMito.bam

samtools sort $INPUT > $OUTPUT\_sorted.bam
samtools index $OUTPUT\_sorted.bam

cat /rugpfs/fs0/risc_lab/scratch/jrendleman/ATAC_09262021/references/ChromNotMito.txt | xargs samtools view -@ 4 -b $OUTPUT\_sorted.bam > $OUTPUT\_nonMito.bam
cat /rugpfs/fs0/risc_lab/scratch/jrendleman/ATAC_09262021/references/Chrom1-22XY.txt | xargs samtools view -@ 4 -b $OUTPUT\_sorted.bam > $OUTPUT\_chr1-22XY.bam
samtools sort -n --threads 4 $OUTPUT\_nonMito.bam -O SAM | samtools flagstat -@ 4 - > $OUTPUT\_nonMito.flagstat
samtools sort -n --threads 4 $OUTPUT\_chr1-22XY.bam -O SAM | samtools flagstat -@ 4 - > $OUTPUT\_chr1-22XY.flagstat
