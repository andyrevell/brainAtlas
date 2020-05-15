"""
2020.05.12
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

"""

import get_electrode_localization
import pickle
import numpy as np
import os

#Random Atlases
sub_ID='RID0278'
BIDS_directory = '/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed'
mni_template_directory = '/Users/andyrevell/mount/TOOLS/atlases_and_templates/templates'
atlas_directory = '/Users/andyrevell/mount/TOOLS/atlases_and_templates/atlases/custom_atlases/random_atlases/whole_brain'
atlas_folder=['RA_N0010', 'RA_N0030', 'RA_N0050', 'RA_N0075','RA_N0100','RA_N0200','RA_N0300', 'RA_N0400', 'RA_N0500' , 'RA_N0750', 'RA_N1000', 'RA_N2000']
perm = list(range(1,31))


mni_template_path = '{0}/MNI152_T1_1mm_brain.nii.gz'.format(mni_template_directory)
electrode_coordinates_mni_path = '{0}/sub-{1}/electrode_localization/sub-{1}_electrode_coordinates_mni.csv'.format(BIDS_directory,sub_ID, )
os.path.exists(mni_template_path)
os.path.exists(electrode_coordinates_mni_path)

output_directory = '{0}/sub-{1}/electrode_localization/electrode_localization_by_atlas'.format(BIDS_directory,sub_ID)
print('Saving files to {0}'.format(output_directory))
for i in range(len(atlas_folder)):
    for p in range(len(perm)):
        atlas_path = '{0}/{1}/{1}_Perm{2}.nii.gz'.format(atlas_directory, atlas_folder[i], '{:04}'.format(perm[p]) )
        #print(atlas_path)
        if (os.path.exists(atlas_path)):
            if (os.path.exists(output_directory)):
                file_name = 'sub-{0}_electrode_coordinates_mni_{1}_Perm{2}.csv'.format(sub_ID, atlas_folder[i], '{:04}'.format(perm[p]))
                outputfile = '{0}/{1}'.format(output_directory,file_name)
                print('Saving: {0}'.format(file_name))
                get_electrode_localization.by_atlas(electrode_coordinates_mni_path, atlas_path, mni_template_path, outputfile)
            else:
                print('{0} directory does not exist'.format(output_directory))
        else:
            print('{0} directory does not exist'.format(atlas_path))



#Standard Atlases
sub_ID='RID0278'
BIDS_directory = '/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed'
mni_template_directory = '/Users/andyrevell/mount/TOOLS/atlases_and_templates/templates'
atlas_directory = '/Users/andyrevell/mount/TOOLS/atlases_and_templates/atlases'
atlas_name=['aal_res-1x1x1.nii.gz', 'Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_1mm.nii.gz']


mni_template_path = '{0}/MNI152_T1_1mm_brain.nii.gz'.format(mni_template_directory)
electrode_coordinates_mni_path = '{0}/sub-{1}/electrode_localization/sub-{1}_electrode_coordinates_mni.csv'.format(BIDS_directory,sub_ID, )
os.path.exists(mni_template_path)
os.path.exists(electrode_coordinates_mni_path)

output_directory = '{0}/sub-{1}/electrode_localization/electrode_localization_by_atlas'.format(BIDS_directory,sub_ID)
print('Saving files to {0}'.format(output_directory))
for i in range(len(atlas_name)):
    atlas_path = '{0}/{1}'.format(atlas_directory, atlas_name[i] )
    #print(atlas_path)
    if (os.path.exists(atlas_path)):
        if (os.path.exists(output_directory)):
            file_name = 'sub-{0}_electrode_coordinates_mni_{1}.csv'.format(sub_ID, atlas_name[i][:-7])
            outputfile = '{0}/{1}'.format(output_directory,file_name)
            print('Saving: {0}'.format(file_name))
            get_electrode_localization.by_atlas(electrode_coordinates_mni_path, atlas_path, mni_template_path, outputfile)
        else:
            print('{0} directory does not exist'.format(output_directory))
    else:
        print('{0} directory does not exist'.format(atlas_path))
