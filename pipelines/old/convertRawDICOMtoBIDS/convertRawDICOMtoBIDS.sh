#!/bin/bash

sub=$1
ses=$2
dir=$3
t1=$4 #these are the directories
dwi=$5
mag=$6
phase=$7

#example
# sh convertRawDICOMtoBIDS.sh RID0583 preop3T /gdrive/public/DATA/Human_Data/BIDS/sub-RID0583 /gdrive/public/DATA/Human_Data/BIDS/raw/3T_Subjects/3T_P079/T1w_MPR_Series0049 /gdrive/public/DATA/Human_Data/BIDS/raw/3T_Subjects/3T_P079/MULTISHELL_b2000_117dir_mb2_Series0062 /gdrive/public/DATA/Human_Data/BIDS/raw/3T_Subjects/3T_P079/B0map_v4_Series0056 /gdrive/public/DATA/Human_Data/BIDS/raw/3T_Subjects/3T_P079/B0map_v4_Series0057
#

dcm2niix -o ${dir}/ses-${ses}/anat/ -w 1 -f sub-${sub}_ses-${ses}_T1w ${t1} 
dcm2niix -o ${dir}/ses-${ses}/dwi/ -w 1 -f sub-${sub}_ses-${ses}_dwi ${dwi}
dcm2niix -o ${dir}/ses-${ses}/fmap/ -w 1 -f sub-${sub}_ses-${ses} ${mag}
dcm2niix -o ${dir}/ses-${ses}/fmap/ -w 1 -f sub-${sub}_ses-${ses} ${phase}

rm ${dir}/ses-${ses}/fmap/sub-${sub}_ses-${ses}_phasediff.nii
rm ${dir}/ses-${ses}/fmap/sub-${sub}_ses-${ses}_phasediff.json
rm ${dir}/ses-${ses}/fmap/sub-${sub}_ses-${ses}_magnitude1.nii
rm ${dir}/ses-${ses}/fmap/sub-${sub}_ses-${ses}_magnitude2.nii
rm ${dir}/ses-${ses}/fmap/sub-${sub}_ses-${ses}_magnitude1.json
rm ${dir}/ses-${ses}/fmap/sub-${sub}_ses-${ses}_magnitude2.json

mv ${dir}/ses-${ses}/fmap/sub-${sub}_ses-${ses}*ph*.nii* ${dir}/ses-${ses}/fmap/sub-${sub}_ses-${ses}_phasediff.nii
mv ${dir}/ses-${ses}/fmap/sub-${sub}_ses-${ses}*ph*.json ${dir}/ses-${ses}/fmap/sub-${sub}_ses-${ses}_phasediff.json

mv ${dir}/ses-${ses}/fmap/sub-${sub}_ses-${ses}*e1.nii* ${dir}/ses-${ses}/fmap/sub-${sub}_ses-${ses}_magnitude1.nii
mv ${dir}/ses-${ses}/fmap/sub-${sub}_ses-${ses}*e2.nii* ${dir}/ses-${ses}/fmap/sub-${sub}_ses-${ses}_magnitude2.nii

mv ${dir}/ses-${ses}/fmap/sub-${sub}_ses-${ses}*e1.json ${dir}/ses-${ses}/fmap/sub-${sub}_ses-${ses}_magnitude1.json
mv ${dir}/ses-${ses}/fmap/sub-${sub}_ses-${ses}*e2.json ${dir}/ses-${ses}/fmap/sub-${sub}_ses-${ses}_magnitude2.json



