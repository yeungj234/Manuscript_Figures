#! /bin/bash
#SBATCH -N 1
#SBATCH -c 2
#SBATCH 

INPUT_R1=$(head -n $SLURM_ARRAY_TASK_ID $inputfiles_R1 | tail -n 1)
INPUT_R2=$(head -n $SLURM_ARRAY_TASK_ID $inputfiles_R2 | tail -n 1)
NAME=$(head -n $SLURM_ARRAY_TASK_ID $samplelist | tail -n 1)
OUTPUT_R1=$outdir\/$NAME\_R1
OUTPUT_R2=$outdir\/$NAME\_R2

source activate fastq2bam

## modify read length of R1 to 58 bp, trimmed from 3'end
cutadapt -l 58 -o $OUTPUT_R1\_trimmed_readlength.fastq $INPUT_R1

## modify read length of R1 to 60 bp, trimmed from 3'end
cutadapt -l 60 -o $OUTPUT_R2\_trimmed_readlength.fastq $INPUT_R2

##generate fastQC report after fastq files are trimmed to desired read length
fastqc $OUTPUT_R1\_trimmed_readlength.fastq
fastqc $OUTPUT_R2\_trimmed_readlength.fastq

