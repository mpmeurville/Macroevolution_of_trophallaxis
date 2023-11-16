library(BAMMtools)
require(coda)
require(ape)
library(stringr) 


### Get the pruned tree and the data well formatted. 
tree = read.tree("E:/re-do_V2_Macroevolution/00_dataset_production/output/tree_417.tre")

dat = read.table("E:/re-do_V2_Macroevolution/04_Dtest_417sp_all_traits/input/troph_417.txt", header = T)
colnames(dat) = c("species", "troph")

# plot(tree)
# edgelabels(round(tree$edge.length, 2),bg = F, col="blue", font=.02)
# 
# 
# for(i in 1:length(tree$tip.label)){
# 
#   if(! tree$tip.label[i] %in% dat$species){print(tree$tip.label[i])}
# 
# }


tree$tip.label[tree$tip.label == "Aphaenogaster.cockerelli"] = "Novomessor.cockerelli"

write.tree(tree, "E:/re-do_V2_Macroevolution/08_speciation/BAMM/input/tree_417.tre")

dat$troph[dat$troph == "T"] <- 1
dat$troph[dat$troph == "N"] <- 0


for (i in 1:nrow(dat)){
if(dat$troph[i]== "T"){dat$troph[i]= 1}
if(dat$troph[i]== "N"){dat$troph[i]= 0}
if(dat$troph[i] != 0 & dat$troph[i] != 1){
dat$troph[i] =  strsplit(strsplit(strsplit(dat$troph[i], ",")[[1]][2], ":")[[1]][2], split = "}")[[1]][1]}
}

dat$troph = round(as.numeric(dat$troph))
write.csv(dat, "E:/re-do_V2_Macroevolution/08_speciation/BAMM/input/input_binary.csv", row.names = F)


### Estimate the sampling fraction for each species, genus based. 

valid_sp = read.table("E:/re-do_V2_Macroevolution/08_speciation/BAMM/input/valid_species.txt", sep = "{",header = T)

drops = c( "Tribe", "SpeciesGroup","Species", "Binomial","BinomialAuthority","Subspecies","Trinomial","TrinomialAuthority","Author", "Year","ChangedComb","TypeLocalityCountry")

valid_sp = valid_sp[ , -which(names(valid_sp) %in% drops)]

valid_sp$TaxonName = gsub(" ", "\\.", x = valid_sp$TaxonName)
colnames(valid_sp)[1] = "species"

res = merge(dat, valid_sp, all.x = T, by = "species")
res$prop = NA

for (i in 1:length(unique(res$Genus))){
  
  temp = valid_sp[valid_sp$Genus == unique(res$Genus)[i],] ### Count # sp per genus
  
  res$prop[res$Genus == unique(res$Genus)[i]] = length(res$prop[res$Genus == unique(res$Genus)[i]]) / nrow(temp) # Divide # sp per genus in our dataset by number of species in the genus
  
}

drops = c("Subfamily", "genus", "troph")
res = res[ , -which(names(res) %in% drops)]


write.table(res, "E:/re-do_V2_Macroevolution/08_speciation/BAMM/input/sampling_frac_genus.txt", quote = F, row.names = F, col.names = F, sep = "\t")
# Then,in the file, add 1.0 as the first row. 


### Get the priors for the analysis
setwd("E:/re-do_V2_Macroevolution/08_speciation/BAMM/input")
setBAMMpriors(read.tree("E:/re-do_V2_Macroevolution/00_dataset_production/output/tree_417.tre"))

### check tree is ok

library(ape)
is.ultrametric(tree)
is.binary(tree)

# Now to check min branch length:
min(tree$edge.length)
max(tree$edge.length)

