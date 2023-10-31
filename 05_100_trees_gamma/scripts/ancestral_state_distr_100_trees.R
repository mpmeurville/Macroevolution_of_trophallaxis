library(stringr)
library(tidyr)

files <- list.files(path="D:/re-do_V2/05_100_trees_gamma/output/02_root_node", pattern="*.txt", full.names=TRUE, recursive=FALSE)

res = data.frame(matrix(vector(), 1, 3,
                       dimnames=list(c(), c("trait", "state" ,"root"))),
                stringsAsFactors=F)

for ( i in 1:length(files)){
  
  temp = read.table(files[i], sep = "{", header = F)
  
  for(j in 1:nrow(temp)){
    
    trait = str_split(str_split(string = files[i],pattern = "/")[[1]][6], pattern = "_")[[1]][1]
    
    if(trait %in% c("size", "gam")){
    if(temp$V1[j] == "Mean conditioned state posteriors:"){
      
      for(k in 1:3){
        
        state = str_split(temp$V1[j+k], pattern = ":")[[1]][1]
        root = str_split(temp$V1[j+k], pattern = ":")[[1]][2]
        
        line = c(trait, state, root)
        res = rbind(res, line)
      }
      
    }
    }
    
    if(!trait %in% c("size", "gam")){
      if(temp$V1[j] == "Mean conditioned state posteriors:"){
        
        for(k in 1:2){
          
          state = str_split(temp$V1[j+k], pattern = ":")[[1]][1]
          root = str_split(temp$V1[j+k], pattern = ":")[[1]][2]
          
          line = c(trait, state, root)
          res = rbind(res, line)
        }
        
      }
    }
             
  }
  
}


### Plotting the results

library(ggplot2)

res$root = round(as.numeric(res$root), 5)
res = res[!is.na(res$trait),]
res$state = gsub(pattern = " ", replacement = "", x = res$state)
res = res[!(res$state == "N"),]

mean_values <- aggregate(root ~ trait, data = res, FUN = mean)

pdf("E:/re-do_V2/05_100_trees_gamma/output/02_root_node/histogram_roots_100_trees.pdf")
ggplot(res, aes(x = root, fill = state)) +
  geom_histogram(binwidth = .01, position = "dodge", alpha = 0.5) +
  geom_vline(data = mean_values, aes(xintercept = root), 
             linetype = "dotted", color = "black", size = .5) +
  facet_grid(trait ~ ., scales = "fixed", space = "free_x") +
  labs(x = "Root Value", y = "Count") +
  theme_classic()
dev.off()


t = res[res$state == "G", ]
mean(t$root) # = 0.633812

t = res[res$state == "R", ]
mean(t$root) # = 0.366188

t = res[res$state == "S" & res$trait == "gam", ]
mean(t$root) # = 0

t = res[res$state == "L", ]
mean(t$root) # = 0.046855

t = res[res$state == "M", ]
mean(t$root) # = 0.199888

t = res[res$state == "S" & res$trait == "size", ]
mean(t$root) # = 0.796398
