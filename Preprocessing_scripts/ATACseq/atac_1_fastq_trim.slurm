#! /bin/bash
#SBATCH -N 1
#SBATCH -c 2
#SBATCH 

# example of sbatch command to run this script:
# sbatch -p risc --array=1-37 --export=inputfiles_R1=/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/3022023_run_Deep_Justin_scripts/inputfiles_R1.txt,inputfiles_R2=/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/3022023_run_Deep_Justin_scripts/inputfiles_R2.txt,outdir=/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/3022023_run_Deep_Justin_scripts,samplelist=/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/3022023_run_Deep_Justin_scripts/samplenames.txt /lustre/fs4/risc_lab/scratch/jyeung/scripts/pipelines/Justin_ATACpipeline/atac_1_fastq_trim.slurm

mkdir $outdir\/atac_1_fastq_trim/
INPUT_R1=$(head -n $SLURM_ARRAY_TASK_ID $inputfiles_R1 | tail -n 1)
INPUT_R2=$(head -n $SLURM_ARRAY_TASK_ID $inputfiles_R2 | tail -n 1)
NAME=$(head -n $SLURM_ARRAY_TASK_ID $samplelist | tail -n 1)
OUTPUT_R1=$outdir\/atac_1_fastq_trim/$NAME\_R1
OUTPUT_R2=$outdir\/atac_1_fastq_trim/$NAME\_R2

source activate fastq2bam

cutadapt -a CTGTCTCTTATA -A CTGTCTCTTATA -j 2 -e 0.1 -q 30 -m 5 -o $OUTPUT_R1\_trimmed.fastq -p $OUTPUT_R2\_trimmed.fastq $INPUT_R1 $INPUT_R2

fastqc $OUTPUT_R1\_trimmed.fastq
fastqc $OUTPUT_R2\_trimmed.fastq

