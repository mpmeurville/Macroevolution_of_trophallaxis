library(BAMMtools)
require(coda)
require(ape)
library(stringr) 


### Get the pruned tree and the data well formated. 
tree = read.tree("/home/meurvill/bamm/MP_analyses/v2/input/consensus_tree.tre")
dat = read.table("/home/meurvill/bamm/MP_analyses/v2/input/no_thresh_verified_troph.txt", header = T)
colnames(dat) = c("species", "troph")

for (i in 1:nrow(dat)){
if(dat$troph[i]== "T"){dat$troph[i]= 1}
if(dat$troph[i]== "N"){dat$troph[i]= 0}
if(dat$troph[i] != 0 & dat$troph[i] != 1){
dat$troph[i] =  strsplit(strsplit(dat$troph[i], ",")[[1]][1], ":")[[1]][2]}
}

dat$troph = round(as.numeric(dat$troph))
write.csv(dat, "/home/meurvill/bamm/MP_analyses/v2/input/input_binary.csv")


### Estimate the sampling fraction for each species, genus based. 

valid_sp = read.table("/home/meurvill/bamm/MP_analyses/v2/input/valid_species.txt", sep= "{", header = T)

drops = c( "Tribe", "SpeciesGroup","Species", "Binomial","BinomialAuthority","Subspecies","Trinomial","TrinomialAuthority","Author", "Year","ChangedComb","TypeLocalityCountry")

valid_sp = valid_sp[ , -which(names(valid_sp) %in% drops)]

valid_sp$TaxonName = gsub(" ", "\\.", x = valid_sp$TaxonName)

res = merge(dat, valid_sp, all.x = T, by = "species")
res$prop = NA

for (i in 1:length(unique(res$Genus))){
  
  temp = valid_sp[valid_sp$Genus == unique(res$Genus)[i],] ### Count # sp per genus
  
  res$prop[res$Genus == unique(res$Genus)[i]] = length(res$prop[res$Genus == unique(res$Genus)[i]]) / nrow(temp) # Devide # sp per genus in our dataset by number of species in the genus
  
}

drops = c("Subfamily", "genus", "troph")
res = res[ , -which(names(res) %in% drops)]

write.table(res, "/home/meurvill/bamm/MP_analyses/v2/input/sampling_frac_genus.txt", quote = F, row.names = F, sep = "\t")

### Get the rpiors for the analysis
setwd("/home/meurvill/bamm/MP_analyses/v2/input")
setBAMMpriors(read.tree("/home/meurvill/bamm/MP_analyses/v2/input/consensus_tree.tre"))

