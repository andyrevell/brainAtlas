#Ignore: For Alex Computer 
#resampled_SFC_dir = "./resampled_SFC/max/"
#output_path = "./resampled_SFC/averaged_resampled_data/max/averaged_resampled_max.RData"

SFC_type = "all" #increase, decrease, all
#Andys Computer:
resampled_SFC_dir = paste0("/Users/andyrevell/mount/USERS/arevell/papers/paper001/data_processed/figure7_data/average_SFC_ALL_PATIENTS/medians/", SFC_type, "/")
output_path = paste0("/Users/andyrevell/mount/USERS/arevell/papers/paper001/data_processed/figure7_data/average_SFC_ALL_PATIENTS/averaged_resampled_data/medians/", SFC_type, "/averaged_resampled_data.RData")



#Borel
# Change this to be either up/downsample/median
#resampled_SFC_dir = "/gdrive/public/USERS/arevell/papers/paper001/data_processed/figure6_data/average_SFC_ALL_PATIENTS/medians/"
# Change this to be either up/downsample/median
#output_path = "/gdrive/public/USERS/arevell/papers/paper001/data_processed/figure6_data/average_SFC_ALL_PATIENTS/averaged_resampled_data/medians/averaged_resampled_data.RData"
all_lengths = c()
all_files = dir(resampled_SFC_dir)
count = 1
numFiles = as.numeric(length(all_files))
for(cur_file in all_files){
  processed_SFC_path = paste0(resampled_SFC_dir,cur_file)
  load(processed_SFC_path)
  if(count==1){
    averaged_all_processed_data = all_processed_data
  }
  for(D in 1:length(all_processed_data)){
    for(i in 1:length(all_processed_data[[D]])){
      for(j in 1:length(all_processed_data[[D]][[i]])){
        for(k in 1:length(all_processed_data[[D]][[i]][[j]])){
          for(l in 1:length(all_processed_data[[D]][[i]][[j]][[k]])){
            # pull off the current data 
            if(count==1){
              averaged_all_processed_data[[D]][[i]][[j]][[k]][[l]] = all_processed_data[[D]][[i]][[j]][[k]][[l]]/numFiles
            } else{
              averaged_all_processed_data[[D]][[i]][[j]][[k]][[l]] = averaged_all_processed_data[[D]][[i]][[j]][[k]][[l]]+ (all_processed_data[[D]][[i]][[j]][[k]][[l]]/numFiles)
            }
          }
        }
      }
    }
  }
  
  count = count + 1
  
}

save(averaged_all_processed_data, file = output_path)

