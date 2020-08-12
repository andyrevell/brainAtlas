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

python3.6 Script_02_get_electrode_localization.py

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"""


#assumes current working directory is scripts directory
#%%
import sys
import os
sys.path.append("..")
import get_electrode_localization
import pandas as pd
import numpy as np

#%% Paths and File names
path_paper = "../../.."
inputfile_EEG_times = os.path.join( path_paper, "data_raw/iEEG_times/EEG_times.xlsx")
inputfile_MNI_template = os.path.join( path_paper, "data_raw/MNI_brain_template/MNI152_T1_1mm_brain.nii.gz")
inputpath_electrode_localization = os.path.join( path_paper, "data_raw/electrode_localization")
inputpath_atlases_standard = os.path.join( path_paper, "data_raw/atlases/standard_atlases")
inputpath_atlases_random = os.path.join( path_paper, "data_raw/atlases/random_atlases")
outputpath_electrode_localization = os.path.join( path_paper, "data_processed/electrode_localization_atlas_region")

#%% Paramters
#number of random atlas permutations to run on
permutations = 30 
#%% Load Data
data = pd.read_excel(inputfile_EEG_times)    

#%% Processing Data: extracting sub-IDs

sub_IDs_unique = np.unique(data.RID)


#%%
for i in range(len(sub_IDs_unique)):
    #parsing data DataFrame to get iEEG information
    sub_ID = sub_IDs_unique[i]
    print("\nSubject: {0}".format(sub_ID))
    #getting electrode localization file
    inputpath_electrode_localization_sub_ID = os.path.join(inputpath_electrode_localization, "sub-{0}".format(sub_ID))
    if not os.path.exists(inputpath_electrode_localization_sub_ID):
        print("Path does not exist: {0}".format(inputpath_electrode_localization_sub_ID))
    inputfile_electrode_localization_sub_ID =[f for f in sorted(os.listdir(inputpath_electrode_localization_sub_ID))][0]    
    inputfile_electrode_localization_sub_ID_fullpath = os.path.join(inputpath_electrode_localization_sub_ID, inputfile_electrode_localization_sub_ID)
    #getting atlas names
    atlas_names_standard = [f for f in sorted(os.listdir(inputpath_atlases_standard))]
    atlas_names_random = [f for f in sorted(os.listdir(inputpath_atlases_random))]
    #Output electrode localization
    outputpath_electrode_localization_sub_ID = os.path.join(outputpath_electrode_localization, "sub-{0}".format(sub_ID))
    if not (os.path.isdir(outputpath_electrode_localization_sub_ID)): os.mkdir(outputpath_electrode_localization_sub_ID)#if the path doesn't exists, then make the directory
    #standard atlases: getting electrode localization by region
    for a in range(len(atlas_names_standard)):
        inputfile_atlases_standard = os.path.join(inputpath_atlases_standard, atlas_names_standard[a] )
        outputfile_electrode_localization = "{0}_{1}.csv".format( os.path.splitext(inputfile_electrode_localization_sub_ID)[0],os.path.splitext(os.path.splitext(atlas_names_standard[a] )[0])[0])
        outputfile_electrode_localization_fullpath = os.path.join(outputpath_electrode_localization_sub_ID, outputfile_electrode_localization)
        print("Subject: {0}  Atlas: {1}".format(sub_ID, atlas_names_standard[a]))
        get_electrode_localization.by_atlas(inputfile_electrode_localization_sub_ID_fullpath, inputfile_atlases_standard, inputfile_MNI_template, outputfile_electrode_localization_fullpath)
    #random atlases: getting electrode localization by region
    for a in range(len(atlas_names_random)):
         for p in range(1, permutations+1):
            inputfile_atlases_random = os.path.join(inputpath_atlases_random, atlas_names_random[a], "{0}_v{1}.nii.gz".format(atlas_names_random[a], '{:04}'.format(p))  )
            outputfile_electrode_localization = "{0}_{1}.csv".format( os.path.splitext(inputfile_electrode_localization_sub_ID)[0],os.path.splitext(os.path.splitext("{0}_v{1}.nii.gz".format(atlas_names_random[a], '{:04}'.format(p)))[0])[0])
            outputfile_electrode_localization_fullpath = os.path.join(outputpath_electrode_localization_sub_ID, outputfile_electrode_localization)
            print("Subject: {0}  Atlas: {1}".format(sub_ID,  "{0}_v{1}.nii.gz".format(atlas_names_random[a], '{:04}'.format(p))  ))
            get_electrode_localization.by_atlas(inputfile_electrode_localization_sub_ID_fullpath, inputfile_atlases_random, inputfile_MNI_template, outputfile_electrode_localization_fullpath)
       

    

#%%












