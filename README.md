# Original code for bioinformatics analysis of ATAC-seq & RNA-seq data
## CDK4/6 inhibition induces a senescence-associated secretory phenotype via delayed NF-κB activation
### Authors: Joanna Lan-Hing Yeung1,*, Justin Rendleman1,*, Lauren Anderson Westcott1, Arnold Ou1, Matthew Pressler1, Nicole Pagane1, Irene Duba1, Ria Hosuru1, Bat-Ider Tumenbayar1, Viviana I. Risca1 

1Laboratory of Genome Architecture and Dynamics, The Rockefeller University, New York, NY 10065, USA.
*These authors contributed equally 

## SUMMARY 
Cellular senescence consists of regulated phenotypes associated with permanent exit from the cell cycle in response to stressors such as genomic instability. The consequences of senescence go beyond individual cells due to the senescence associated secretory phenotype (SASP), which can induce inflammation in neighboring cells. Some cancers respond to CDK4/6 inhibitors (CDK4/6i) with a senescence-like phenotype in the absence of extensive DNA damage. We asked how the SASP and the transcriptional regulatory profile triggered by CDK4/6i-driven arrest compares to the canonical NF-κB-regulated SASP triggered by DNA damage. We profiled the dynamics of transcriptional regulation in response to the CDK4/6i, palbociclib, and the DNA damaging agent, doxorubicin. We found upregulation of NF-κB driven-SASP genes was shared across both drugs, although delayed in CDK4/6i, coinciding with slower enhancer activation and epigenetic changes. ATM/ATR inhibition did not affect CDK4/6i-induced NF-κB nuclear localization, suggesting an alternative upstream activator. Inhibiting NF-κB suppressed the expression of SASP genes without reversing stable arrest, pointing to SASP manipulation as a potential therapeutic strategy and providing insights into controversies regarding cell cycle arrest-driven SASP.
 
 

## Directory tree
```
├── Figure2
│   └── Figure2.Rmd 
├── Figure3
│   ├── deepTools_files
│   │   └── deeptools_Coverage_1kb.slurm
│   └── Figure3.Rmd
├── Figure4
│   ├── Figure4.Rmd
│   └── motif_analysis_input
│       └── MEME_AME.slurm
├── Figure5
│   └── Figure5.Rmd
├── Figure6
│   ├── deepTools_files
│   │   └── deeptools_Coverage_1kb.slurm
│   ├── Figure6.Rmd
│   └── NFKB_tp_peaks
│       └── get_tp_peaks_motifs.slurm
├── FigureS1
│   └── FigureS1.Rmd
├── FigureS2
│   ├── deepTools_files
│   │   └── deeptools_Coverage_1kb.slurm
│   ├── E2F_tp_peaks
│   │   └── get_tp_peaks_motifs.slurm
│   └── FigureS2.Rmd
├── FigureS3
│   ├── FigureS3.Rmd
│   └── motif_analysis_input
│       └── MEME_AME.slurm
├── FigureS4
│   └── FigureS4.Rmd
├── FigureS5
│   ├── FigureS5.Rmd
│   └── Supplemental_Figure_SASP_composition.Rmd
├── FigureS6
│   ├── FigureS6.Rmd
│   └── motif_analysis_input
│       └── MEME_AME.slurm
├── generate_script_tree.sh
├── Preprocessing_scripts
│   ├── Assess_QC_metrics
│   │   ├── calculate_FRIP_R_script.R
│   │   ├── calculate_FRIP_scores_R.slurm
│   │   ├── cat_duplication_metrics.sh
│   │   ├── cat_PBC_QC.sh
│   │   ├── count_mito_readpairs.sh
│   │   ├── get_total_reads.sh
│   │   ├── run_array_job.sh
│   │   └── tss_enrichment_score.sh
│   ├── ATACseq
│   │   ├── atac_1_fastq_trim.slurm
│   │   ├── atac_2_fastq_align.slurm
│   │   ├── atac_3_bam_managemito.slurm
│   │   ├── atac_4_bam_markduplicates.slurm
│   │   ├── atac_5_bam_FLD.slurm
│   │   ├── atac_6.3_IDR_tagalign.slurm
│   │   ├── atac_6_IDR_tagalign_2reps.slurm
│   │   ├── bamCoverage_scaleFactor_noOffset.slurm
│   │   ├── cutsCoverage.R
│   │   ├── cutsCoverage.slurm
│   │   ├── iterative_peak_filtering
│   │   │   ├── mergedFW_peakCall.R
│   │   │   └── peakfiltering.slurm
│   │   └── mergebam.slurm
│   └── RNAseq
│       └── kallisto_counting.slurm
└── Supplemental_Tables
    └── Supplemental_Tables.Rmd
```

### Description of scripts
- `./Figure2/Figure2.Rmd`  
  ⤷ *code to generate figures for Figure 2*

- `./Figure3/deepTools_files/deeptools_Coverage_1kb.slurm`  
  ⤷ *code to plot Tn5 insertion sites around p53 motifs*

- `./Figure3/Figure3.Rmd`  
  ⤷ *code to generate figures for Figure 3*

- `./Figure4/Figure4.Rmd`  
  ⤷ *code to generate figures for Figure 4*

- `./Figure4/motif_analysis_input/MEME_AME.slurm`  
  ⤷ *code to perform motif enrichment analysis using MEME-AME HOCOMOCO v11 database *

- `./Figure5/Figure5.Rmd`  
  ⤷ *code to generate figures for Figure 5*

- `./Figure6/deepTools_files/deeptools_Coverage_1kb.slurm`  
  ⤷ *code to plot Tn5 insertion sites around NF-kB motifs*

- `./Figure6/Figure6.Rmd`  
  ⤷ *code to generate figures for Figure 6.*

- `./Figure6/NFKB_tp_peaks/get_tp_peaks_motifs.slurm`  
  ⤷ *code to count the number of true positive peaks for NFKB family of motifs after MEME-AME analysis.*

- `./FigureS1/FigureS1.Rmd`  
  ⤷ *code to generate figures for Figure S1.*

- `./FigureS2/deepTools_files/deeptools_Coverage_1kb.slurm`  
  ⤷ *code to plot Tn5 insertion sites around E2F motifs*

- `./FigureS2/E2F_tp_peaks/get_tp_peaks_motifs.slurm`  
  ⤷ *code to count the number of true positive peaks for E2F family of motifs after MEME-AME analysis.*

- `./FigureS2/FigureS2.Rmd`  
  ⤷ *code to generate figures for Figure S2*

- `./FigureS3/FigureS3.Rmd`  
  ⤷ *code to generate figures for Figure S3*

- `./FigureS3/motif_analysis_input/MEME_AME.slurm`  
  ⤷ *code to perform motif enrichment analysis using MEME-AME HOCOMOCO v11 database*

- `./FigureS4/FigureS4.Rmd`  
  ⤷ *code to generate figures for Figure S4*

- `./FigureS5/FigureS5.Rmd`  
  ⤷ *code to generate figures for Figure S5*

- `./FigureS6/FigureS6.Rmd`  
  ⤷ *code to generate figures for Figure S6*

- `./FigureS6/motif_analysis_input/MEME_AME.slurm`  
  ⤷ *code to perform motif enrichment analysis using MEME-AME HOCOMOCO v11 database*

- `./Preprocessing_scripts/Assess_QC_metrics/calculate_FRIP_R_script.R`  
  ⤷ *calculate FRIP score for each individual sample's narrowPeak & bam file in R*

- `./Preprocessing_scripts/Assess_QC_metrics/calculate_FRIP_scores_R.slurm`  
  ⤷ *slurm script to run ./Preprocessing_scripts/Assess_QC_metrics/calculate_FRIP_R_script.R*

- `./Preprocessing_scripts/Assess_QC_metrics/cat_duplication_metrics.sh`  
  ⤷ *script to extract duplication metrics based on the output *metrics.txt files generated from /Preprocessing_scripts/ATACseq/atac_4_bam_markduplicates.slurm*

- `./Preprocessing_scripts/Assess_QC_metrics/cat_PBC_QC.sh`  
  ⤷ *script to extract duplication metrics based on the output *PBC_QC.txt files generated from /Preprocessing_scripts/ATACseq/atac_4_bam_markduplicates.slurm*

- `./Preprocessing_scripts/Assess_QC_metrics/count_mito_readpairs.sh`  
  ⤷ *script to count the number of mitochondrial read pairs based on the output *.flagstat & *non.Mito.flagstat files generated from ./Preprocessing_scripts/ATACseq/atac_3_bam_managemito.slurm*

- `./Preprocessing_scripts/Assess_QC_metrics/get_total_reads.sh`  
  ⤷ *script to extract total raw read pairs based on the output *.log files generated from ./Preprocessing_scripts/ATACseq/atac_2_fastq_align.slurm*

- `./Preprocessing_scripts/Assess_QC_metrics/run_array_job.sh`  
  ⤷ *script to run ./Preprocessing_scripts/Assess_QC_metrics/tss_enrichment_score.sh*

- `./Preprocessing_scripts/Assess_QC_metrics/tss_enrichment_score.sh`  
  ⤷ *script to calculate TSS enrichment scores based on ENCODE ATAC-seq standards and using Gencode v41 gene annotation file*

- `./Preprocessing_scripts/ATACseq/atac_1_fastq_trim.slurm`  
  ⤷ *script to trim off Tn5 adapters from fastq files*

- `./Preprocessing_scripts/ATACseq/atac_2_fastq_align.slurm`  
  ⤷ *script to align reads from trimmed fastqs to hg38 genome & generate bam files*

- `./Preprocessing_scripts/ATACseq/atac_3_bam_managemito.slurm`  
  ⤷ *script to remove mitochondrial reads*

- `./Preprocessing_scripts/ATACseq/atac_4_bam_markduplicates.slurm`  
  ⤷ *script to generate final bam files and remove duplicate reads*

- `./Preprocessing_scripts/ATACseq/atac_5_bam_FLD.slurm`  
  ⤷ *Script that runs picard CollectInsertSizeMetrics to generate the fragment length distribution *

- `./Preprocessing_scripts/ATACseq/atac_6.3_IDR_tagalign.slurm`  
  ⤷ *script to call peaks with MACS2 and perform IDR on samples with 3 technical replicates.*

- `./Preprocessing_scripts/ATACseq/atac_6_IDR_tagalign_2reps.slurm`  
  ⤷ *script to call peaks with MACS2 and perform IDR on samples with 2 technical replicates.*

- `./Preprocessing_scripts/ATACseq/bamCoverage_scaleFactor_noOffset.slurm`  
  ⤷ *script to generate bigwigs normalized by sequencing depth from bam files*

- `./Preprocessing_scripts/ATACseq/cutsCoverage.R`  
  ⤷ *script that extracts the ends of reads after adjusting for Tn5 insertion bias and converting it to a normalized bigwig of Tn5 insertion sites to be used as input for deeptools_Coverage_1kb.slurm*

- `./Preprocessing_scripts/ATACseq/cutsCoverage.slurm`  
  ⤷ *script that runs ./Preprocessing_scripts/ATACseq/cutsCoverage.R*

- `./Preprocessing_scripts/ATACseq/iterative_peak_filtering/mergedFW_peakCall.R`  
  ⤷ *after performing IDR and concatenating all narrowPeak files into a master redundant peak set, this script iteratively filters overlapping peaks*

- `./Preprocessing_scripts/ATACseq/iterative_peak_filtering/peakfiltering.slurm`  
  ⤷ *script that runs ./Preprocessing_scripts/ATACseq/iterative_peak_filtering/mergedFW_peakCall.R*

- `./Preprocessing_scripts/ATACseq/mergebam.slurm`  
  ⤷ *script to merge bam files from the same condition*

- `./Preprocessing_scripts/RNAseq/kallisto_counting.slurm`  
  ⤷ *script to count transcript abundance using kallisto*

- `./Supplemental_Tables/Supplemental_Tables.Rmd`  
  ⤷ *code to generate supplemental tables*
