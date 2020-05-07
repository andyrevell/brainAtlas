""""
2020.04.06. Python 3.7

purpose:
To get iEEG data from iEEG.org. Note, you must download iEEG python package from GitHub - instructions are below
Gets time series data and sampling frequency information. Specified electrodes are removed.
Saves as a pickle format

input
    username: your iEEG.org username
    password: your iEEG.org password
    iEEG_filename: The file name on iEEG.org you want to download from
    start_time_usec: the start time in the iEEG_filename. In microseconds
    duration: the duration of data you want to download. In microseconds
    removed_channels: the channel names EXACT MATCH you want to exclude.
    outputfile: the path and filename you want to save. DO NOT INCLUDE EXTENSION.
        The extension is automatically pkl (pickle)

Example usage:

username = 'arevell'
password = ''
iEEG_filename='HUP138_phaseII'
start_time_usec = 415723190000
duration = 6000000
removed_channels = ['EKG1', 'EKG2', 'CZ', 'C3', 'C4', 'F3', 'F7', 'FZ', 'F4', 'F8', 'LF04', 'RC03', 'RE07', 'RC05', 'RF01', 'RF03', 'RB07', 'RG03', 'RF11', 'RF12']
outputfile = '/Users/andyrevell/Box/01_papers/test'

get_iEEG_data(username, password, iEEG_filename, start_time_usec, duration, removed_channels, outputfile)

#How to get back pickled files
with open('{0}.pkl'.format(outputfile), 'rb') as f:
    data, fs = pickle.load(f)
"""
from ieeg.auth import Session
import pandas as pd
import pickle

def get_iEEG_data(username, password, iEEG_filename, start_time_usec, duration, removed_channels, outputfile):
    s = Session(username, password)
    ds = s.open_dataset(iEEG_filename)
    channels = list(range(len(ds.ch_labels)))
    data = ds.get_data(start_time_usec, duration, channels)

    df = pd.DataFrame(data, columns=ds.ch_labels)
    df = pd.DataFrame.drop(df, removed_channels, axis=1)

    fs = ds.get_time_series_details(ds.ch_labels[0]).sample_rate #get sample rate
    file_name = '{0}.pkl'.format(outputfile)

    with open(file_name, 'wb') as f: pickle.dump([df, fs], f)


""""
Download and install iEEG python package - ieegpy
GitHub repository: https://github.com/ieeg-portal/ieegpy

If you downloaded this code from https://github.com/andyrevell/paper001.git then skip to step 2
1. Download/clone ieepy. 
    git clone https://github.com/ieeg-portal/ieegpy.git
2. Change directory to the GitHub repo
3. Install libraries to your python Path. If you are using a virtual environment (ex. conda), make sure you are in it
    a. Run:
        python setup.py build
    b. Run: 
        python setup.py install
              
""""