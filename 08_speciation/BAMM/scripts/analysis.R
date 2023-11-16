
require(BAMMtools)
require(coda)
require(ape)

### Change working directory
setwd("E:/re-do_V2_Macroevolution/08_speciation/BAMM/")

### Load tree
tree <- read.tree("input/tree_417.tre")

### Import data for the combined trophallaxis trait
troph.traits <- read.csv("input/input_binary.csv", row.names = 1)

library(tidyverse)
#troph.traits <- troph.traits %>% remove_rownames %>% column_to_rownames(var="species")


### Import data from BAMM run
mcmcout <- read.csv("output/non_norm_tree/mcmc_out_ReDo.txt", header = T)

### Check for convergence

burnstart <- floor(0.1 * nrow(mcmcout))
plot(mcmcout$logLik ~ mcmcout$generation,pch=19)

plot(mcmcout$logLik )


postburn <- mcmcout[burnstart:nrow(mcmcout), ]
mcmcout[burnstart:nrow(mcmcout),]
plot(postburn$logLik)

# Get effective sample size (ESS). Should be > 200
effectiveSize(postburn$logLik)
effectiveSize(postburn$N_shifts)

# -> The analysis converged well.

### Create bammdata object.
event <- getEventData(tree, "output/non_norm_tree/event_data_ReDo.txt", burnin = 0.1)

### How many rate shifts?
post_probs <- table(postburn$N_shifts) / nrow(postburn)
names(post_probs)
shift_probs <- summary(event) # shift_probs is a dataframe giving the posterior probabilities of each rate shift count observed during simulation of the posterior.
shift_probs

### Get the rates and parameters for trophallaxers and non-trophallaxers

troph_sorted <- troph.traits[tree$tip.label,]
names(troph_sorted) <- tree$tip.label

sp.with.troph<-as.character(names(troph_sorted)[troph_sorted==1])
sp.wo.troph<-as.character(names(troph_sorted)[troph_sorted==0])

wholetree.noTBAMMpost<-subtreeBAMM(event,tips=sp.wo.troph)
wholetree.TBAMMpost<-subtreeBAMM(event,tips=sp.with.troph)

# Retrieve diversification rates for the whole dataset
allRates <- getCladeRates(event)
cat("whole tree rate: mean",mean(allRates$lambda-allRates$mu),"sd",sd(allRates$lambda-allRates$mu))
cat("lamda: mean",mean(allRates$lambda),"sd",sd(allRates$lambda)) # lambda: A vector of speciation rates (if applicable), with the i'th rate corresponding to the mean rate from the i'th sample in the posterior
cat("mu: mean",mean(allRates$mu),"sd",sd(allRates$mu)) # mu: A vector of extinction rates (if applicable), with the i'th rate corresponding to the mean rate from the i'th sample in the posterior


# Retrieve diversification rates for branches that don't use trophallaxis
rateNoTroph <- getCladeRates(wholetree.noTBAMMpost)
cat("whole tree No-troph rate: mean",mean(rateNoTroph$lambda-rateNoTroph$mu),"sd",sd(rateNoTroph$lambda-rateNoTroph$mu))
cat("lamda: mean",mean(rateNoTroph$lambda),"sd",sd(rateNoTroph$lambda)) # lambda: A vector of speciation rates (if applicable), with the i'th rate corresponding to the mean rate from the i'th sample in the posterior
cat("mu: mean",mean(rateNoTroph$mu),"sd",sd(rateNoTroph$mu)) # mu: A vector of extinction rates (if applicable), with the i'th rate corresponding to the mean rate from the i'th sample in the posterior
quantile(allRates$lambda, c(0.05, 0.95))


# Retrieve diversification rates for branches that use trophallaxis
rateTroph <- getCladeRates(wholetree.TBAMMpost)
cat("whole tree Troph rate: mean",mean(rateTroph$lambda-rateTroph$mu),"sd",sd(rateTroph$lambda-rateTroph$mu))
cat("lamda: mean",mean(rateTroph$lambda),"sd",sd(rateTroph$lambda)) # lambda: A vector of speciation rates (if applicable), with the i'th rate corresponding to the mean rate from the i'th sample in the posterior
cat("mu: mean",mean(rateTroph$mu),"sd",sd(rateTroph$mu)) # mu: A vector of extinction rates (if applicable), with the i'th rate corresponding to the mean rate from the i'th sample in the posterior

# Differences between trophallaxers and no-trophallaxers
cat("mean r1-r0:",mean((rateTroph$lambda-rateTroph$mu)-(rateNoTroph$lambda-rateNoTroph$mu)),"sd",sd((rateTroph$lambda-rateTroph$mu)-(rateNoTroph$lambda-rateNoTroph$mu)))


# plotRateThroughTime(event, ratetype="speciation")
# # For the SAC origin (node 425)
# library(phytools)
# 
# SACRates <- getCladeRates(event, node = findMRCA(tree, c("Monomorium.floricola", "Crematogaster.minutissima")))
# mean(SACRates$lambda) # A bit higher than the rate of the whole phylogeny: expected
# 
# 
# # For the Formicine origin (node 588)
# library(phytools)
# 
# FRates <- getCladeRates(event, node = findMRCA(tree, c("Camponotus.modoc", "Brachymyrmex.depilis")))
# mean(FRates$lambda) # A bit higher than the rate of the whole phylogeny: expected
# 
# # For the Doli origin (node 703)
# library(phytools)
# 
# DRates <- getCladeRates(event, node = findMRCA(tree, c("Iridomyrmex.purpureus", "Nothomyrmecia.macrops")))
# mean(DRates$lambda) # A bit lower than the rate of the whole phylogeny: expected



### STRAPP test
# Assess whether the correlation between the trait and and bamm-estimated speciation, extinction and net-diversification rate is significant, using permutation.

set.seed(1218)

#sort trophallaxis data in the same order as the tree tips and bammdata object
troph_sorted <- troph.traits[tree$tip.label,]
names(troph_sorted) <- tree$tip.label

STRAPP_netD <- traitDependentBAMM(event, as.factor(troph_sorted), reps = 10000, rate = "net diversification", return.full = TRUE, method = 'm', logrates = FALSE,
                                  two.tailed = TRUE )
STRAPP_netD$p.value


STRAPP_Sp <- traitDependentBAMM(event, as.factor(troph_sorted), reps = 10000, rate = "speciation", return.full = TRUE, method = 'm', logrates = FALSE,
                                two.tailed = TRUE )
STRAPP_Sp$p.value


STRAPP_Ex <- traitDependentBAMM(event, as.factor(troph_sorted), reps = 10000, rate = "extinction", return.full = TRUE, method = 'm', logrates = FALSE,
                                two.tailed = TRUE )
STRAPP_Ex$p.value



saveRDS(STRAPP_netD, file="output/non_norm_tree/BAMM_STRAPP_netD_redo.rds")
saveRDS(STRAPP_Sp, file="output/non_norm_tree/BAMM_STRAPP_Sp_redo.rds")
saveRDS(STRAPP_Ex, file="output/non_norm_tree/BAMM_STRAPP_Ex_redo.rds")

save.image(file = "output/non_norm_tree/BAMM_analysis_redo.RData")

