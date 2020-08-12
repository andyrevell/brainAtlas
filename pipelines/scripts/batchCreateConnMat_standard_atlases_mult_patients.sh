#!/bin/bash
echo "here" 
subs=("0194" "0278" "0320" "0309" "0365" "0139" "0490" "0502" "0508" "0420" "0522" "0520" "0454" "0536" "0529" "0595")
for sub in ${subs[@]}
do
	./batchCreateConnMat_standard_atlases.sh ${sub}
done 

