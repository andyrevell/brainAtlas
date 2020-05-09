"""
2020.05.06
Andy Revell and Alex Silva
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Purpose:
    Calculate functional correlations between given time series data and channels.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Logic of code:
    1. Calculate correlations within a given time window: Window data in 1 second
    2. Calculate broadband functional connectivity with echobase broadband_conn
    3. Calculate other band functional connectivity with echobase multiband_conn
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Input:
    inputfile: a pickled list. See get_iEEG_data.py and https://docs.python.org/3/library/pickle.html for more information
        index 0: time series data N x M : row x column : time x channels
        index 1: fs, sampling frequency of time series data
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Output:
    Saves file outputfile as a pickel. For more info on pickeling, see https://docs.python.org/3/library/pickle.html
    Briefly: it is a way to save + compress data. it is useful for saving lists, as in a list of time series data and sampling frequency together along with channel names

    List index 0: ndarray. broadband. C x C x T. C: channels. T: times (1 second intervals). To change, see line 70: endInd = int(((t+1)*fs) - 1)
    List index 1: ndarray. alphatheta. C x C x T
    List index 2: ndarray. beta. C x C x T
    List index 3: ndarray. lowgamma. C x C x T
    List index 4: ndarray. highgamma. C x C x T
    List index 5: ndarray. C x _  Electrode row and column names. Stored here are the corresponding row and column names in the matrices above.
    List index 6: pd.DataFrame. N x 1. order of matrices in pickle file. The order of stored matrices are stored here to aid in transparency.
        Typically, the order in broadband, alphatheta, beta, lowgamma, highgamma

    To open the pickle file, use command:
    with open(outputfile, 'rb') as f: broadband, alphatheta, beta, lowgamma, highgamma, electrode_row_and_column_names, order_of_matrices_in_pickle_file = pickle.load(f)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Example:

inputfile = '/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-RID0278/eeg/sub-RID0278_HUP138_phaseII_248432340000_248525740000_EEG.pickle'
outputfile = '/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-RID0278/connectivity_matrices/functional/sub-RID0278_HUP138_phaseII_248432340000_248525740000_functionalConnectivity.pickle'
get_Functional_connectivity(inputfile,outputfile)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Please use this naming convention if data is from iEEG.org
sub-RIDXXXX_iEEGFILENAME_STARTTIME_STOPTIME_functionalConnectivity.pickle
example: 'sub-RID0278_HUP138_phaseII_248432340000_248525740000_functionalConnectivity.pickle'

"""
from echobase import broadband_conn, multiband_conn
import numpy as np
import pickle
import pandas as pd

""""
Note on Pycharm users to import echobase:
Right click the folder in which get_Functional_connectivity.py and echobase.py (MUST BE IN SAME DIRECTORY)
Select "Mark Directory As" --> "Mark as Source Root" 
Can also go to preferences --> Project structure to change source root 
"""

def get_Functional_connectivity(inputfile,outputfile):
    print("\n\nCalculating Functional Connectivity:")
    print("inputfile: {0}".format(inputfile))
    print("outputfile: {0}".format(outputfile))
    with open(inputfile, 'rb') as f: data, fs = pickle.load(f)#un-pickles files
    data_array = np.array(data)
    fs = float(fs)
    totalSecs = np.floor(np.size(data_array,0)/fs)
    totalSecs = int(totalSecs)
    alphatheta = np.zeros((np.size(data_array,1),np.size(data_array,1),totalSecs))
    beta = np.zeros((np.size(data_array,1),np.size(data_array,1),totalSecs))
    broadband = np.zeros((np.size(data_array,1),np.size(data_array,1),totalSecs))
    highgamma = np.zeros((np.size(data_array,1),np.size(data_array,1),totalSecs))
    lowgamma = np.zeros((np.size(data_array,1),np.size(data_array,1),totalSecs))
    for t in range(0,totalSecs):
        print("Calculating {0} out of {1} seconds".format(t+1, totalSecs))
        startInd = int(t*fs)
        endInd = int(((t+1)*fs) - 1) #calculating over 1 second windows
        window = data_array[startInd:endInd,:]
        broad = broadband_conn(window,int(fs),avgref=True)
        adj_alphatheta, adj_beta, adj_lowgamma, adj_highgamma = multiband_conn(window,int(fs),avgref=True)
        alphatheta[:,:,t] = adj_alphatheta
        beta[:,:,t] = adj_beta
        broadband[:,:,t] = broad
        highgamma[:,:,t] = adj_highgamma
        lowgamma[:,:,t] = adj_lowgamma
    print("Saving to: {0}".format(outputfile))
    electrode_row_and_column_names = data.columns.values
    order_of_matrices_in_pickle_file = pd.DataFrame(["broadband", "alphatheta", "beta", "lowgamma" , "highgamma" ], columns=["Order of matrices in pickle file"])
    with open(outputfile, 'wb') as f: pickle.dump([broadband, alphatheta, beta, lowgamma, highgamma, electrode_row_and_column_names, order_of_matrices_in_pickle_file], f)
    #np.savez(outputfile, broadband=broadband, alphatheta=alphatheta, beta=beta, lowgamma=lowgamma, highgamma=highgamma)
    print("...done\n\n")
