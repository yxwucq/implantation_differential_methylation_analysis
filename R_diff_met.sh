#!/usr/bin/env bash

# pick the columns then change 
# awk 'NR==1 {print substr($1,2),$2,$4,$5 } NR!=1 {print $1,$2,$4,$5}' ./data/preg_met_merged.bed > tmpfile && mv tmpfile ./data/preg_met_merged_input.bed
# awk 'NR==1 {print substr($1,2),$2,$4,$5 } NR!=1 {print $1,$2,$4,$5}' ./data/no_preg_met_merged.bed > tmpfile && mv tmpfile ./data/no_preg_met_merged_input.bed

# using R to analyze differential methylation
# conda activate R4.2.1 

for chr in {1..22}; do
echo "processing chr$chr..."
Rscript --vanilla diff_met.R "$chr"
done