library(ggplot2)

data = read.csv("E:/re-do_V2/02_BNN/run_5_5/final_model_v2/feature_imp.csv")

data$feature_name = gsub(x = data$feature_name, pattern = "block_0", replacement = "GamergatesOvSp")
data$feature_name = gsub(x = data$feature_name, pattern = "block_1", replacement = "Sting")
data$feature_name = gsub(x = data$feature_name, pattern = "block_2", replacement = "Sugary Liquids")
data$feature_name = gsub(x = data$feature_name, pattern = "block_3", replacement = "Phylogeny")
data$feature_name = gsub(x = data$feature_name, pattern = "block_4", replacement = "Colony Size")
data$feature_name = gsub(x = data$feature_name, pattern = "block_5", replacement = "Temperature")
data$feature_name = gsub(x = data$feature_name, pattern = "block_6", replacement = "Humidity")

overall_acc = 93.87 # Full model accuracy on training set


pdf("/media/marie-pierre/Elements/re-do_V2/02_BNN/run_5_5/final_model_v2/feature_permutation/feat_perm_fig.pdf")

ggplot(data = data, aes(y = delta_acc_mean, x = reorder(feature_name, delta_acc_mean))) +
  geom_bar(stat = "identity") +
  geom_errorbar(aes(ymin=delta_acc_mean-delta_acc_std, ymax=delta_acc_mean+delta_acc_std), width=.2,
                position=position_dodge(.9)) +
  coord_flip()

dev.off()
