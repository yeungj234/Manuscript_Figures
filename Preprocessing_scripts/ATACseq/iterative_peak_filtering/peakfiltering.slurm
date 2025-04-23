#! /bin/bash
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --verbose
#SBATCH -J peak_calling
#SBATCH -e %x-%j-%a.err
#SBATCH -o %x-%j-%a.out

OUTPUT=$outdir\/$NAME\_peakfilt.gtf

cd $outdir
source /ru-auth/local/home/risc_soft/miniconda3/etc/profile.d/conda.sh
conda activate rstudio

Rscript /lustre/fs4/risc_lab/scratch/rhosuru/mergedFW_peakCall.R $INPUT $FW $OUTPUT
