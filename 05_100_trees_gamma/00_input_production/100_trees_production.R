library(ape)
library(dplyr)
library(stringr) 
library(progress)
library(tidyverse)

data = read.tree("/media/meurvill/Elements/re-do_V2/00_dataset_production/output/tree_417.tre")
data = as.data.frame(data$tip.label)
colnames(data) = c("species")

trees = read.tree("/media/meurvill/Elements/re-do_V2/00_dataset_production/input/Dryad_archive/15k_all_ant_trees/15k_NCuniform_stem_posterior.tre")

invalid = read.csv("/media/meurvill/Elements/re-do_V2/00_dataset_production/input/invalid_species.txt", header = T, sep = "\t")

drops = c( "Subfamily","Tribe","Genus","Species","CurrentPlacement","Year", "CurrentStatus","Source", "Year", "SubspeciesAuthority", "Subspecies", "SpeciesAuthority" )
invalid = invalid[ , !names(invalid) %in% drops]
invalid$TaxonName = gsub(" ", "\\.", invalid$TaxonName)
invalid$Author = gsub(" ", "\\.", invalid$Author)
colnames(invalid)[2] = "CurrentPlacement"


data$species = gsub("Ooceraea.biroi", "Cerapachys.biroi", data$species)
data$species = gsub("Novomessor.cockerelli", "Aphaenogaster.cockerelli", data$species)
data$species = gsub("Dinoponera.grandis", "Dinoponera.australis", data$species)
data$species = gsub("Myrmicaria.natalensis.eumenoides", "Myrmicaria.natalensis_eumenoides", data$species)


for(i in 1:100){
  
  tree = trees[[i]]
  
  for(j in 1:length(tree$tip.label)){
    
    if(tree$tip.label[j] %in% invalid$TaxonName & !tree$tip.label[j] %in% c("Leptogenys.watsoni", "Leptogenys.minchinii", "Dinoponera.australis")){
      
      print(paste0(i, "   Old: ", tree$tip.label[j], "   ...   New: ", invalid$CurrentPlacement[tree$tip.label[j] == invalid$TaxonName]))
      
      tree$tip.label[j] = invalid$CurrentPlacement[tree$tip.label[j] == invalid$TaxonName]
      
    }
  }
}


species_in_tree = as.data.frame(tree$tip.label)
colnames(species_in_tree) = "species"

## Prune tree

for (i in 1:100){
  tree = trees[[i]]
tree = keep.tip(tree, data$species)
  trees[[i]] = tree}


# ## Identify duplicated species after correcting species names

for (i in 1:100){

    tip = as.data.frame(trees[[i]]$tip.label)
  colnames(tip) = "sp"
  dup_sp = as.data.frame(tip[duplicated( tip$sp),])
  print(dup_sp)
  print(nrow(tip))
  trees[[i]]$tip.label = gsub( pattern = "Cerapachys.biroi", replacement = "Ooceraea.biroi", x = trees[[i]]$tip.label)
  trees[[i]]$tip.label = gsub(pattern =  "Aphaenogaster.cockerelli", replacement = "Novomessor.cockerelli",x =  trees[[i]]$tip.label)
  trees[[i]]$tip.label = gsub( pattern = "Dinoponera.australis",replacement =  "Dinoponera.grandis", x = trees[[i]]$tip.label)
  trees[[i]]$tip.label = gsub( pattern = "Myrmicaria.natalensis_eumenoides",replacement =  "Myrmicaria.natalensis.eumenoides", x = trees[[i]]$tip.label)
  
}





write.tree(trees, file = "/media/meurvill/Elements/re-do_V2/05_100_trees_gamma/00_input_production/output/100_trees_renamed.tre")

c = 0
for ( i in 1:100){
  c = c +1
  write.tree(trees[[i]], paste0("/media/meurvill/Elements/re-do_V2/05_100_trees_gamma/01_input/100_trees/tree_", c, ".tre") )
  write.tree(trees[[i]], paste0("/home/meurvill/Documents/troph_inference/re-do-V2/05_100_trees_gamma/01_input/100_trees/tree_", c, ".tre") )
  
  
}

library(geiger)

c = 0
for ( i in 1:100){
  c = c +1
  tree = rescale(trees[[i]], model = "depth", 0.5)  
  
  write.tree(tree, paste0("/media/meurvill/Elements/re-do_V2/05_100_trees_gamma/01_input/100_trees/tree_", c, "_normalized.tre") )
  write.tree(tree, paste0("/home/meurvill/Documents/troph_inference/re-do-V2/05_100_trees_gamma/01_input/100_trees/tree_", c, "_normalized.tre") )
  
  
}
