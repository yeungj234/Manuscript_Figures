#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
library(BiocParallel)
library(rtracklayer)
library(GenomicRanges)

# Read narrowPeaks to Granges as peak_gr + metadata columns
extraCols_narrowPeak <- c(signalValue = "numeric", pValue = "numeric",
                          qValue = "numeric", peak = "integer")

#import merged narrow peaks file as a GRanges object with metadata columns
peak_gr <- import(args[1], format = "BED", extraCols = extraCols_narrowPeak)

ref_gr <- GRangesForUCSCGenome("hg38") #load in reference USCS genome
ref_gr <- head(ref_gr, 25)

# Set fixed width
fw <- as.integer(args[2]) #fixed width

# update peaks number with chromosome number, start and end of the OG peaks
chr_nm <- mcols(peak_gr)$name
peak_name <- paste(seqnames(peak_gr), ":", start(peak_gr),"-",end(peak_gr), "_", chr_nm, sep = "")
mcols(peak_gr)$name <- peak_name

# Reassign start and end to fw/2 + summit(calc summit) <- summit = start + peak
summit =  vector()
summit = mcols(peak_gr)$peak # make peak value into a vector initially
start(peak_gr) <- start(peak_gr) + summit - fw/2 #move start to 1/2 of the fixed width from summit
end(peak_gr) <- start(peak_gr) + fw #move end to fixed width value from NEW start

contig_gr <- reduce(peak_gr) #merge fixed width peaks
#contig is the same as mergedFW

# order and remove any fixed widths in peak_gr that are not completely CONTAINED in the reference
peak_gr <- sort(peak_gr)
peak_gr <- subsetByOverlaps(peak_gr, ref_gr, type = "within")

contig_gr = sortSeqlevels(contig_gr)
contig_gr <- split(contig_gr, start(contig_gr)) ##split up into GrangesList of contigs

it_peaks <- function(con_gr, temp_gr)
{
  temp_final_gr <- GRanges()
  olgr <- subsetByOverlaps(temp_gr, con_gr, minoverlap = fw/2 -1) # overlap of peak summits that fall within a contig
  while(isEmpty(olgr) == FALSE)
  {
    olgr <- sort(olgr, by=~qValue, decreasing = TRUE) #sort overlapping peaks so highest qValue is at the top
    temp_final_gr <- append(temp_final_gr, olgr[1]) #add highest qvalue of overlapping peaks to final genomic ranges object
    olgr <- subsetByOverlaps(olgr, olgr[1], invert = TRUE)# subset seperated peaks left over in the contig
  }
  return(temp_final_gr)
}
#algorthim: group all peaks with summits in the contig -> rank peaks via qvalue -> choose highest qvalue -> remove peaks overlapping with most significant peak from group -> repeat till empty and move to next contig

# using the function on the GRangeslist and returning it into a Granges object
final_gr_list <- bplapply(contig_gr, it_peaks, peak_gr) #parallelize the function so that each chromosome is being iterated through at the same time
final_gr_list <- GRangesList(final_gr_list) #make list into GRangesList
final_gr<- unlist(final_gr_list) #make GRangesList in GRanges object
final_gr@ranges@NAMES <- c() #remove excess names by making them nulls(keep seqnames)
export.gff2(final_gr, args[3]) #export final GRanges object to a gtf file in specified directory