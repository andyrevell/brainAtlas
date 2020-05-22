# Ignore: For Alex Computer 
#processed_SFC_dir = "./processed_SFC/"
#resampled_SFC_dir = "./resampled_SFC/max/"


library("pracma")#need for interpolations
#Andy computer:
processed_SFC_dir = "/Users/andyrevell/mount/USERS/arevell/papers/paper001/data_processed/figure5_data/structure_function_correlation/"
resampled_SFC_dir = "/Users/andyrevell/mount/USERS/arevell/papers/paper001/data_processed/figure6_data/average_SFC_ALL_PATIENTS/medians/"

#Borel:
#processed_SFC_dir = "/gdrive/public/USERS/arevell/papers/paper001/data_processed/figure5_data/structure_function_correlation/"
# change this to be either medians/up/downsample 
#resampled_SFC_dir = "/gdrive/public/USERS/arevell/papers/paper001/data_processed/figure6_data/average_SFC_ALL_PATIENTS/medians/"


  
all_lengths = c()
all_files = dir(processed_SFC_dir)
for(cur_file in all_files){
  processed_SFC_path = paste(processed_SFC_dir,cur_file,sep = "")
  load(processed_SFC_path)
  all_lengths = c(all_lengths,length(all_data_random_atlases[[1]][[3]][[1]][[1]]))
}
# Just uncomment the one that corresponds to where you want to save. 
desired_length = median(all_lengths)
#desired_length = min(all_lengths)
#desired_length = max(all_lengths)

for(cur_file in all_files){
  processed_SFC_path = paste(processed_SFC_dir,cur_file,sep = "")
  output_resampled_SFC_path = paste(resampled_SFC_dir,"resampled_",cur_file,sep="") 
  resample_SFC(processed_SFC_path,output_resampled_SFC_path,desired_length)
}
