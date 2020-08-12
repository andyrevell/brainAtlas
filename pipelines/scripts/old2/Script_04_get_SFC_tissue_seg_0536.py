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

import get_structure_function_correlation
import matplotlib.pyplot as plt
import pickle
import numpy as np
import os


# all patient times
# sub_ID='RID0194'
# iEEG_filename="HUP134_phaseII_D02"
# start_times_array=[179223935812,
# 179302933433,
# 179381931054,
# 157702933433]
# stop_times_array=[179302933433,
# 179381931054,
# 179561931054,
# 157882933433]


# sub_ID='RID0278'
# iEEG_filename="HUP138_phaseII"
# start_times_array=[248432340000,
# 248525740000,
# 248619140000,
# 338848220000,
# 339008330000,
# 339168440000,
# 415933490000,
# 416023190000,
# 416112890000,
# 429398830000,
# 429498590000,
# 429598350000,
# 458393300000,
# 458504560000,
# 458615820000,
# 226925740000,
# 317408330000,
# 394423190000,
# 407898590000,
# 436904560000]
# stop_times_array=[248525740000,
# 248619140000,
# 248799140000,
# 339008330000,
# 339168440000,
# 339348440000,
# 416023190000,
# 416112890000,
# 416292890000,
# 429498590000,
# 429598350000,
# 429778350000,
# 458504560000,
# 458615820000,
# 458795820000,
# 227019140000,
# 317568440000,
# 394512890000,
# 407998350000,
# 437015820000]



# sub_ID='RID0309'
# iEEG_filename="HUP151_phaseII"
# start_times_array=[494702000000,
# 494776000000,
# 494850000000,
# 529938316831,
# 530011424682,
# 530084532533,
# 473176000000,
# 508411424682]
# stop_times_array=[494776000000,
# 494850000000,
# 495030000000,
# 530011424682,
# 530084532533,
# 530264532533,
# 473250000000,
# 508484532533]

# sub_ID='RID0320'
# iEEG_filename="HUP140_phaseII_D02"
# start_times_array=[331624747156,
# 331979921071,
# 332335094986,
# 340243011431,
# 340528040025,
# 340813068619,
# 344266714798,
# 344573548935,
# 344880383072,
# 310399132626,
# 318928040025,
# 302115130000]
# stop_times_array=[331979921071,
# 332335094986,
# 332635094986,
# 340528040025,
# 340813068619,
# 341113068619,
# 344573548935,
# 344880383072,
# 345180383072,
# 310579132626,
# 319108040025,
# 302295130000]


sub_ID='RID0536'
iEEG_filename="HUP195_phaseII_D01"
start_times_array=[84609521985,
84729094008,
84848666031,
164626956810,
164694572385,
164762187960,
250573896890,
250710930770,
250847964650,
286753301266,
286819539584,
286885777902,
63129090000,
152892270000,
237460640000,
269881750000]
stop_times_array=[84729094008,
84848666031,
85028666031,
164694572385,
164762187960,
164942187960,
250710930770,
250847964650,
251027964650,
286819539584,
286885777902,
287065777902,
63309090000,
153072270000,
237640640000,
270061750000]



# sub_ID='RID0440'
# iEEG_filename='HUP172_phaseII'
# #seizure 402704260829
# start_times_array=[
# 356850680000,
# 402651841658,
# 402704260829,
# 402756680000,
# 367346290000,
# 408637470000,
# 408697930000,
# 408758390000,
# 565390000000,
# 586927711315,
# 586990000000,
# 587052288685,
# 643376000000,
# 664924780939,
# 664976000000,
# 665027219061,
# 671279000000,
# 692821000000,
# 692879000000,
# 692937000000]
# stop_times_array=[
# 356903099171,
# 402704260829,
# 402756680000,
# 402936680000,
# 367406750000,
# 408697930000,
# 408758390000,
# 408938390000,
# 565452288685,
# 586990000000,
# 587052288685,
# 587232288685,
# 643427219061,
# 664976000000,
# 665027219061,
# 665207219061,
# 671337000000,
# 692879000000,
# 692937000000,
# 693117000000]







#Random Atlases
atlas_folder=['RA_N0010', 'RA_N0030', 'RA_N0050', 'RA_N0075','RA_N0100','RA_N0200','RA_N0300', 'RA_N0400', 'RA_N0500' , 'RA_N0750', 'RA_N1000', 'RA_N2000']
# Classification atlases 
class_atlases = ['tissue_segmentation_dist_from_grey']
perm = list(range(1,31))
BIDS_proccessed_directory="/gdrive/public/DATA/Human_Data/BIDS_processed"

for a in range(len(atlas_folder)):
    outputfile_directory = "{0}/sub-{1}/connectivity_matrices/structure_function_correlation/{2}".format(BIDS_proccessed_directory,sub_ID,atlas_folder[a])
    print('Output directory: {0}'.format(outputfile_directory))
    for p in range(len(perm)):
        structure_file_name= 'sub-{0}_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz.trk.gz.{1}_Perm{2}.count.pass.connectivity.mat'.format(sub_ID, atlas_folder[a], '{:04}'.format(perm[p])  )
        for i in range(len(start_times_array)):
            for class_atlas in class_atlases:
                #Making Correct file paths and names based on above input
                electrode_localization_file_name = 'sub-{0}_electrode_coordinates_mni_{1}_Perm{2}.csv'.format(sub_ID, atlas_folder[a], '{:04}'.format(perm[p])   )
                start_time_usec=start_times_array[i]
                stop_time_usec=stop_times_array[i]
                structure_file_path =  "{0}/sub-{1}/connectivity_matrices/structural/{2}/{3}".format(BIDS_proccessed_directory,sub_ID,atlas_folder[a],structure_file_name)
                function_file_path = "{0}/sub-{1}/connectivity_matrices/functional/eeg/sub-{1}_{2}_{3}_{4}_functionalConnectivity.pickle".format(BIDS_proccessed_directory,sub_ID,iEEG_filename,start_time_usec,stop_time_usec)
                electrode_localization_by_atlas_file_path =  "{0}/sub-{1}/electrode_localization/electrode_localization_by_atlas/{2}".format(BIDS_proccessed_directory,sub_ID,electrode_localization_file_name)
                electrode_localization_by_class_atlas_file_path =  "{0}/sub-{1}/electrode_localization/electrode_localization_by_atlas/sub-{1}_electrode_coordinates_mni_{2}.csv".format(BIDS_proccessed_directory,sub_ID,class_atlas)
                
                outputfile_name = "sub-{0}_{1}_{2}_{3}_{4}_Perm{5}_class_by_{6}".format(sub_ID,iEEG_filename,start_time_usec,stop_time_usec, atlas_folder[a], '{:04}'.format(perm[p]),class_atlas)
                outputfile_directory_cur = "{0}/classification_by_{1}".format(outputfile_directory,class_atlas)
                outputfile = '{0}/{1}'.format(outputfile_directory_cur, outputfile_name)
                print('Output directory: {0}'.format(outputfile_directory))
                #Making sure files exist
                if (os.path.exists(structure_file_path))==False:
                    print('{0} does not exist'.format(structure_file_path))
                else:
                    if (os.path.exists(function_file_path)) == False:
                        print('{0} does not exist'.format(function_file_path))
                    else:
                        if (os.path.exists(electrode_localization_by_atlas_file_path))==False:
                            print('{0} does not exist'.format(electrode_localization_by_atlas_file_path))
                        else:
                            if (os.path.exists(outputfile_directory_cur))==False:
                                print('{0} does not exist'.format(outputfile_directory_cur))
                                print('Making directory {0}'.format(outputfile_directory_cur))
                                os.mkdir(outputfile_directory_cur) 
                                get_structure_function_correlation.SFC_by_tissue_seg(structure_file_path,function_file_path,electrode_localization_by_atlas_file_path, electrode_localization_by_class_atlas_file_path, outputfile)
                            else:
                                #Run structure-function correlation calculation
                                print('Calculating: {0}'.format(outputfile_name))
                                get_structure_function_correlation.SFC_by_tissue_seg(structure_file_path,function_file_path,electrode_localization_by_atlas_file_path, electrode_localization_by_class_atlas_file_path, outputfile)
    
    