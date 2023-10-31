# In the terminal:  tail */*marginal.likelihood.txt> marg_likelihood.txt

library(data.table)
library(stringr)

path_in = "/media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/output/01_bayes_gamma22/"
path_out = path_in
  
f = read.table(paste0(path_in, "marg_likelihood.txt"), sep = "\n", stringsAsFactors = F )

### Create output df

res = data.frame(matrix(NA, nrow = nrow(f)/9, ncol = 2))
colnames(res) = c("model", "marginal_likelihood")

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
  
  if(grepl("Overall ln-marginal likelihood", as.character(f$V1[h]))){
    v = as.character(f$V1[h])
    vi = str_split(v, pattern = ": ")[[1]][2]
    res$marginal_likelihood[mod] = vi
  }
}

write.csv (res, paste0(path_out,  "ln-marg_lik_Bayes.csv"), quote = F, row.names = F)

