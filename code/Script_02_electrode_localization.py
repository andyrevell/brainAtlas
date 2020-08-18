"""
2020.06.10
Andy Revell
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Purpose: script to get electrode localization

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Logic of code:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Input:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Output:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Example:

python3.6 Script_02_electrode_localization.py

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"""


#assumes current working directory is scripts directory
#%%
path = "/mnt"
import sys
import os
from os.path import join as ospj
sys.path.append(ospj(path, "paper001/code/tools"))
import electrode_localization
import pandas as pd
import numpy as np

#%% Paths and File names
ifname_EEG_times = ospj( path, "data_raw/iEEG_times/EEG_times.xlsx")
ifname_MNI_template = ospj( path, "data_raw/MNI_brain_template/MNI152_T1_1mm_brain.nii.gz")
ifpath_electrode_localization = ospj( path, "data_raw/electrode_localization")
ifpath_atlases_standard = ospj( path, "data_raw/atlases/standard_atlases")
ifpath_atlases_random = ospj( path, "data_raw/atlases/random_atlases")
ofpath_electrode_localization = ospj( path, "data_processed/electrode_localization_atlas_region")

#%% Paramters
#number of random atlas permutations to run on
permutations = 30 
#%% Load Data
data = pd.read_excel(ifname_EEG_times)    

#%% Processing Data: extracting sub-IDs

sub_IDs_unique = np.unique(data.RID)


#%%
for i in range(len(sub_IDs_unique)):
    #parsing data DataFrame to get iEEG information
    sub_ID = sub_IDs_unique[i]
    print("\nSubject: {0}".format(sub_ID))
    #getting electrode localization file
    ifpath_electrode_localization_sub_ID = ospj(ifpath_electrode_localization, "sub-{0}".format(sub_ID))
    if not os.path.exists(ifpath_electrode_localization_sub_ID):
        print("Path does not exist: {0}".format(ifpath_electrode_localization_sub_ID))
    ifname_electrode_localization_sub_ID =[f for f in sorted(os.listdir(ifpath_electrode_localization_sub_ID))][0]    
    ifname_electrode_localization_sub_ID_fullpath = ospj(ifpath_electrode_localization_sub_ID, ifname_electrode_localization_sub_ID)
    #getting atlas names
    atlas_names_standard = [f for f in sorted(os.listdir(ifpath_atlases_standard))]
    atlas_names_random = [f for f in sorted(os.listdir(ifpath_atlases_random))]
    #Output electrode localization
    ofpath_electrode_localization_sub_ID = ospj(ofpath_electrode_localization, "sub-{0}".format(sub_ID))
    if not (os.path.isdir(ofpath_electrode_localization_sub_ID)): os.mkdir(ofpath_electrode_localization_sub_ID)#if the path doesn't exists, then make the directory
    #standard atlases: getting electrode localization by region
    for a in range(len(atlas_names_standard)):
        ifname_atlases_standard = ospj(ifpath_atlases_standard, atlas_names_standard[a] )
        atlas_name = os.path.splitext(os.path.splitext(atlas_names_standard[a] )[0])[0]
        ofpath_electrode_localization_sub_ID_atlas = ospj(ofpath_electrode_localization_sub_ID, atlas_name)
        if not (os.path.isdir(ofpath_electrode_localization_sub_ID_atlas)): os.mkdir(ofpath_electrode_localization_sub_ID_atlas)
        ofname_electrode_localization = "{0}_{1}.csv".format( os.path.splitext(ifname_electrode_localization_sub_ID)[0],os.path.splitext(os.path.splitext(atlas_names_standard[a] )[0])[0])
        ofname_electrode_localization_fullpath = ospj(ofpath_electrode_localization_sub_ID_atlas, ofname_electrode_localization)
        print("Subject: {0}  Atlas: {1}".format(sub_ID, atlas_names_standard[a]))
        electrode_localization.by_atlas(ifname_electrode_localization_sub_ID_fullpath, ifname_atlases_standard, ifname_MNI_template, ofname_electrode_localization_fullpath)
    #random atlases: getting electrode localization by region
    for a in range(len(atlas_names_random)):
         for p in range(1, permutations+1):
            ifname_atlases_random = ospj(ifpath_atlases_random, atlas_names_random[a], "{0}_v{1}.nii.gz".format(atlas_names_random[a], '{:04}'.format(p))  )
            atlas_name = os.path.splitext(os.path.splitext(atlas_names_random[a] )[0])[0]
            ofpath_electrode_localization_sub_ID_atlas = ospj(ofpath_electrode_localization_sub_ID, atlas_name)
            if not (os.path.isdir(ofpath_electrode_localization_sub_ID_atlas)): os.mkdir(ofpath_electrode_localization_sub_ID_atlas)
            ofname_electrode_localization = "{0}_{1}.csv".format( os.path.splitext(ifname_electrode_localization_sub_ID)[0],os.path.splitext(os.path.splitext("{0}_v{1}.nii.gz".format(atlas_names_random[a], '{:04}'.format(p)))[0])[0])
            ofname_electrode_localization_fullpath = ospj(ofpath_electrode_localization_sub_ID_atlas, ofname_electrode_localization)
            print("Subject: {0}  Atlas: {1}".format(sub_ID,  "{0}_v{1}.nii.gz".format(atlas_names_random[a], '{:04}'.format(p))  ))
            electrode_localization.by_atlas(ifname_electrode_localization_sub_ID_fullpath, ifname_atlases_random, ifname_MNI_template, ofname_electrode_localization_fullpath)
       

    

#%%












