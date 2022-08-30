#!/usr/bin/env bash

sort -k1,1 -k2,2n ./data/no_preg_met_data.bedgraph | bedtools merge -header -i stdin -d -1 -c 4,5 -o sum,sum > ./data/no_preg_met_merged.bed
sort -k1,1 -k2,2n ./data/preg_met_data.bedgraph | bedtools merge -header -i stdin -d -1 -c 4,5 -o sum,sum > ./data/preg_met_merged.bed
