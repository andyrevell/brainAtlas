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
python3.6 -c 'import Script_02_get_electrode_localization_ASedit as el; el.batch_localize_electrodes([320],[10,30,50,75,100,200,300,400,500,750,1000,2000],1,30,True)'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

"""

import get_electrode_localization
import pickle
import numpy as np
import os

def batch_localize_electrodes(subjects,random_atlas_number_parcellations,permLower,permUpper,compute_standard_atlases):
    standard_atlas_list = ["AAL600", "aal_res-1x1x1", "JHU_res-1x1x1", "CPAC200_res-1x1x1", "desikan_res-1x1x1", "DK_res-1x1x1",
    "Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_1mm", "Schaefer2018_100Parcels_17Networks_order_FSLMNI152_1mm",
    "Schaefer2018_200Parcels_17Networks_order_FSLMNI152_1mm", "Schaefer2018_300Parcels_17Networks_order_FSLMNI152_1mm",
    "Schaefer2018_400Parcels_17Networks_order_FSLMNI152_1mm", "Talairach_res-1x1x1"]
    perms = list(range(permLower,permUpper+1))
    BIDS_dir = '/gdrive/public/DATA/Human_Data/BIDS_processed'
    mni_template_path = '/gdrive/public/TOOLS/atlases_and_templates/templates/MNI152_T1_1mm_brain.nii.gz'
    atlas_dir = '/gdrive/public/TOOLS/atlases_and_templates/atlases/custom_atlases/random_atlases/whole_brain'
    for sub in subjects:
        electrode_coordinates_mni_path = '{0}/sub-RID{1}/electrode_localization/sub-RID{1}_electrode_coordinates_mni.csv'.format(BIDS_dir,'{:04}'.format(sub))
        output_dir =  '{0}/sub-RID{1}/electrode_localization/electrode_localization_by_atlas'.format(BIDS_dir,'{:04}'.format(sub))
        for node in random_atlas_number_parcellations:
            for perm in perms:
                atlas_path = '{0}/{1}/{1}_Perm{2}.nii.gz'.format(atlas_dir, 'RA_N'+'{:04}'.format(node), '{:04}'.format(perm))
                #print(atlas_path)
                if (os.path.exists(atlas_path)):
                    if (os.path.exists(output_dir)):
                        file_name = 'sub-RID{0}_electrode_coordinates_mni_{1}_Perm{2}.csv'.format('{:04}'.format(sub), 'RA_N'+'{:04}'.format(node), '{:04}'.format(perm))                                                
                        outputfile = '{0}/{1}'.format(output_dir,file_name)
                        print('Saving: {0}'.format(file_name))
                        get_electrode_localization.by_atlas(electrode_coordinates_mni_path, atlas_path, mni_template_path, outputfile)
                    else:
                        print('{0} directory does not exist'.format(output_dir))
                        print('making directory')
                        os.mkdir(output_dir)
                        file_name = 'sub-RID{0}_electrode_coordinates_mni_{1}_Perm{2}.csv'.format('{:04}'.format(sub), 'RA_N'+'{:04}'.format(node), '{:04}'.format(perm))                                                
                        outputfile = '{0}/{1}'.format(output_dir,file_name)
                        print('Saving: {0}'.format(file_name))
                        get_electrode_localization.by_atlas(electrode_coordinates_mni_path, atlas_path, mni_template_path, outputfile)
                else:
                    print('{0} directory does not exist'.format(atlas_path))
    
    if(compute_standard_atlases):
        atlas_dir_temp = '/gdrive/public/TOOLS/atlases_and_templates/atlases'
        for sub in subjects:
            electrode_coordinates_mni_path = '{0}/sub-RID{1}/electrode_localization/sub-RID{1}_electrode_coordinates_mni.csv'.format(BIDS_dir,'{:04}'.format(sub))
            output_dir =  '{0}/sub-RID{1}/electrode_localization/electrode_localization_by_atlas'.format(BIDS_dir,'{:04}'.format(sub))
            for temp in standard_atlas_list:
                atlas_path = '{0}/{1}.nii.gz'.format(atlas_dir_temp, temp)
                if (os.path.exists(atlas_path)):
                    if (os.path.exists(output_dir)):
                        file_name = 'sub-RID{0}_electrode_coordinates_mni_{1}.csv'.format('{:04}'.format(sub), temp)                                               
                        outputfile = '{0}/{1}'.format(output_dir,file_name)
                        print('Saving: {0}'.format(file_name))
                        get_electrode_localization.by_atlas(electrode_coordinates_mni_path, atlas_path, mni_template_path, outputfile)
                    else:
                        print('{0} directory does not exist'.format(output_dir))
                else:
                    print('{0} directory does not exist'.format(atlas_path))
            
            
    
                        
                
        
#Random Atlases










# sub_ID='RID0278'
# BIDS_directory = '/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed'
# mni_template_directory = '/Users/andyrevell/mount/TOOLS/atlases_and_templates/templates'
# atlas_directory = '/Users/andyrevell/mount/TOOLS/atlases_and_templates/atlases/custom_atlases/random_atlases/whole_brain'
# atlas_folder=['RA_N0010', 'RA_N0030', 'RA_N0050', 'RA_N0075','RA_N0100','RA_N0200','RA_N0300', 'RA_N0400', 'RA_N0500' , 'RA_N0750', 'RA_N1000', 'RA_N2000']
# perm = list(range(1,31))


# mni_template_path = '{0}/MNI152_T1_1mm_brain.nii.gz'.format(mni_template_directory)
# electrode_coordinates_mni_path = '{0}/sub-{1}/electrode_localization/sub-{1}_electrode_coordinates_mni.csv'.format(BIDS_directory,sub_ID, )
# os.path.exists(mni_template_path)
# os.path.exists(electrode_coordinates_mni_path)

# output_directory = '{0}/sub-{1}/electrode_localization/electrode_localization_by_atlas'.format(BIDS_directory,sub_ID)
# print('Saving files to {0}'.format(output_directory))
# for i in range(len(atlas_folder)):
#     for p in range(len(perm)):
#         atlas_path = '{0}/{1}/{1}_Perm{2}.nii.gz'.format(atlas_directory, atlas_folder[i], '{:04}'.format(perm[p]) )
#         #print(atlas_path)
#         if (os.path.exists(atlas_path)):
#             if (os.path.exists(output_directory)):
#                 file_name = 'sub-{0}_electrode_coordinates_mni_{1}_Perm{2}.csv'.format(sub_ID, atlas_folder[i], '{:04}'.format(perm[p]))
#                 outputfile = '{0}/{1}'.format(output_directory,file_name)
#                 print('Saving: {0}'.format(file_name))
#                 get_electrode_localization.by_atlas(electrode_coordinates_mni_path, atlas_path, mni_template_path, outputfile)
#             else:
#                 print('{0} directory does not exist'.format(output_directory))
#         else:
#             print('{0} directory does not exist'.format(atlas_path))



# #Standard Atlases
# sub_ID='RID0278'
# BIDS_directory = '/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed'
# mni_template_directory = '/Users/andyrevell/mount/TOOLS/atlases_and_templates/templates'
# atlas_directory = '/Users/andyrevell/mount/TOOLS/atlases_and_templates/atlases'
# atlas_name=['aal_res-1x1x1.nii.gz', 'Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_1mm.nii.gz']


# mni_template_path = '{0}/MNI152_T1_1mm_brain.nii.gz'.format(mni_template_directory)
# electrode_coordinates_mni_path = '{0}/sub-{1}/electrode_localization/sub-{1}_electrode_coordinates_mni.csv'.format(BIDS_directory,sub_ID, )
# os.path.exists(mni_template_path)
# os.path.exists(electrode_coordinates_mni_path)

# output_directory = '{0}/sub-{1}/electrode_localization/electrode_localization_by_atlas'.format(BIDS_directory,sub_ID)
# print('Saving files to {0}'.format(output_directory))
# for i in range(len(atlas_name)):
#     atlas_path = '{0}/{1}'.format(atlas_directory, atlas_name[i] )
#     #print(atlas_path)
#     if (os.path.exists(atlas_path)):
#         if (os.path.exists(output_directory)):
#             file_name = 'sub-{0}_electrode_coordinates_mni_{1}.csv'.format(sub_ID, atlas_name[i][:-7])
#             outputfile = '{0}/{1}'.format(output_directory,file_name)
#             print('Saving: {0}'.format(file_name))
#             get_electrode_localization.by_atlas(electrode_coordinates_mni_path, atlas_path, mni_template_path, outputfile)
#         else:
#             print('{0} directory does not exist'.format(output_directory))
#     else:
#         print('{0} directory does not exist'.format(atlas_path))
