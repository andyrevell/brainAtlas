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

import numpy as np
import pickle
import pandas as pd
from scipy.io import loadmat #fromn scipy to read mat files (structural connectivity)
from scipy.stats import spearmanr, pearsonr
import matplotlib.pyplot as plt


def SFC(structure_file_path,function_file_path,electrode_localization_by_atlas_file_path, outputfile):
    """
    :param structure_file_path:
    :param function_file_path:
    :param electrode_localization_by_atlas_file_path:
    :return:
    """

    """
    
    #Example:

    sub_ID='RID0309'
    iEEG_filename="HUP151_phaseII"
    start_times_array=[494702000000]
    stop_times_array=[494776000000]

    atlas_folder = 'RA_N0100'
    perm = 1
    structure_file_path= '/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-{0}/connectivity_matrices/structural/{1}/sub-{0}_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz.trk.gz.{1}_Perm{2}.count.pass.connectivity.mat'.format(sub_ID,atlas_folder,'{:04}'.format(perm))
    electrode_localization_by_atlas_file_path = '/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-{0}/electrode_localization/electrode_localization_by_atlas/sub-{0}_electrode_coordinates_mni_{1}_Perm{2}.csv'.format(sub_ID,atlas_folder,'{:04}'.format(perm))

    function_file_path = '/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-{0}/connectivity_matrices/functional/eeg/sub-{0}_{1}_{2}_{3}_functionalConnectivity.pickle'.format(sub_ID,iEEG_filename,start_times_array[0],stop_times_array[0])

    #Output Files:
    outputfile = '/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-{0}/connectivity_matrices/structure_function_correlation/{1}/sub-{0}_{2}_{3}_{4}_{1}_Perm{5}_correlation.pickle'.format(sub_ID,atlas_folder, iEEG_filename, start_times_array[0],stop_times_array[0],'{:04}'.format(perm))

    """
    #Get functional connecitivty data in pickle file format
    with open(function_file_path, 'rb') as f: broadband, alphatheta, beta, lowgamma, highgamma, electrode_row_and_column_names, order_of_matrices_in_pickle_file = pickle.load(f)
    FC_list = [broadband, alphatheta, beta, lowgamma,highgamma ]

    # set up the dataframe of electrodes to analyze
    final_electrodes = pd.DataFrame(electrode_row_and_column_names,columns=['electrode_name'])
    final_electrodes = final_electrodes.reset_index()
    final_electrodes = final_electrodes.rename(columns={"index": "func_index"})

    #Get Structural Connectivity data in mat file format. Output from DSI studio
    structural_connectivity_array = np.array(pd.DataFrame(loadmat(structure_file_path)['connectivity']))

    #Get electrode localization by atlas csv file data. From get_electrode_localization.py
    electrode_localization_by_atlas = pd.read_csv(electrode_localization_by_atlas_file_path)

    # normalizing and log-scaling the structural matrices
    structural_connectivity_array[structural_connectivity_array == 0] = 1;
    structural_connectivity_array = np.log10(structural_connectivity_array)  # log-scaling. Converting 0s to 1 to avoid taking log of zeros
    structural_connectivity_array = structural_connectivity_array / np.max(structural_connectivity_array)  # normalization

    #Only consider electrodes that are in both the localization and the pickle file
    final_electrodes = final_electrodes.merge(electrode_localization_by_atlas.iloc[:,[0,4]],on='electrode_name')
    # Remove electrodes in the Functional Connectivity matrices that have a region of 0
    final_electrodes = final_electrodes[final_electrodes['region_number']!=0]
    for i in range(len(FC_list)):
       FC_list[i] = FC_list[i][final_electrodes['func_index'],:,:]
       FC_list[i] = FC_list[i][:,final_electrodes['func_index'], :]

    #Fisher z-transform of functional connectivity data. This is to take means of correlations and do correlations to the structural connectivity
    #Fisher z transform is just arctanh
    for i in range(len(FC_list)):
       FC_list[i] = np.arctanh(FC_list[i])

    # Remove structural ROIs not in electrode_localization ROIs
    electrode_ROIs = np.unique(np.array(final_electrodes.iloc[:,2]))
    electrode_ROIs = electrode_ROIs[~(electrode_ROIs == 0)] #remove region 0
    structural_index = electrode_ROIs - 1 #subtract 1 because of python's zero indexing
    structural_connectivity_array = structural_connectivity_array[structural_index,:]
    structural_connectivity_array = structural_connectivity_array[:,structural_index]

    #taking average functional connectivity for those electrodes in same atlas regions
    for i in range(len(FC_list)):
       ROIs = np.array( final_electrodes.iloc[:,2])
       for r in range(len(electrode_ROIs)):
           index_logical = (ROIs == electrode_ROIs[r])
           index_first = np.where(index_logical)[0][0]
           index_second_to_end = np.where(index_logical)[0][1:]
           mean = np.mean(FC_list[i][index_logical,:,:], axis=0)
           # Fill in with mean.
           FC_list[i][index_first,:,:] = mean
           FC_list[i][:, index_first, :] = mean
           #delete the other rows and oclumns belonging to same region.
           FC_list[i] = np.delete(FC_list[i], index_second_to_end, axis=0)
           FC_list[i] = np.delete(FC_list[i], index_second_to_end, axis=1)
           #keeping track of which electrode labels correspond to which rows and columns
           ROIs = np.delete(ROIs, index_second_to_end, axis=0)
       #remove electrodes in the ROI labeld as zero
       index_logical = (ROIs == 0)
       index = np.where(index_logical)[0]
       FC_list[i] = np.delete(FC_list[i], index, axis=0)
       FC_list[i] = np.delete(FC_list[i], index, axis=1)
       ROIs = np.delete(ROIs, index, axis=0)


    #order FC matrices by ROIs
    order = np.argsort(ROIs)
    for i in range(len(FC_list)):
       FC_list[i] = FC_list[i][order,:,:]
       FC_list[i] = FC_list[i][:, order, :]

    #un-fisher ztranform
    for i in range(len(FC_list)):
       FC_list[i] = np.tanh(FC_list[i])


    #initialize correlation arrays
    Corrrelation_list = [None] * len(FC_list)
    for i in range(len(FC_list)):
       Corrrelation_list[i] = np.zeros(  [FC_list[0].shape[2]], dtype=float)

    correlation_type = 'spearman'
    #calculate Structure-Function Correlation.
    for i in range(len(FC_list)):
       for t in range(FC_list[i].shape[2]-1):
           #Spearman Rank Correlation: functional connectivity and structural connectivity are non-normally distributed. So we should use spearman
           if correlation_type == 'spearman':
               Corrrelation_list[i][t] = spearmanr(  np.ndarray.flatten(FC_list[i][:,:,t]) , np.ndarray.flatten(structural_connectivity_array)   ).correlation
               #print("spearman")
           # Pearson Correlation: This is calculated bc past studies use Pearson Correlation and we want to see if these results are comparable.
           if correlation_type == 'pearson':
               Corrrelation_list[i][t] = pearsonr(np.ndarray.flatten(FC_list[i][:, :, t]), np.ndarray.flatten(structural_connectivity_array))[0]




    order_of_matrices_in_pickle_file = pd.DataFrame(["broadband", "alphatheta", "beta", "lowgamma" , "highgamma" ], columns=["Order of matrices in pickle file"])
    with open(outputfile, 'wb') as f: pickle.dump([Corrrelation_list[0], Corrrelation_list[1], Corrrelation_list[2], Corrrelation_list[3], Corrrelation_list[4], order_of_matrices_in_pickle_file], f)



"""    
#Vizualizing distributions of raw data:
fig, axs = plt.subplots(2,1)
axs[0].hist( np.ndarray.flatten( np.array(structural_connectivity_array)), bins = 40 )
axs[0].title.set_text('Structural Streamline Counts Distribution')
axs[0].set_xlabel('Log normalized Stremline Counts (only ones in electrode regions)')
axs[0].set_ylabel('Frequency')
axs[1].hist(np.ndarray.flatten(np.array(  np.arctanh(broadband)  )), bins=40)
axs[1].title.set_text('BroadBand Cross Correlation Distribution')
axs[1].set_xlabel('Cross Correlation Fisher Z transform')
axs[1].set_ylabel('Frequency')
plt.show()
#Notes: streamline counts seems to have a HEAVY right skew distribution: Okay for correlating Structure and Function distirbutions with just a pearson correlation? Should do spearman rank

#visualize structure-function correlation on a correlational line
x = np.ndarray.flatten(structural_connectivity_array)
i = 0
t=0
y = np.ndarray.flatten(FC_list[i][:,:,t]) 
fig, axs = plt.subplots(1,1)
axs.scatter(x, y )
axs.axes.set_xlim(-0.1,1)
axs.axes.set_ylim(0, 1)
axs.title.set_text('')
axs.set_xlabel('Structural Correlation')
axs.set_ylabel('Functional Correlation')
plt.show()


# visualize structure-function correlation by time
i = 0
x = range(len(Corrrelation_list[i]))
y = np.ndarray.flatten(Corrrelation_list[i])
fig, axs = plt.subplots(1, 1)
axs.scatter(x, y)
#axs.axes.set_xlim(-0.1, 1)
axs.axes.set_ylim(0.1, 0.6)
axs.title.set_text('')
axs.set_xlabel('')
axs.set_ylabel('')
plt.show()
    

#save FC_list for vizualization
# seizure 3
# pre-ictal
outputfile_FC_list = '/Users/andyrevell/mount/USERS/arevell/papers/paper001/data_processed/supplemental_data/sub-RID0278_HUP138_phaseII_415933490000_416023190000_RA_N1000_Perm0001_matrices_window0.20.pickle'
# ictal
outputfile_FC_list = '/Users/andyrevell/mount/USERS/arevell/papers/paper001/data_processed/supplemental_data/sub-RID0278_HUP138_phaseII_416023190000_416112890000_RA_N1000_Perm0001_matrices_window0.20.pickle'
# postictal
outputfile_FC_list = '/Users/andyrevell/mount/USERS/arevell/papers/paper001/data_processed/supplemental_data/sub-RID0278_HUP138_phaseII_416112890000_416292890000_RA_N1000_Perm0001_matrices_window0.20.pickle'

order_of_matrices_in_pickle_file = pd.DataFrame(["broadband", "alphatheta", "beta", "lowgamma" , "highgamma", "structural" ], columns=["Order of matrices in pickle file"])
with open(outputfile_FC_list, 'wb') as f: pickle.dump([FC_list[0], FC_list[1], FC_list[2], FC_list[3], FC_list[4],structural_connectivity_array, ROIs, order_of_matrices_in_pickle_file], f)

"""


