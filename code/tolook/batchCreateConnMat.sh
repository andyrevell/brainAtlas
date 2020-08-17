#!/bin/bash
echo "here" 
export permNum=$1
export sub=$2
# list of random atlas nodes to analyze 
nodes=("0010" "0030" "0050" "0075" "0100" "0200" "0300" "0400" "0500" "0750" "1000" "2000")
# parent data directory 
dataPath=/gdrive/public/DATA/Human_Data/BIDS_processed/sub-RID${sub}
for node in ${nodes[@]} 
do
	mkdir $dataPath/connectivity_matrices/structural/RA_N${node}
	/gdrive/public/USERS/arevell/papers/paper001/paper001/pipelines/structural_pipelines/driver_get_structural_conn_mats.sh $dataPath/imaging/dwi/*.nii.gz /gdrive/public/TOOLS/atlases_and_templates/atlases/custom_atlases/random_atlases/whole_brain/RA_N${node} $dataPath/connectivity_matrices/structural/RA_N${node} $permNum		
done

