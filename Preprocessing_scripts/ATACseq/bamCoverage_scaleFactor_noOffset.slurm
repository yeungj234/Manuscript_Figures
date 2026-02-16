#! /bin/bash
#SBATCH -n 1
#SBATCH -c 16
#SBATCH --verbose
#SBATCH -J scaleFactor_bw
#SBATCH -e %x-%j-%a.err
#SBATCH -o %x-%j-%a.out

INPUT=$(head -n $SLURM_ARRAY_TASK_ID $inputfiles | tail -n 1)
NAME=$(head -n $SLURM_ARRAY_TASK_ID $samplelist | tail -n 1)
SCALE=$(head -n $SLURM_ARRAY_TASK_ID $scalefactors | tail -n 1)
OUTPUT=$outdir\/$NAME

# sbatch --array=1-6 --export=inputfiles=inputfiles.txt,outdir=/lustre/fs4/risc_lab/scratch/jyeung/for_Hide/ATAC_deep_sequencing_Novogene_10112024/scaleFactornorm_bigwigs,samplelist=samplenames.txt,scalefactors=scaleFactor.txt bamCoverage_scaleFactor_noOffset.slurm
cd $outdir

# keep entire fragment length, normalize by scaleFactor determined by DESeq2 and convert to bigwig for coverage plots. 

source activate ATACseq

# blacklist_file=/rugpfs/fs0/risc_lab/scratch/jrendleman/ATAC_09262021/references/ENCFF940NTE_blacklist.bed
# convert bam to bigwig using userspecified scale factors
bamCoverage -b $INPUT -o $OUTPUT\_scaleFactornorm.bw \
    --binSize 5 \
    --scaleFactor $SCALE \
    --extendReads \
    --numberOfProcessors 4
