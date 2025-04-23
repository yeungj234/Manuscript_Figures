#! /bin/bash
#SBATCH -n 1
#SBATCH -c 6
#SBATCH --verbose
#SBATCH -J picard.markdups
#SBATCH -e %x-%j-%a.err
#SBATCH -o %x-%j-%a.out

# example of sbatch command to run this script:
# sbatch -p risc --array=1-37 --export=outdir=/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/3022023_run_Deep_Justin_scripts,samplelist=/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/3022023_run_Deep_Justin_scripts/samplenames.txt /lustre/fs4/risc_lab/scratch/jyeung/scripts/pipelines/Justin_ATACpipeline/atac_4_bam_markduplicates.slurm

# make output directory for mark duplicates step
mkdir $outdir\/atac_4_bam_markduplicates/

# create text file with directory paths to bam files. 
find $outdir\/atac_3_bam_managemito/ -name '*chr1-22XY.bam'|sort > $outdir\/atac_4_bam_markduplicates/inputfiles.txt

# create variables for inputfiles
inputfiles=$outdir\/atac_4_bam_markduplicates/inputfiles.txt

INPUT=$(head -n $SLURM_ARRAY_TASK_ID $inputfiles | tail -n 1)
NAME=$(head -n $SLURM_ARRAY_TASK_ID $samplelist | tail -n 1)
#OUTPUT_R1=$outdir\/$NAME\_R1
#OUTPUT_R2=$outdir\/$NAME\_R2
OUTPUT=$outdir\/atac_4_bam_markduplicates/$NAME

source activate fastq2bam

samtools view -@ 6 -F 1804 -f 2 -q 30 -u $INPUT | samtools sort -n --threads 6 - > $OUTPUT\_temp.bam
samtools fixmate -@ 6 -r $OUTPUT\_temp.bam $OUTPUT\_temp_fixmate.bam

samtools view -@ 6 -F 1804 -f 2 -u $OUTPUT\_temp_fixmate.bam | samtools sort --threads 6 - -o $OUTPUT\_filtered.bam

rm $OUTPUT\_temp.bam

rm $OUTPUT\_temp_fixmate.bam


#picard SortSam I=$INPUT O=$OUTPUT\_sorted.bam SO=queryname
picard MarkDuplicates I=$OUTPUT\_filtered.bam O=$OUTPUT\_markdups.bam M=$OUTPUT\_metrics.txt

#rm $OUTPUT\_sorted.bam

samtools view -@ 6 -F 1804 -f 2 -b $OUTPUT\_markdups.bam > $OUTPUT\_final.bam
samtools index -@ 6 $OUTPUT\_final.bam
samtools sort -n --threads 6 $OUTPUT\_final.bam -O SAM | samtools flagstat -@ 6 - > $OUTPUT\_final.flagstat

samtools sort -n --threads 6 $OUTPUT\_markdups.bam -o $OUTPUT\srt.tmp.bam
#bedtools bamtobed -bedpe -i $OUTPUT\srt.tmp.bam | awk 'BEGIN{OFS="\t"}{print $1,$2,$4,$6,$9,$10}' | grep -v 'chrM' | sort | uniq -c | awk 'BEGIN{mt=0;m0=0;m1=0;m2=0} ($1==1){m1=m1+1} ($1==2){m2=m2+1}{m0=m0+1}{mt=mt+$1} END {printf "%d\t%d\t%d\t%d\t%f\t%f\t%f\n",mt,m0,m1,m2,m0/mt,m1/m0,m1/m2}' > $OUTPUT\_PBC_QC.txt
bedtools bamtobed -bedpe -i $OUTPUT\srt.tmp.bam | awk 'BEGIN{OFS="\t"}{print $1,$2,$4,$6,$9,$10}' | grep -v 'chrM' | sort | uniq -c | awk 'BEGIN{mt=0;m0=0;m1=0;m2=0} ($1==1){m1=m1+1} ($1==2){m2=m2+1}{m0=m0+1}{mt=mt+$1} END {printf "%d\t%d\t%d\t%d\t%f\t%f\t%f\n",mt,m0,m1,m2,m0/mt,m1/m0,m1/m2}' > $OUTPUT\_PBC_QC.txt
rm $OUTPUT\srt.tmp.bam
rm $OUTPUT\_markdups.bam


