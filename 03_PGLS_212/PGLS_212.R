


library(ape)
library(dplyr)


my_tree <- read.tree('E://re-do_V2_Macroevolution//00_dataset_production/output/tree_212.tre') # For Newick format trees

#my_data = read.csv("/home/marie-pierre/Documents/PhD/communication/trophallaxis_correlation_diet/evolutionnary_analysis/plot_of_hell/01_not_binarized_nodes/not_binarized_nodes.csv")

### 212 sp
cl = read.csv("E://re-do_V2_Macroevolution//01_Dtest_211sp_all_traits/input/clonal_212.txt", sep = "\t")
colnames(cl)[2] = "cl"
liq = read.csv("E://re-do_V2_Macroevolution//01_Dtest_211sp_all_traits/input/liq_212.txt", sep = "\t")
colnames(liq)[2] = "liq"
ova = read.csv("E://re-do_V2_Macroevolution//01_Dtest_211sp_all_traits/input/ova_212.txt", sep = "\t")
colnames(ova)[2] = "ova"
spe = read.csv("E://re-do_V2_Macroevolution//01_Dtest_211sp_all_traits/input/sperm_212.txt", sep = "\t")
colnames(spe)[2] = "spe"
st = read.csv("E://re-do_V2_Macroevolution//01_Dtest_211sp_all_traits/input/sting_212.txt", sep = "\t")
colnames(st)[2] = "st"
tro = read.csv("E://re-do_V2_Macroevolution//01_Dtest_211sp_all_traits/input/troph_212.txt", sep = "\t")
colnames(tro)[2] = "tro"
gam = read.csv("E://re-do_V2_Macroevolution//01_Dtest_211sp_all_traits/input/GamOvSt_212.txt", sep = "\t")
colnames(gam)[2] = "gam"
siz = read.csv("E://re-do_V2_Macroevolution//01_Dtest_211sp_all_traits/input/col_212.txt", sep = "\t")
colnames(siz)[2] = "siz"


# Binarize tri-states traits
library(reshape2)
s = unique(siz)
g = unique(gam)

siz = dcast(s, formula = X212 ~ siz, fun.aggregate = length)
colnames(siz) = c("X212", "l", "m", "sm")

gam = dcast(g, formula = X212 ~ gam, fun.aggregate = length)
colnames(gam) = c("X212", "g", "r", "s")


# Merge all traits in one df
my_data = merge(cl, liq, by = "X212")
my_data = merge(my_data, ova, by = "X212")
my_data = merge(my_data, spe, by = "X212")
my_data = merge(my_data, st, by = "X212")
my_data = merge(my_data, tro, by = "X212")
my_data = merge(my_data, gam, by = "X212")
my_data = merge(my_data, siz, by = "X212")

colnames(my_data)[1] = "sp1"

rownames(my_data) <- my_data$sp1

my_data$cl = as.factor(my_data$cl)
my_data$liq = as.factor(my_data$liq)
my_data$ova = as.factor(my_data$ova)
my_data$spe = as.factor(my_data$spe)
my_data$st = as.factor(my_data$st)
my_data$s = as.factor(my_data$s)
my_data$r = as.factor(my_data$r)
my_data$g = as.factor(my_data$g)
my_data$sm = as.factor(my_data$sm)
my_data$m = as.factor(my_data$m)
my_data$l = as.factor(my_data$l)

#my_data$troph = as.factor(my_data$troph)


# 
# if (!require("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# 
# BiocManager::install("graph")

library(phylopath)


my_data$cl = gsub(pattern = "N", replacement = "0", x = my_data$cl)
my_data$cl = gsub(pattern = "C", replacement = "1", x = my_data$cl)

my_data$liq = gsub(pattern = "N", replacement = "0", x = my_data$liq)
my_data$liq = gsub(pattern = "L", replacement = "1", x = my_data$liq)

my_data$ova = gsub(pattern = "N", replacement = "0", x = my_data$ova)
my_data$ova = gsub(pattern = "O", replacement = "1", x = my_data$ova)

my_data$spe = gsub(pattern = "N", replacement = "0", x = my_data$spe)
my_data$spe = gsub(pattern = "U", replacement = "1", x = my_data$spe)

my_data$st = gsub(pattern = "N", replacement = "0", x = my_data$st)
my_data$st = gsub(pattern = "S", replacement = "1", x = my_data$st)

my_data$tro = gsub(pattern = "N", replacement = "0", x = my_data$tro)
my_data$tro = gsub(pattern = "T", replacement = "1", x = my_data$tro)


# ### PGLS few traits by hypothesis ###
# 
# # 1: test the hypothesis that small colony size comes from gamergates which refrains troph
# 
# 
# models <- define_model_set(
#   one = c(sm~g, tro~g),
#   two = c(g~sm, tro~g),
#   three = c(sm~g, tro~sm),
#   four = c(sm~tro, g~tro),
#   .common = NULL # Things common to all models, basically something known already. Here we have none.
# )
# 
# # models$zero
# 
# positions <- data.frame(
#   name = c("sm", "tro", "g"),
#   x = c(1,1,1),
#   y = c(3,2, 1 )
# )
# 
# 
# pdf("E://re-do_V2_Macroevolution//03_PGLS_212/output/model_plot_ScsTG.pdf", height = 12, width = 12)
# plot_model_set(models, manual_layout = positions, edge_width = 0.5)
# dev.off()
# 
# 
# result <- phylo_path(models, data = my_data, tree = my_tree, btol = 10)
# # show_warnings()
# # warnings() # Only solution hermedia/marie-pierre/Elements https://github.com/lamho86/phylolm/issues/3
# #result
# 
# s <- summary(result)
# s
# pdf("D://re-do_V2/03_PGLS_212/output/ScsTG_PGLS_barchart.pdf")
# plot(s)
# dev.off()
# 
# ### Model averaging
# 
# # Check delta CICcs.
# #average_model <- average(result, cut_off = 6) # Take all non signif. models. 
# average_model <- average(result, cut_off = 2) # Take models with delta CIC < 2. 
# #average_model <- average(result, cut_off =  10.6298) # Take models with delta CIC < 10. 
# 
# av_model_ColTroGam <- average_model
# 
# # plot(average_model, algorithm = 'mds', curvature = 0.1) # increase the curvature to avoid overlapping edges
# pdf("D://re-do_V2/03_PGLS_212/output/av_ScsTG_average_best_models.pdf")
# plot(average_model, type = "color" ,show.legend = T, edge_width = .5)
# dev.off()
# 
# pdf("D://re-do_V2/03_PGLS_212/output/av_CI_ScsTG_PGLS_barchart.pdf")
# coef_plot(average_model,error_bar = "ci",order_by="strength",to=NULL) + ggplot2::coord_flip() # plot the standardized regression coefficient: I guess the values of the coefficients and their standard error.
# dev.off()
# 
# average_model
# 
# CI_l = average_model$lower
# write.csv(CI_l, "D://re-do_V2/03_PGLS_212/output/ScsTG_PGLS_averaged_CI-lower.csv")
# 
# CI_u = average_model$upper
# write.csv(CI_u, "D://re-do_V2/03_PGLS_212/output/ScsTG_PGLS_averaged_CI-upper.csv")
# 
# 
# 
# # 2: liquid food promotes trophallaxis, then loss of sting and large colony sizes
# 
# models <- define_model_set(
#   one = c(tro~liq, l~tro, st~tro),
#   two = c(tro~st + liq, l~tro),
#   three = c(tro~l + liq+ st),
#   four = c(l~liq, tro~l, st~liq),
#   five = c(l~liq, tro~l, st~tro),
#   six = c(tro~liq, l~tro, st~liq),
#   seven = c(liq~tro, l~tro, st~liq),
#   
#   .common = NULL # Things common to all models, basically something known already. Here we have none.
# )
# 
# # models$zero
# 
# positions <- data.frame(
#   name = c("l", "tro", "liq", "st"),
#   x = c(0.5,1, 1, 1.5),
#   y = c(1,2, 3,1 )
# )
# 
# 
# pdf("D://re-do_V2/03_PGLS_212/output/model_plot_LcsLTS.pdf", height = 12, width = 12)
# plot_model_set(models, manual_layout = positions, edge_width = 0.5)
# dev.off()
# 
# 
# result <- phylo_path(models, data = my_data, tree = my_tree, btol = 10)
# # show_warnings()
# # warnings() # Only solution hermedia/marie-pierre/Elements https://github.com/lamho86/phylolm/issues/3
# #result
# 
# s <- summary(result)
# s
# pdf("D://re-do_V2/03_PGLS_212/output/LcsLTS_PGLS_barchart.pdf")
# plot(s)
# dev.off()
# 
# 
# ### Model averaging
# 
# # Check delta CICcs.
# #average_model <- average(result, cut_off = 6) # Take all non signif. models. 
# average_model <- average(result, cut_off = 2) # Take models with delta CIC < 2. 
# #average_model <- average(result, cut_off =  10.6298) # Take models with delta CIC < 10. 
# 
# av_model_LiqColTroSti <- average_model
# 
# # plot(average_model, algorithm = 'mds', curvature = 0.1) # increase the curvature to avoid overlapping edges
# pdf("D://re-do_V2/03_PGLS_212/output/av_LcsLTS_average_best_models.pdf")
# plot(average_model, type = "color" ,show.legend = T, edge_width = .5)
# dev.off()
# 
# pdf("D://re-do_V2/03_PGLS_212/output/av_CI_LcsLTS_PGLS_barchart.pdf")
# coef_plot(average_model,error_bar = "ci",order_by="strength",to=NULL) + ggplot2::coord_flip() # plot the standardized regression coefficient: I guess the values of the coefficients and their standard error.
# dev.off()
# 
# average_model
# CI_l = average_model$lower
# write.csv(CI_l, "D://re-do_V2/03_PGLS_212/output/LcsLTS_PGLS_averaged_CI-lower.csv")
# 
# CI_u = average_model$upper
# write.csv(CI_u, "D://re-do_V2/03_PGLS_212/output/LcsLTS_PGLS_averaged_CI-upper.csv")
# 
# 
# # 3: test worker sterility relationship with trophallaxis: what is the role of worker sterility or totipotency?
# 
# models <- define_model_set(
#   one = c(s~r, r~g + tro + cl),
#   two = c(g~r, cl~r, s~r, r~tro),
#   three = c(tro~r, cl~tro, s~r, r~g),
#   four = c(tro~r, cl~tro, s~r, g~r),
#   five = c(tro~g, cl ~tro, cl ~tro, r~tro, s~r),
#   six = c(g~tro, r~g, s~r, cl~r),
#   seven = c(tro~g, r~tro, s~tro, cl~tro),
#   eight = c(g~r, cl~tro, s~r, r~tro),
#   nine = c(tro~r, r~cl, s~r, r~g),
#   ten = c(tro~g, r~tro, s~tro, tro~cl),
#   eleven = c(s~r, r~g + tro, cl~tro),
#   twelve = c(tro~g, r~tro, s~tro, cl~r),
#   thirteen = c(g~tro, s~tro, r~tro, cl~tro),
#   
#   .common = NULL # Things common to all models, basically something known already. Here we have none.
# )
# 
# positions <- data.frame(
#   name = c("g", "r", "s", "tro", "cl"),
#   x = c(0.5,1,1, 1.5, 1.5),
#   y = c(3, 2, 1, 3, 2)
# )
# 
# pdf("D://re-do_V2/03_PGLS_212/output/model_plot_SRGTCl.pdf", height = 12, width = 12)
# plot_model_set(models, manual_layout = positions, edge_width = 0.5)
# dev.off()
# 
# 
# result <- phylo_path(models, data = my_data, tree = my_tree, btol = 10)
# # show_warnings()
# # warnings() # Only solution hermedia/marie-pierre/Elements https://github.com/lamho86/phylolm/issues/3
# #result
# 
# s <- summary(result)
# s
# pdf("D://re-do_V2/03_PGLS_212/output/SRGTCl_PGLS_barchart.pdf")
# plot(s)
# dev.off()
# 
# ### Model averaging
# 
# # Check delta CICcs.
# #average_model <- average(result, cut_off = 6) # Take all non signif. models. 
# average_model <- average(result, cut_off = 2) # Take models with delta CIC < 2. 
# #average_model <- average(result, cut_off =  10.6298) # Take models with delta CIC < 10. 
# 
# 
# # plot(average_model, algorithm = 'mds', curvature = 0.1) # increase the curvature to avoid overlapping edges
# pdf("D://re-do_V2/03_PGLS_212/output/av_SRGTCl_average_best_models.pdf")
# plot(average_model, type = "color" ,show.legend = T, edge_width = .5)
# dev.off()
# 
# pdf("D://re-do_V2/03_PGLS_212/output/av_CI_SRGTCl_PGLS_barchart.pdf")
# coef_plot(average_model,error_bar = "ci",order_by="strength",to=NULL) + ggplot2::coord_flip() # plot the standardized regression coefficient: I guess the values of the coefficients and their standard error.
# dev.off()
# 
# average_model
# 
# CI_l = average_model$lower
# write.csv(CI_l, "D://re-do_V2/03_PGLS_212/output/SRGTCl_PGLS_averaged_CI-lower.csv")
# 
# CI_u = average_model$upper
# write.csv(CI_u, "D://re-do_V2/03_PGLS_212/output/SRGTCl_PGLS_averaged_CI-upper.csv")
# 
# 
# ### Scale
# # Load the necessary library
# library(ggplot2)
# 
# # Define the range and tick locations
# min_value <- -3.50
# max_value <- 3.50
# tick_locations <- c(-3.43, -0.29, -2.99, -0.69, 0.09, 0.57, 1.09, 1.17, 
#                     0.35, -0.37, 1.18, -0.69, -0.44, 0.65, -0.14, 0.73, -0.64, -1.03)
# 
# # Create a sequence of numbers within the range
# gradient <- seq(min_value, max_value, by = 0.01)  # Adjust the by value for smoother gradient
# 
# # Square each number in the gradient
# squared_gradient <- gradient^2
# 
# # Create a data frame for the plot
# data <- data.frame(Gradient = gradient, Squared_Gradient = squared_gradient)
# 
# # Create the plot using ggplot2
# ggplot(data, aes(x = Gradient, y = Squared_Gradient)) +
#   geom_line(aes(color = Gradient), size = 5) +
#   scale_color_gradient2(low = "red", mid = "white", high = "blue", midpoint = 0) +
#   labs(x = "Gradient", y = "Squared Gradient", title = "Squared Gradient") +
#   theme_minimal() +
#   theme(legend.position = "none", axis.text.x = element_text(angle = 90, hjust = 1)) +
#   scale_x_continuous(breaks = tick_locations)
# # 
# 
# 
# ### Plot our models together
# 
# av_model_ColTroGam
# av_model_LiqColTroSti
# 
# 
# # plot(average_model, algorithm = 'mds', curvature = 0.1) # increase the curvature to avoid overlapping edges
# plot(av_model_ColTroGam, type = "color" ,show.legend = T, edge_width = .5)
# plot(av_model_LiqColTroSti, type = "color" ,show.legend = T, edge_width = .5)
# 


###### All traits of interest

models <- define_model_set(
  one = c(tro~g+liq, l~tro, liq~st),
  two = c(tro~g+liq, l~tro, st~liq),
  three = c(tro~g+liq+l, liq~st), 
  four = c(tro~g+liq+l, st~liq),
  five = c(tro~g, l~tro, liq~tro, st~liq),
  six = c(tro~g, l~tro, liq~tro+st),
  seven = c(tro~g+l, liq~tro, st~liq),
  eight = c(tro~g +l, liq~tro+st),
  nine = c(tro~g, st~g, liq~tro, l~tro),
  ten = c(tro~g + liq, st~g, l~tro),
  eleven = c(tro~g+l, liq~tro, st~g),
  #twelve = c(tro~g+l+liq, st~g),  # Removed because when in, weird error. If we comment three or four, it also solves the pb, but twelve is less likely?
  Bone = c(tro~liq, g~tro, l~tro, liq~st),
  Btwo = c(tro~liq, g~tro, l~tro, st~liq),
  Bthree = c(tro~liq+l, g~tro,liq~st),
  Bfour = c(tro~liq+l, g~tro, st~liq),
  Bfive = c(g~tro, l~tro, liq~tro, st~liq),
  Bsix = c(g~tro, l~tro, liq~tro+st),
  Bseven = c(tro~l, g~tro, liq~tro, st~liq),
  Beight = c(tro~l,g~tro, liq~tro+st),
  Bnine = c(g~tro, st~g, liq~tro, l~tro),
  Bten = c(tro~ liq, g~tro, st~g, l~tro),
  Beleven = c(tro~l, g~tro,liq~tro, st~g),
  Btwelve = c(tro~l+liq, g~tro,st~g),
  
  
  
  .common = NULL # Things common to all models, basically something known already. Here we have none.
)

# models$zero

positions <- data.frame(
  name = c("tro", "liq", "g", "l", "st"),
  x = c(1.5,1.75,1.25,1.5,1.5),
  y = c(2.25, 2.5, 2.5, 2.5, 2.75)
)


pdf("E://re-do_V2_Macroevolution//03_PGLS_212/output/all_model_plot.pdf", height = 12, width = 12)
plot_model_set(models, manual_layout = positions, edge_width = 0.5)
dev.off()


result <- phylo_path(models, data = my_data, tree = my_tree)
# show_warnings()
# warnings() # Only solution here : https://github.com/lamho86/phylolm/issues/3
#result

s <- summary(result)
s

pdf("E://re-do_V2_Macroevolution/03_PGLS_212/output/all_PGLS_barchart.pdf")
plot(s)
dev.off()

### Model averaging

# Check delta CICcs.
average_model <- average(result, cut_off = 2) # Take models with delta CIC < 2. 

av_model_ColTroGam <- average_model

# plot(average_model, algorithm = 'mds', curvature = 0.1) # increase the curvature to avoid overlapping edges
pdf("E://re-do_V2_Macroevolution//03_PGLS_212/output/av_all_average_best_models.pdf")
plot(average_model, type = "color" ,show.legend = T, edge_width = .5)
dev.off()

pdf("E://re-do_V2_Macroevolution//03_PGLS_212/output/av_CI_all_PGLS_barchart.pdf")
coef_plot(average_model,error_bar = "ci",order_by="strength",to=NULL) + ggplot2::coord_flip() # plot the standardized regression coefficient: I guess the values of the coefficients and their standard error.
dev.off()

average_model

CI_l = average_model$lower
write.csv(CI_l, "E://re-do_V2_Macroevolution//03_PGLS_212/output/all_PGLS_averaged_CI-lower.csv")

CI_u = average_model$upper
write.csv(CI_u, "E://re-do_V2_Macroevolution//03_PGLS_212/output/all_PGLS_averaged_CI-upper.csv")






















### Exploratory path analysis

source("D://re-do_V2/03_PGLS_212/BEPA.R")

colnames(my_data)[10:12] = c("ste", "lar", "med") # Rename to avoid some variable names being embeded in other

# Started at 10h15 - finished at 13h21
#models_string = get_all_models(c("lar", "sm", "g", "tro", "liq", "st"), exclusions = c("lar ~ sm", 
#                                                                                       "sm ~ lar")) # Do not consider associations of small and large colony sizes for example

# save(models_string, file = "D://re-do_V2/03_PGLS_212/models_all.RData")
load(file = "D://re-do_V2/03_PGLS_212/models_all.RData")


#models <- define_model_set(string2formula(models_string))

# Started at 13h22- Finished overnight
#models =  strings_to_model_sets(models_string, parallel = T, n_cores = 6)


# save(models, file = "D://re-do_V2/03_PGLS_212/models_matrix.RData")
load(file = "D://re-do_V2/03_PGLS_212/models_matrix.RData")

#plot_model_set(models, manual_layout = positions, edge_width = 0.5)

# Started at 9h00 (21.06) - 09:00 (22.06 )
#result <- phylo_path(models, data = my_data, tree = my_tree, btol = 10 )
#save(result, file = "D://re-do_V2/03_PGLS_212/models_results.RData")
load(file = "D://re-do_V2/03_PGLS_212/models_results.RData")

s <- summary(result)
#s
save(s, file = "D://re-do_V2/03_PGLS_212/models_s.RData")
#load(file = "D://re-do_V2/03_PGLS_212/models_s.RData")



#pdf("D://re-do_V2/03_PGLS_212/output/LScsStLiGaTr_PGLS_barchart.pdf")
plot(s[1:20,])
#dev.off()

### Model averaging

# Check delta CICcs.
#average_model <- average(result, cut_off = 6) # Take all non signif. models. 
average_model <- average(result, cut_off = 2) # Take models with delta CIC < 2. 
#average_model <- average(result, cut_off =  10.6298) # Take models with delta CIC < 10. 


# plot(average_model, algorithm = 'mds', curvature = 0.1) # increase the curvature to avoid overlapping edges
#pdf("D://re-do_V2/03_PGLS_212/output/av_LScsStLiGaTr_average_best_models.pdf")
plot(average_model, type = "color" ,show.legend = T, edge_width = .5)
#dev.off()

#pdf("D://re-do_V2/03_PGLS_212/output/av_CI_LScsStLiGaTr_PGLS_barchart.pdf")
coef_plot(average_model,error_bar = "ci",order_by="strength",to=NULL) + ggplot2::coord_flip() # plot the standardized regression coefficient: I guess the values of the coefficients and their standard error.
#dev.off()

average_model


CI_l = average_model$lower
write.csv(CI_l, "D:/re-do_V2/03_PGLS_212/All_traits_explo_CI-lower.csv")

CI_u = average_model$upper
write.csv(CI_u, "D:/re-do_V2/03_PGLS_212/All_traits_explo_CI-upper.csv")

