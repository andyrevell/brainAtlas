#Ignore: For Alex Computer 
#resampled_SFC_dir = "./resampled_SFC/max/"
#output_path = "./resampled_SFC/averaged_resampled_data/max/averaged_resampled_max.RData"


#Andys Computer:
SFC_dir = "/Users/andyrevell/mount/USERS/arevell/papers/paper001/data_processed/figure5_data/structure_function_correlation/"
output_path = "/Users/andyrevell/mount/USERS/arevell/papers/paper001/data_processed/figure6_data/average_Ictal_mean_and_Difference_calculation/average_Ictal_mean_and_Difference_calculation.RData"

#Borel
# Change this to be either up/downsample/median
#SFC_dir = "/gdrive/public/USERS/arevell/papers/paper001/data_processed/figure6_data/average_SFC_ALL_PATIENTS/medians/"
# Change this to be either up/downsample/median
#output_path = "/gdrive/public/USERS/arevell/papers/paper001/data_processed/figure6_data/average_SFC_ALL_PATIENTS/averaged_resampled_data/medians/averaged_resampled_data.RData"

all_files = dir(SFC_dir)
count = 1
numFiles = as.numeric(length(all_files))

for(cur_file in all_files){
  processed_SFC_path = paste0(SFC_dir,cur_file)
  load(processed_SFC_path)
  for(i in 1:length(all_data_random_atlases)){
    for(k in 1:length(all_data_random_atlases[[i]]$ictal$mean ) )  {
    
      # intialize list to save means and absolute difference
          if (count==1 & k == 1 & i == 1){
            means_random_atlases = vector(mode = "list", length = length(all_data_random_atlases[[i]]$ictal$mean ))
            names(means_random_atlases) = names(all_data_random_atlases[[i]]$ictal$mean )
            difference_random_atlases = vector(mode = "list", length = length(all_data_random_atlases[[i]]$ictal$mean ))
            names(difference_random_atlases) = names(all_data_random_atlases[[i]]$ictal$mean )
            for(t in 1:length(all_data_random_atlases[[i]]$ictal$mean ) )  {
              means_random_atlases[[t ]] = data.frame(matrix(NA, nrow = length(all_data_random_atlases), ncol =  numFiles), row.names = names(all_data_random_atlases) )
              difference_random_atlases[[t]] =  data.frame( matrix(NA, nrow = length(all_data_random_atlases), ncol =  numFiles), row.names = names(all_data_random_atlases)  )
              colnames(means_random_atlases[[t]]) = substr(all_files,1,nchar(all_files)-22)
              colnames(difference_random_atlases[[t]]) = substr(all_files,1,nchar(all_files)-22)
            
          }
        }
      means_random_atlases[[k]][i,count]  =      mean(na.omit(all_data_random_atlases[[i]]$ictal$mean[[k]]))
      difference_random_atlases[[k]][i,count]  = mean(na.omit(all_data_random_atlases[[i]]$ictal$mean[[k]])) - mean(na.omit(all_data_random_atlases[[i]]$preictal$mean[[k]]))     #remove any NA's
      
    }
  }
  
  for(i in 1:length(all_data_standard_atlases)){
   
      for(k in 1:length(all_data_standard_atlases[[i]]$ictal)){
        # pull off the current data 
        if (count==1 & k == 1 & i == 1){
            means_standard_atlases = vector(mode = "list", length = length(all_data_standard_atlases[[i]]$ictal ))
            names(means_standard_atlases) = names(all_data_standard_atlases[[i]]$ictal )
            difference_standard_atlases = vector(mode = "list", length = length(all_data_standard_atlases[[i]]$ictal ))
            names(difference_standard_atlases) = names(all_data_standard_atlases[[i]]$ictal )
            for(t in 1:length(all_data_standard_atlases[[i]]$ictal ) )  {
              means_standard_atlases[[t]] = data.frame(matrix(NA, nrow = length(all_data_standard_atlases), ncol =  numFiles), row.names = names(all_data_standard_atlases) )
              difference_standard_atlases[[t]] =  data.frame( matrix(NA, nrow = length(all_data_standard_atlases), ncol =  numFiles), row.names = names(all_data_standard_atlases)  )
              colnames(means_standard_atlases[[t]]) = substr(all_files,1,nchar(all_files)-22)
              colnames(difference_standard_atlases[[t]]) = substr(all_files,1,nchar(all_files)-22)
          }
        }
        means_standard_atlases[[k]][i,count]  =      mean(na.omit(all_data_standard_atlases[[i]]$ictal[[k]]))     #remove any NA's   
        difference_standard_atlases[[k]][i,count]  = mean(na.omit(all_data_standard_atlases[[i]]$ictal[[k]])) - mean(na.omit(all_data_standard_atlases[[i]]$preictal[[k]]))     #remove any NA's
        }
      }
    
  count = count + 1
}
  
#plot(x = c(1:12),   y = rowMeans(means_random_atlases[[1]])   )
#plot(x = c(1:12),   y = rowMeans(  abs( difference_random_atlases[[1]])    )   )

save(means_random_atlases, means_standard_atlases, difference_random_atlases,difference_standard_atlases, file = output_path)

