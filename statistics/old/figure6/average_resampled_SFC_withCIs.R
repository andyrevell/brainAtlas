#Ignore: For Alex Computer 
#resampled_SFC_dir = "./resampled_SFC/max/"
#output_path = "./resampled_SFC/averaged_resampled_data/max/averaged_resampled_max.RData"

SFC_type = "increase" #increase, decrease, all
# #Andys Computer:
resampled_SFC_dir = paste0("/Users/andyrevell/mount/USERS/arevell/papers/paper001/data_processed/figure6_data/average_SFC_ALL_PATIENTS/medians/", SFC_type, "/")
output_path = paste0("/Users/andyrevell/mount/USERS/arevell/papers/paper001/data_processed/figure6_data/average_SFC_ALL_PATIENTS/averaged_resampled_data/medians/", SFC_type, "/averaged_resampled_data.RData")
# 

#resampled_SFC_dir = "../../../data_processed/figure6_data/average_SFC_ALL_PATIENTS/medians/increase/"
#output_path = "./test.RData"
#Borel
# Change this to be either up/downsample/median
#resampled_SFC_dir = "/gdrive/public/USERS/arevell/papers/paper001/data_processed/figure6_data/average_SFC_ALL_PATIENTS/medians/"
# Change this to be either up/downsample/median
#output_path = "/gdrive/public/USERS/arevell/papers/paper001/data_processed/figure6_data/average_SFC_ALL_PATIENTS/averaged_resampled_data/medians/averaged_resampled_data.RData"
all_lengths = c()
all_files = dir(resampled_SFC_dir)
count = 1
numFiles = as.numeric(length(all_files))
processed_SFC_path = paste(resampled_SFC_dir,all_files[1],sep = "")
load(processed_SFC_path)
for(i in 1:length(all_data_random_atlases)){
  for(j in 1:length(all_data_random_atlases[[i]])){
    for(k in 1:1){
      for(l in 1:length(all_data_random_atlases[[i]][[j]][[k]])){
        fileNum = 1
        all_raw_data = matrix(0,nrow=numFiles,ncol=length(all_data_random_atlases[[i]][[j]][[k]][[l]]))
        for(cur_file in all_files){
          processed_SFC_path = paste(resampled_SFC_dir,cur_file,sep = "")
          load(processed_SFC_path)
          if(count==1){
            averaged_resampled_random_atlases = all_data_random_atlases
            averaged_resampled_standard_atlases = all_data_standard_atlases
          }
          # pull off the current data 
          if(fileNum==1){
            averaged_resampled_random_atlases[[i]][[j]][[k]][[l]] = all_data_random_atlases[[i]][[j]][[k]][[l]]/numFiles
          } else{
            averaged_resampled_random_atlases[[i]][[j]][[k]][[l]] = averaged_resampled_random_atlases[[i]][[j]][[k]][[l]]+ (all_data_random_atlases[[i]][[j]][[k]][[l]]/numFiles)
          }
          all_raw_data[fileNum,] = all_data_random_atlases[[i]][[j]][[k]][[l]]#averaged_resampled_random_atlases[[i]][[j]][[k]][[l]]
          count = count + 1
          fileNum = fileNum + 1
        }
        std_at_times = apply(all_raw_data,2,sd)
        sterr_at_times = std_at_times*qt(.975,df=numFiles-1)/sqrt(numFiles)
        averaged_resampled_random_atlases[[i]][[j]][[2]][[l]] = averaged_resampled_random_atlases[[i]][[j]][[1]][[l]] + sterr_at_times
        averaged_resampled_random_atlases[[i]][[j]][[3]][[l]] = averaged_resampled_random_atlases[[i]][[j]][[1]][[l]] - sterr_at_times
      }
    }
  }
}
count = 1
for(i in 1:length(all_data_standard_atlases)){
  for(j in 1:length(all_data_standard_atlases[[i]])){
    for(k in 1:length(all_data_standard_atlases[[i]][[j]])){
      fileNum = 1
      all_raw_data = matrix(0,nrow=numFiles,ncol=length(all_data_standard_atlases[[i]][[j]][[k]]))
      for(cur_file in all_files){
        processed_SFC_path = paste(resampled_SFC_dir,cur_file,sep = "")
        load(processed_SFC_path)
        if(count==1){
          averaged_resampled_standard_atlases = all_data_standard_atlases
          upper_95_ci_standard_atlases = all_data_standard_atlases
          lower_95_ci_standard_atlases = all_data_standard_atlases
        }
        # pull off the current data 
        if(fileNum==1){
          averaged_resampled_standard_atlases[[i]][[j]][[k]] = all_data_standard_atlases[[i]][[j]][[k]]/numFiles
        } else{
          averaged_resampled_standard_atlases[[i]][[j]][[k]] = averaged_resampled_standard_atlases[[i]][[j]][[k]]+ (all_data_standard_atlases[[i]][[j]][[k]]/numFiles)
        }
        all_raw_data[fileNum,] = all_data_standard_atlases[[i]][[j]][[k]]
        count = count + 1
        fileNum = fileNum + 1
      }
      std_at_times = apply(all_raw_data,2,sd)
      sterr_at_times = std_at_times*qt(.975,df=numFiles-1)/sqrt(numFiles)
      upper_95_ci_standard_atlases[[i]][[j]][[k]] = averaged_resampled_standard_atlases[[i]][[j]][[k]] + sterr_at_times
      lower_95_ci_standard_atlases[[i]][[j]][[k]] = averaged_resampled_standard_atlases[[i]][[j]][[k]] - sterr_at_times
      
      
      
    }
  }
}

#making standard data structure the same as the random data structure

averaged_resampled_standard_atlases_structured = averaged_resampled_standard_atlases

num_files = length(names(averaged_resampled_standard_atlases_structured))
for (i in 1:num_files){
  for (j in 1:length(averaged_resampled_standard_atlases[[i]] )  ){
    averaged_resampled_standard_atlases_structured[[i]][[j]] = vector(mode = "list", length = 3) # making empty list to fill in mean, upper CI, and lower CI
    names(averaged_resampled_standard_atlases_structured[[i]][[j]]) = names(averaged_resampled_random_atlases$RA_N0010$interictal)
    
    averaged_resampled_standard_atlases_structured[[i]][[j]][[1]] = averaged_resampled_standard_atlases[[i]][[j]]
    averaged_resampled_standard_atlases_structured[[i]][[j]][[2]] = upper_95_ci_standard_atlases[[i]][[j]]
    averaged_resampled_standard_atlases_structured[[i]][[j]][[3]] =  lower_95_ci_standard_atlases[[i]][[j]]
  }

}





# count = 1
# for(cur_file in all_files){
#   processed_SFC_path = paste(resampled_SFC_dir,cur_file,sep = "")
#   load(processed_SFC_path)
#   if(count==1){
#     averaged_resampled_random_atlases = all_data_random_atlases
#     averaged_resampled_standard_atlases = all_data_standard_atlases
#   }
#   for(i in 1:length(all_data_standard_atlases)){
#     for(j in 1:length(all_data_standard_atlases[[i]])){
#       for(k in 1:length(all_data_standard_atlases[[i]][[j]])){
#         # pull off the current data 
#         if(count==1){
#           averaged_resampled_standard_atlases[[i]][[j]][[k]] = averaged_resampled_standard_atlases[[i]][[j]][[k]]/numFiles
#         } else{
#           averaged_resampled_standard_atlases[[i]][[j]][[k]]= averaged_resampled_standard_atlases[[i]][[j]][[k]]+ (all_data_standard_atlases[[i]][[j]][[k]]/numFiles)
#         }
#       }
#     }
#   }
#   count = count + 1
#   
# }

averaged_resampled_standard_atlases = averaged_resampled_standard_atlases_structured 
save(averaged_resampled_random_atlases, averaged_resampled_standard_atlases, file = output_path)

