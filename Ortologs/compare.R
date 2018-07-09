

library(data.table)

################
# define species and tables
wdir="/Users/evgenigalimov/Dropbox/21_Bioinf/sgseq/Orthologs/"
OMAcomp = "comp"


#sp1 = "a"
#sp1_table = "a"
#sp2 = "b"
#sp2_table = "b"



setwd(wdir)
files = list.files(pattern = "*.UniqueGenes.txt",include.dirs = FALSE)

###########
# getting short names for files
fn = list()
for (f in 1:length(files)) {
  ft1=unlist(strsplit(files[f], "_"))
  fn[f]=ft1[1]
}
###
# setting variables
sp1 = fn[1]
sp1_table = files[1]
sp2 = fn[2]
sp2_table = files[2]
###############
# find orthologs


pairs_sp1_sp2r <- read.table("comp", sep="\t", header = F ,stringsAsFactors = FALSE)
species_1r = read.table(sp1_table, sep="\t", header = F ,stringsAsFactors = FALSE)
species_2r = read.table(sp2_table, sep="\t", header = F ,stringsAsFactors = FALSE)
#dat = as.data.table(dat2)


species_1 = as.data.table(species_1r)
species_2 = as.data.table(species_2r)
pairs_sp1_sp2 = as.data.table(pairs_sp1_sp2r)

list_1find <- data.frame(stringsAsFactors=FALSE) 

for (i in 1:nrow(species_1)) {
    for (j in 1:nrow(pairs_sp1_sp2)) {
          if (species_1[i]==pairs_sp1_sp2[j,1]) {
            list_1find=rbind(list_1find,pairs_sp1_sp2[j,])
          
        }
    }
}

list_2find <- data.frame(stringsAsFactors=FALSE) 
for (i in 1:nrow(species_2)) {
  for (j in 1:nrow(list_1find)) {
    if (species_2[i]==list_1find[j,2]) {
      list_2find=rbind(list_2find,list_1find[j,])
      
    }
  }
}

write.table(list_2find, file = paste(wdir,sp1,"_",sp2,".txt", sep=""), 
            quote = FALSE, sep = "\t", eol = "\n", row.names = FALSE, col.names = FALSE)






