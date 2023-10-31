# In the terminal:  tail */*/*marginal.likelihood.txt> marg_likelihood.txt

data <- read.table("/media/marie-pierre/Elements/re-do_V2/05_100_trees_gamma/output/marg_lik.txt", sep = "{")

library(data.table)
library(stringr)

path_in = "Downloads/"
path_out = path_in

### Create output df

res = data.frame(matrix(NA, nrow = 20000, ncol = 7))
colnames(res) = c("tree", "trait", "model", "marginal_likelihood", "num", "den", "weight")

mod = 0

for (h in 1:nrow(data)){
  
  if(grepl("==>", as.character(data$V1[h]))){
    mod = mod +1
    ml_name = as.character(data$V1[h])
    print(h)
    res$model[mod] = str_split(as.character(ml_name), pattern = "/")[[1]][2]
    res$tree[mod] = str_split(str_split(as.character(ml_name), pattern = "/")[[1]][1], pattern = " ")[[1]][2]
    res$model = gsub(pattern = "\\_", replacement = "\\.", res$model)
    res$trait[mod] = str_split(res$model[mod], pattern = "\\.")[[1]][1]
  }
  
  if(grepl("Overall ln-marginal likelihood", as.character(data$V1[h]))){
    v = as.character(data$V1[h])
    vi = str_split(v, pattern = ": ")[[1]][2]
    res$marginal_likelihood[mod] = vi
  }
}

res = res[!(is.na(res$tree)),]

res_w = data.frame(matrix(NA, nrow = 1, ncol = 7))
colnames(res_w) = c("tree", "trait", "model", "marginal_likelihood", "num", "den", "weight")


for(i in 1:100){
  
  temp = res[res$tree == i,]
  
  for(j in 1:nlevels(as.factor(temp$trait))){
    
    temp2 = temp[temp$trait == levels(as.factor(temp$trait))[j],]
    temp2$num = exp(as.numeric(temp2$marginal_likelihood))
    temp2$den = sum(temp2$num)
    
    for (k in 1:nrow(temp2)){
      
      temp2$weight[k] = round(temp2$num[k]/temp2$den[k], 2)
      
    }
    
    res_w = rbind(res_w, temp2)
    
  }}
  
res_w = res_w[!is.na(res_w$tree),]

### Write the script for blending the models by trait

for(i in 1:nlevels(as.factor(res_w$trait))){
  
  temp = res_w[res_w$trait == levels(as.factor(res_w$trait))[i],]
  
  script = data.frame(matrix(NA, nrow = 100, ncol = 1))
  colnames(script) = c("#!/bin/bash")
  
  if(levels(as.factor(res_w$trait))[i] == "clonal"){ temp$model = gsub(pattern = "clonal.model.Bayes.ER", replacement = "clonal_model_Bayes_ER", x = temp$model)  }
  if(levels(as.factor(res_w$trait))[i] == "size"){ temp$model = gsub(pattern = "size.model.Bayes.ORD1.ER", replacement = "size.model.Bayes.ORD1_ER", x = temp$model)  }
  if(levels(as.factor(res_w$trait))[i] == "size"){ temp$model = gsub(pattern = "size.model.Bayes.ORD1.SYM", replacement = "size.model.Bayes.ORD1_SYM", x = temp$model)  }
  
  for(j in 1:100){
    
    temp2 = temp[temp$tree == j,]
    
    output = paste0("Blend-sMap -o /media/meurvill/Elements1/re-do_V2/05_100_trees_gamma/output/01_blended/", temp2$trait[1], "_", j, ".blended.smap.bin")
    
    input = " -n 5000"
    
    for(k in 1:nrow(temp2)){
      
      input = paste0(input, " -s /media/meurvill/Elements1/re-do_V2/05_100_trees_gamma/output/", j, "/",  temp2$model[k], "/", temp2$model[k], ".smap.bin,", temp2$weight[k])
      
    }
  
    script$`#!/bin/bash`[j] = paste0(output, input)

    }

  write.csv(script, paste0("/media/marie-pierre/Elements/re-do_V2/05_100_trees_gamma/scripts/" ,"/", temp$trait[1], "_blend.sh"), quote = F, row.names = F)
  
  }

# write.csv (res, paste0(path_out,  "ln-marg_lik_Bayes.csv"), quote = F, row.names = F)

