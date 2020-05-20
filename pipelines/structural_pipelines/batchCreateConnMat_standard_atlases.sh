#!/bin/bash
echo "here" 
export sub=$1
# list of standard atlases to analyze 
nodes=("AAL600.nii.gz" "aal_res-1x1x1.nii.gz" "JHU_res-1x1x1.nii.gz" "CPAC200_res-1x1x1.nii.gz" "desikan_res-1x1x1.nii.gz" "DK_res-1x1x1.nii.gz" "Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_1mm.nii.gz" "Schaefer2018_100Parcels_17Networks_order_FSLMNI152_1mm.nii.gz" "Schaefer2018_200Parcels_17Networks_order_FSLMNI152_1mm.nii.gz" "Schaefer2018_300Parcels_17Networks_order_FSLMNI152_1mm.nii.gz" "Schaefer2018_400Parcels_17Networks_order_FSLMNI152_1mm.nii.gz" "Talairach_res-1x1x1.nii.gz")
# parent data directory 
dataPath=/gdrive/public/DATA/Human_Data/BIDS_processed/sub-RID${sub}
# directory of standard atlases 
atlasDir=/gdrive/public/USERS/silvaale/Atlases/AtlasTemplatesForPaper
for node in ${nodes[@]} 
do
	saveFolder=${node%.nii.gz}
	echo ${saveFolder}
	mkdir $dataPath/connectivity_matrices/structural/${saveFolder}
	sh /gdrive/public/USERS/arevell/papers/paper001/paper001/pipelines/get_structural_connectivity.sh $dataPath/imaging/dwi/*.nii.gz ${atlasDir}/${node} $dataPath/connectivity_matrices/structural/${saveFolder}
done

