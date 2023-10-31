library(ape)

tree_417 = read.tree("E:/re-do_V2/00_dataset_production/output/tree_417_norm_validNames.tre")

### Prune tree to subtree from node 427

subtree = extract.clade(phy = tree_417, node = 427)
length(subtree$tip.label)

write.tree(subtree, "E:/re-do_V2/07_subtree/input/subtree_113.tre")

### Keep only species in subtree in sMap input files

files <- list.files("E:/re-do_V2/04_Dtest_417sp_all_traits/input", pattern="*.txt", full.names=TRUE)

for ( i in 1:length(files)){
  
  temp = read.csv(files[1], sep = "\t")
  temp = temp[temp$X417 %in% subtree$tip.label,] 
  colnames(temp) = c("113", "1")
  
  write.table(temp, paste0("E:/re-do_V2/07_subtree/input/", strsplit(files[i], split = "/")[[1]][5]), quote = F, row.names = F)
}


#### Formicoids - Dorylines subtree

### Prune tree to subtree from node 421

subtree = extract.clade(phy = tree_417, node = 421)
length(subtree$tip.label)

write.tree(subtree, "E:/re-do_V2/07_subtree/input/subtree_326.tre")

### Keep only species in subtree in sMap input files

files <- list.files("E:/re-do_V2/04_Dtest_417sp_all_traits/input", pattern="troph", full.names=TRUE)

for ( i in 1:length(files)){
  
  temp = read.csv(files[1], sep = "\t")
  temp = temp[temp$X417 %in% subtree$tip.label,] 
  colnames(temp) = c("326", "1")
  
  write.table(temp, paste0("E:/re-do_V2/07_subtree/input/", strsplit(strsplit(files[i], split = "/")[[1]][5], split = "_")[[1]][1], "_326.txt"), quote = F, row.names = F)
}
