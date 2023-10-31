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
#div_rates = c(0.2, 0.03) # (Lambda, mu): Lambda = speciation, mu = extinction
#tree = tree.bd( div_rates, max.t=30.0 )

#tree <- read.tree("/home/meurvill/Documents/troph_inference/HiSSE/input/first_tree_consensus_no_thresh_normalized.txt") #415 sp
tree <- read.tree("/home/meurvill/Documents/troph_inference/HiSSE/input/mcc_valid_tree.tre")

# Plot tree
#plot(tree)


#Get trophallaxis data
dat = read.table("/home/meurvill/Documents/troph_inference/HiSSE/input/no_thresh_verified_troph.txt", sep = "\t", header = F)
colnames(dat) = c("species", "troph")

### MODIFY THE TRAIT FILE: MUST BE BINARY.
t <- str_match(dat$troph[1], ":\\s*(.*?)\\s*,")[2]

for (i in 1:nrow(dat)){
  
  if(!is.na(str_match(dat$troph[i], ":\\s*(.*?)\\s*,")[1])){
    print(i)
    Troph =  as.numeric(str_match(dat$troph[i], ":\\s*(.*?)\\s*,")[2])
    No_troph = as.numeric(str_match(dat$troph[i], ",N:\\s*(.*?)\\s*\\}")[2])
    
    if (Troph > No_troph){dat$troph[i] = "T"}
    if (Troph <= No_troph){dat$troph[i] = "N"} ### Diacamma rugosum is 50/50 troph and non-troph. I set to no.
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

combo = combo[match(tree$tip.label, combo$species),]

# For user-specified “root.p”, you should specify the probability for each state. If you are doing a
# hidden model, there will be four states: 0A, 1A, 0B, 1B. So if you wanted to say the root had to be
# state 0, you would specify “root.p = c(0.5, 0, 0.5, 0)”.

#root = c(0.97, 0.03)

turnover <- c(1,1)
extinction.fraction <- c(1,1)
f <- c(1,1)

trans.rates.bisse <-  TransMatMakerHiSSE(hidden.traits=0)
print(trans.rates.bisse)

# dull null” – i.e., turnover and extinction fraction are the same for both states.
dull.null <- hisse(phy=tree, data=combo, f=f, turnover=turnover, 
                   eps=extinction.fraction, hidden.states=FALSE, 
                   trans.rate=trans.rates.bisse)

# dull.null <- hisse(phy=tree, data=combo, f=f, turnover=turnover, 
#                    eps=extinction.fraction, hidden.states=FALSE, 
#                    trans.rate=trans.rates.bisse, root.p = root)


# full_DN_fig <- MarginReconHiSSE(tree, combo, f=f, hidden.states = TRUE, pars = dull.null$solution)
# 
# pdf("/home/meurvill/Documents/troph_inference/HiSSE/Output_all_sp/dull_null_unknown_root.pdf")
# plot_hisse <- plot.hisse.states(full_DN_fig, rate.param = "net.div", show.tip.label = TRUE)
# dev.off()
# 


# Bisse with turnover rate params are unlinked across the observed state combination

turnover <- c(1,2)
extinction.fraction <- c(1,1)

BiSSE <- hisse(phy=tree, data=combo, f=f, turnover=turnover, 
               eps=extinction.fraction, hidden.states=FALSE, 
               trans.rate=trans.rates.bisse)

# BiSSE <- hisse(phy=tree, data=combo, f=f, turnover=turnover, 
#                eps=extinction.fraction, hidden.states=FALSE, 
#                trans.rate=trans.rates.bisse, root.p = root)

# b = MarginReconHiSSE(phy=tree, data=combo, f=f, hidden.states=FALSE, pars = BiSSE$solution )
# plot.hisse.states(b, rate.param = "net.div", type = "fan")

# Setting up a HiSSE model


turnover <- c(1,2,3,4)
extinction.fraction <- rep(1, 4) 
f = c(1,1)
trans.rate.hisse <- TransMatMakerHiSSE(hidden.traits=1)
print(trans.rate.hisse)

HiSSE <- hisse(phy=tree, data=combo, f=f, turnover=turnover, 
               eps=extinction.fraction, hidden.states=TRUE, 
               trans.rate=trans.rate.hisse)

# HiSSE <- hisse(phy=tree, data=combo, f=f, turnover=turnover, 
#                eps=extinction.fraction, hidden.states=TRUE, 
#                trans.rate=trans.rate.hisse, root.p = root)


# h = MarginReconHiSSE(phy=tree, data=combo, f=f, hidden.states=TRUE, pars = HiSSE$solution )
# plot.hisse.states(h, rate.param = "net.div", type = "fan")


# CID-2 : These models explicitly assume that the evolution of a binary character is independent of the diversification process without forcing the diversification process to be constant across the entire tree, which is the normal CID used in these types of analyses.
turnover <- c(1, 1, 2, 2)
extinction.fraction <- rep(1, 4) 
f = c(1,1)
trans.rate <- TransMatMakerHiSSE(hidden.traits=1, make.null=TRUE)

HiSSE_CID_2 <- hisse(phy=tree, data=combo, f=f, turnover=turnover, 
               eps=extinction.fraction, hidden.states=TRUE, 
               trans.rate=trans.rate)

# HiSSE_CID_2 <- hisse(phy=tree, data=combo, f=f, turnover=turnover, 
#                      eps=extinction.fraction, hidden.states=TRUE, 
#                      trans.rate=trans.rate, root.p = root)


# h_CID2 = MarginReconHiSSE(phy=tree, data=combo, f=f, hidden.states=TRUE, pars = HiSSE_CID_2$solution )
# plot.hisse.states(h_CID2, rate.param = "net.div", type = "fan")


# CID-4

#root = c(0.03,0, 0.97, 0, 0, 0, 0, 0)

turnover <- c(1, 1, 2, 2, 3, 3, 4, 4)
extinction.fraction <- rep(1, 8) 
trans.rate <- TransMatMakerHiSSE(hidden.traits=3, make.null=TRUE)

HiSSE_CID_4 <- hisse(phy=tree, data=combo, f=f, turnover=turnover, 
                     eps=extinction.fraction, hidden.states=TRUE, 
                     trans.rate=trans.rate)

# HiSSE_CID_4 <- hisse(phy=tree, data=combo, f=f, turnover=turnover, 
#                      eps=extinction.fraction, hidden.states=TRUE, 
#                      trans.rate=trans.rate, root.p = root)


 h_CID4 = MarginReconHiSSE(phy=tree, data=combo, f=f, hidden.states=TRUE, pars = HiSSE_CID_4$solution )
 plot.hisse.states(h_CID4, rate.param = "net.div", type = "fan")


dull.null$AIC
BiSSE$AIC
HiSSE$AIC
HiSSE_CID_2$AIC
HiSSE_CID_4$AIC

HiSSE_CID_4$AIC - HiSSE_CID_2$AIC
HiSSE_CID_4$AIC - HiSSE$AIC
HiSSE_CID_4$AIC - BiSSE$AIC
HiSSE_CID_4$AIC - dull.null$AIC



save.image("/home/meurvill/Documents/troph_inference/HiSSE/Output_all_sp/all_sp_analysis_unknown_root.RData")


