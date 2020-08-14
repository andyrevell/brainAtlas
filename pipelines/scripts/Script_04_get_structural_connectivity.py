"""
2020.06.10
Andy Revell
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Purpose: script to get iEEG data in batches

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Logic of code:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Input:
  username: first argument. Your iEEG.org username
  password: second argument. Your iEEG.org password

  Reads data on which sub-IDs to download data from in data_raw/iEEG_times/EEG_times.xlsx
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Output:
Saves EEG timeseries in specified output directors
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Example:

python3.6 Script_04_get_structural_connectivity.py

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"""


#assumes current working directory is scripts directory
#%%
import sys
import os
import pandas as pd
#%% Paths and File names

inputfile_EEG_times = "data_raw/iEEG_times/EEG_times.xlsx"
inputpath_dwi =  "data_raw/imaging"
outputpath_tractography = "data_processed/tractography"

#may not be applicable if DSI Studio is already on your $PATH environment
dsi_studio_path = "/Applications/dsi_studio.app/Contents/MacOS/" # On a Mac: "/Applications/dsi_studio.app/Contents/MacOS/"

                             
#%%Load Data
data = pd.read_excel(inputfile_EEG_times)    

#%%
for i in range(len(data)):
    #parsing data DataFrame to get iEEG information
    sub_ID = data.iloc[i].RID
    inputfile_dwi =    "sub-{0}_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz".format(sub_ID) 
    inputfile_dwi_fullpath = os.path.join(inputpath_dwi,"sub-{0}".format(sub_ID), inputfile_dwi)
    input_name = os.path.splitext(os.path.splitext(inputfile_dwi)[0])[0]
    outputpath_tractography_sub_ID = os.path.join(outputpath_tractography, "sub-{0}".format(sub_ID))
    if not (os.path.isdir(outputpath_tractography_sub_ID)): os.mkdir(outputpath_tractography_sub_ID)
    output_src =  os.path.join(outputpath_tractography, "sub-{0}".format(sub_ID), "{0}.src.gz".format(input_name))
    
    if (os.path.exists(output_src)):
        print("Source file already exists: {0}".format(output_src))
    if not (os.path.exists(output_src)):#if file already exists, don't run below
        print("Creating Source File in DSI Studio")
        cmd = "{0}/dsi_studio --action=src --source={1} --output={2}".format(dsi_studio_path, inputfile_dwi_fullpath, output_src)
        os.system(cmd)
        print("Creating Reconstruction File in DSI Studio")
        cmd = "{0}/dsi_studio --action=rec --source={1} --method=4 --param0=1.25".format(dsi_studio_path, output_src)
        os.system(cmd)
       

#%%












