#!/bin/bash

dwi=$1
atlas_dir=$2
out_dir=$3
number_of_atlas_permutations=$4

# loop over desired permutation number
i=1
while [ "$i" -le "$number_of_atlas_permutations" ]; do

    perm=$(printf "%04d" $i)
    atlas=${atlas_dir}/*Perm${perm}*.nii*
    echo atlas: $atlas
    sh /gdrive/public/USERS/arevell/papers/paper001/paper001/pipelines/get_structural_connectivity.sh $dwi $atlas $out_dir

    i=$(($i + 1))
done

tmp=${out_dir}/tmp
mv ${dwi}.* ${tmp}/

