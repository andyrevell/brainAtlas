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


BIDS_proccessed_directory="/gdrive/public/DATA/Human_Data/BIDS_processed"

for a in range(len(atlas_folder)):
    outputfile_directory = "{0}/sub-{1}/connectivity_matrices/structure_function_correlation/{2}".format(BIDS_proccessed_directory,sub_ID,atlas_folder[a])
    print('Output directory: {0}'.format(outputfile_directory))
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
            outputfile_name = "sub-{0}_{1}_{2}_{3}_{4}_Perm{5}_correlation.pickle".format(sub_ID,iEEG_filename,start_time_usec,stop_time_usec, atlas_folder[a], '{:04}'.format(perm[p]))
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



#Standard Atlases
sub_ID='RID0278'
atlas_folder=['aal_res-1x1x1', 'AAL600', 'CPAC200_res-1x1x1', 'desikan_res-1x1x1','DK_res-1x1x1','JHU_res-1x1x1','Schaefer2018_100Parcels_17Networks_order_FSLMNI152_1mm', 'Schaefer2018_200Parcels_17Networks_order_FSLMNI152_1mm', 'Schaefer2018_300Parcels_17Networks_order_FSLMNI152_1mm' , 'Schaefer2018_400Parcels_17Networks_order_FSLMNI152_1mm', 'Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_1mm', 'Talairach_res-1x1x1']
iEEG_filename="HUP138_phaseII"
start_times_array=[394423190000,
415933490000,
416023190000,
416112890000]
stop_times_array=[394512890000,
416023190000,
416112890000,
416292890000]


BIDS_proccessed_directory="/gdrive/public/DATA/Human_Data/BIDS_processed"

for a in range(len(atlas_folder)):
    outputfile_directory = "{0}/sub-{1}/connectivity_matrices/structure_function_correlation/{2}".format(BIDS_proccessed_directory,sub_ID,atlas_folder[a])
    print('Output directory: {0}'.format(outputfile_directory))
    structure_file_name= 'sub-{0}_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz.trk.gz.{1}.count.pass.connectivity.mat'.format(sub_ID, atlas_folder[a]  )
    for i in range(len(start_times_array)):
        #Making Correct file paths and names based on above input
        electrode_localization_file_name = 'sub-{0}_electrode_coordinates_mni_{1}.csv'.format(sub_ID, atlas_folder[a]  )
        start_time_usec=start_times_array[i]
        stop_time_usec=stop_times_array[i]
        structure_file_path =  "{0}/sub-{1}/connectivity_matrices/structural/{2}/{3}".format(BIDS_proccessed_directory,sub_ID,atlas_folder[a],structure_file_name)
        function_file_path = "{0}/sub-{1}/connectivity_matrices/functional/sub-{1}_{2}_{3}_{4}_functionalConnectivity.pickle".format(BIDS_proccessed_directory,sub_ID,iEEG_filename,start_time_usec,stop_time_usec)
        electrode_localization_by_atlas_file_path =  "{0}/sub-{1}/electrode_localization/electrode_localization_by_atlas/{2}".format(BIDS_proccessed_directory,sub_ID,electrode_localization_file_name)
        outputfile_name = "sub-{0}_{1}_{2}_{3}_{4}_correlation.pickle".format(sub_ID,iEEG_filename,start_time_usec,stop_time_usec, atlas_folder[a])
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
atlases=['RA_N0010', 'RA_N0030', 'RA_N0050', 'RA_N0075','RA_N0100','RA_N0200','RA_N0300', 'RA_N0400', 'RA_N0500' , 'RA_N0750', 'RA_N1000', 'RA_N2000']
for a in range(len(atlases)):
    atlas_folder = atlases[a]
    data_directory = '/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-RID0278/connectivity_matrices/structure_function_correlation/{0}'.format(atlas_folder)
    perm = list(range(1,31))



    for p in range(len(perm)):
        data_interictal_file_name = 'sub-RID0278_HUP138_phaseII_394423190000_394512890000_{0}_Perm{1}_correlation.pickle'.format(atlas_folder, '{:04}'.format(perm[p]))
        data_preictal_file_name = 'sub-RID0278_HUP138_phaseII_415933490000_416023190000_{0}_Perm{1}_correlation.pickle'.format(atlas_folder, '{:04}'.format(perm[p]))
        data_ictal_file_name = 'sub-RID0278_HUP138_phaseII_416023190000_416112890000_{0}_Perm{1}_correlation.pickle'.format(atlas_folder, '{:04}'.format(perm[p]))
        data_postictal_file_name = 'sub-RID0278_HUP138_phaseII_416112890000_416292890000_{0}_Perm{1}_correlation.pickle'.format(atlas_folder, '{:04}'.format(perm[p]))

        data_interictal_filepath = '{0}/{1}'.format(data_directory, data_interictal_file_name)
        data_preictal_filepath = '{0}/{1}'.format(data_directory, data_preictal_file_name)
        data_ictal_file_path = '{0}/{1}'.format(data_directory, data_ictal_file_name)
        data_postictal_filepath = '{0}/{1}'.format(data_directory, data_postictal_file_name)

        with open(data_interictal_filepath, 'rb') as f:
            data_interictal_broadband, data_interictal_alphatheta, data_interictal_beta, data_interictal_lowgamma, data_interictal_highgamma, order_of_matrices_in_pickle_file = pickle.load(f)
        with open(data_preictal_filepath, 'rb') as f:
            data_preictal_broadband, data_preictal_alphatheta, data_preictal_beta, data_preictal_lowgamma, data_preictal_highgamma, order_of_matrices_in_pickle_file = pickle.load(f)
        with open(data_ictal_file_path, 'rb') as f:
            data_ictal_broadband, data_ictal_alphatheta, data_ictal_beta, data_ictal_lowgamma, data_ictal_highgamma, order_of_matrices_in_pickle_file = pickle.load(f)
        with open(data_postictal_filepath, 'rb') as f:
            data_postictal_broadband, data_postictal_alphatheta, data_postictal_beta, data_postictal_lowgamma, data_postictal_highgamma, order_of_matrices_in_pickle_file = pickle.load(f)

        if p == 0:
            avg_data_interictal_broadband = np.zeros( [data_interictal_broadband.shape[0], len(perm)]  )
            avg_data_interictal_alphatheta = np.zeros( [data_interictal_alphatheta.shape[0], len(perm)]  )
            avg_data_interictal_beta =np.zeros( [data_interictal_beta.shape[0], len(perm)]  )
            avg_data_interictal_lowgamma = np.zeros( [data_interictal_lowgamma.shape[0], len(perm)]  )
            avg_data_interictal_highgamma = np.zeros( [data_interictal_highgamma.shape[0], len(perm)]  )
            avg_data_preictal_broadband = np.zeros( [data_preictal_broadband.shape[0], len(perm)]  )
            avg_data_preictal_alphatheta = np.zeros( [data_preictal_alphatheta.shape[0], len(perm)]  )
            avg_data_preictal_beta = np.zeros( [data_preictal_beta.shape[0], len(perm)]  )
            avg_data_preictal_lowgamma = np.zeros( [data_preictal_lowgamma.shape[0], len(perm)]  )
            avg_data_preictal_highgamma = np.zeros( [data_preictal_highgamma.shape[0], len(perm)]  )
            avg_data_ictal_broadband = np.zeros( [data_ictal_broadband.shape[0], len(perm)]  )
            avg_data_ictal_alphatheta = np.zeros( [data_ictal_alphatheta.shape[0], len(perm)]  )
            avg_data_ictal_beta = np.zeros( [data_ictal_beta.shape[0], len(perm)]  )
            avg_data_ictal_lowgamma = np.zeros( [data_ictal_lowgamma.shape[0], len(perm)]  )
            avg_data_ictal_highgamma = np.zeros( [data_ictal_highgamma.shape[0], len(perm)]  )
            avg_data_postictal_broadband = np.zeros( [data_postictal_broadband.shape[0], len(perm)]  )
            avg_data_postictal_alphatheta = np.zeros( [data_postictal_alphatheta.shape[0], len(perm)]  )
            avg_data_postictal_beta = np.zeros( [data_postictal_beta.shape[0], len(perm)]  )
            avg_data_postictal_lowgamma = np.zeros( [data_postictal_lowgamma.shape[0], len(perm)]  )
            avg_data_postictal_highgamma = np.zeros( [data_postictal_highgamma.shape[0], len(perm)]  )
        avg_data_interictal_broadband[:,p] = data_interictal_broadband
        avg_data_interictal_alphatheta[:,p] = data_interictal_alphatheta
        avg_data_interictal_beta[:,p] = data_interictal_beta
        avg_data_interictal_lowgamma[:,p] = data_interictal_lowgamma
        avg_data_interictal_highgamma[:,p] = data_interictal_highgamma
        avg_data_preictal_broadband[:,p] = data_preictal_broadband
        avg_data_preictal_alphatheta[:,p] = data_preictal_alphatheta
        avg_data_preictal_beta[:,p] = data_preictal_beta
        avg_data_preictal_lowgamma[:,p] = data_preictal_lowgamma
        avg_data_preictal_highgamma[:,p] = data_preictal_highgamma
        avg_data_ictal_broadband[:,p] = data_ictal_broadband
        avg_data_ictal_alphatheta[:,p] = data_ictal_alphatheta
        avg_data_ictal_beta[:,p] = data_ictal_beta
        avg_data_ictal_lowgamma[:,p] = data_ictal_lowgamma
        avg_data_ictal_highgamma[:,p] = data_ictal_highgamma
        avg_data_postictal_broadband[:,p] = data_postictal_broadband
        avg_data_postictal_alphatheta[:,p] = data_postictal_alphatheta
        avg_data_postictal_beta[:,p] = data_postictal_beta
        avg_data_postictal_lowgamma[:,p] = data_postictal_lowgamma
        avg_data_postictal_highgamma[:,p] = data_postictal_highgamma



    data_interictal_broadband = np.mean(avg_data_interictal_broadband, axis=1)
    data_interictal_alphatheta = np.mean(avg_data_interictal_alphatheta, axis=1)
    data_interictal_beta = np.mean(avg_data_interictal_beta, axis=1)
    data_interictal_lowgamma = np.mean(avg_data_interictal_lowgamma, axis=1)
    data_interictal_highgamma = np.mean(avg_data_interictal_highgamma, axis=1)
    data_preictal_broadband = np.mean(avg_data_preictal_broadband, axis=1)
    data_preictal_alphatheta = np.mean(avg_data_preictal_alphatheta, axis=1)
    data_preictal_beta = np.mean(avg_data_preictal_beta, axis=1)
    data_preictal_lowgamma = np.mean(avg_data_preictal_lowgamma, axis=1)
    data_preictal_highgamma = np.mean(avg_data_preictal_highgamma, axis=1)
    data_ictal_broadband = np.mean(avg_data_ictal_broadband, axis=1)
    data_ictal_alphatheta = np.mean(avg_data_ictal_alphatheta, axis=1)
    data_ictal_beta = np.mean(avg_data_ictal_beta, axis=1)
    data_ictal_lowgamma = np.mean(avg_data_ictal_lowgamma, axis=1)
    data_ictal_highgamma = np.mean(avg_data_ictal_highgamma, axis=1)
    data_postictal_broadband = np.mean(avg_data_postictal_broadband, axis=1)
    data_postictal_alphatheta = np.mean(avg_data_postictal_alphatheta, axis=1)
    data_postictal_beta = np.mean(avg_data_postictal_beta, axis=1)
    data_postictal_lowgamma = np.mean(avg_data_postictal_lowgamma, axis=1)
    data_postictal_highgamma = np.mean(avg_data_postictal_highgamma, axis=1)

    sd_data_interictal_broadband = np.std(avg_data_interictal_broadband, axis=1)
    sd_data_interictal_alphatheta = np.std(avg_data_interictal_alphatheta, axis=1)
    sd_data_interictal_beta = np.std(avg_data_interictal_beta, axis=1)
    sd_data_interictal_lowgamma = np.std(avg_data_interictal_lowgamma, axis=1)
    sd_data_interictal_highgamma = np.std(avg_data_interictal_highgamma, axis=1)
    sd_data_preictal_broadband = np.std(avg_data_preictal_broadband, axis=1)
    sd_data_preictal_alphatheta = np.std(avg_data_preictal_alphatheta, axis=1)
    sd_data_preictal_beta = np.std(avg_data_preictal_beta, axis=1)
    sd_data_preictal_lowgamma = np.std(avg_data_preictal_lowgamma, axis=1)
    sd_data_preictal_highgamma = np.std(avg_data_preictal_highgamma, axis=1)
    sd_data_ictal_broadband = np.std(avg_data_ictal_broadband, axis=1)
    sd_data_ictal_alphatheta = np.std(avg_data_ictal_alphatheta, axis=1)
    sd_data_ictal_beta = np.std(avg_data_ictal_beta, axis=1)
    sd_data_ictal_lowgamma = np.std(avg_data_ictal_lowgamma, axis=1)
    sd_data_ictal_highgamma = np.std(avg_data_ictal_highgamma, axis=1)
    sd_data_postictal_broadband = np.std(avg_data_postictal_broadband, axis=1)
    sd_data_postictal_alphatheta = np.std(avg_data_postictal_alphatheta, axis=1)
    sd_data_postictal_beta = np.std(avg_data_postictal_beta, axis=1)
    sd_data_postictal_lowgamma = np.std(avg_data_postictal_lowgamma, axis=1)
    sd_data_postictal_highgamma = np.std(avg_data_postictal_highgamma, axis=1)

    t_dist= 2.042

    change = sd_data_interictal_broadband/np.sqrt(len(perm))*t_dist
    data_interictal_broadband_error = [data_interictal_broadband  + change, data_interictal_broadband  - change]
    change = sd_data_interictal_alphatheta/np.sqrt(len(perm))*t_dist
    data_interictal_alphatheta_error = [data_interictal_alphatheta  + change, data_interictal_alphatheta  - change]
    change = sd_data_interictal_beta/np.sqrt(len(perm))*t_dist
    data_interictal_beta_error = [data_interictal_beta  + change, data_interictal_beta  - change]
    change = sd_data_interictal_lowgamma/np.sqrt(len(perm))*t_dist
    data_interictal_lowgamma_error = [data_interictal_lowgamma  + change, data_interictal_lowgamma  - change]
    change = sd_data_interictal_highgamma/np.sqrt(len(perm))*t_dist
    data_interictal_highgamma_error = [data_interictal_highgamma  + change, data_interictal_highgamma  - change]
    change = sd_data_preictal_broadband/np.sqrt(len(perm))*t_dist
    data_preictal_broadband_error = [data_preictal_broadband  + change, data_preictal_broadband  - change]
    change = sd_data_preictal_alphatheta/np.sqrt(len(perm))*t_dist
    data_preictal_alphatheta_error = [data_preictal_alphatheta  + change, data_preictal_alphatheta  - change]
    change = sd_data_preictal_beta/np.sqrt(len(perm))*t_dist
    data_preictal_beta_error = [data_preictal_beta  + change, data_preictal_beta  - change]
    change = sd_data_preictal_lowgamma/np.sqrt(len(perm))*t_dist
    data_preictal_lowgamma_error = [data_preictal_lowgamma  + change, data_preictal_lowgamma  - change]
    change = sd_data_preictal_highgamma/np.sqrt(len(perm))*t_dist
    data_preictal_highgamma_error = [data_preictal_highgamma  + change, data_preictal_highgamma  - change]
    change = sd_data_ictal_broadband/np.sqrt(len(perm))*t_dist
    data_ictal_broadband_error = [data_ictal_broadband  + change, data_ictal_broadband  - change]
    change = sd_data_ictal_alphatheta/np.sqrt(len(perm))*t_dist
    data_ictal_alphatheta_error = [data_ictal_alphatheta  + change, data_ictal_alphatheta  - change]
    change = sd_data_ictal_beta/np.sqrt(len(perm))*t_dist
    data_ictal_beta_error = [data_ictal_beta  + change, data_ictal_beta  - change]
    change = sd_data_ictal_lowgamma/np.sqrt(len(perm))*t_dist
    data_ictal_lowgamma_error = [data_ictal_lowgamma  + change, data_ictal_lowgamma  - change]
    change = sd_data_ictal_highgamma/np.sqrt(len(perm))*t_dist
    data_ictal_highgamma_error = [data_ictal_highgamma  + change, data_ictal_highgamma  - change]
    change = sd_data_postictal_broadband/np.sqrt(len(perm))*t_dist
    data_postictal_broadband_error = [data_postictal_broadband  + change, data_postictal_broadband  - change]
    change = sd_data_postictal_alphatheta/np.sqrt(len(perm))*t_dist
    data_postictal_alphatheta_error = [data_postictal_alphatheta  + change, data_postictal_alphatheta  - change]
    change = sd_data_postictal_beta/np.sqrt(len(perm))*t_dist
    data_postictal_beta_error = [data_postictal_beta  + change, data_postictal_beta  - change]
    change = sd_data_postictal_lowgamma/np.sqrt(len(perm))*t_dist
    data_postictal_lowgamma_error = [data_postictal_lowgamma  + change, data_postictal_lowgamma  - change]
    change = sd_data_postictal_highgamma/np.sqrt(len(perm))*t_dist
    data_postictal_highgamma_error = [data_postictal_highgamma  + change, data_postictal_highgamma  - change]




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
    data_interictal_broadband_movingAvg_error = [np.convolve(data_interictal_broadband_error[0], np.ones((N,))/N, mode='valid'), np.convolve(data_interictal_broadband_error[1], np.ones((N,))/N, mode='valid')]

    data_other_broadband_movingAvg = np.convolve( np.concatenate((data_preictal_broadband, data_ictal_broadband, data_postictal_broadband), axis=None), np.ones((N,))/N, mode='valid')
    data_other_broadband_movingAvg_error = [np.convolve( np.concatenate((data_preictal_broadband_error[0], data_ictal_broadband_error[0], data_postictal_broadband_error[0]), axis=None), np.ones((N,))/N, mode='valid'),
                                            np.convolve(np.concatenate((data_preictal_broadband_error[1], data_ictal_broadband_error[1], data_postictal_broadband_error[1]), axis=None),np.ones((N,)) / N, mode='valid')]

    #pad the running mean
    pad =  np.empty( len(data_interictal_broadband) - len(data_interictal_broadband_movingAvg) )
    pad[:] = np.nan
    data_interictal_broadband_movingAvg = np.concatenate((pad, data_interictal_broadband_movingAvg), axis=None  )
    data_interictal_broadband_movingAvg_error[0] = np.concatenate((pad, data_interictal_broadband_movingAvg_error[0]), axis=None  )
    data_interictal_broadband_movingAvg_error[1] = np.concatenate((pad, data_interictal_broadband_movingAvg_error[1]), axis=None  )
    pad =  np.empty( len(data_preictal_broadband)  + len(data_ictal_broadband) + len(data_postictal_broadband)- len(data_other_broadband_movingAvg) )
    pad[:] = np.nan
    data_other_broadband_movingAvg = np.concatenate((pad, data_other_broadband_movingAvg), axis=None  )
    data_other_broadband_movingAvg_error[0] = np.concatenate((pad, data_other_broadband_movingAvg_error[0]), axis=None  )
    data_other_broadband_movingAvg_error[1] = np.concatenate((pad, data_other_broadband_movingAvg_error[1]), axis=None  )

    # visualize structure-function correlation by time
    i = 0
    x = range(len(data_interictal_broadband) + len(filler) + len(data_preictal_broadband)  + len(data_ictal_broadband) + len(data_postictal_broadband) )
    y = np.concatenate((data_interictal_broadband, filler, data_preictal_broadband, data_ictal_broadband, data_postictal_broadband), axis=None)
    y_movingAvg = np.concatenate((data_interictal_broadband_movingAvg, filler, data_other_broadband_movingAvg), axis=None)
    y_movingAvg_error = [np.concatenate((data_interictal_broadband_movingAvg_error[0], filler, data_other_broadband_movingAvg_error[0]), axis=None),
                         np.concatenate((data_interictal_broadband_movingAvg_error[1], filler, data_other_broadband_movingAvg_error[1]), axis=None)]

    if a == 0:
        fig, axs = plt.subplots(1, 1)
    #axs.scatter(x, y, c= colors)
    axs.plot(x,y_movingAvg, zorder=1, linewidth=2.0, label = atlases[a])
    #axs.plot(x,y_movingAvg_error[0], zorder=1, color = '#00000066', linewidth=1.0)
    #axs.plot(x,y_movingAvg_error[1], zorder=1, color = '#00000066', linewidth=1.0)
    axs.axes.set_ylim(-0.3, 0.6)
    axs.title.set_text('Structure-Function Correlation')
    axs.set_xlabel('Time (s)')
    axs.set_ylabel('Correlation')
    #plt.legend(loc='upper left')
    print("{0}".format( atlases[a]))

plt.show()

"""