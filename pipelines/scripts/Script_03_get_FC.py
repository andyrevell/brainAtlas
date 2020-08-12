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

python3.6 Script_03_get_FC.py

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"""


#assumes current working directory is scripts directory
#%%
import sys
import os
sys.path.append("..")
from get_Functional_connectivity import get_Functional_connectivity
import pandas as pd

#%% Paths and File names
path_paper = "../../.."
inputfile_EEG_times = os.path.join( path_paper, "data_raw/iEEG_times/EEG_times.xlsx")

inputpath_EEG = os.path.join( path_paper, "data_raw/EEG")
outputpath_FC = os.path.join( path_paper, "data_raw/adjacency_matrices/function")


                             
#%%Load Data
data = pd.read_excel(inputfile_EEG_times)    

#%%
for i in range(len(data)):
    #parsing data DataFrame to get iEEG information
    sub_ID = data.iloc[i].RID
    iEEG_filename = data.iloc[i].file
    start_time_usec = int(data.iloc[i].connectivity_start_time_seconds*1e6)
    stop_time_usec = int(data.iloc[i].connectivity_end_time_seconds*1e6)
    descriptor = data.iloc[i].descriptor
    inputpath_EEG_sub_ID = os.path.join(inputpath_EEG, "sub-{0}".format(sub_ID))
    inputfile_EEG_sub_ID = "{0}/sub-{1}_{2}_{3}_{4}_EEG.pickle".format(inputpath_EEG_sub_ID, sub_ID, iEEG_filename, start_time_usec, stop_time_usec)
    #check if EEG file exists
    if not (os.path.exists(inputfile_EEG_sub_ID)):
        print("EEG file does not exist: {0}".format(inputfile_EEG_sub_ID))
    #Output filename EEG
    outputpath_FC_sub_ID = os.path.join(outputpath_FC, "sub-{0}".format(sub_ID))
    if not (os.path.isdir(outputpath_FC_sub_ID)): os.mkdir(outputpath_FC_sub_ID)#if the path doesn't exists, then make the directory
    outputfile_FC = "{0}/sub-{1}_{2}_{3}_{4}_functionalConnectivity.pickle".format(outputpath_FC_sub_ID, sub_ID, iEEG_filename, start_time_usec, stop_time_usec)
    print("\nID: {0}\nDescriptor: {1}".format(sub_ID, descriptor))
    if (os.path.exists(outputfile_FC)):
        print("File already exists: {0}".format(outputfile_FC))
    if not (os.path.exists(outputfile_FC)):#if file already exists, don't run below
        get_Functional_connectivity(inputfile_EEG_sub_ID, outputfile_FC)
   


   

#%%












