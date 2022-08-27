library(DSS)
require(bsseq)

preg_data = read.table("./data/preg_met_merged.bed", header = T)
no_preg_data = read.table("./data/no_preg_met_merged.bed", header = T)

BSobj = makeBSseqData(list(preg_data, no_preg_data), c("P", "N"))

dmlTest = DMLtest(BSobj, group1 = "P", group2 = "N", smoothing = T)

dmrs_95_delta = callDMR(dmlTest, delta = 0.1, p.threshold = 0.05)
dmrs_95 = callDMR(dmlTest, p.threshold = 0.05)
dmrs_99_delta = callDMR(dmlTest, delta = 0.1, p.threshold = 0.01)
dmrs_99 = callDMR(dmlTest, p.threshold = 0.01)

write.bed = function(Tx, file){
    write.table(Tx, file = file, sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)
}

write.bed(dmrs_95_delta, file="output_data/dmrs_95_delta.bed")
write.bed(dmrs_95, file="output_data/dmrs_95.bed")
write.bed(dmrs_99_delta, file="output_data/dmrs_99_delta.bed")
write.bed(dmrs_99, file="output_data/dmrs_99.bed")