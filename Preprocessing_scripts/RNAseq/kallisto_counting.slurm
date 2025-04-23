#! /bin/bash
#SBATCH -n 1
#SBATCH -c 4
#SBATCH --verbose
#SBATCH -J RNA
#SBATCH -e %x-%j-%a.err
#SBATCH -o %x-%j-%a.out

# EXAMPLE OF RUNNING THIS SCRIPT: 
# sbatch -p risc --array=1-14 --export=inputfiles_R1= /lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/RNAseq/kallisto_02232023/inputfiles_R1.txt,inputfiles_R2= /lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/RNAseq/kallisto_02232023/inputfiles_R2.txt,index=/lustre/fs4/risc_lab/store/jyeung/indexes/V29_Kallisto_index/ENCFF471EAM.idx,outdir=/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/RNAseq/kallisto_02232023/,samplelist= /lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/RNAseq/kallisto_02232023/samplenames.txt  /lustre/fs4/risc_lab/scratch/jyeung/scripts/pipelines/RNA_pipeline/kallisto_counting.slurm
#inputfiles_R1: fastq files for read 1
#inputfiles_R2: fastq files for read 2
#samplelist: desired sample names for fastq files
#outdir: output directory
INPUT_R1=$(head -n $SLURM_ARRAY_TASK_ID $inputfiles_R1 | tail -n 1)
INPUT_R2=$(head -n $SLURM_ARRAY_TASK_ID $inputfiles_R2 | tail -n 1)
NAME=$(head -n $SLURM_ARRAY_TASK_ID $samplelist | tail -n 1)
OUTPUT=$outdir\/$NAME

mkdir $OUTPUT
cd $OUTPUT



source activate jr_rna

#kallisto index -i $index $transcript.fasta

kallisto quant -i $index -o $outdir\/$NAME -b 100 $INPUT_R1 $INPUT_R2

