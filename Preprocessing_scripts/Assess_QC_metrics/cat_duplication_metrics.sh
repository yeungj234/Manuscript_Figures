#!/bin/bash

# Output TSV file
output_tsv="duplication_metrics_summary.tsv"

# Write header
echo -e "sample\tLIBRARY\tUNPAIRED_READS_EXAMINED\tREAD_PAIRS_EXAMINED\tSECONDARY_OR_SUPPLEMENTARY_RDS\tUNMAPPED_READS\tUNPAIRED_READ_DUPLICATES\tREAD_PAIR_DUPLICATES\tREAD_PAIR_OPTICAL_DUPLICATES\tPERCENT_DUPLICATION\tESTIMATED_LIBRARY_SIZE" > "$output_tsv"

# Loop over all *_metrics.txt files
for file in *_metrics.txt; do
  # Extract the sample name (remove suffix)
  sample=$(basename "$file" _metrics.txt)

  # Extract just line 9 (the data line)
  data_line=$(head -n 8 "$file" | tail -n 1)

  # Normalize whitespace and convert to tabs
  dup_values=$(echo "$data_line" | tr -s '[:space:]' '\t')

  # Append to the output
  echo -e "$sample\t$dup_values" >> "$output_tsv"
done
