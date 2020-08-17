# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import nibabel as nib 
import numpy as np 
from sklearn.linear_model import LinearRegression
from scipy.io import loadmat,savemat
import pandas as pd 
import os


def get_centroids(atlas_path):
    
    img = nib.load(atlas_path)
    img_data = img.get_fdata()
    
    # get dimensions 
    dims = img_data.shape
    
    # convert to x y z value format
    points = np.zeros((dims[0]*dims[1]*dims[2],4))
    count = 0
    for i in range(0,dims[0]):
        for j in range(0,dims[1]):
            for k in range(0,dims[2]):
                points[count,:] = [i,j,k,img_data[i,j,k]]
                count = count + 1
    
    # pull unique regions 
    regions = np.unique(img_data.flatten())
    
    # if one of unique regions is zero we want to delete it 
    if(regions[0]==0):
        regions = np.delete(regions,0)
    
    centroids = np.zeros((regions.shape[0],3))
    
    # here is where we compute the mean center of mass (centroid) first order
    for i in range(0,regions.shape[0]):
        pointsint = points[points[:,3]==regions[i],0:3]
        centroids[i,:] = [np.mean(pointsint[:,0]),np.mean(pointsint[:,1]),np.mean(pointsint[:,2])]
        
    
    
    return(centroids)

def create_pairwise_dist_matrix(atlas_path):
    centroids = get_centroids(atlas_path)
    # loop over centroids and compute pairwise distance 
    dist_matrix = np.zeros((centroids.shape[0],centroids.shape[0]))
    for i in range(0,centroids.shape[0]):
        for j in range(0,centroids.shape[0]):
            point_1 = centroids[i,:]
            point_2 = centroids[j,:]
            dist_matrix[i,j] = np.sqrt((point_1[0]-point_2[0])**2 + (point_1[1]-point_2[1])**2 + (point_1[2]-point_2[2])**2)
    
    
    return(dist_matrix)
            
    
    
    
    
    

def regress_dist_from_structural(conn_matrix_path,atlas_path):
    
    # get the distance matrix 
    dist_matrix = create_pairwise_dist_matrix(atlas_path)
    
    # get the connectivity matrix 
    struc = np.array(pd.DataFrame(loadmat(conn_matrix_path)['connectivity']))
    struc[struc == 0] = 1;
    struc = np.log10(struc) 
    #struc = struc/np.max(struc)
    inds = np.tril_indices(struc.shape[0],-1)
    struc_plot = struc[inds].reshape(-1,1)
    dist_plot = dist_matrix[inds].reshape(-1,1)
    # fit linear model and take residuals 
    model = LinearRegression().fit(dist_plot,struc_plot)
    preds = model.predict(dist_matrix.flatten().reshape(-1,1))
    residuals = struc.flatten().reshape(-1,1) - preds
    residuals = np.reshape(residuals,struc.shape)
    return(residuals)
    
    
def batch_regress_dist_from_structural_per_sub(sub_ID):

    BIDS_proccessed_directory="/gdrive/public/DATA/Human_Data/BIDS_processed"
    #Random Atlases
    atlas_folder=['RA_N0010', 'RA_N0030', 'RA_N0050', 'RA_N0075','RA_N0100','RA_N0200',
                  'RA_N0300', 'RA_N0400', 'RA_N0500' , 'RA_N0750', 'RA_N1000', 'RA_N2000']
    atlas_dir = "/gdrive/public/TOOLS/atlases_and_templates/atlases/custom_atlases/random_atlases/whole_brain"
    for a in range(len(atlas_folder)):
        outputfile_directory = "{0}/sub-{1}/connectivity_matrices/structural_regress_distance/{2}".format(BIDS_proccessed_directory,sub_ID,atlas_folder[a])
        print('Output directory: {0}'.format(outputfile_directory))
        perm = list(range(1, 31))
        for p in range(len(perm)):
            structure_file_name= 'sub-{0}_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz.trk.gz.{1}_Perm{2}.count.pass.connectivity.mat'.format(sub_ID, atlas_folder[a], '{:04}'.format(perm[p])  )
            structure_file_path =  "{0}/sub-{1}/connectivity_matrices/structural/{2}/{3}".format(BIDS_proccessed_directory,sub_ID,atlas_folder[a],structure_file_name)
            atlas_file_path = "{0}/{1}/{1}_Perm{2}.nii.gz".format(atlas_dir,atlas_folder[a],'{:04}'.format(perm[p]))
            outputfile = '{0}/{1}'.format(outputfile_directory, structure_file_name)
            #Making sure files exist
            if (os.path.exists(structure_file_path))==False:
                print('{0} does not exist'.format(structure_file_path))
            elif (os.path.exists(outputfile_directory))==False:
                print('{0} does not exist'.format(outputfile_directory))
                os.mkdir(outputfile_directory)
                adj_struc = regress_dist_from_structural(structure_file_path, atlas_file_path)
                to_save = {"connectivity":adj_struc}
                savemat(outputfile,to_save)
            else:
                adj_struc = regress_dist_from_structural(structure_file_path, atlas_file_path)
                to_save = {"connectivity":adj_struc}
                savemat(outputfile,to_save)
 
    stand_atlas_path = "/gdrive/public/TOOLS/atlases_and_templates/atlases"
    #Standard Atlases
    atlas_folder=['aal_res-1x1x1', 'AAL600', 'CPAC200_res-1x1x1', 'desikan_res-1x1x1','DK_res-1x1x1','JHU_res-1x1x1',
                  'Schaefer2018_100Parcels_17Networks_order_FSLMNI152_1mm', 'Schaefer2018_200Parcels_17Networks_order_FSLMNI152_1mm',
                  'Schaefer2018_300Parcels_17Networks_order_FSLMNI152_1mm' , 'Schaefer2018_400Parcels_17Networks_order_FSLMNI152_1mm',
                  'Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_1mm', 'Talairach_res-1x1x1','JHU_aal_combined_res-1x1x1'
                  ]
    for a in range(len(atlas_folder)):
        outputfile_directory = "{0}/sub-{1}/connectivity_matrices/structural_regress_distance/{2}".format(BIDS_proccessed_directory,sub_ID,atlas_folder[a])
        print('Output directory: {0}'.format(outputfile_directory))
        structure_file_name= 'sub-{0}_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz.trk.gz.{1}.count.pass.connectivity.mat'.format(sub_ID, atlas_folder[a])
        structure_file_path =  "{0}/sub-{1}/connectivity_matrices/structural/{2}/{3}".format(BIDS_proccessed_directory,sub_ID,atlas_folder[a],structure_file_name)
        atlas_file_path = "{0}/{1}.nii.gz".format(stand_atlas_path,atlas_folder[a])
        outputfile = '{0}/{1}'.format(outputfile_directory, structure_file_name)
        #Making sure files exist
        if (os.path.exists(structure_file_path))==False:
            print('{0} does not exist'.format(structure_file_path))
        elif (os.path.exists(outputfile_directory))==False:
            print('{0} does not exist'.format(outputfile_directory))
            os.mkdir(outputfile_directory)
            adj_struc = regress_dist_from_structural(structure_file_path, atlas_file_path)
            to_save = {"connectivity":adj_struc}
            savemat(outputfile,to_save)
        else:
            adj_struc = regress_dist_from_structural(structure_file_path, atlas_file_path)
            to_save = {"connectivity":adj_struc}
            savemat(outputfile,to_save)               
                
                
    
    
    
    
    
    
    