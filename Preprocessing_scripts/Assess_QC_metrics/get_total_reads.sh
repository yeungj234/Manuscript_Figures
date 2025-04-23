#!/bin/bash

# Output CSV file
output_csv="total_reads_summary.csv"

# Write header
echo -e "sample,total_reads" > "$output_csv"

# Loop through all .log files
for logfile in *.log; do
  # Extract sample name (remove the .log extension)
  sample=$(basename "$logfile" .log)

  # Extract total reads from the first line
  total_reads=$(head -n 1 "$logfile" | awk '{print $1}')

  # Write to CSV
  echo -e "${sample},${total_reads}" >> "$output_csv"
done
