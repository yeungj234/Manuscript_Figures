#! /bin/bash
#SBATCH --verbose
#SBATCH -J bowtie2
#SBATCH -e %x-%j-%a.err
#SBATCH -o %x-%j-%a.out

# example of sbatch command to run this script:
# sbatch -p risc --array=1-37 --export=outdir=/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/3022023_run_Deep_Justin_scripts,genomeIndexName=/rugpfs/fs0/risc_lab/store/risc_data/downloaded/hg38/genome/Sequence/Bowtie2Index/genome,samplelist=/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/3022023_run_Deep_Justin_scripts/samplenames.txt /lustre/fs4/risc_lab/scratch/jyeung/scripts/pipelines/Justin_ATACpipeline/atac_2_fastq_align.slurm

# make output directory for fastq align step
mkdir $outdir\/atac_2_fastq_align/

# create text file with directory paths to input read 1 & read 2 trimmed fastq files. 
find $outdir\/atac_1_fastq_trim -name '*R1_trimmed.fastq'|sort > $outdir\/atac_2_fastq_align/inputfiles_R1.txt
find $outdir\/atac_1_fastq_trim -name '*R2_trimmed.fastq'|sort > $outdir\/atac_2_fastq_align/inputfiles_R2.txt

# create variables for inputfiles
inputfiles_R1=$outdir\/atac_2_fastq_align/inputfiles_R1.txt
inputfiles_R2=$outdir\/atac_2_fastq_align/inputfiles_R2.txt

INPUT_R1=$(head -n $SLURM_ARRAY_TASK_ID $inputfiles_R1 | tail -n 1)
INPUT_R2=$(head -n $SLURM_ARRAY_TASK_ID $inputfiles_R2 | tail -n 1)
# samplelist=text file containing desired sample names
NAME=$(head -n $SLURM_ARRAY_TASK_ID $samplelist | tail -n 1)
#OUTPUT_R1=$outdir\atac_2_fastq_align/$NAME\_R1
#OUTPUT_R2=$outdir\atac_2_fastq_align/$NAME\_R2
OUTPUT=$outdir\/atac_2_fastq_align/$NAME

source activate fastq2bam

bowtie2 -k 4 -p 6 -X2000 --local --mm -x $genomeIndexName -1 $INPUT_R1 -2 $INPUT_R2 --seed 23 2>$OUTPUT\_$SLURM_JOB_ID\.log | samtools view -Su /dev/stdin | samtools sort -n -o $OUTPUT\_$SLURM_JOB_ID\.bam -
