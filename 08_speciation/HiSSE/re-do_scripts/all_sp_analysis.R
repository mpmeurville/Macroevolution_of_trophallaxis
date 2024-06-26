library(diversitree)
library(ape)
library(deSolve)
library(GenSA)
library(subplex)
library(nloptr)
library(hisse)
library(stringr) 


# Tuto here on new Hisse package: https://speciationextinction.info/articles/hisse-new-vignette.html
# https://lukejharmon.github.io/ilhabela/2015/07/05/BiSSE-and-HiSSE/
# https://academic.oup.com/sysbio/article/65/4/583/1753616


# Build tree
# Because of renaming, many species in the Economo tree appear twice or more, which is a problem. We take the decision to rename only the species in our dataset
# in order to be able to identify species with known and imputed trophallaxis. 

#tree <- read.tree("/home/meurvill/Documents/troph_inference/HiSSE/input/first_tree_consensus_no_thresh_normalized.txt") #415 sp

setwd()
tree <- read.tree("/re-do_V2_Macroevolution/00_dataset_production/input/Dryad_archive/15k_all_ant_trees/15k_NCuniform_stem_mcc.tre") # The full ~14000 species tree.
tree$tip.label = gsub(pattern = "_", replacement = "\\.", x = tree$tip.label)
sp_in_tree = as.data.frame(tree$tip.label)


#Get trophallaxis data
dat = read.table("D:/re-do_V2_Macroevolution/04_Dtest_417sp_all_traits/input/troph_417.txt", sep = "\t", header = T)
colnames(dat) = c("species", "troph")


# Identify sp in dataset not in tree inval

for( i in 1:nrow(dat)){
  
  if(!dat$species[i] %in% sp_in_tree$`tree$tip.label`){
    
    print(dat$species[i])

  }
  
}

dat$species[dat$species == "Dinoponera.grandis"] = "Dinoponera.australis"
dat$species[dat$species == "Ooceraea.biroi"] = "Carapachys.biroi"
dat$species[dat$species == "Novomessor.cockerelli"] = "Aphaenogaster.cockerelli"


### MODIFY THE TRAIT FILE: MUST BE BINARY.
t <- str_match(dat$troph[1], ":\\s*(.*?)\\s*,")[2]

for (i in 1:nrow(dat)){
  
  if(!is.na(str_match(dat$troph[i], ":\\s*(.*?)\\s*,")[1])){
    print(i)
    No_troph =  as.numeric(str_match(dat$troph[i], ":\\s*(.*?)\\s*,")[2])
    Troph = as.numeric(str_match(dat$troph[i], ",T:\\s*(.*?)\\s*\\}")[2])
    
    if (Troph > No_troph){dat$troph[i] = "T"}
    if (Troph < No_troph){dat$troph[i] = "N"} 
  }
  
}

dat$troph[dat$troph == "T"] <- 1
dat$troph[dat$troph == "N"] <- 0


### Get species names from tree
t = as.data.frame(tree$tip.label)


### Merge tree species and data together
colnames(t) = "species"
combo = merge(t, dat, by = "species", all=T)
row.names(combo) = combo$species
combo$troph = as.numeric(combo$troph)
for (i in 1: nrow(combo)){
  if(is.na(combo$troph[i])){combo$troph[i] = 2}
  
}

combo = combo[match(tree$tip.label, combo$species),] # Ordering the data in the same order than tree

# For user-specified “root.p”, you should specify the probability for each state. If you are doing a
# hidden model, there will be four states: 0A, 1A, 0B, 1B. So if you wanted to say the root had to be
# state 0, you would specify “root.p = c(0.5, 0, 0.5, 0)”.

root = c(0.91, 0.08) # Taken from root node for trophallaxis on ASR417 sp

######## BiSSE dull.null ########
# turnover and extinction fraction are the same for both states

turnover <- c(1,1)
extinction.fraction <- c(1,1) 
f <- c(1,1) # Here we state to 1 because we use the whole phylogeny, with a third variable unknown being 2. We can't know how much of the data we have for each state of the trait. 

trans.rates.bisse <-  TransMatMakerHiSSE(hidden.traits=0)
print(trans.rates.bisse)

# dull null” – i.e., turnover and extinction fraction are the same for both states.
# dull.null <- hisse(phy=tree, data=combo, f=f, turnover=turnover, 
#                    eps=extinction.fraction, hidden.states=FALSE, 
#                    trans.rate=trans.rates.bisse)

# dull.null <- hisse(phy=tree, data=combo, f=f, turnover=turnover,
#                    eps=extinction.fraction, hidden.states=FALSE,
#                    trans.rate=trans.rates.bisse, root.p = root)
# 
# 
# save.image("re-do_V2_Macroevolution/08_speciation/HiSSE/Output_all_sp/all_sp_analysis_DefinedRoot_redo_dull.null_model.RData")
# 


####### BiSSE ########
# True Bisse Model where there is no hidden state, but the turnover rate parameters are unlinked
# across the observed state combinations.


turnover <- c(1,2)
extinction.fraction <- c(1,1)
f <- c(1,1) # Here we state to 1 because we use the whole phylogeny, with a third variable unknown being 2. We can't know how much of the data we have for each state of the trait. 

trans.rates.bisse <-  TransMatMakerHiSSE(hidden.traits=0)
print(trans.rates.bisse)

# BiSSE <- hisse(phy=tree, data=combo, f=f, turnover=turnover,
#                eps=extinction.fraction, hidden.states=FALSE,
#                trans.rate=trans.rates.bisse, root.p = root)
# 
# save.image("re-do_V2_Macroevolution/08_speciation/HiSSE/Output_all_sp/all_sp_analysis_DefinedRoot_redo_BISSE.null_model.RData")


######## HiSSE character dependant ########


turnover <- c(1,2,3,4)
extinction.fraction <- rep(1, 4) 
f = c(1,1)
trans.rate.hisse <- TransMatMakerHiSSE(hidden.traits=1)
print(trans.rate.hisse)

# HiSSE <- hisse(phy=tree, data=combo, f=f, turnover=turnover,
#                eps=extinction.fraction, hidden.states=TRUE,
#                trans.rate=trans.rate.hisse, root.p = root)
# 
# save.image("re-do_V2_Macroevolution/08_speciation/HiSSE/Output_all_sp/all_sp_analysis_DefinedRoot_redo_HiSSE.dependant_model.RData")

######## HiSSE character INdependant ########

# CID-2 : These models explicitly assume that the evolution of a binary character is independent of the diversification process without forcing the diversification process to be constant across the entire tree, which is the normal CID used in these types of analyses.
turnover <- c(1, 1, 2, 2)
extinction.fraction <- rep(1, 4) 
f = c(1,1)
trans.rate <- TransMatMakerHiSSE(hidden.traits=1, make.null=TRUE)
print(trans.rate)

# 
# HiSSE_CID_2 <- hisse(phy=tree, data=combo, f=f, turnover=turnover,
#                      eps=extinction.fraction, hidden.states=TRUE,
#                      trans.rate=trans.rate, root.p = root)
# save.image("re-do_V2_Macroevolution/08_speciation/HiSSE/Output_all_sp/all_sp_analysis_DefinedRoot_redo_HiSSE.CID-2_model.RData")


######## HiSSE character INdependant ########
# 
# # CID-4 : These models explicitly assume that the evolution of a binary character is independent of the diversification process without forcing the diversification process to be constant across the entire tree, which is the normal CID used in these types of analyses.
# turnover <- c(1, 1, 2, 2, 3, 3, 4, 4)
# extinction.fraction <- rep(1, 8) 
# f = c(1,1)
# trans.rate <- TransMatMakerHiSSE(hidden.traits=3, make.null=TRUE)
# print(trans.rate)
# 
# 
# HiSSE_CID_4 <- hisse(phy=tree, data=combo, f=f, turnover=turnover,
#                      eps=extinction.fraction, hidden.states=TRUE,
#                      trans.rate=trans.rate, root.p = root)
# save.image("re-do_V2_Macroevolution/08_speciation/HiSSE/Output_all_sp/all_sp_analysis_DefinedRoot_redo_HiSSE.CID-4_model.RData")
# 
# 

dull.null$AIC
BiSSE$AIC
HiSSE$AIC
HiSSE_CID_2$AIC
# HiSSE_CID_4$AIC


# Eps = death / birth = extinction fraction
# Tau = birth + death = net turnover

res = as.data.frame(HiSSE$solution )

res = as.data.frame(HiSSE_CID_2$solution )


HiSSE$AIC - HiSSE_CID_2$AIC
HiSSE$AIC - BiSSE$AIC
HiSSE$AIC - dull.null$AIC


 
h_HISSE = MarginReconHiSSE(phy=tree, data=combo, f=f, hidden.states=TRUE, pars = HiSSE$solution )
#plot.hisse.states(h_HISSE, rate.param = "net.div", type = "fan")

