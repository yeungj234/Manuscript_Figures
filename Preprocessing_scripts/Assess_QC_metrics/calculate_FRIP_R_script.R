library(GenomicRanges)
library(GenomicAlignments)
library(rtracklayer)
library(BiocParallel)

# Set working directory
setwd("/lustre/fs4/risc_lab/scratch/jyeung/merged_LSPDvsDoxo_1and2/FRIP")

# Read file paths and sample names
peakfile <- readLines("narrowPeakfiles2.txt")
bam <- readLines("bamfiles_sorted.txt")
samplenames <- readLines("samplenames_basedonpeaks.txt")

# Import peak GRanges objects
peak_GRanges <- lapply(peakfile, import)

# Set up BiocParallel
register(MulticoreParam(workers = 4))  # Change 4 to however many cores you want to use

# Define function to calculate FRiP and write CSV
calc_and_write_frip <- function(i) {
  bam_GAlignments <- readGAlignmentPairs(bam[i])
  overlaps <- bam_GAlignments[bam_GAlignments %over% peak_GRanges[[i]]]
  frip <- length(overlaps) / length(bam_GAlignments)
  frip_df <- data.frame(sample = samplenames[i], FRIP = frip)
  write.csv(frip_df,
            file = file.path(getwd(), paste0(samplenames[i], "_frip_scores.csv")),
            row.names = FALSE)
  return(NULL)  # We don't need to return anything
}

# Run in parallel
bplapply(seq_along(peak_GRanges), calc_and_write_frip)