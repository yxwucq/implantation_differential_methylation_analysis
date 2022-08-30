#!/usr/bin/env bash

# Do Not Directly Run This Code
# 吴宇轩 2022.8.27


# using these two as examples for their low size
# the pregnant ./data/PBAT_E184_B13.single5mC
# not pregnant ./data/PBAT_E185_B13.single5mC

# select data like chr pos total met
# awk '{print $1,$2,$5,$6}' ./data/PBAT_E184_B13.single5mC > ./data/_PBAT_E184_B13.txt
# awk '{print $1,$2,$5,$6}' ./data/PBAT_E185_B13.single5mC > ./data/_PBAT_E185_B13.txt

# select the first four columns 

function met_merge {
    head_status=True
    count=1
    total=$(awk 'END {print NR}' "./data/$1")
    for each_file in $(cat ./data/$1); do
        if [ $head_status = True ]; then
            printf "#chr\tpos\tpos_e\tN\tX\n" > ./data/"$2".bedgraph
            head_status=False
        fi 
        echo "processing $count/$total"
        awk -F '\t' 'BEGIN {OFS = FS} $NF == "CpG" {print $1,$2,$2+1,$5,$6}' "./data/$each_file.single5mC" >> ./data/"$2".bedgraph
        count=$((count+1))
    done
}

met_merge "N_list0617.txt" "no_preg_met_data"
met_merge "P_list0617.txt" "preg_met_data"

# activate anaconda in advance
# sort and then merge with option -c and -o

eval "$(conda shell.bash hook)" # need before activate conda environment
conda activate anaconda
sort -k1,1 -k2,2n ./data/no_preg_met_data.bedgraph | bedtools merge -header -i stdin -d -1 -c 4,5 -o sum,sum > ./data/no_preg_met_merged.bed
sort -k1,1 -k2,2n ./data/preg_met_data.bedgraph | bedtools merge -header -i stdin -d -1 -c 4,5 -o sum,sum > ./data/preg_met_merged.bed

# pick the columns then change 
awk 'NR==1 {print substr($1,2),$2,$4,$5 } NR!=1 {print $1,$2,$4,$5}' ./data/preg_met_merged.bed > tmpfile && mv tmpfile ./data/preg_met_merged_input.bed
awk 'NR==1 {print substr($1,2),$2,$4,$5 } NR!=1 {print $1,$2,$4,$5}' ./data/no_preg_met_merged.bed > tmpfile && mv tmpfile ./data/no_preg_met_merged_input.bed

# split the data to get smaller dataset
for chr in {1..22}; do awk -v chr="chr${chr}" 'NR==1 {print } $1 == chr { print }' ./data/preg_met_merged_input.bed > "./data/split/preg_met_merged_input_${chr}.bed"; done
for chr in {1..22}; do awk -v chr="chr${chr}" 'NR==1 {print } $1 == chr { print }' ./data/no_preg_met_merged_input.bed > "./data/split/no_preg_met_merged_input_${chr}.bed"; done

# using R to analyze differential methylation
conda activate R4.2.1 

for chr in {1..22}; do
echo "processing chr$chr..."
Rscript --vanilla diff_met.R "$chr"
done

# 

function merge_then_sort {
if [ -e ./output_data/total_dmrs_"$1"_delta.bed ]; then
    rm ./output_data/total_dmrs_"$1"_delta.bed; 
fi
touch total_dmrs_"$1"_delta.bed
for each_file in ./output_data/dmrs_"$1"_delta_* ; do
    cat $each_file >> ./output_data/total_dmrs_"$1"_delta.bed
done

sort -rnk9,9 ./output_data/total_dmrs_"$1"_delta.bed > tmpfile && mv tmpfile ./output_data/total_dmrs_"$1"_delta.bed
head -20000 ./output_data/total_dmrs_"$1"_delta.bed > ./output_data/total_dmrs_"$1"_delta_p.bed
tail -20000 ./output_data/total_dmrs_"$1"_delta.bed > ./output_data/total_dmrs_"$1"_delta_np.bed
}

merge_then_sort 95
merge_then_sort 99

