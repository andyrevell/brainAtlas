#Ignore: For Alex Computer 
#resampled_SFC_dir = "./resampled_SFC/max/"
#output_path = "./resampled_SFC/averaged_resampled_data/max/averaged_resampled_max.RData"

SFC_type = "decrease" #increase, decrease, all
#Andys Computer:
resampled_SFC_dir = paste0("/Users/andyrevell/mount/USERS/arevell/papers/paper001/data_processed/figure6_data/average_SFC_ALL_PATIENTS/medians/", SFC_type, "/")
output_path = paste0("/Users/andyrevell/mount/USERS/arevell/papers/paper001/data_processed/figure6_data/average_SFC_ALL_PATIENTS/averaged_resampled_data/medians/", SFC_type, "/averaged_resampled_data.RData")



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
  processed_SFC_path = paste(resampled_SFC_dir,cur_file,sep = "")
  load(processed_SFC_path)
  if(count==1){
  averaged_resampled_random_atlases = all_data_random_atlases
  averaged_resampled_standard_atlases = all_data_standard_atlases
  }
  for(i in 1:length(all_data_random_atlases)){
    for(j in 1:length(all_data_random_atlases[[i]])){
      for(k in 1:length(all_data_random_atlases[[i]][[j]])){
        for(l in 1:length(all_data_random_atlases[[i]][[j]][[k]])){
          # pull off the current data 
          if(count==1){
            averaged_resampled_random_atlases[[i]][[j]][[k]][[l]] = all_data_random_atlases[[i]][[j]][[k]][[l]]/numFiles
          } else{
            averaged_resampled_random_atlases[[i]][[j]][[k]][[l]] = averaged_resampled_random_atlases[[i]][[j]][[k]][[l]]+ (all_data_random_atlases[[i]][[j]][[k]][[l]]/numFiles)
          }
        }
      }
    }
  }
  
  for(i in 1:length(all_data_standard_atlases)){
    for(j in 1:length(all_data_standard_atlases[[i]])){
      for(k in 1:length(all_data_standard_atlases[[i]][[j]])){
        # pull off the current data 
        if(count==1){
          averaged_resampled_standard_atlases[[i]][[j]][[k]] = averaged_resampled_standard_atlases[[i]][[j]][[k]]/numFiles
        } else{
          averaged_resampled_standard_atlases[[i]][[j]][[k]]= averaged_resampled_standard_atlases[[i]][[j]][[k]]+ (all_data_standard_atlases[[i]][[j]][[k]]/numFiles)
        }
      }
    }
  }
  count = count + 1
  
}

save(averaged_resampled_random_atlases, averaged_resampled_standard_atlases, file = output_path)

