# -*- coding: utf-8 -*-
"""
Created on Wed May 20 11:09:06 2020

@author: asilv
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
    structure_file_path= '/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-RID0536/connectivity_matrices/structural/RA_N0100/sub-RID0536_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz.trk.gz.RA_N0100_Perm0001.count.pass.connectivity.mat'
    electrode_localization_by_atlas_file_path = '/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-RID0536/electrode_localization/electrode_localization_by_atlas/sub-RID0536_electrode_coordinates_mni_RA_N0100_Perm0001.csv'
       
    #seizure 3
    #pre-ictal 
    function_file_path = '/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-RID0536/connectivity_matrices/functional/eeg/sub-RID0536_HUP195_phaseII_D01_250573896890_250710930770_functionalConnectivity.pickle'
    #ictal 
    function_file_path = '/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-RID0536/connectivity_matrices/functional/eeg/sub-RID0536_HUP195_phaseII_D01_250710930770_250847964650_functionalConnectivity.pickle'
    #postictal 
    function_file_path = '/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-RID0536/connectivity_matrices/functional/eeg/sub-RID0536_HUP195_phaseII_D01_250847964650_251027964650_functionalConnectivity.pickle'
    
    #Output Files:
    #pre-ictal
    outputfile = '/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-RID0536/connectivity_matrices/structure_function_correlation/RA_N0100/sub-RID0536_HUP195_phaseII_D01_250573896890_250710930770_RA_N0100_Perm0001_correlation.pickle'
    #ictal 
    outputfile = '/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-RID0536/connectivity_matrices/structure_function_correlation/RA_N0100/sub-RID0536_HUP195_phaseII_D01_250710930770_250847964650_RA_N0100_Perm0001_correlation.pickle'
    #postictal 
    outputfile = '/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-RID0536/connectivity_matrices/structure_function_correlation/RA_N0100/sub-RID0536_HUP195_phaseII_D01_250847964650_251027964650_RA_N0100_Perm0001_correlation.pickle'
    
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
    
