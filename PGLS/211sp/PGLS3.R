library(ape)

my_tree <- read.tree('/home/marie-pierre/Documents/PhD/communication/trophallaxis_correlation_diet/evolutionnary_analysis/large inputs/053_Dtest_analysis/input/211_sp/consensus_tree.txt') # For Newick format trees

my_data = read.csv("/home/marie-pierre/Documents/PhD/communication/trophallaxis_correlation_diet/evolutionnary_analysis/plot_of_hell/01_not_binarized_nodes/not_binarized_nodes.csv")

my_data <- my_data[is.na(my_data$sp2),]

sp = as.data.frame(my_tree$tip.label)
colnames(sp) = "sp1"

my_data =  merge(sp, my_data, by = "sp1", all.x = T)

rownames(my_data) <- my_data$sp1

drops <- c("X","NodeID", "sp2", "sp1", "Small", "Medium")
my_data = my_data[ , !(names(my_data) %in% drops)]

colnames(my_data) = c("G","S","T","L", "La")

my_data$G = as.factor(my_data$G)
my_data$L = as.factor(my_data$L)
my_data$S = as.factor(my_data$S)
my_data$La = as.factor(my_data$La)




# if (!require("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# 
# BiocManager::install("graph")

library(phylopath)

models <- define_model_set(
  zero = c(),
  one   = c(La ~ T , S ~ T, G ~ T, T ~ L),
  two   = c( La ~ G, S ~ G,  T ~ L, G ~ T),
  three = c(S ~ G, G ~ T, T ~ La, T ~ L),
  four  = c(T ~ S, S ~ La, La ~ G, La ~ L),
  five = c(T ~ S, T ~ L, T ~ G, T ~ La),
  six = c(T ~ L, L ~ S, S ~ La, S ~ G),
  seven = c(La ~ T, S ~T, T ~ G, T ~ L),
  eight = c(L ~ T, La ~ T, G ~ T, T ~ S),
  nine = c(S ~ T, L ~ T, La ~ G, G ~ T)
  # .common = c(LS ~ BM, NL ~ BM, DD ~ NL) # Thins common to all models, basically something known already. Here we have none.
)

models$zero
models$one
models$two
models$three
models$four
models$five
models$six
models$seven
models$eight
models$nine

pdf("/home/marie-pierre/Documents/PhD/communication/trophallaxis_correlation_diet/evolutionnary_analysis/large inputs/07_path_analysis/troph_liq_gam_sting_size/models_tested_PGLS3.pdf")
plot_model_set(models)
dev.off()

### Tried to make the graphs pretty but does no work. Dis it manually
# positions <- data.frame(
#   name = c('Trophallaxis', 'Sugary Liquids', 'Gamergates', 'Large colony', 'Sting'),
#   x = c(3, 1, 2, 4, 5),
#   y = c(1, 2, 2, 2, 2))
# 
# plot_model_set(models, manual_layout = positions)

result <- phylo_path(models, data = my_data, tree = my_tree)
# show_warnings()
# warnings() # Only solution here: https://github.com/lamho86/phylolm/issues/3
result

s <- summary(result)

pdf("/home/marie-pierre/Documents/PhD/communication/trophallaxis_correlation_diet/evolutionnary_analysis/large inputs/07_path_analysis/troph_liq_gam_sting_size/best_models_CICc_pval_PGLS3.pdf")
plot(s)
dev.off()

best_model <- best(result, boot = 500)

plot(best_model)

coef_plot(best_model,error_bar="se",order_by="strength",to=NULL) + ggplot2::coord_flip() # plot the standardized regression coefficient: I guess the values of the coefficients and their standard error.


### Model averaging
average_model <- average(result)
# plot(average_model, algorithm = 'mds', curvature = 0.1) # increase the curvature to avoid overlapping edges
pdf("/home/marie-pierre/Documents/PhD/communication/trophallaxis_correlation_diet/evolutionnary_analysis/large inputs/07_path_analysis/troph_liq_gam_sting_size/averaged_network_PGLS3.pdf")
plot(average_model, type = "color" ,show.legend = T)
dev.off()

pdf("/home/marie-pierre/Documents/PhD/communication/trophallaxis_correlation_diet/evolutionnary_analysis/large inputs/07_path_analysis/troph_liq_gam_sting_size/coeff_reg_CI_PGLS3.pdf")
coef_plot(average_model,error_bar = "ci",order_by="strength",to=NULL) + ggplot2::coord_flip() # plot the standardized regression coefficient: I guess the values of the coefficients and their standard error.
dev.off()

average_model
