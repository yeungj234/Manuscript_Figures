## 🧾 Script File Structure

.
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
│   │   ├── cutsCoverage.slurm
│   │   ├── deeptools_TSS_Cov_1kb.slurm
│   │   ├── get_total_reads.sh
│   │   ├── run_array_job.sh
│   │   └── tss_enrichment_score.sh
│   ├── ATACseq
│   │   ├── atac_0_fastq_trim_readlength.slurm
│   │   ├── atac_1_fastq_trim.slurm
│   │   ├── atac_2_fastq_align.slurm
│   │   ├── atac_2_fastq_align_userinputs.slurm
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

25 directories, 48 files
