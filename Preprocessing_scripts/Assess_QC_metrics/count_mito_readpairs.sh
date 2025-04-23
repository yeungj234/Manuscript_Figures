#!/bin/bash
# Output CSV file
output_csv="mito_readpairs_counts.csv"

# Write header
echo -e "flagstat_file,mito_reads" > "$output_csv"
for flagstat_file in *.flagstat; do
  # Skip nonMito files, we'll handle them together
  if [[ "$flagstat_file" == *_nonMito.flagstat ]]; then
    continue
  fi

  # Get base name (strip .flagstat)
  base="${flagstat_file%.flagstat}"

  # Define the corresponding nonMito file
  non_mito_file="${base}_nonMito.flagstat"

  # Check that the nonMito file exists
  if [[ ! -f "$non_mito_file" ]]; then
    echo "Warning: $non_mito_file not found. Skipping $base."
    continue
  fi

  # Extract total and non-mito reads
  total_reads=$(cat "$flagstat_file" | sed -n '7p' |sed 's/ .*//g') 
  non_mito_reads=$(cat "$non_mito_file" | sed -n '7p' |sed 's/ .*//g')

  # Calculate mitochondrial reads
  mito_reads=$((total_reads - non_mito_reads))

  # Save to CSV
  echo "$flagstat_file,$mito_reads" >> "$output_csv"
done
