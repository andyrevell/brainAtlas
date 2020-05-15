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


#Random Atlases
sub_ID='RID0278'
atlas_folder=['RA_N0010', 'RA_N0030', 'RA_N0050', 'RA_N0075','RA_N0100','RA_N0200','RA_N0300', 'RA_N0400', 'RA_N0500' , 'RA_N0750', 'RA_N1000', 'RA_N2000']
perm = list(range(1,31))
iEEG_filename="HUP138_phaseII"
start_times_array=[394423190000,
415933490000,
416023190000,
416112890000]
stop_times_array=[394512890000,
416023190000,
416112890000,
416292890000]


BIDS_proccessed_directory="/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed"

for a in range(len(atlas_folder)):
    outputfile_directory = "{0}/sub-{1}/connectivity_matrices/structure_function_correlation/{2}".format(BIDS_proccessed_directory,sub_ID,atlas_folder[a])
    print('Output directory:'.format(outputfile_directory))
    for p in range(len(perm)):
        structure_file_name= 'sub-{0}_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz.trk.gz.{1}_Perm{2}.count.pass.connectivity.mat'.format(sub_ID, atlas_folder[a], '{:04}'.format(perm[p])  )
        for i in range(len(start_times_array)):
            #Making Correct file paths and names based on above input
            electrode_localization_file_name = 'sub-{0}_electrode_coordinates_mni_{1}_Perm{2}.csv'.format(sub_ID, atlas_folder[a], '{:04}'.format(perm[p])   )
            start_time_usec=start_times_array[i]
            stop_time_usec=stop_times_array[i]
            structure_file_path =  "{0}/sub-{1}/connectivity_matrices/structural/{2}/{3}".format(BIDS_proccessed_directory,sub_ID,atlas_folder[a],structure_file_name)
            function_file_path = "{0}/sub-{1}/connectivity_matrices/functional/sub-{1}_{2}_{3}_{4}_functionalConnectivity.pickle".format(BIDS_proccessed_directory,sub_ID,iEEG_filename,start_time_usec,stop_time_usec)
            electrode_localization_by_atlas_file_path =  "{0}/sub-{1}/electrode_localization/electrode_localization_by_atlas/{2}".format(BIDS_proccessed_directory,sub_ID,electrode_localization_file_name)

            outputfile_name = "sub-{0}_{1}_{2}_{3}_{4}_{5}_correlation.pickle".format(sub_ID,iEEG_filename,start_time_usec,stop_time_usec, atlas_folder[a], '{:04}'.format(perm[p]))
            outputfile = '{0}/{1}'.format(outputfile_directory, outputfile_name)

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
                        if (os.path.exists(outputfile_directory))==False:
                            print('{0} does not exist'.format(outputfile_directory))
                        else:
                            #Run structure-function correlation calculation
                            print('Calculating: {0}'.format(outputfile_name))
                            get_structure_function_correlation.SFC(structure_file_path,function_file_path,electrode_localization_by_atlas_file_path, outputfile)



"""
#plot SFC
data_interictal_filepath = '/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-RID0278/connectivity_matrices/structure_function_correlation/RA_N1000/sub-RID0278_HUP138_phaseII_394423190000_394512890000_RA_N1000_Perm0001_correlation.pickle'
data_preictal_filepath = '/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-RID0278/connectivity_matrices/structure_function_correlation/RA_N1000/sub-RID0278_HUP138_phaseII_415933490000_416023190000_RA_N1000_Perm0001_correlation.pickle'
data_ictal_file_path = '/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-RID0278/connectivity_matrices/structure_function_correlation/RA_N1000/sub-RID0278_HUP138_phaseII_416023190000_416112890000_RA_N1000_Perm0001_correlation.pickle'
data_postictal_filepath = '/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-RID0278/connectivity_matrices/structure_function_correlation/RA_N1000/sub-RID0278_HUP138_phaseII_416112890000_416292890000_RA_N1000_Perm0001_correlation.pickle'

with open(data_preictal_filepath, 'rb') as f:
    data_preictal_broadband, data_preictal_alphatheta, data_preictal_beta, data_preictal_lowgamma, data_preictal_highgamma, order_of_matrices_in_pickle_file = pickle.load(f)
with open(data_ictal_file_path, 'rb') as f:
    data_ictal_broadband, data_ictal_alphatheta, data_ictal_beta, data_ictal_lowgamma, data_ictal_highgamma, order_of_matrices_in_pickle_file = pickle.load(f)
with open(data_postictal_filepath, 'rb') as f:
    data_postictal_broadband, data_postictal_alphatheta, data_postictal_beta, data_postictal_lowgamma, data_postictal_highgamma, order_of_matrices_in_pickle_file = pickle.load(f)
with open(data_interictal_filepath, 'rb') as f:
    data_interictal_broadband, data_interictal_alphatheta, data_interictal_beta, data_interictal_lowgamma, data_interictal_highgamma, order_of_matrices_in_pickle_file = pickle.load(f)


#create filler data with NAs. Filler between interictal and preictal (becasue they are not continuous)
filler = np.empty( int(data_ictal_broadband.shape[0]*0.4) ) # X% of ictal length
filler[:] = np.nan
#Make colors
colors_interictal = '#cc000066'
colors_preictal = '#00cc0066'
colors_ictal = '#0000cc66'
colors_postictal = '#cc00cc66'
np.repeat(colors_interictal, 10)
colors = np.concatenate([np.repeat(colors_interictal,  len(data_interictal_broadband)),
                         np.repeat('#000000',  len(filler)),
                         np.repeat(colors_preictal, len(data_preictal_broadband) ),
                         np.repeat(colors_ictal, len(data_ictal_broadband)),
                         np.repeat(colors_postictal, len(data_postictal_broadband)) ]  )

#create running mean (moving average, convolution)
N = 20 #length of window
data_interictal_broadband_movingAvg = np.convolve(data_interictal_broadband, np.ones((N,))/N, mode='valid')
data_other_broadband_movingAvg = np.convolve( np.concatenate((data_preictal_broadband, data_ictal_broadband, data_postictal_broadband), axis=None), np.ones((N,))/N, mode='valid')
#pad the running mean
pad =  np.empty( len(data_interictal_broadband) - len(data_interictal_broadband_movingAvg) )
pad[:] = np.nan
data_interictal_broadband_movingAvg = np.concatenate((pad, data_interictal_broadband_movingAvg), axis=None  )
pad =  np.empty( len(data_preictal_broadband)  + len(data_ictal_broadband) + len(data_postictal_broadband)- len(data_other_broadband_movingAvg) )
pad[:] = np.nan
data_other_broadband_movingAvg = np.concatenate((pad, data_other_broadband_movingAvg), axis=None  )

# visualize structure-function correlation by time
i = 0
x = range(len(data_interictal_broadband) + len(filler) + len(data_preictal_broadband)  + len(data_ictal_broadband) + len(data_postictal_broadband) )
y = np.concatenate((data_interictal_broadband, filler, data_preictal_broadband, data_ictal_broadband, data_postictal_broadband), axis=None)
y_movingAvg = np.concatenate((data_interictal_broadband_movingAvg, filler, data_other_broadband_movingAvg), axis=None)
fig, axs = plt.subplots(1, 1)
axs.scatter(x, y, c= colors)
axs.plot(x,y_movingAvg, zorder=1, color = '#000000bb', linewidth=5.0)
# axs.axes.set_xlim(-0.1, 1)
axs.axes.set_ylim(0.1, 0.6)
axs.title.set_text('Structure-Function Correlation')
axs.set_xlabel('Time (s)')
axs.set_ylabel('Correlation')
plt.show()

"""