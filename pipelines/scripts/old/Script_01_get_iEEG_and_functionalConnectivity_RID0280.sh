#!/bin/bash

#2020.05.08 Andy Revell
#Purpose: Shell script to get iEEG data in batches

#Input:
#   Shell script inputs:
#   username: first argument. Your iEEG.org username
#   password: second argument. Your iEEG.org password

#   Please edit all other inputs below based on needs
#       iEEG_filename: The file name on iEEG.org you want to download from
#       start_time_usec: the start time in the iEEG_filename. In microseconds
#       stop_time_usec: the stop time in the iEEG_filename. In microseconds.
#           iEEG.org needs a duration input: this is calculated by stop_time_usec - start_time_usec
#       ignore_electrodes: the electrode/channel names you want to exclude. EXACT MATCH on iEEG.org. Caution: some may be LA08 or LA8
#       outputfile: the path and filename you want to save.
#           PLEASE INCLUDE EXTENSION .pickle.
#           Use this output naming convention: sub-RIDXXXX_iEEGFILENAME_STARTTIME_STOPTIME_EEG.pickle
#           example: 'sub-RID0278_HUP138_phaseII_415723190000_248525740000_EEG.pickle'

#NOTE: ignore_electrodes MUST BE TYPED EXACLY LIKE THIS.
#FOLLOW THESE CRITERIA: No blank space after commas. No brackets []. Double quotes surrounding entire input ONLY. No other quotes
#Example: "EKG1,EKG2,CZ,C3,C4,F3,F7,FZ,F4,F8,LF04,RC03,RE07,RC05,RF01,RF03,RB07,RG03,RF11,RF12"

#Output:
#   Saves EEG timeseries in specified output directors

#Example:
#./ShellScript_01_get_iEEG_and_functionalConnectivity.sh 'arevell' 'password'

username=$1
password=$2

sub_ID="RID0280"
iEEG_filename="HUP137_phaseII_D01"
ignore_electrodes="EKG1,EKG2,LA12,RA11,RA12"

start_times_array=(
109500000000
109700000000
)
stop_times_array=(
109700000000
109900000000
)


for i in "${!start_times_array[@]}"; do
  printf "\n\n\nID: ${sub_ID}"
  printf "\nStart: ${start_times_array[i]}"
  printf "\nStop: ${stop_times_array[i]}"
  start_time_usec=${start_times_array[i]}
  stop_time_usec=${stop_times_array[i]}

  BIDS_proccessed_directory="/gdrive/public/DATA/Human_Data/BIDS_processed"
  EEG_outputfile="${BIDS_proccessed_directory}/sub-${sub_ID}/eeg/sub-${sub_ID}_${iEEG_filename}_${start_time_usec}_${stop_time_usec}_EEG.pickle"
  functional_connectivity_inputfile=${EEG_outputfile}
  functional_connectivity_outputfile="${BIDS_proccessed_directory}/sub-${sub_ID}/connectivity_matrices/functional/eeg/sub-${sub_ID}_${iEEG_filename}_${start_time_usec}_${stop_time_usec}_functionalConnectivity.pickle"

  #Get iEEG data
  python3.6 -c 'import get_iEEG_data, sys; get_iEEG_data.get_iEEG_data(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5], sys.argv[6].split(","),sys.argv[7])' "$username" "$password" "$iEEG_filename" "$start_time_usec" "$stop_time_usec" "$ignore_electrodes" "$EEG_outputfile"
  #Get Functional Connectivity
  python3.6 -c 'import get_Functional_connectivity, sys; get_Functional_connectivity.get_Functional_connectivity(sys.argv[1], sys.argv[2])' "$functional_connectivity_inputfile" "$functional_connectivity_outputfile"

done
