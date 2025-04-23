#! /bin/bash
#SBATCH -N 1
#SBATCH -c 2
#SBATCH --array=1-16  # Example array job range

# Example of sbatch command to run this script:
# sbatch -p risc --array=1-16 --export=outdir=/path/to/output,inputfiles=/path/to/inputfiles,names=/path/to/names,motif=E2F get_tp_peaks_motifs.slurm

# Read the appropriate line from the input files
INPUT=$(head -n $SLURM_ARRAY_TASK_ID $inputfiles | tail -n 1)
NAME=$(head -n $SLURM_ARRAY_TASK_ID $names | tail -n 1)

# Filter for the specified motif and save the results
egrep "${motif}.*tp$" $INPUT | cut -f3 > $outdir/$NAME\_${motif}_all_tp_Downpeaks_ids.tsv