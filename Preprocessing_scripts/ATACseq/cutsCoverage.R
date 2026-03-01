library(readr)
library(GenomicAlignments)
library(Rsamtools)
library(MotifDb)
library(motifmatchr)
library(BSgenome.Hsapiens.UCSC.hg38)
library(soGGi)
library(rtracklayer)
library(GenomicRanges)
library(ChIPseeker)
library(TxDb.Hsapiens.UCSC.hg38.knownGene)
library(org.Hs.eg.db)
library(DESeq2)


# name bams
mergedbams_files <- c("/lustre/fs4/risc_lab/scratch/jyeung/merged_LSPDvsDoxo_1and2/merged_bams/Cycling_merged_sorted.bam",
"/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/3022023_run_Deep_Justin_scripts/atac_4_bam_markduplicates/merged_bams/day3_Doxo_merged_sorted.bam",
"/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_1/ATACseq/5182022_run_Deep_Justin_scripts/4markduplicates_output/mergedbams/day10Doxo_merged_sorted.bam",
"/lustre/fs4/risc_lab/scratch/jyeung/merged_LSPDvsDoxo_1and2/merged_bams/day14_Doxo_merged_sorted.bam",
"/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/3022023_run_Deep_Justin_scripts/atac_4_bam_markduplicates/merged_bams/day21_Doxo_merged_sorted.bam",
"/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/3022023_run_Deep_Justin_scripts/atac_4_bam_markduplicates/merged_bams/day3_Palbo_merged_sorted.bam",
"/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_1/ATACseq/5182022_run_Deep_Justin_scripts/4markduplicates_output/mergedbams/day10Palbo_merged_sorted.bam",
"/lustre/fs4/risc_lab/scratch/jyeung/merged_LSPDvsDoxo_1and2/merged_bams/day14_Palbo_merged_sorted.bam",
"/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/3022023_run_Deep_Justin_scripts/atac_4_bam_markduplicates/merged_bams/day21_Palbo_merged_sorted.bam",
"/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/3022023_run_Deep_Justin_scripts/atac_4_bam_markduplicates/merged_bams/day28_Palbo_merged_sorted.bam")
names(mergedbams_files) <- c("Cycling", "day3_Doxo", "day10_Doxo", "day14_Doxo", "day21_Doxo", "day3_Palbo", "day10_Palbo", "day14_Palbo", "day21_Palbo", "day28_Palbo")

# read in bams as Genomic Alignment pairs 
write_dir <- "/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/Tn5_offset_merged_bigwigs/scaleFactornorm_cutsCoverage_bigwigs"
#mergedbams_all <- lapply(mergedbams_files[1:2], readGAlignmentPairs)
#save(mergedbams_all, file=paste0(write_dir,"/workspaces/mergedbams_Cycling_day3Doxo_GAlignments.RData"))

#mergedbams_all <- lapply(mergedbams_files[3:5], readGAlignmentPairs)
#save(mergedbams_all, file=paste0(write_dir, "/workspaces/mergedbams_day10Doxo_day14Doxo_day21Doxo_GAlignments.RData"))

#mergedbams_all <- lapply(mergedbams_files[6:8], readGAlignmentPairs)
#save(mergedbams_all, file=paste0(write_dir, "/workspaces/mergedbams_day3Palbo_day10Palbo_day14Palbo_GAlignments.RData"))

#mergedbams_all <- lapply(mergedbams_files[9:10], readGAlignmentPairs)
#save(mergedbams_all, file=paste0(write_dir, "/workspaces/mergedbams_day21Palbo_day28Palbo_GAlignments.RData"))

# extract only ends of reads from each strand from each read. 
cutsCoverage_list <- list()
for(i in 1:length(mergedbams_files)){
  merged_bam <- readGAlignmentPairs(file = mergedbams_files[i])
  read1 <- first(merged_bam)
  read2 <- second(merged_bam)
  # read 1
  Firsts <- resize(granges(read1), fix = "start", 1)
  # account for Tn5 shift
  First_Pos_toCut <- shift(granges(Firsts[strand(read1) == "+"]), 4)
  First_Neg_toCut <- shift(granges(Firsts[strand(read1) == "-"]), -5) 
  # read 2
  Seconds <- resize(granges(read2), fix = "start", 1)
  # account for Tn5 shift
  Second_Pos_toCut <- shift(granges(Seconds[strand(read2) == "+"]), 4)
  Second_Neg_toCut <- shift(granges(Seconds[strand(read2) == "-"]), -5)
  # put all cut sites into 1 vector to plot as a single plot
  test_toCut <- c(First_Pos_toCut, First_Neg_toCut, Second_Pos_toCut, Second_Neg_toCut)
  # make cut sites into Rlelist
  cutsCoverage <- coverage(test_toCut)
  cutsCoverage_list[[i]] <- cutsCoverage
  save(cutsCoverage,file=paste0(write_dir, "/workspaces/", names(mergedbams_files)[i], "_merged_cutsCoverage.RData"))
}
names(cutsCoverage_list) <- names(mergedbams_files)

# load in DESeq object from ATAC-seq fragments counted under 500bp bins. (less biased for size factor normalization than counts under peaks)
load("/lustre/fs4/risc_lab/scratch/jyeung/LS_PDvsDoxo_2/ATACseq/post_peakcalling_analysis/ATAC_DESeq_Genomic_Bins_06052024/workspaces/dds_filt.RData")
dds_filt <- dds_filt[ ,c(1:5, 38, 40, 39, 41, 42, 28:32, 43:45, 6:7, 49:51, 11:15, 33:37, 46:48, 8:10, 52:54, 16:27)]
dds_filt$group <- factor(paste0(dds_filt$Condition, dds_filt$Biorep))

# get scalefactors for each condition (merge bioreps and tech reps)
dds_filt_collapsed <- collapseReplicates(dds_filt, dds_filt$Condition)
dds_filt_collapsed <- estimateSizeFactors(dds_filt_collapsed)
dds_filt_collapsed <- dds_filt_collapsed[ ,c(1,9,2,4,6,10,3,5,7,8)]

# calculate size factor. 
scalefactor <- 1/dds_filt_collapsed$sizeFactor
names(scalefactor) <- names(mergedbams_files)
normcutsCoverage <- list()
for(i in 1:length(cutsCoverage_list)){
  normcutsCoverage[[i]] <- cutsCoverage_list[[i]]*scalefactor[match(names(cutsCoverage_list), names(scalefactor))][i] # multiply cuts Coverage by size factor for normalization. 
}
# export cutsCoverage as bigwigs
for(i in 1:length(cutsCoverage_list)){
  export.bw(cutsCoverage_list[[i]], con=paste0(write_dir, "/", names(mergedbams_files)[i], "merged_cutsCoverage.bw"))
  
  export.bw(normcutsCoverage[[i]], con=paste0(write_dir, "/", names(mergedbams_files)[i], "merged_scaleFactornorm_cutsCoverage.bw"))
}
