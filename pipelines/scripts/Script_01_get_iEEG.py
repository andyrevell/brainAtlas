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

python3.6 Script_01_get_iEEG_data_RID0440.py 'username' 'password'

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"""


#assumes current working directory is scripts directory
#%%
import sys
import os
sys.path.append("..")
sys.path.append("../ieegpy/")
from get_iEEG_data import get_iEEG_data
import pandas as pd

#%% Paths and File names
path_paper = "../../.."
inputfile_EEG_times = os.path.join( path_paper, "data_raw/iEEG_times/EEG_times.xlsx")
outputpath_EEG = os.path.join( path_paper, "data_raw/EEG")

                              
#%% Load username and password input
username= sys.argv[1]
password= sys.argv[2]


#%%Load Data
data = pd.read_excel(inputfile_EEG_times)    

#%%
for i in range(len(data)):
    #parsing data DataFrame to get iEEG information
    sub_ID = data.iloc[i].RID
    iEEG_filename = data.iloc[i].file
    ignore_electrodes = data.iloc[i].ignore_electrodes.split(",")
    start_time_usec = int(data.iloc[i].connectivity_start_time_seconds*1e6)
    stop_time_usec = int(data.iloc[i].connectivity_end_time_seconds*1e6)
    descriptor = data.iloc[i].descriptor
    #Output filename EEG
    outputpath_EEG_sub_ID = os.path.join(outputpath_EEG, "sub-{0}".format(sub_ID))
    if not (os.path.isdir(outputpath_EEG_sub_ID)): os.mkdir(outputpath_EEG_sub_ID)#if the path doesn't exists, then make the directory
    outputfile_EEG = "{0}/sub-{1}_{2}_{3}_{4}_EEG.pickle".format(outputpath_EEG_sub_ID, sub_ID, iEEG_filename, start_time_usec, stop_time_usec)
    print("\n\n\nID: {0}\nDescriptor: {1}".format(sub_ID, descriptor))
    if (os.path.exists(outputfile_EEG)):
        print("File already exists: {0}".format(outputfile_EEG))
    if not (os.path.exists(outputfile_EEG)):#if file already exists, don't run below
        get_iEEG_data(username,password,iEEG_filename, start_time_usec, stop_time_usec, ignore_electrodes, outputfile_EEG)


    

#%%












