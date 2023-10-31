# RUN tail -n +1 output/ML_models/*/*mean.params* > ml_estimates_ML_all.txt to collect all rates!

library(data.table)
library(stringr)

path_in = "/home/meurvill/Documents/troph_inference/re-do_v1/01_Dtest_211sp_all_traits/output/01_ML/"

path_out = "/home/meurvill/Documents/troph_inference/re-do_v1/01_Dtest_211sp_all_traits/models/Bayes/"

### Open the file with all rates. 
f = read.table(paste0(path_in, "ml_estimates_ML_all.txt"), sep = "\n", stringsAsFactors = F)

### For independant models
for (h in 1:nrow(f)){
  
  s = "#NEXUS

Begin Pi;

    Character: 0;

    Default: Dirichlet(1);

End;

Begin Rates;

    Character: 0;

    Rates:
"
  
  if(grepl("==>", as.character(f$V1[h]))){
    #print(h)
    ml_name = as.character(f$V1[h])
    print(h)
    t = str_split(as.character(ml_name), pattern = "/")[[1]]
    u = str_split(t, pattern = " ")[[1]][2]
    Bayes_name = gsub("ML", "Bayes", u)
    Bayes_name = paste0(Bayes_name,".nex")
    print(Bayes_name)
    
    x = s
  }
  
  if(grepl("r\\(", as.character(f$V1[h]))){
    r = as.character(f$V1[h])
    rate = str_split(r, pattern = "r\\(")
    rate = str_split(rate[[1]][2], pattern = "\\):\\\t")
    left = rate[[1]][1]
    right = rate[[1]][2]
    if (!grepl("Equal", right)){right = as.numeric(rate[[1]][2] )}
    print(h)
    if(!grepl("Equal", right) && right != "0"){
      right = paste0("LogNormal(", log(right), ", 1)")
      
    }
    
    if(right == 0){ right = "Exponential(100)"}
    
    x = paste(x, paste0("\t",left, " : ", right, "\n"))
    
    if (!grepl("r\\(", as.character(f$V1[h+1]))){    
      x = paste(x, "\t; \n\nEnd;")
      write(x, paste0(path_out, Bayes_name))
    }
    
  }}

# 
# ### For conditionned models
# for (h in 1:nrow(f)){
#   
#   s = "#NEXUS
# 
# Begin Dependency;
# 
# 	Independent: 1;
# 
# 	Conditioned: 0 | 1;
# 		Default: Dirichlet(1)
# 			;
# End;
# 
# Begin Pi;
# 
#     Character: 1;
# 
#     Default: Dirichlet(1);
# 
# End;
# 
# Begin Rates;
# 
#     Character: 1;
# 
#     Rates:
# "
#   
#   if(grepl("==>", as.character(f$V1[h]))){
#     #print(h)
#     ml_name = as.character(f$V1[h])
#     print(h)
#     t = str_split(as.character(ml_name), pattern = "/")[[1]]
#     u = str_split(t, pattern = " ")[[1]][2]
#     Bayes_name = gsub("ML", "Bayes", u)
#     Bayes_name = paste0(Bayes_name,".nex")
#     print(Bayes_name)
#     
#     x = s
#   }
#   
#   if(grepl("r\\(", as.character(f$V1[h]))){
#     r = as.character(f$V1[h])
#     rate = str_split(r, pattern = "r\\(")
#     rate = str_split(rate[[1]][2], pattern = "\\):\\\t")
#     left = rate[[1]][1]
#     right = rate[[1]][2]
#     if (!grepl("Equal", right)){right = as.numeric(rate[[1]][2] )}
#     print(h)
#     if(!grepl("Equal", right) && right != "0"){
#       right = paste0("LogNormal(", log(right), ", 1)")
#       
#     }
#     
#     if(right == 0){ right = "Exponential(100)"}
#     
#     x = paste(x, paste0("\t",left, " : ", right, "\n"))
#     
#     if (!grepl("r\\(", as.character(f$V1[h+1]))){    
#       x = paste(x, "\t; \n\nEnd;")
#       write(x, paste0(path_out, Bayes_name))
#     }
#     
#     }}


