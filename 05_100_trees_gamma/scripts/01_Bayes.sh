#!/bin/bash

counter=89

for j in {90..100}; do

((counter= counter + 1))

#echo $counter


mkdir /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/output/$counter

tree=tree_"$counter"_normalized.tre
echo $tree


for i in /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/models/Bayes/gamma22/gam.model.Bayesrev.ARD.nex; do

        foldername=$i
        foldername=${foldername::-4}
        f=$(basename "$foldername")

        mkdir /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/output/$counter/$f

#echo $f

sMap -t /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/01_input/100_trees/$tree -d /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/01_input/GamOvSt_417.txt -o /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/output/$counter/$f/$f -n 1000 -i $i -ss
done
done

#############################################################################

counter=18

for j in {19..100}; do

((counter= counter + 1))

#echo $counter


mkdir /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/output/$counter

tree=tree_"$counter"_normalized.tre
echo $tree

for i in /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/models/Bayes/gamma22/sting.model.Bayes.ER.nex; do

        foldername=$i
        foldername=${foldername::-4}
        f=$(basename "$foldername")

        mkdir /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/output/$counter/$f

#echo $f
sMap -t /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/01_input/100_trees/$tree -d //media/meurvill/Elements/re-do_V2/05_100_trees_gamma/01_input/sting_417.txt -o  /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/output/$counter/$f/$f -n 1000 -i $i -ss
done
done


#############################################################################

counter=0

for j in {1..100}; do

((counter= counter + 1))

#echo $counter


mkdir /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/output/$counter

tree=tree_"$counter"_normalized.tre
echo $tree

for i in /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/models/Bayes/gamma22/troph.model.Bayes.ARD.nex; do

        foldername=$i
        foldername=${foldername::-4}
        f=$(basename "$foldername")

        mkdir /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/output/$counter/$f

#echo $f
sMap -t /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/01_input/100_trees/$tree -d /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/01_input/troph_417.txt -o /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/output/$counter/$f/$f -n 1000 -i $i -ss
done
done

#############################################################################

counter=0

for j in {1..100}; do

((counter= counter + 1))

#echo $counter


mkdir /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/output/$counter

tree=tree_"$counter"_normalized.tre
echo $tree

for i in /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/models/Bayes/gamma22/liq.model.Bayes.ER.nex; do

        foldername=$i
        foldername=${foldername::-4}
        f=$(basename "$foldername")

        mkdir /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/output/$counter/$f

#echo $f
sMap -t /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/01_input/100_trees/$tree -d /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/01_input/liq_417.txt -o  /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/output/$counter/$f/$f -n 1000 -i $i -ss
done
done

#############################################################################

counter=93

for j in {94..100}; do

((counter= counter + 1))

#echo $counter


mkdir /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/output/$counter

tree=tree_"$counter"_normalized.tre
echo $tree

for i in /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/models/Bayes/gamma22/clonal.model.Bayes.ARD.nex; do

        foldername=$i
        foldername=${foldername::-4}
        f=$(basename "$foldername")

        mkdir /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/output/$counter/$f

#echo $f
sMap -t /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/01_input/100_trees/$tree -d /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/01_input/clonal_417.txt -o  /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/output/$counter/$f/$f -n 1000 -i $i -ss
done
done

#############################################################################

counter=91

for j in {92..100}; do

((counter= counter + 1))

#echo $counter


mkdir /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/output/$counter

tree=tree_"$counter"_normalized.tre
echo $tree


for i in /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/models/Bayes/gamma22/sperm.model.Bayes.ARD.nex; do

        foldername=$i
        foldername=${foldername::-4}
        f=$(basename "$foldername")

        mkdir /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/output/$counter/$f

#echo $f
sMap -t /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/01_input/100_trees/$tree -d /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/01_input/sperm_417.txt -o /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/output/$counter/$f/$f -n 1000 -i $i -ss
done
done


#############################################################################

counter=0

for j in {1..100}; do

((counter= counter + 1))

#echo $counter


mkdir /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/output/$counter

tree=tree_"$counter"_normalized.tre
echo $tree


for i in /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/models/Bayes/gamma22/ovar.model.Bayes.ER.nex; do

        foldername=$i
        foldername=${foldername::-4}
        f=$(basename "$foldername")

        mkdir /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/output/$counter/$f

#echo $f
sMap -t /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/01_input/100_trees/$tree -d /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/01_input/ova_417.txt -o /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/output/$counter/$f/$f -n 1000 -i $i -ss
done
done

#############################################################################

counter=96

for j in {97..100}; do

((counter= counter + 1))

#echo $counter


mkdir /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/output/$counter

tree=tree_"$counter"_normalized.tre
echo $tree

for i in /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/models/Bayes/gamma22/size.model.Bayes.ORD1_ER.nex; do

        foldername=$i
        foldername=${foldername::-4}
        f=$(basename "$foldername")

        mkdir /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/output/$counter/$f

#echo $f
sMap -t /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/01_input/100_trees/$tree -d /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/01_input/col_417.txt -o /media/meurvill/Elements/re-do_V2/05_100_trees_gamma/output/$counter/$f/$f -n 1000 -i $i -ss
done
done


