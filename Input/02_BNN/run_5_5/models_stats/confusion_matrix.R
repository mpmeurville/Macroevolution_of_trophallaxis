
files = list.files("E:/re-do_V2/02_BNN/run_5_5/", recursive = T,  pattern = "*_p1_h0_l5_5_s1_binf_1234_pred_mean_pr.txt")
data = read.table("E:/re-do_V2/02_BNN/input/labels_train.txt", header = T)

res = data.frame(matrix(vector(), 10, 8,
                       dimnames=list(c(), c("TP", "TN", "FP", "FN", "Acc", "prec", "rec", "F1"))),
                stringsAsFactors=F)

for ( f in 1:10){

  pred = read.table(paste0("E:/re-do_V2/02_BNN/run_5_5/", files[f]), header = F)
  colnames(pred) = c("species", "NoT", "T" )
  m = merge(data, pred, by = "species", all.y = T)
  m$rounded_p = round(m$T)

  TP = 0
  FP = 0
  TN = 0
  FN = 0

  for (i in 1: nrow(m)){

    if(m$troph_status[i] == 1 & m$rounded_p[i] == 1){TP = TP +1}
    if(m$troph_status[i] == 1 & m$rounded_p[i] == 0){FN = FN +1}
    if(m$troph_status[i] == 0 & m$rounded_p[i] == 1){FP = FP +1}
    if(m$troph_status[i] == 0 & m$rounded_p[i] == 0){TN = TN +1}

  }

  acc = (TP+TN)/(TP+FP+FN+TN)
  prec = TP/(TP+FP)
  rec = TP/(TP+FN)

  F1_score = 2*(prec*rec)/(prec+rec) # Maximizing the F1 score looks to limit both false positives and false negatives as much as possible.

  res$TP[f] = TP
  res$TN[f] = TN
  res$FP[f] = FP
  res$FN[f] = FN
  res$Acc[f] = acc
  res$prec[f] = prec
  res$rec[f] = rec
  res$F1[f] = F1_score

  }

#write.csv(res, "/media/meurvill/Elements/re-do_V2/02_BNN/run_5_5/models_stats/stats_models.csv")

av_acc = mean(res$Acc)
av_prc = mean(res$prec)
av_res = mean(res$rec)
av_F1 = mean(res$F1)

av_TP =mean(res$TP)
av_TN =mean(res$TN)
av_FP =mean(res$FP)
av_FN =mean(res$FN)

# Stats final model
pred = read.table("E:/re-do_V2/02_BNN/run_5_5/final_model_v2/prediction_feature_BNN_Full_p1_h0_l5_5_s1_binf_1234_pred_mean_pr.txt", header = F)
#pred = read.table("/media/meurvill/Elements/re-do_V2/02_BNN/run_5_5/final_model_v2/all_data_BNN_Full_p0_h0_l5_5_s1_b1_1234_pred_mean_pr.txt", header = F)


data = read.table("E:/re-do_V2/02_BNN/input/labels_train.txt", header = T)

colnames(pred) = c("species", "NoT", "T" )
m = merge(data, pred, by = "species", all.y = T)
m$rounded_p = round(m$T)

TP = 0
FP = 0
TN = 0
FN = 0

for (i in 1: nrow(m)){
  
  if(m$troph_status[i] == 1 & m$rounded_p[i] == 1){TP = TP +1}
  if(m$troph_status[i] == 1 & m$rounded_p[i] == 0){FN = FN +1}
  if(m$troph_status[i] == 0 & m$rounded_p[i] == 1){FP = FP +1}
  if(m$troph_status[i] == 0 & m$rounded_p[i] == 0){TN = TN +1}
  
}

acc = (TP+TN)/(TP+FP+FN+TN) 
prec = TP/(TP+FP)
rec = TP/(TP+FN)

F1_score = 2*(prec*rec)/(prec+rec) # Maximizing the F1 score looks to limit both false positives and false negatives as much as possible.


### Check stats from experts

experts = read.csv("D:/re-do_V2/00_dataset_production/input/papers_MA_data_predicted.csv")
experts = experts[, 1:11]


library(dplyr)
library(stringr)


experts = experts %>%
  filter(!grepl('\\*', Riou.Mizuno))

experts$valid_species = gsub(" ", ".", experts$valid_species)
experts$valid_species = str_to_title(experts$valid_species)


experts = experts[rowSums(is.na(experts)) < 10, ]



# Get predictions
data = read.table("D:/re-do_V2/02_BNN/run_5_5/final_model_v2/prediction_feature_BNN_Full_p1_h0_l5_5_s1_binf_1234_pred_mean_pr.txt", header = F )
colnames(data) = c("species", "NoT", "T" )

data$expert = NA

for(i in 1:nrow(experts)){
  for (j in 2:ncol(experts)){
    
    if(!is.na(experts[i, j]) && experts[i, j] == 1){data$expert[data$species == experts$valid_species[i]] = 1}
    if(!is.na(experts[i, j]) && experts[i, j] == 0){data$expert[data$species == experts$valid_species[i]] = 0}
  }
}

data$rounded = round(data$T)


TP = 0
FP = 0
TN = 0
FN = 0

for (i in 1: nrow(data)){
  
  if(data$expert[i] == 1 & data$rounded[i] == 1 & !is.na(data$expert[i])){TP = TP +1}
  if(data$expert[i] == 1 & data$rounded[i] == 0 & !is.na(data$expert[i])){
    
    FN = FN + 1
    print(data$species[i])
    }
  if(data$expert[i] == 0 & data$rounded[i] == 1 & !is.na(data$expert[i])){
    
    FP = FP + 1
    print(data$species[i])
    }
  if(data$expert[i] == 0 & data$rounded[i] == 0 & !is.na(data$expert[i])){TN = TN +1}
  
}

acc = (TP+TN)/(TP+FP+FN+TN) 
prec = TP/(TP+FP)
rec = TP/(TP+FN)

F1_score = 2*(prec*rec)/(prec+rec) # Maximizing the F1 score looks to limit both false positives and false negatives as much as possible.

