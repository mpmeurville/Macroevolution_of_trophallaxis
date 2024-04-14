


library(ape)
library(dplyr)


my_tree <- read.tree('D:/re-do_V2_Macroevolution//00_dataset_production/output/tree_212.tre') # For Newick format trees

#my_data = read.csv("/home/marie-pierre/Documents/PhD/communication/trophallaxis_correlation_diet/evolutionnary_analysis/plot_of_hell/01_not_binarized_nodes/not_binarized_nodes.csv")

### 212 sp
cl = read.csv("D:/re-do_V2_Macroevolution//01_Dtest_211sp_all_traits/input/clonal_212.txt", sep = "\t")
colnames(cl)[2] = "cl"
liq = read.csv("D:/re-do_V2_Macroevolution//01_Dtest_211sp_all_traits/input/liq_212.txt", sep = "\t")
colnames(liq)[2] = "liq"
ova = read.csv("D:/re-do_V2_Macroevolution//01_Dtest_211sp_all_traits/input/ova_212.txt", sep = "\t")
colnames(ova)[2] = "ova"
spe = read.csv("D:/re-do_V2_Macroevolution//01_Dtest_211sp_all_traits/input/sperm_212.txt", sep = "\t")
colnames(spe)[2] = "spe"
st = read.csv("D:/re-do_V2_Macroevolution//01_Dtest_211sp_all_traits/input/sting_212.txt", sep = "\t")
colnames(st)[2] = "st"
tro = read.csv("D:/re-do_V2_Macroevolution//01_Dtest_211sp_all_traits/input/troph_212.txt", sep = "\t")
colnames(tro)[2] = "tro"
gam = read.csv("D:/re-do_V2_Macroevolution//01_Dtest_211sp_all_traits/input/GamOvSt_212.txt", sep = "\t")
colnames(gam)[2] = "gam"
siz = read.csv("D:/re-do_V2_Macroevolution//01_Dtest_211sp_all_traits/input/col_212.txt", sep = "\t")
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



###### Only models of interest

models <- define_model_set(
  c = c(tro~g, st~g, l~g, liq~tro), # Conflict hypothesis
  d = c(st ~liq, tro~liq, l~tro + liq, g~g), # Eco opportunism hypothesis
  e = c(l~g + liq, tro~l, st~st), # Colony size first
  f = c(st~g, liq~st, tro~liq, l~l),

  
  .common = NULL # Things common to all models, basically something known already. Here we have none.
)

# models$zero

positions <- data.frame(
  name = c("tro", "liq", "g", "l", "st"),
  x = c(1.5,1.75,1.25,1.5,1.5),
  y = c(2.25, 2.5, 2.5, 2.5, 2.75)
)


pdf("D:/re-do_V2_Macroevolution//03_PGLS_212/output/last_models/5_models_plot.pdf", height = 12, width = 12)
plot_model_set(models, manual_layout = positions, edge_width = 0.5)
dev.off()


result <- phylo_path(models, data = my_data, tree = my_tree)
# show_warnings()
# warnings() # Only solution here : https://github.com/lamho86/phylolm/issues/3
#result

s <- summary(result)
s

pdf("D:/re-do_V2_Macroevolution/03_PGLS_212/output/last_models/5_models_PGLS_barchart.pdf")
plot(s)
dev.off()

### Model averaging

#best_model <- best(result)
#plot(best_model, type = "color" ,show.legend = T, edge_width = .5)



# Check delta CICcs.
average_model <- average(result, cut_off = 2) # Take models with delta CIC < 2. 

av_model_ColTroGam <- average_model

# plot(average_model, algorithm = 'mds', curvature = 0.1) # increase the curvature to avoid overlapping edges
pdf("D:/re-do_V2_Macroevolution//03_PGLS_212/output/last_models/5_models_averaged.pdf")
plot(average_model, type = "color", show.legend = T, edge_width = .5)
dev.off()

pdf("D:/re-do_V2_Macroevolution//03_PGLS_212/output/last_models/5_models_averaged_CI.pdf")
coef_plot(average_model,error_bar = "ci",order_by="strength",to=NULL) + ggplot2::coord_flip() # plot the standardized regression coefficient: I guess the values of the coefficients and their standard error.
dev.off()

average_model

CI_l = average_model$lower
write.csv(CI_l, "D:/re-do_V2_Macroevolution//03_PGLS_212/output/last_models/5_models_av_CI-lower.csv")

CI_u = average_model$upper
write.csv(CI_u, "D:/re-do_V2_Macroevolution//03_PGLS_212/output/last_models/5_models_av_CI-upper.csv")



# Check delta CICcs with no model selection
average_model <- average(result, cut_off = 15) # Take models with delta CIC < 2. 

av_model_ColTroGam <- average_model

# plot(average_model, algorithm = 'mds', curvature = 0.1) # increase the curvature to avoid overlapping edges
pdf("/media/marie-pierre/Elements//re-do_V2_Macroevolution//03_PGLS_212/output/last_models/all_models_CIC15/5_models_averaged.pdf")
plot(average_model, type = "color" ,show.legend = T, edge_width = .5)
dev.off()

pdf("/media/marie-pierre/Elements//re-do_V2_Macroevolution//03_PGLS_212/output/last_models/all_models_CIC15/5_models_averaged_CI.pdf")
coef_plot(average_model,error_bar = "ci",order_by="strength",to=NULL) + ggplot2::coord_flip() # plot the standardized regression coefficient: I guess the values of the coefficients and their standard error.
dev.off()

average_model

CI_l = average_model$lower
write.csv(CI_l, "/media/marie-pierre/Elements//re-do_V2_Macroevolution//03_PGLS_212/output/last_models/all_models_CIC15/5_models_av_CI-lower.csv")

CI_u = average_model$upper
write.csv(CI_u, "/media/marie-pierre/Elements//re-do_V2_Macroevolution//03_PGLS_212/output/last_models/all_models_CIC15/5_models_av_CI-upper.csv")

### Legend

# Load required library
library(ggplot2)

# Define the values for the legend
values_of_interest <- seq(-4, 4, by = 0.1) # Adjust as needed

# Create data for the legend gradient
legend_data <- data.frame(
  x = rep(1, length(values_of_interest)),
  y = values_of_interest
)

# Create the legend plot
legend_plot <- ggplot(legend_data, aes(x, y)) +
  geom_tile(aes(fill = y)) +
  scale_fill_gradientn(colors = c("firebrick", "grey", "navy"),
                       values = scales::rescale(c(0, 0.5, 1)),
                       breaks = values_of_interest) +
  theme_void() +
  theme(legend.position = "none") + # Remove legend
  geom_text(aes(label = round(y, 2)), color = "black", size = 3, hjust = -0.5) + # Add labels
  labs(title = "Legend",
       x = NULL,
       y = NULL)

# Display the legend plot
pdf("output/5_models/legend.pdf")
print(legend_plot)
dev.off()

### Exploratory path analysis
# 
# source("D://re-do_V2_Macroevolution//03_PGLS_212/BEPA.R")
# 
# colnames(my_data)[10:12] = c("ste", "lar", "med") # Rename to avoid some variable names being embeded in other
# 
# 
# 
# # Started at 10h15 - finished at 13h21
# # models_string = get_all_models(c("lar", "g", "tro", "liq", "st"), exclusions = c("liq ~ g", "lar~liq", "lar~g", 
# #                                                                                  "lar~st", "g~liq", "g~lar", "st~lar", 
# #                                                                                  "st~tro", "st~g"))
# 
# models_string = get_all_models(c("lar", "g", "tro", "liq", "st"))
# 
# save(models_string, file = "D://re-do_V2_Macroevolution//03_PGLS_212/models_all_traits.RData")
# #load(file = "D://re-do_V2_Macroevolution/03_PGLS_212/models_all.RData")
# 
# 
# # Now, remove unwanted edges
# 
# ## lar not produced by gam or sting
# 
# models_string = models_string[!grepl(pattern = "g", models_string$lar),]
# models_string = models_string[!grepl(pattern = "st", models_string$lar),]
# 
# ## Liq not produced by gam
# models_string = models_string[!grepl(pattern = "g", models_string$liq),]
# 
# ## Troph not produced by st
# models_string = models_string[!grepl(pattern = "st", models_string$tro),]
# 
# ## Gam not produced by st, liq, large
# models_string = models_string[!grepl(pattern = "st", models_string$g),]
# models_string = models_string[!grepl(pattern = "liq", models_string$g),]
# models_string = models_string[!grepl(pattern = "lar", models_string$g),]
# 
# ## St not produced by large
# 
# models_string = models_string[!grepl(pattern = "lar", models_string$st),]
# 
# 
# 
# 
# # save(models_string, file = "D://re-do_V2/03_PGLS_212/models_all.RData")
# # load(file = "D://re-do_V2/03_PGLS_212/models_all.RData")
# 
# save(models_string, file = "D://re-do_V2_Macroevolution//03_PGLS_212/models_all_traits_reduced.RData")
# load(file = "D://re-do_V2_Macroevolution//03_PGLS_212/models_all_traits_reduced.RData")
# 
# 
# ### models <- define_model_set(string2formula(models_string)) Does not work
# 
# # Started at 13h22- Finished overnight
# models =  strings_to_model_sets(models_string, parallel = T, n_cores = 6)
# 
# 
# save(models, file = "D://re-do_V2_Macroevolution//03_PGLS_212/models_matrix_reduced.RData")
# load(file = "D://re-do_V2_Macroevolution//03_PGLS_212/models_matrix_reduced.RData")
# 
# pdf("D:/re-do_V2_Macroevolution/03_PGLS_212/output/all_models_reduced,pdf", height = 800, width = 800)
# plot_model_set(models)
# dev.off()
# 
# # Started at 9h00 (21.06) - 09:00 (22.06 )
# result <- phylo_path(models, data = my_data, tree = my_tree, btol = 10 )
# save(result, file = "D://re-do_V2_Macroevolution//03_PGLS_212/models_results_reduced.RData")
# load(file = "D://re-do_V2_Macroevolution//03_PGLS_212/models_results_reduced.RData")
# 
# s <- summary(result)
# #s
# save(s, file = "D://re-do_V2_Macroevolution//03_PGLS_212/models_s_reduced.RData")
# load(file = "D://re-do_V2_Macroevolution//03_PGLS_212/models_s_reduced.RData")
# 
# 
# 
# #pdf("D://re-do_V2/03_PGLS_212/output/LScsStLiGaTr_PGLS_barchart.pdf")
# plot(s[1:20,])
# #dev.off()
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
# #pdf("D://re-do_V2/03_PGLS_212/output/av_LScsStLiGaTr_average_best_models.pdf")
# plot(average_model, type = "color" ,show.legend = T, edge_width = .5)
# #dev.off()
# 
# #pdf("D://re-do_V2/03_PGLS_212/output/av_CI_LScsStLiGaTr_PGLS_barchart.pdf")
# coef_plot(average_model,error_bar = "ci",order_by="strength",to=NULL) + ggplot2::coord_flip() # plot the standardized regression coefficient: I guess the values of the coefficients and their standard error.
# #dev.off()
# 
# average_model
# 
# 
# CI_l = average_model$lower
# write.csv(CI_l, "D:/re-do_V2/03_PGLS_212/All_traits_explo_CI-lower.csv")
# 
# CI_u = average_model$upper
# write.csv(CI_u, "D:/re-do_V2/03_PGLS_212/All_traits_explo_CI-upper.csv")

