#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Aug 31 12:29:50 2020

@author: andyrevell
"""
#%%

import os
import numpy as np
import nibabel as nib
path = "/mnt"
ifpath = os.path.join(path, "data_raw/atlases/original_atlases_from_source")
reference = os.path.join(ifpath, "MNI-maxprob-thr25-1mm.nii.gz")
identity_matrix = os.path.join("data_raw/atlases/atlas_labels_description", "identity_matrix_to_transform_atlases_to_1mm_MNI152_space.mat")#NOTE: the identity file is a txt file, NOT a matlab file. it is just a numpy.identity(4) matrix. 

ofpath = os.path.join(path,"data_raw/atlases/standard_atlases")
ofpath_canonical = os.path.join(path,"data_raw/atlases/original_atlases_in_RAS_orientation")
#%%

atlases = [f for f in sorted(os.listdir(ifpath))]

for i in range(len(atlases)):
    atlas = atlases[i]
    print("\n\n")
    print(atlas)
    ifname = os.path.join(ifpath, atlas)
    ofname = os.path.join(ofpath,atlas )
    
    ofname_canonical = os.path.join(ofpath_canonical,atlas )
    
    img = nib.load(ifname)
    data = img.get_fdata() 
    print(nib.aff2axcodes(img.affine))
    img_canonical = nib.as_closest_canonical(img)
    print(nib.aff2axcodes(img_canonical.affine))

    #Yeo images are 256 x 256x 256 x 1 --> removing that extra dimension
    if len(data.shape) ==4:
        print("reshaping image from {0} dimension to {1}".format(data.shape, (data.shape[0],data.shape[1],data.shape[2]) ))
        img_3D = nib.funcs.four_to_three(img_canonical)[0]
        print(nib.aff2axcodes(img_3D.affine))
        print("saving {0}".format(ofname_canonical))
        nib.save(img_3D, ofname_canonical)
    else:
        print("saving {0}".format(ofname_canonical))
        nib.save(img_canonical, ofname_canonical)


img_canonical

img_c = nib.load(ofname_canonical)
print(nib.aff2axcodes(img_c.affine))

img_standard = nib.load(ofname)
print(nib.aff2axcodes(img_standard.affine))
img_canonical = nib.as_closest_canonical(img)


    cmd = "flirt -in {0} -ref {1} -out {2} -applyxfm -init {3} -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12 -interp nearestneighbour".format(ofname_canonical, reference, ofname, identity_matrix)
    os.system(cmd)
