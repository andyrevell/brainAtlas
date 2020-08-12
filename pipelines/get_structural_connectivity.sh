#!/bin/bash
# the user will first provide the path to the dwi file 
dwi=$1 #this needs to be the exact path i.e. /gdrive/public/DATA/image.nii.gz, and not "../../../DATA/image.nii.gz"
atlas=$2
output_dir=$3


base_name=$(basename $dwi)
tmp=${output_dir}/tmp
mkdir -p ${tmp}

echo "\n \n"
echo "Making source File \n"
#making source file in dsi_studio
dsi_studio --action=src --source=${dwi} --output=${base_name}.src.gz

echo "Doing Reconstruction \n"
#Making reconstruction of diffusion imagning. 
dsi_studio --action=rec --source=${dwi}.src.gz --method=4 --param0=1.25

echo "Generating Tractography and Connectivity Matrix \n"
#Generating track file AND connectivity matrix with user-input atlas
#We found the parameters manually by using the dsi_studio GUI. 
#With the GUI, we created src and tracktography files with the parameters followed from Preya Shah et. al 2019 Brain journal. 
#DSI GUI studio outputs a long hash for the parameters we used, and this has is what is below. 
dsi_studio --action=trk --source=${dwi}.src.gz.odf8.f5.bal.012fy.rdi.gqi.1.25.fib.gz --parameter_id=7C1D393C9A99193FF3B3513Fb803Fcb2041bC84340420Fca01cbaCDCC4C3Ec --output=${dwi}.trk.gz --connectivity=${atlas} --connectivity_type=pass --connectivity_threshold=0


#mv ${dwi}*connectivity.* ${tmp}/.. 
#mv ${dwi}*network_measures.* ${tmp}/


#Created in summer 2019. Updated August 10th 2020


#Some parameters examples:
#parameter_id=8E23963D9A99193FF3B3513Fb803Fcb2041bC84340420Fca01cbaCDCC4C3Ec
#parameter_id=7C1D393C9A99193FF3B3513Fb803Fcb2041bC84340420Fca01cbaCDCC4C3Ec


