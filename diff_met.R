library(DSS)
library(tidyverse)
library(data.table)
require(bsseq)

args = commandArgs(trailingOnly = TRUE)

print("Running R")

preg_data = fread(str_c("./data/split/preg_met_merged_input_", args[1], ".bed"), header = T)
no_preg_data = fread(str_c("./data/split/no_preg_met_merged_input_", args[1], ".bed"), header = T)

print("Making Data")
BSobj = makeBSseqData(list(preg_data, no_preg_data), c("P", "N"))

print("Perform Test")
# four = MulticoreParam(workers=4, progressbar=TRUE) cannot work 
single = MulticoreParam(workers=1, progressbar=TRUE)
dmlTest = DMLtest(BSobj, group1 = c("P"), group2 = c("N"), smoothing = T, BPPARAM=single) #specify the ncores


# dmrs_95_delta = callDMR(dmlTest, delta = 0.1, p.threshold = 0.05)
# dmrs_95 = callDMR(dmlTest, p.threshold = 0.05)
# dmrs_99_delta = callDMR(dmlTest, delta = 0.1, p.threshold = 0.01)
# dmrs_99 = callDMR(dmlTest, p.threshold = 0.01)
dmrs_999_delta = callDMR(dmlTest, delta = 0.1, p.threshold = 0.001)

write.bed = function(Tx, file){
    write.table(Tx, file = file, sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)
}

# write.bed(dmrs_95_delta, file=str_c("output_data/dmrs_95_delta_",args[1],".bed"))
# write.bed(dmrs_95, file="output_data/dmrs_95.bed")
# write.bed(dmrs_99_delta, file=str_c("output_data/dmrs_99_delta_",args[1],".bed"))
# write.bed(dmrs_99, file="output_data/dmrs_99.bed")
write.bed(dmrs_999_delta, file=str_c("output_data/dmrs_999_delta_",args[1],".bed"))