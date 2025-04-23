#! /bin/bash
#SBATCH -n 1
#SBATCH -c 20
#SBATCH --verbose
#SBATCH -J cutsCoverageR
#SBATCH -e %x-%j-%a.err
#SBATCH -o %x-%j-%a.out

source /ru-auth/local/home/risc_soft/miniconda3/etc/profile.d/conda.sh
conda activate joanna

Rscript /lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/Tn5_offset_merged_bigwigs/scaleFactornorm_cutsCoverage_bigwigs/cutsCoverage.R
