#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Aug 30 17:22:25 2020

@author: andyrevell
"""
import numpy as np
import nibabel as nib
import os
import seaborn as sns
path = "/mnt"
ifname = os.path.join(path, "data_raw/atlases_for_figures/Melbourne_Childrens_Regional_Infant_Brain_atlas/M-CRIB_orig_P01_parc.nii.gz")
output = os.path.join(path,"data_raw/atlases_for_figures/Melbourne_Childrens_Regional_Infant_Brain_atlas/M-CRIB_orig_P01_parc_edited.nii.gz")
img = nib.load(ifname)
data = img.get_fdata()

#%%

labels_to_replace = [2, 4, 14, 15, 24, 41, 43]

for i in range(len(labels_to_replace)):
    replace = np.where(data == labels_to_replace[i])
    data[replace] = 0
    


tmp = data[:,150,:]

sns.heatmap(tmp)


#renumber 

labels = np.unique(data)
count = 0

for i in range(len(labels)):
    replace = np.where(data == labels[i])
    data[replace] = count
    count = count + 1
    
    
np.unique(data)


new_img = nib.Nifti1Image(data, img.affine, img.header)

nib.save(new_img, output)



img.header


path = "/Users/andyrevell/deepLearner/home/arevell/Documents/01_papers/paper001"
atlas = "AAL.nii"
ifname = os.path.join(path, "data_raw/atlases/original", atlas)
img = nib.load(ifname)
data = img.get_fdata()

data.shape



np.max(data)
