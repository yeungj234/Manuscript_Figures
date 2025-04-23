#!/bin/bash

# Output TSV file name
output_file="PBC_QC_summary.tsv"

# Print the header to the TSV file
echo -e "File Name\tTotal read pairs\tDistinct pairs\tm1\tm2\tm0/mt\tm1/m0\tm1/m2" > "$output_file"

# Loop through all .txt files in the current directory
for file in *PBC_QC.txt; do
  if [[ -f "$file" ]]; then
    # Read the line from the file
    metrics=$(cat "$file")
    
    # Append the filename and the metrics as a TSV line
    echo -e "$file\t$metrics" >> "$output_file"
  fi
done
