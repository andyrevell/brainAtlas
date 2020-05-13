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
    print(aff)
    
    # read in the MNI
    aff_mni = nib.load(mni_template_path).affine
    aff_mni[0,:] = -1*aff_mni[0,:]
    print(aff_mni)
    #getting electrode coordinates data
    data = pd.read_csv(electrode_coordinates_mni_path, sep=",", header=None)
    data = data.iloc[:, range(0, 4)]
    column_names = ['electrode_name', "mni_x_coordinate", "mni_y_coordinate", "mni_z_coordinate", "region_number"]
    data = data.rename(columns={data.columns[0]:column_names[0], data.columns[1]:column_names[1], data.columns[2]:column_names[2], data.columns[3]:column_names[3]      })

    coordinates = np.array((data.iloc[:,range(1,4)])) #get the MNI real-world coordinates of electrodes
    #transform the real-world coordinates to the atals voxel space. Need to inverse the affine with np.linalg.inv(). To go from voxel to world, just input aff (dont inverse the affine)
    coordinates_voxels = nib.affines.apply_affine(np.linalg.inv(aff_mni), coordinates)
    coordinates_voxels = np.round(coordinates_voxels) #round to nearest voxel
    print(coordinates_voxels)
    coordinates_voxels = coordinates_voxels.astype(int)

    img_ROI = img_data[coordinates_voxels[:,0]-1, coordinates_voxels[:,1]-1, coordinates_voxels[:,2]-1]
    img_ROI = np.reshape(img_ROI, [img_ROI.shape[0], 1])
    img_ROI = img_ROI.astype(int)
    img_ROI = pd.DataFrame(img_ROI)
    data =  pd.concat([data,img_ROI ] , axis=1)
    data = data.rename(columns={data.columns[4]:column_names[4]})
    pd.DataFrame.to_csv(data, outputfile, header=True, index=False)


def inside_or_outside_atlas(electrode_coordinates_mni_path, atlas_path, mni_template_path, outputfile):
    """
    electrode_coordinates_mni_path='/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-RID0278/electrode_localization/sub-RID0278_electrode_coordinates_mni.csv'
    atlas_path='/Users/andyrevell/mount/TOOLS/atlases_and_templates/atlases/aal_res-1x1x1.nii.gz'
    outputfile='/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-RID0278/electrode_localization/electrode_localization_by_atlas/sub-RID0278_electrode_coordinates_mni_outside_outside_aal_res-1x1x1.csv'
    mni_template_path ='/Users/andyrevell/mount/TOOLS/atlases_and_templates/templates/MNI152_T1_1mm_brain.nii'

    """
    # getting imaging data
    img = nib.load(atlas_path)
    img_data = img.get_fdata()  # getting actual image data array
    aff_img = img.affine  # get affine transformation in atals. Helps us convert real-world coordinates to voxel locations

    mni = nib.load(mni_template_path)
    mni_data = img.get_fdata()  # getting actual image data array
    aff_mni = img.affine

    # getting electrode coordinates data
    data = pd.read_csv(electrode_coordinates_mni_path, sep=",", header=None)
    data = data.iloc[:, range(0, 4)]
    column_names = ['electrode_name', "mni_x_coordinate", "mni_y_coordinate", "mni_z_coordinate", "inside_or_outside"]
    data = data.rename(columns={data.columns[0]: column_names[0], data.columns[1]: column_names[1],
                                data.columns[2]: column_names[2], data.columns[3]: column_names[3]})

    coordinates = np.array((data.iloc[:, range(1, 4)]))  # get the MNI real-world coordinates of electrodes
    # transform the real-world coordinates to the atals voxel space. Need to inverse the affine with np.linalg.inv(). To go from voxel to world, just input aff (dont inverse the affine)
    coordinates_voxels = nib.affines.apply_affine(np.linalg.inv(aff_img), coordinates)
    coordinates_voxels = np.round(coordinates_voxels)  # round to nearest voxel
    coordinates_voxels = coordinates_voxels.astype(int)
    # find which region # is associated with each electrode (voxel) coodinate
    img_ROI = img_data[coordinates_voxels[:, 0], coordinates_voxels[:, 1], coordinates_voxels[:, 2]]
    img_ROI = np.reshape(img_ROI, [img_ROI.shape[0], 1])
    img_ROI = img_ROI.astype(int)
    img_ROI = pd.DataFrame(img_ROI)
    data = pd.concat([data, img_ROI], axis=1)
    data = data.rename(columns={data.columns[4]: column_names[4]})
    pd.DataFrame.to_csv(data, outputfile, header=True, index=False)

    #find whther coodinate is inside atlas, outside atlas, or outside brain.
    #Output classifications: "inside", "outside", "outside_brain". The fifth column of data should be filled with these three string categories
    # use the MNI template to determine if outside brain. Use AAL atlas to determine if inside or outside that atlas.


def distance_from_grayMatter(electrode_coordinates_mni_path, tissue_segmentation_path, outputfile):
    """
    electrode_coordinates_mni_path='/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-RID0278/electrode_localization/sub-RID0278_electrode_coordinates_mni.csv'
    atlas_path='/Users/andyrevell/mount/TOOLS/atlases_and_templates/atlases/aal_res-1x1x1.nii.gz'
    outputfile='/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-RID0278/electrode_localization/electrode_localization_by_atlas/sub-RID0278_electrode_coordinates_mni_distance_to_white_matter.csv'
    tissue_segmentation_path ='/Users/andyrevell/mount/TOOLS/atlases_and_templates/atlases/tissue_res-1x1x1.nii.gz'

    """
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
