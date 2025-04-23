#! /bin/bash
#SBATCH -n 1
#SBATCH -c 4
#SBATCH --verbose
#SBATCH -J picard.FLD
#SBATCH -e %x-%j-%a.err
#SBATCH -o %x-%j-%a.out

# example of sbatch command to run this script:
# sbatch -p risc --array=1-37 --export=outdir=/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/3022023_run_Deep_Justin_scripts,samplelist=/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/3022023_run_Deep_Justin_scripts/samplenames.txt /lustre/fs4/risc_lab/scratch/jyeung/scripts/pipelines/Justin_ATACpipeline/atac_5_bam_FLD.slurm

# make output directory for plotting FLD (fragment length distribution) step
mkdir $outdir\/atac_5_bam_FLD/

# create text file with directory paths to input final bams.  
find $outdir\/atac_4_bam_markduplicates/ -name '*final.bam'|sort > $outdir\/atac_5_bam_FLD/inputfiles.txt

# create variables for inputfiles
inputfiles=$outdir\/atac_5_bam_FLD/inputfiles.txt

INPUT=$(head -n $SLURM_ARRAY_TASK_ID $inputfiles | tail -n 1)
NAME=$(head -n $SLURM_ARRAY_TASK_ID $samplelist | tail -n 1)
#OUTPUT_R1=$outdir\/$NAME\_R1
#OUTPUT_R2=$outdir\/$NAME\_R2
OUTPUT=$outdir\/atac_5_bam_FLD/$NAME

source activate fastq2bam

picard CollectInsertSizeMetrics INPUT=$INPUT OUTPUT=$OUTPUT\_insertdata.txt H=$OUTPUT\_FLD.pdf VERBOSITY=ERROR QUIET=TRUE USE_JDK_DEFLATER=TRUE USE_JDK_INFLATER=TRUE W=1000 STOP_AFTER=5000000
