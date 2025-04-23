#! /bin/bash
#SBATCH -n 1
#SBATCH -c 8
#SBATCH --verbose
#SBATCH -J tagAlign
#SBATCH -e %x-%j-%a.err
#SBATCH -o %x-%j-%a.out

# sbatch --array=1-9 --export=inputfiles_Rep1=/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/Richard_Peak_Calling_Settings/LS_PDvsDoxo_2_PeakCalls/inputfiles_Rep1_3reps.txt,inputfiles_Rep2=/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/Richard_Peak_Calling_Settings/LS_PDvsDoxo_2_PeakCalls/inputfiles_Rep2_3reps.txt,inputfiles_Rep3=/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/Richard_Peak_Calling_Settings/LS_PDvsDoxo_2_PeakCalls/inputfiles_Rep3_3reps.txt,inputfiles_pooled=/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/Richard_Peak_Calling_Settings/LS_PDvsDoxo_2_PeakCalls/inputfiles_pooled_3reps.txt,outdir=/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/Richard_Peak_Calling_Settings/LS_PDvsDoxo_2_PeakCalls/pval0.01,samplelist=/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/Richard_Peak_Calling_Settings/LS_PDvsDoxo_2_PeakCalls/samplenames_3reps.txt,pvalue=0.01 /lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/Richard_Peak_Calling_Settings/atac_6.3_IDR_tagalign.slurm

INPUT_Rep1=$(head -n $SLURM_ARRAY_TASK_ID $inputfiles_Rep1 | tail -n 1)
INPUT_Rep2=$(head -n $SLURM_ARRAY_TASK_ID $inputfiles_Rep2 | tail -n 1)
INPUT_Rep3=$(head -n $SLURM_ARRAY_TASK_ID $inputfiles_Rep3 | tail -n 1)
INPUT_pooled=$(head -n $SLURM_ARRAY_TASK_ID $inputfiles_pooled | tail -n 1)
NAME=$(head -n $SLURM_ARRAY_TASK_ID $samplelist | tail -n 1)

OUTPUT=$outdir\/$NAME

conda deactivate
source activate macs2_python2

##Call peaks replicates
macs2 callpeak -t $INPUT_Rep1 -f BED -n $NAME\_Rep1.tn5.Richard -g 2.7e9 --nomodel --pvalue $pvalue
macs2 callpeak -t $INPUT_Rep2 -f BED -n $NAME\_Rep2.tn5.Richard -g 2.7e9 --nomodel --pvalue $pvalue
macs2 callpeak -t $INPUT_Rep3 -f BED -n $NAME\_Rep3.tn5.Richard -g 2.7e9 --nomodel --pvalue $pvalue

##Call peaks pooled sample

macs2 callpeak -t $INPUT_pooled -f BED -n $NAME\_pool.tn5.Richard -g 2.7e9 --nomodel --pvalue $pvalue

sort -k 8gr,8gr $NAME\_Rep1.tn5.Richard_peaks.narrowPeak | awk 'BEGIN{OFS="\t"}{$4="Peak_"NR ; print $0}' | head -n 300000 | gzip -nc > $OUTPUT\_Rep1.tn5.Richard.narrowPeak.gz
sort -k 8gr,8gr $NAME\_Rep2.tn5.Richard_peaks.narrowPeak | awk 'BEGIN{OFS="\t"}{$4="Peak_"NR ; print $0}' | head -n 300000 | gzip -nc > $OUTPUT\_Rep2.tn5.Richard.narrowPeak.gz
sort -k 8gr,8gr $NAME\_Rep3.tn5.Richard_peaks.narrowPeak | awk 'BEGIN{OFS="\t"}{$4="Peak_"NR ; print $0}' | head -n 300000 | gzip -nc > $OUTPUT\_Rep3.tn5.Richard.narrowPeak.gz
sort -k 8gr,8gr $NAME\_pool.tn5.Richard_peaks.narrowPeak | awk 'BEGIN{OFS="\t"}{$4="Peak_"NR ; print $0}' | head -n 300000 | gzip -nc > $OUTPUT\_pool.tn5.Richard.narrowPeak.gz

#apply IDR

conda deactivate
source activate encode-atac-seq-pipeline
idr --samples $OUTPUT\_Rep1.tn5.Richard.narrowPeak.gz $OUTPUT\_Rep2.tn5.Richard.narrowPeak.gz \
--peak-list $OUTPUT\_pool.tn5.Richard.narrowPeak.gz --input-file-type narrowPeak \
--output-file $OUTPUT\_IDR_12.tn5.Richard.narrowPeak --rank p.value --soft-idr-threshold 0.05 \
--plot --use-best-multisummit-IDR

idr --samples $OUTPUT\_Rep2.tn5.Richard.narrowPeak.gz $OUTPUT\_Rep3.tn5.Richard.narrowPeak.gz \
--peak-list $OUTPUT\_pool.tn5.Richard.narrowPeak.gz --input-file-type narrowPeak \
--output-file $OUTPUT\_IDR_23.tn5.Richard.narrowPeak --rank p.value --soft-idr-threshold 0.05 \
--plot --use-best-multisummit-IDR

idr --samples  $OUTPUT\_IDR_12.tn5.Richard.narrowPeak  $OUTPUT\_IDR_23.tn5.Richard.narrowPeak \
--peak-list $OUTPUT\_pool.tn5.Richard.narrowPeak.gz --input-file-type narrowPeak \
--output-file $OUTPUT\_IDR_final.tn5.Richard.narrowPeak --rank p.value --soft-idr-threshold 0.05 \
--plot --use-best-multisummit-IDR

IDR_THRESH_TRANSFORMED=$(awk -v p=0.05 'BEGIN{print -log(p)/log(10)}')

awk 'BEGIN{OFS="\t"} $12>='"${IDR_THRESH_TRANSFORMED}"' {print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10}' $OUTPUT\_IDR_final.tn5.Richard.narrowPeak | \
sort | uniq | sort -k7n,7n | gzip -nc > $OUTPUT\_REP1_VS_REP2_VS_REP3.IDR0.05.Richard.narrowPeak.gz

BLACKLIST=/rugpfs/fs0/risc_lab/scratch/jrendleman/ATAC_09262021/references/ENCFF940NTE_blacklist.bed 

bedtools intersect -v -a $OUTPUT\_REP1_VS_REP2_VS_REP3.IDR0.05.Richard.narrowPeak.gz -b $BLACKLIST | \
awk 'BEGIN{OFS="\t"} {if ($5>1000) $5=1000; print $0}' | grep -P 'chr[\dXY]+[ \t]'  | \
gzip -nc > $OUTPUT\_REP1_VS_REP2_VS_REP3.IDR0.05.filt.Richard.narrowPeak.gz

cat $outdir/*_REP1_VS_REP2_VS_REP3.IDR0.05.filt.Richard.narrowPeak.gz >master_IDR_Richard.Peaks.narrowPeak.gz

