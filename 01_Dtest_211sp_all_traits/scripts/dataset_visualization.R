library(ape)
library(ggtree)


############ 212 sp ############ 

tree_212 = read.tree("/media/marie-pierre/Elements/re-do_V1/01_Dtest_211sp_all_traits/input/norm_tree_212sp.txt")
clonal_212 = read.table("/media/marie-pierre/Elements/re-do_V1/01_Dtest_211sp_all_traits/input/clonal_212.txt", header = T)
colnames(clonal_212) = c("species", "clonal")
size_212 = read.table("/media/marie-pierre/Elements/re-do_V1/01_Dtest_211sp_all_traits/input/col_212.txt", header = T)
colnames(size_212) = c("species", "size")
sting_212 = read.table("/media/marie-pierre/Elements/re-do_V1/01_Dtest_211sp_all_traits/input/sting_212.txt", header = T)
colnames(sting_212) = c("species", "sting")
troph_212 = read.table("/media/marie-pierre/Elements/re-do_V1/01_Dtest_211sp_all_traits/input/troph_212.txt", header = T)
colnames(troph_212) = c("species", "troph")
gam_212 = read.table("/media/marie-pierre/Elements/re-do_V1/01_Dtest_211sp_all_traits/input/GamOvSt_212.txt", header = T)
colnames(gam_212) = c("species", "gam")
liq_212 = read.table("/media/marie-pierre/Elements/re-do_V1/01_Dtest_211sp_all_traits/input/liq_212.txt", header = T)
colnames(liq_212) = c("species", "liq")
ova_212 = read.table("/media/marie-pierre/Elements/re-do_V1/01_Dtest_211sp_all_traits/input/ova_212.txt", header = T)
colnames(ova_212) = c("species", "ova")
sperm_212 = read.table("/media/marie-pierre/Elements/re-do_V1/01_Dtest_211sp_all_traits/input/sperm_212.txt", header = T)
colnames(sperm_212) = c("species", "sperm")


dat_212 = merge(clonal_212, size_212, by = "species")
dat_212 = merge(dat_212, sting_212, by = "species")
dat_212 = merge(dat_212, troph_212, by = "species")
dat_212 = merge(dat_212, gam_212, by = "species")
dat_212 = merge(dat_212, liq_212, by = "species")
dat_212 = merge(dat_212, ova_212, by = "species")
dat_212 = merge(dat_212, sperm_212, by = "species")

row.names(dat_212) = dat_212$species
dat_212 = dat_212[, -1]

circ = ggtree(tree_212, layout = "fan", branch.length = "none", open.angle = 10, ) + 
  geom_tiplab(size = 1.5)

p1 = gheatmap(circ, dat_212, offset=15, width=.2,
              colnames_angle= 90, colnames_position = "top", colnames_offset_y = 2, font.size = 1.2)
pdf("/media/marie-pierre/Elements/re-do_V1/01_Dtest_211sp_all_traits/input/dataset_visualization_212sp.pdf")
p1
dev.off()


############ 415 sp ############ 
library(ape)
library(ggtree)


tree_415 = read.tree("/media/marie-pierre/Elements/re-do_V1/03_ASR_Dtest_all_sp/01_input/norm_tree_415sp.txt")
clonal_415 = read.table("/media/marie-pierre/Elements/re-do_V1/03_ASR_Dtest_all_sp/01_input/clonal_415.txt", header = T)
colnames(clonal_415) = c("species", "clonal")
size_415 = read.table("/media/marie-pierre/Elements/re-do_V1/03_ASR_Dtest_all_sp/01_input/col_415.txt", header = T)
colnames(size_415) = c("species", "size")
sting_415 = read.table("/media/marie-pierre/Elements/re-do_V1/03_ASR_Dtest_all_sp/01_input/sting_415.txt", header = T)
colnames(sting_415) = c("species", "sting")
troph_415 = read.table("/media/marie-pierre/Elements/re-do_V1/03_ASR_Dtest_all_sp/01_input/troph_415.txt", header = T)
colnames(troph_415) = c("species", "troph")

for(i in 1:nrow(troph_415)){
  if(troph_415$troph[i] != "T" & troph_415$troph[i] != "N"){
    troph_415$troph[i] = round(as.numeric(strsplit(strsplit(strsplit(troph_415$troph[i], split = ",")[[1]][2], split = ":")[[1]][2], split = "}"[[1]][1])))
  }
}
troph_415$troph = gsub(x = troph_415$troph, pattern = 0, replacement = "N")
troph_415$troph = gsub(x = troph_415$troph, pattern = 1, replacement = "T")

gam_415 = read.table("/media/marie-pierre/Elements/re-do_V1/03_ASR_Dtest_all_sp/01_input/GamOvSt_415.txt", header = T)
colnames(gam_415) = c("species", "gam")
liq_415 = read.table("/media/marie-pierre/Elements/re-do_V1/03_ASR_Dtest_all_sp/01_input/liq_415.txt", header = T)
colnames(liq_415) = c("species", "liq")
ova_415 = read.table("/media/marie-pierre/Elements/re-do_V1/03_ASR_Dtest_all_sp/01_input/ova_415.txt", header = T)
colnames(ova_415) = c("species", "ova")
sperm_415 = read.table("/media/marie-pierre/Elements/re-do_V1/03_ASR_Dtest_all_sp/01_input/sperm_415.txt", header = T)
colnames(sperm_415) = c("species", "sperm")


dat_415 = merge(clonal_415, size_415, by = "species")
dat_415 = merge(dat_415, sting_415, by = "species")
dat_415 = merge(dat_415, troph_415, by = "species")
dat_415 = merge(dat_415, gam_415, by = "species")
dat_415 = merge(dat_415, liq_415, by = "species")
dat_415 = merge(dat_415, ova_415, by = "species")
dat_415 = merge(dat_415, sperm_415, by = "species")

row.names(dat_415) = dat_415$species
dat_415 = dat_415[, -1]

circ = ggtree(tree_415, layout = "fan", branch.length = "none", open.angle = 5, ) + 
  geom_tiplab(size = .9)

p1 = gheatmap(circ, dat_415, offset=12, width=.2,
              colnames_angle= 90, colnames_position = "top", colnames_offset_y = 2, font.size = 1.2)

pdf("/media/marie-pierre/Elements/re-do_V1/03_ASR_Dtest_all_sp/01_input/dataset_visualization_415sp.pdf")
p1
dev.off()
