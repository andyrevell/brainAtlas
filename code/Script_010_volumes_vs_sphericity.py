"""
2020.06.10
Andy Revell
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Purpose: script to get electrode localization

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Logic of code:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Input:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Output:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Example:

python3.6 Script_010_volumes_vs_sphericity.py

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"""


#assumes current working directory is scripts directory
#%%
path = "/mnt"
import sys
import os
from os.path import join as ospj
sys.path.append(ospj(path, "paper001/code/tools"))
import volumes_sphericity_surface_area as vsSA
import pandas as pd

#%% Paths and File names
ifpath_atlases_standard = ospj( path, "data_raw/atlases/standard_atlases")
ifpath_atlases_random = ospj( path, "data_raw/atlases/random_atlases")
ofpath_volumes = ospj( path, "data_processed/volumes_and_sphericity/volumes")
ofpath_sphericity = ospj( path, "data_processed/volumes_and_sphericity/sphericity")

#%% Paramters
#number of random atlas permutations to run on
permutations = 1

atlas_names_standard = [f for f in sorted(os.listdir(ifpath_atlases_standard))]
atlas_names_random = [f for f in sorted(os.listdir(ifpath_atlases_random))]


#%%

#standard atlases: getting electrode localization by region
for a in range(len(atlas_names_standard)):
    ifname_atlases_standard = ospj(ifpath_atlases_standard, atlas_names_standard[a] )
    atlas_name = os.path.splitext(os.path.splitext(atlas_names_standard[a] )[0])[0]
    ofpath_volumes_atlas =  ospj(ofpath_volumes, atlas_name )
    ofpath_sphericity_atlas =  ospj(ofpath_sphericity, atlas_name )
    if not (os.path.isdir(ofpath_volumes_atlas)): os.mkdir(ofpath_volumes_atlas)
    if not (os.path.isdir(ofpath_sphericity_atlas)): os.mkdir(ofpath_sphericity_atlas)
    ofname_volumes = "{0}/{1}_volumes.csv".format(ofpath_volumes_atlas, atlas_name)
    ofname_sphericity = "{0}/{1}_sphericity.csv".format(ofpath_sphericity_atlas, atlas_name)
    print("\nAtlas: {0}".format(atlas_name))
    if not (os.path.exists(ofname_volumes)):#check if file exists
        print("Calculating Volumes: {0}".format(ofname_volumes))
        volumes = vsSA.get_region_volume(ifname_atlases_standard)
        pd.DataFrame.to_csv(volumes, ofname_volumes, header=True, index=False)
    else:
        print("File exists: {0}".format(ofname_volumes))
    if not (os.path.exists(ofname_sphericity)):#check if file exists
        print("Calculating Sphericity: {0}".format(ofname_sphericity))
        sphericity = vsSA.get_region_sphericity(ifname_atlases_standard)
        pd.DataFrame.to_csv(sphericity, ofname_sphericity, header=True, index=False)
        print("")#print new line due to overlap of next line with progress bar
    else:
        print("File exists: {0}".format(ofname_sphericity))
        
    
#random atlases: getting electrode localization by region
for a in range(len(atlas_names_random)):
    for p in range(1, permutations+1):
        ifname_atlases_random = ospj(ifpath_atlases_random, atlas_names_random[a], "{0}_v{1}.nii.gz".format(atlas_names_random[a], '{:04}'.format(p))  )
        atlas_name = os.path.splitext(os.path.splitext(atlas_names_random[a] )[0])[0]
        ofpath_volumes_atlas =  ospj(ofpath_volumes, atlas_name )
        ofpath_sphericity_atlas =  ospj(ofpath_sphericity, atlas_name )
        if not (os.path.isdir(ofpath_volumes_atlas)): os.mkdir(ofpath_volumes_atlas)
        if not (os.path.isdir(ofpath_sphericity_atlas)): os.mkdir(ofpath_sphericity_atlas)
        ofname_volumes = "{0}/{1}_volumes.csv".format(ofpath_volumes_atlas, atlas_name)
        ofname_sphericity = "{0}/{1}_sphericity.csv".format(ofpath_sphericity_atlas, atlas_name)
        print("\nAtlas: {0}".format(atlas_name))
        if not (os.path.exists(ofname_volumes)):#check if file exists
            print("Calculating Volumes: {0}".format(ofname_volumes))
            volumes = vsSA.get_region_volume(ifname_atlases_standard)
            pd.DataFrame.to_csv(volumes, ofname_volumes, header=True, index=False)
        else:
            print("File exists: {0}".format(ofname_volumes))
        if not (os.path.exists(ofname_sphericity)):#check if file exists
            print("Calculating Sphericity: {0}".format(ofname_sphericity))
            sphericity = vsSA.get_region_sphericity(ifname_atlases_standard)
            pd.DataFrame.to_csv(sphericity, ofname_sphericity, header=True, index=False)
            print("")#print new line due to overlap of next line with progress bar
        else:
            print("File exists: {0}".format(ofname_sphericity))
            

