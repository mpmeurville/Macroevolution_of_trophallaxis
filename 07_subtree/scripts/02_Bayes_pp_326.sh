#!/bin/bash


for i in E:/re-do_V2/07_subtree/models/Bayes/troph*; do

        foldername=$i
        foldername=${foldername::-4}
        f=$(basename "$foldername")

        mkdir E:/re-do_V2/07_subtree/output/01_Bayes/$f

echo $f

# echo $foldername
sMap -t E:/re-do_V2/07_subtree/input/subtree_326.tre -d E:/re-do_V2/07_subtree/input/troph_326.txt -o E:/re-do_V2/07_subtree/output/01_Bayes/326sp/$f/$f -n 1000 -i $i -ss --nt 24 --pm 5 --pp 100
done





sMap -t E:/re-do_V2/07_subtree/input/subtree_326.tre -d E:/re-do_V2/07_subtree/input/troph_326.txt -o E:/re-do_V2/07_subtree/output/01_Bayes/326sp/troph.model.Bayes.ARD/troph.model.Bayes.ARD -n 1000 -i E:/re-do_V2/07_subtree/models/Bayes/troph.model.Bayes.ARD.nex -ss --nt 24 --pm 5 --pp 100


sMap -t E:/re-do_V2/07_subtree/input/subtree_326.tre -d E:/re-do_V2/07_subtree/input/troph_326.txt -o E:/re-do_V2/07_subtree/output/01_Bayes/326sp/troph.model.Bayes.ER/troph.model.Bayes.ER -n 1000 -i E:/re-do_V2/07_subtree/models/Bayes/troph.model.Bayes.ER.nex -ss --nt 24 --pm 5 --pp 100








