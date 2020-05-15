"""
Date 2020.05.10
Andy Revell and Alex Silva
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Purpose:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Logic of code:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Input:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Output:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Example:


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Please use this naming convention

example:

"""
import numpy as np
import pandas as pd
import nibabel as nib


def by_atlas(electrode_coordinates_mni_path,atlas_path,mni_template_path,outputfile):
    """
    electrode_coordinates_mni_path='/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-RID0278/electrode_localization/sub-RID0278_electrode_coordinates_mni.csv'
    atlas_path='/Users/andyrevell/mount/TOOLS/atlases_and_templates/atlases/custom_atlases/random_atlases/whole_brain/RA_N1000/RA_N1000_Perm0001.nii.gz'
    outputfile='/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-RID0278/electrode_localization/electrode_localization_by_atlas/sub-RID0278_electrode_coordinates_mni_RA_N1000_Perm0001.csv'
    mni_template_path ='/Users/andyrevell/mount/TOOLS/atlases_and_templates/templates/MNI152_T1_1mm_brain.nii.gz'

    """
    #getting imaging data
    img = nib.load(atlas_path)
    img_data = img.get_fdata() #getting actual image data array
    aff = img.affine #get affine transformation in atals. Helps us convert real-world coordinates to voxel locations
    
    # read in the MNI
    aff_mni = nib.load(mni_template_path).affine
    aff_mni[0,:] = -1*aff_mni[0,:]
    #getting electrode coordinates data
    data = pd.read_csv(electrode_coordinates_mni_path, sep=",", header=None)
    data = data.iloc[:, range(0, 4)]
    column_names = ['electrode_name', "mni_x_coordinate", "mni_y_coordinate", "mni_z_coordinate", "region_number"]
    data = data.rename(columns={data.columns[0]:column_names[0], data.columns[1]:column_names[1], data.columns[2]:column_names[2], data.columns[3]:column_names[3]      })

    coordinates = np.array((data.iloc[:,range(1,4)])) #get the MNI real-world coordinates of electrodes
    #transform the real-world coordinates to the atals voxel space. Need to inverse the affine with np.linalg.inv(). To go from voxel to world, just input aff (dont inverse the affine)
    coordinates_voxels = nib.affines.apply_affine(np.linalg.inv(aff_mni), coordinates)
    coordinates_voxels = np.round(coordinates_voxels) #round to nearest voxel
    coordinates_voxels = coordinates_voxels.astype(int)

    img_ROI = img_data[coordinates_voxels[:,0]-1, coordinates_voxels[:,1]-1, coordinates_voxels[:,2]-1]
    img_ROI = np.reshape(img_ROI, [img_ROI.shape[0], 1])
    img_ROI = img_ROI.astype(int)
    img_ROI = pd.DataFrame(img_ROI)
    data =  pd.concat([data,img_ROI ] , axis=1)
    data = data.rename(columns={data.columns[4]:column_names[4]})
    pd.DataFrame.to_csv(data, outputfile, header=True, index=False)


def inside_or_outside_atlas(electrode_coordinates_mni_path,atlas_path,mni_template_path,classify_atlas_path,outputfile):
    """
    electrode_coordinates_mni_path='/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-RID0278/electrode_localization/sub-RID0278_electrode_coordinates_mni.csv'
    atlas_path='/Users/andyrevell/mount/TOOLS/atlases_and_templates/atlases/aal_res-1x1x1.nii.gz'
    outputfile='/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-RID0278/electrode_localization/electrode_localization_by_atlas/sub-RID0278_electrode_coordinates_mni_outside_outside_aal_res-1x1x1.csv'
    mni_template_path ='/Users/andyrevell/mount/TOOLS/atlases_and_templates/templates/MNI152_T1_1mm_brain.nii'

    """

    #getting imaging data
    img = nib.load(atlas_path)
    img_data = img.get_fdata() #getting actual image data array
    
    # read in the MNI
    aff_mni = nib.load(mni_template_path).affine
    aff_mni[0,:] = -1*aff_mni[0,:]
    
    # read in the classify atlas
    class_atlas = nib.load(classify_atlas_path)
    class_atlas_arr = class_atlas.get_fdata()
    
    #getting electrode coordinates data
    data = pd.read_csv(electrode_coordinates_mni_path, sep=",", header=None)
    data = data.iloc[:, range(0, 4)]
    column_names = ['electrode_name', "mni_x_coordinate", "mni_y_coordinate", "mni_z_coordinate", "region_number","in_Class_atlas"]
    data = data.rename(columns={data.columns[0]:column_names[0], data.columns[1]:column_names[1], data.columns[2]:column_names[2], data.columns[3]:column_names[3]      })

    coordinates = np.array((data.iloc[:,range(1,4)])) #get the MNI real-world coordinates of electrodes
    #transform the real-world coordinates to the atals voxel space. Need to inverse the affine with np.linalg.inv(). To go from voxel to world, just input aff (dont inverse the affine)
    coordinates_voxels = nib.affines.apply_affine(np.linalg.inv(aff_mni), coordinates)
    coordinates_voxels = np.round(coordinates_voxels) #round to nearest voxel
    coordinates_voxels = coordinates_voxels.astype(int)

    img_ROI = img_data[coordinates_voxels[:,0]-1, coordinates_voxels[:,1]-1, coordinates_voxels[:,2]-1]
    img_ROI = np.reshape(img_ROI, [img_ROI.shape[0], 1])
    img_ROI = img_ROI.astype(int)
    img_ROI = pd.DataFrame(img_ROI)
    data =  pd.concat([data,img_ROI ] , axis=1)
    data = data.rename(columns={data.columns[4]:column_names[4]})
    
    # now pull off whether it is in atlas
    in_atlas = class_atlas_arr[coordinates_voxels[:,0]-1, coordinates_voxels[:,1]-1, coordinates_voxels[:,2]-1]
    in_atlas = np.reshape(in_atlas, [in_atlas.shape[0], 1])
    in_atlas[in_atlas>1] = 1
    in_atlas = pd.DataFrame(in_atlas.astype(int))
    data = pd.concat([data,in_atlas], axis=1)
    data = data.rename(columns={data.columns[5]:column_names[5]})
    
    
    pd.DataFrame.to_csv(data, outputfile, header=True, index=False)


def distance_from_grayMatter(electrode_coordinates_mni_path, mni_template_path, tissue_segmentation_path, outputfile):
    """
    electrode_coordinates_mni_path='/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-RID0278/electrode_localization/sub-RID0278_electrode_coordinates_mni.csv'
    atlas_path='/Users/andyrevell/mount/TOOLS/atlases_and_templates/atlases/aal_res-1x1x1.nii.gz'
    outputfile='/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-RID0278/electrode_localization/electrode_localization_by_atlas/sub-RID0278_electrode_coordinates_mni_distance_to_white_matter.csv'
    tissue_segmentation_path ='/Users/andyrevell/mount/TOOLS/atlases_and_templates/atlases/tissue_res-1x1x1.nii.gz'

    """
       
    # read in the MNI
    aff_mni = nib.load(mni_template_path).affine
    aff_mni[0,:] = -1*aff_mni[0,:]
    
    # getting imaging data
    img = nib.load(tissue_segmentation_path)
    img_data = img.get_fdata()  # getting actual image data array
    
    # list of all grey matter points 
    greyInds = np.where((img_data == 1) | (img_data == 2))

    
    #getting electrode coordinates data
    data = pd.read_csv(electrode_coordinates_mni_path, sep=",", header=None)
    data = data.iloc[:, range(0, 4)]
    column_names = ['electrode_name', "mni_x_coordinate", "mni_y_coordinate", "mni_z_coordinate", "distance from grey matter"]
    data = data.rename(columns={data.columns[0]:column_names[0], data.columns[1]:column_names[1], data.columns[2]:column_names[2], data.columns[3]:column_names[3]      })

    coordinates = np.array((data.iloc[:,range(1,4)])) #get the MNI real-world coordinates of electrodes
    #transform the real-world coordinates to the atals voxel space. Need to inverse the affine with np.linalg.inv(). To go from voxel to world, just input aff (dont inverse the affine)
    coordinates_voxels = nib.affines.apply_affine(np.linalg.inv(aff_mni), coordinates)
    coordinates_voxels = np.round(coordinates_voxels) #round to nearest voxel
    coordinates_voxels = coordinates_voxels.astype(int)

    
    # Find distance to closest GM region
    # Classify 0 = inside GM.  -1 = outside brain. and float = distance.
    # Please consider Gray matter in tissue_res-1x1x1 categories as a 1 or 2. WM = category 3. Outside brain = category 0
    img_ROI = img_data[coordinates_voxels[:,0]-1, coordinates_voxels[:,1]-1, coordinates_voxels[:,2]-1]
    img_ROI = np.reshape(img_ROI, [img_ROI.shape[0], 1])
    img_ROI[img_ROI==0] = -1
    img_ROI[(img_ROI==1) | (img_ROI==2)] = 0

    for i in range(0,img_ROI.shape[0]):
        if(img_ROI[i]==3):
            minDist_coord = find_dist_to_grey(greyInds, coordinates_voxels[i,:]-1)
            img_ROI[i] = minDist_coord
    
                                              
    img_ROI = pd.DataFrame(img_ROI)
    data =  pd.concat([data,img_ROI ] , axis=1)
    data = data.rename(columns={data.columns[4]:column_names[4]})

    
 
    
    
    pd.DataFrame.to_csv(data, outputfile, header=True, index=False)
    


def find_dist_to_grey(greyPoints,whitePoint):
    for i in range(0,greyPoints[0].shape[0]):
        dist = np.sqrt((whitePoint[0]-greyPoints[0][i])**2 + (whitePoint[1]-greyPoints[1][i])**2 + (whitePoint[2]-greyPoints[2][i])**2)
        if(i==0):
            minDist = dist
        else: 
            if(dist<minDist):
                minDist = dist
    return(minDist)
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    # getting imaging data
    img = nib.load(tissue_segmentation_path)
    img_data = img.get_fdata()  # getting actual image data array
    aff = img.affine  # get affine transformation in atals. Helps us convert real-world coordinates to voxel locations

    # getting electrode coordinates data
    data = pd.read_csv(electrode_coordinates_mni_path, sep=",", header=None)
    data = data.iloc[:, range(0, 4)]
    column_names = ['electrode_name', "mni_x_coordinate", "mni_y_coordinate", "mni_z_coordinate", "neareset_GM_distance"]
    data = data.rename(columns={data.columns[0]: column_names[0], data.columns[1]: column_names[1],
                                data.columns[2]: column_names[2], data.columns[3]: column_names[3]})


    coordinates = np.array((data.iloc[:, range(1, 4)]))  # get the MNI real-world coordinates of electrodes
    # transform the real-world coordinates to the atals voxel space. Need to inverse the affine with np.linalg.inv(). To go from voxel to world, just input aff (dont inverse the affine)
    coordinates_voxels = nib.affines.apply_affine(np.linalg.inv(aff), coordinates)
    coordinates_voxels = np.round(coordinates_voxels)  # round to nearest voxel
    coordinates_voxels = coordinates_voxels.astype(int)

    # Find distance to closest GM region
    # Classify 0 = inside GM.  -1 = outside brain. and float = distance.
    # Please consider Gray matter in tissue_res-1x1x1 categories as a 1 or 2. WM = category 3. Outside brain = category 0

    pd.DataFrame.to_csv(data, outputfile, header=True, index=False)
