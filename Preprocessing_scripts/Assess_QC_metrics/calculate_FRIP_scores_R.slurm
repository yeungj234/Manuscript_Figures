#! /bin/bash
#SBATCH -n 1
#SBATCH -c 20
#SBATCH --verbose
#SBATCH -J FRIP
#SBATCH -e %x-%j-%a.err
#SBATCH -o %x-%j-%a.out

source /ru-auth/local/home/risc_soft/miniconda3/etc/profile.d/conda.sh
conda activate joanna

Rscript /lustre/fs4/risc_lab/scratch/jyeung/merged_LSPDvsDoxo_1and2/FRIP/calculate_FRIP_R_script.R
