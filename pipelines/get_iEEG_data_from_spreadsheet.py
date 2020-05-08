"""
2020.05.08 Andy Revell
Purpose: Get iEEG data entries in a text spreadsheet. See paper001/data/raw for spreadsheet example. Uses get_iEEG_data.py.

Please remember to removed your password.
Store password in file called password in pipelines (paper001/pipelines/password). .gitignore should ignore this files if you name it exactly
Run this:
password = open('paper001/pipelines/password.txt','r'); password = password.read()
"""

import get_iEEG_data
directory = '/gdrive/public/DATA/Human_Data/BIDS_processed'

username = 'arevell'
password = open('paper001/pipelines/password.txt','r'); password = password.read()
ID = 'RID0278'
iEEG_filename = 'HUP138_phaseII'
ignore_electrodes = ['EKG1', 'EKG2', 'CZ', 'C3', 'C4', 'F3', 'F7', 'FZ', 'F4', 'F8', 'LF04', 'RC03', 'RE07', 'RC05', 'RF01', 'RF03', 'RB07', 'RG03', 'RF11', 'RF12']
start_time_usec = 248432340000
duration = 93400000
outfile = '{0}/sub-{1}/eeg/sub-{1}_{2}_{3}_{4}_timeseries.pickle'.format(directory,ID,iEEG_filename, start_time_usec,duration )
get_iEEG_data(username, password, iEEG_filename, start_time_usec, duration,ignore_electrodes, outfile)




