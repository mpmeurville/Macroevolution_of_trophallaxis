#!/bin/bash


for i in /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/models/Bayes/clonal*; do

        foldername=$i
        foldername=${foldername::-4}
        f=$(basename "$foldername")

        mkdir /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/output/01_bayes_gamma22/$f

echo $f

# echo $foldername
sMap -t /media/meurvill/Elements/re-do_V2/00_dataset_production/output/tree_212_norm.tre -d /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/input/clonal_212.txt -o /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/output/01_bayes_gamma22/$f/$f -n 1000 -i $i -ss --nt 24 --pm 5 --pp 100
done




for i in /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/models/Bayes/size*; do

        foldername=$i
        foldername=${foldername::-4}
        f=$(basename "$foldername")

        mkdir /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/output/01_bayes_gamma22/$f

echo $f

# echo $foldername
sMap -t /media/meurvill/Elements/re-do_V2/00_dataset_production/output/tree_212_norm.tre -d /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/input/col_212.txt -o /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/output/01_bayes_gamma22/$f/$f -n 1000 -i $i -ss --nt 24 --pm 5 --pp 100
done




for i in /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/models/Bayes/gam*; do

        foldername=$i
        foldername=${foldername::-4}
        f=$(basename "$foldername")

        mkdir /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/output/01_bayes_gamma22/$f

echo $f

# echo $foldername
sMap -t /media/meurvill/Elements/re-do_V2/00_dataset_production/output/tree_212_norm.tre -d /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/input/GamOvSt_212.txt -o /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/output/01_bayes_gamma22/$f/$f -n 1000 -i $i -ss --nt 24 --pm 5 --pp 100
done





for i in /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/models/Bayes/liq*; do

        foldername=$i
        foldername=${foldername::-4}
        f=$(basename "$foldername")

        mkdir /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/output/01_bayes_gamma22/$f

echo $f

# echo $foldername
sMap -t /media/meurvill/Elements/re-do_V2/00_dataset_production/output/tree_212_norm.tre -d /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/input/liq_212.txt -o /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/output/01_bayes_gamma22/$f/$f -n 1000 -i $i -ss --nt 24 --pm 5 --pp 100
done




for i in /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/models/Bayes/ova*; do

        foldername=$i
        foldername=${foldername::-4}
        f=$(basename "$foldername")

        mkdir /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/output/01_bayes_gamma22/$f

echo $f

# echo $foldername
sMap -t /media/meurvill/Elements/re-do_V2/00_dataset_production/output/tree_212_norm.tre -d /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/input/ova_212.txt -o /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/output/01_bayes_gamma22/$f/$f -n 1000 -i $i -ss --nt 24 --pm 5 --pp 100
done





for i in /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/models/Bayes/sperm*; do

        foldername=$i
        foldername=${foldername::-4}
        f=$(basename "$foldername")

        mkdir /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/output/01_bayes_gamma22/$f

echo $f

# echo $foldername
sMap -t /media/meurvill/Elements/re-do_V2/00_dataset_production/output/tree_212_norm.tre -d /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/input/sperm_212.txt -o /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/output/01_bayes_gamma22/$f/$f -n 1000 -i $i -ss --nt 24 --pm 5 --pp 100
done






for i in /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/models/Bayes/sting*; do

        foldername=$i
        foldername=${foldername::-4}
        f=$(basename "$foldername")

        mkdir /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/output/01_bayes_gamma22/$f

echo $f

# echo $foldername
sMap -t /media/meurvill/Elements/re-do_V2/00_dataset_production/output/tree_212_norm.tre -d /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/input/sting_212.txt -o /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/output/01_bayes_gamma22/$f/$f -n 1000 -i $i -ss --nt 24 --pm 5 --pp 100
done




for i in /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/models/Bayes/troph*; do

        foldername=$i
        foldername=${foldername::-4}
        f=$(basename "$foldername")

        mkdir /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/output/01_bayes_gamma22/$f

echo $f

# echo $foldername
sMap -t /media/meurvill/Elements/re-do_V2/00_dataset_production/output/tree_212_norm.tre -d /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/input/troph_212.txt -o /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/output/01_bayes_gamma22/$f/$f -n 1000 -i $i -ss --nt 24 --pm 5 --pp 100
done
















