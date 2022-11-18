#BAMM Analysis#

require(BAMMtools)
require(coda)
require(ape)

#Change working directory
setwd("/home/meurvill/bamm/MP_analyses/v2/")

#Load tree
tree <- read.tree("input/consensus_tree.nwk")

#import data for the combined trophallaxis trait
troph.traits <- read.csv("input/input_binary.csv", row.names = 1)
#Import data from BAMM run which used control_1.txt
mcmcout <- read.csv("mcmc_out.txt", header = T)

#Plot mcmc
# dev.off()
# plot(mcmcout$logLik ~ mcmcout$generation,pch=19)

#Check for convergence
burnstart <- floor(0.1 * nrow(mcmcout))
postburn <- mcmcout[burnstart:nrow(mcmcout), ]
mcmcout[burnstart:nrow(mcmcout),]

effectiveSize(postburn$logLik)
effectiveSize(postburn$N_shifts)

event <- getEventData(tree, "event_data.txt", burnin = 0.1)

#sort tips into which ones are troph vs. no troph
troph_sorted <- troph.traits[tree$tip.label,]
names(troph_sorted)<-tree$tip.label

sp.with.troph<-as.character(names(troph_sorted)[troph_sorted==1])
sp.wo.troph<-as.character(names(troph_sorted)[troph_sorted==0])

wholetree.noTBAMMpost<-subtreeBAMM(event,tips=sp.wo.troph)
wholetree.TBAMMpost<-subtreeBAMM(event,tips=sp.with.troph)

#retrieve diversification rates for branches that don't use trophallaxis
rateNoTroph <- getCladeRates(wholetree.noTBAMMpost)
cat("whole tree No-troph rate: mean",mean(rateNoTroph$lambda-rateNoTroph$mu),"sd",sd(rateNoTroph$lambda-rateNoTroph$mu))
cat("lamda: mean",mean(rateNoTroph$lambda),"sd",sd(rateNoTroph$lambda)) # lambda: A vector of speciation rates (if applicable), with the i'th rate corresponding to the mean rate from the i'th sample in the posterior
cat("mu: mean",mean(rateNoTroph$mu),"sd",sd(rateNoTroph$mu)) # mu: A vector of extinction rates (if applicable), with the i'th rate corresponding to the mean rate from the i'th sample in the posterior

#retreive diversification rates for branches that are mutualists
rateTroph <- getCladeRates(wholetree.TBAMMpost)
cat("whole tree Troph rate: mean",mean(rateTroph$lambda-rateTroph$mu),"sd",sd(rateTroph$lambda-rateTroph$mu))
cat("lamda: mean",mean(rateTroph$lambda),"sd",sd(rateTroph$lambda)) # lambda: A vector of speciation rates (if applicable), with the i'th rate corresponding to the mean rate from the i'th sample in the posterior
cat("mu: mean",mean(rateTroph$mu),"sd",sd(rateTroph$mu)) # mu: A vector of extinction rates (if applicable), with the i'th rate corresponding to the mean rate from the i'th sample in the posterior

#differences between mutualist and non-mutualist#
cat("mean r1-r0:",mean((rateTroph$lambda-rateTroph$mu)-(rateNoTroph$lambda-rateNoTroph$mu)),"sd",sd((rateTroph$lambda-rateTroph$mu)-(rateNoTroph$lambda-rateNoTroph$mu)))

#STRAPP test
set.seed(1218)
STRAPP <- traitDependentBAMM(event, as.factor(troph_sorted), reps = 10000, rate = "net diversification", return.full = TRUE, method = 'm', logrates = FALSE,
                             two.tailed = TRUE, )
STRAPP$p.value
saveRDS(STRAPP, file="BAMM_STRAPP.rds")
save.image(file = "BAMM_analysis.RData")
