# RUN tail -n +1 */*modelstat.txt* > modelstat_ML.txt to collect all stats. 

library(data.table)
library(stringr)

path_in = "/home/meurvill/Documents/troph_inference/re-do_v1/01_Dtest_211sp_all_traits/output/01_ML/"
path_out = "/home/meurvill/Documents/troph_inference/re-do_v1/01_Dtest_211sp_all_traits/output/01_ML/"
f = read.table(paste0(path_in, "modelstat_ML.txt"), sep = "\n", stringsAsFactors = F)

### Create output df

res = data.frame(matrix(NA, nrow = nrow(f)/5, ncol = 5))
colnames(res) = c("model", "ln-Maximum_likelihood","AIC", "AICc", "BIC")

mod = 0

for (h in 1:nrow(f)){
  
  if(grepl("==>", as.character(f$V1[h]))){
    mod = mod +1
    ml_name = as.character(f$V1[h])
    print(h)
    t = str_split(as.character(ml_name), pattern = "/")[[1]]
    name = str_split(t, pattern = " ")[[1]][2]
    res$model[mod] = name 
  }
  
  if(grepl("ln-Maximum likelihood", as.character(f$V1[h]))){
    v = as.character(f$V1[h])
    vi = str_split(v, pattern = ": ")[[1]][2]
    res$`ln-Maximum_likelihood`[mod] = vi
  }
  
  if(grepl("AIC:", as.character(f$V1[h]))){
    v = as.character(f$V1[h])
    vi = str_split(v, pattern = ": ")[[1]][2]
    res$AIC[mod] = vi
  }
  
  if(grepl("AICc:", as.character(f$V1[h]))){
    v = as.character(f$V1[h])
    vi = str_split(v, pattern = ": ")[[1]][2]
    res$AICc[mod] = vi
  }
  
  if(grepl("BIC:", as.character(f$V1[h]))){
    v = as.character(f$V1[h])
    vi = str_split(v, pattern = ": ")[[1]][2]
    res$BIC[mod] = vi
  }
}

write.csv (res, paste0(path_out,  "model_stats_clean.csv"), quote = F, row.names = F)


### Extract marginal likelihood results
# 
# f = read.table(paste0(path_in, "marginal_likelihoods.Bayes.txt"), sep = "\n", stringsAsFactors = F)
# 
# 
# res = data.frame(matrix(NA, nrow = nrow(f)/5, ncol = 5))
# colnames(res) = c("model", "Marg_lik")
# 
# mod = 0
# 
# for (h in 1:nrow(f)){
#   
#   if(grepl("==>", as.character(f$V1[h]))){
#     mod = mod +1
#     ml_name = as.character(f$V1[h])
#     print(h)
#     t = str_split(as.character(ml_name), pattern = "/")[[1]]
#     name = str_split(t, pattern = " ")[[1]][2]
#     res$model[mod] = name 
#   }
#   
#   if(grepl("Ln-marginal likelihood for characters ", as.character(f$V1[h]))){
#     v = as.character(f$V1[h])
#     vi = str_split(v, pattern = ": ")[[1]][2]
#     res$Marg_lik[mod] = vi
#   }
#  
# }
# 
# write.csv (res, paste0(path_out,  "Marg_lielihood.Bayes.csv"), quote = F, row.names = F)
