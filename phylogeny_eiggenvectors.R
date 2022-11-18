library(ape)
#install.packages("PVR")
library(PVR)
library(phytools)
library("BoSSA")

babiana.tree <- ape::read.tree(file = "/home/meurvill/Downloads/doi_10.5061_dryad.g579t7k__v1/Dryad_archive/Dryad_archive/15k_all_ant_trees/15k_NCuniform_stem_mcc.tre")

### Trial to get the eigen value for the root

babiana.tree <- bind.tip(babiana.tree, "test", where = 14595)

# pdf("/home/meurvill/Documents/troph_inference/phylo_modified_test.pdf")
# 
# plot(babiana.tree, cex = 0.1, type = "fan" , edge.width = 0.1)
# 
# dev.off()

#generating eigenvectors


decomp <- PVRdecomp(babiana.tree, type = "newick") #produces object of class 'PVR'
label.decomp<-as.data.frame(decomp@phylo$tip.label)
egvec<-as.data.frame(decomp@Eigen$vectors) ##extract eigenvectors
egval<-decomp@Eigen$values #extract eigenvalues
eigPerc<-egval/(sum(egval)) #calculate % of variance
eigPercCum<-t(cumsum(eigPerc)) #cumulated variance
numeigen<-sum(eigPercCum<1) #eigenvectors representing more than 95% variance
egOK<-egvec[,1:numeigen] #only select eigenvectors (columns) representing 95% of variance from the initial table
# Change 'numeigen' on above line to a number if you want to specify number of eigenvectors
eigenTobind<-cbind(label.decomp,egOK) #add names, these are the eigenvectors to merge with trait database
#rename eigenTobind species column so it matches trait dataset species column
names(eigenTobind)[1] <- "species"

eigenTobind$species <- gsub('"', "", eigenTobind$species)
eigenTobind$species <- gsub('\\.', " ", eigenTobind$species)


write.csv(eigenTobind, "/home/meurvill/Documents/troph_inference/eigentobind_100percent_root_test.csv")
