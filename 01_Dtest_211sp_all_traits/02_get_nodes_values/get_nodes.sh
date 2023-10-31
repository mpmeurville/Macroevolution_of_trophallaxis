#!/bin/bash




for i in /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/output/02_blend/*blended.smap.bin; do

cd 

	foldername=$i
	foldername=${foldername::-4}
	f=$(basename "$foldername")

# echo $f
echo $i

for j in {0..423}; do
NodeInfo --simple -s $i -n $j >> /media/meurvill/Elements/re-do_V2/01_Dtest_211sp_all_traits/02_get_nodes_values/output/$f.txt


done
done

