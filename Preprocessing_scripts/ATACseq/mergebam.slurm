#! /bin/bash
#SBATCH -N 1
#SBATCH -c 2
#SBATCH 

##input bam files 1 and 2
INPUT_R1=$(head -n $SLURM_ARRAY_TASK_ID $inputfiles_R1 | tail -n 1)
INPUT_R2=$(head -n $SLURM_ARRAY_TASK_ID $inputfiles_R2 | tail -n 1)

##assigned sample names to merged bam files
NAME=$(head -n $SLURM_ARRAY_TASK_ID $samplelist | tail -n 1)
OUTPUT=$outdir\/$NAME\

source activate fastq2bam

samtools merge -r $OUTPUT\_final_merged.bam $INPUT_R1 $INPUT_R2

