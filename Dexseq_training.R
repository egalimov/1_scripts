#!/usr/bin/env Rscript
View(young.aged)
View(young.aged.woutr)
View(young.aged.v)
View(young.aged.v.fdr)

e <- read.table("e.csv", sep=",", header = T)
View(e)
e <- e[- grep("[+]", e$external_gene_id),]


fd <- read.table("fdr.txt", sep="\t", header = T)
View(fd)

young.aged <- read.table("170922_worm_heintz_CTL_OLD_res_clean_novel.tab", sep="\t", header = T)
View(rescleannovel)


young.aged <- read.csv("noaggr_ctl_old_SignificantExons.csv")

young.aged <- read.csv("171010_mouse_pe_ctl_old_SignificantExons.csv")
#young.aged <- read.csv("young-aged.csv")
#young.aged <- read.csv("/Users/evgenigalimov/Documents/3_BioInf/1_Cel_dexseq/ctl_aged_with_utr/Zanda_AD_Tc1J20_ctl_aged_SignificantExons.csv")
#young.aged.woutr <- read.csv("/Users/evgenigalimov/Documents/3_BioInf/1_Cel_dexseq/ctl_aged_with_utr/Zanda_AD_Tc1J20_ctl_aged_SignificantExons171024_wo_utr.csv")

length(which(young.aged$FDR<0.10))         #  number of values in $FDR column < 0.01
#length(which(young.aged.woutr$FDR<0.01)) 

young.aged.v <- young.aged[- grep("[+]", young.aged$external_gene_id),]     #save strings which don't contain "+"() i.e.2 genes)
View(young.aged.v)
length(which(young.aged.v$FDR<0.10))         #  number of values in $FDR column < 0.01
young.aged.v.fdr <- young.aged.v[which(young.aged.v$FDR<0.10),]    # leave only genes with FDR<0.01
unique.genes<-unique(young.aged.v.fdr$EnsemblID)  #make list of unique gene names

write.table(unique.genes, file = "unique_genes_FDR-0.01.csv",row.names=FALSE, quote=FALSE,col.names = FALSE)

print(unique.genes)

---
a = data.frame()
a  <- young.aged1[+ grep("[+]", young.aged1$external_gene_id),] 
b  <- young.aged1[- grep("[+]", young.aged1$strand),] 
View(a)
length(which(young.aged1$FDR<0.10))         #  number of values in $FDR column < 0.01
#length(which(young.aged.woutr$FDR<0.01)) 

young.aged.v1 <- young.aged1[- grep("[+]", young.aged1$external_gene_id),]     #save strings which don't contain "+"() i.e.2 genes)
View(young.aged.v1)
length(which(young.aged.v1$FDR<0.10))         #  number of values in $FDR column < 0.01
young.aged.11 <- young.aged1[which(young.aged1$FDR<0.10),]    # leave only genes with FDR<0.01
View(young.aged.11)
unique.genes<-unique(young.aged.11$EnsemblID)  #make list of unique gene names

write.table(unique.genes, file = "unique_genes_FDR-0.01.csv",row.names=FALSE, quote=FALSE,col.names = FALSE)


a1 <- read.table("1", sep="\t", header = T)
View(a1)
