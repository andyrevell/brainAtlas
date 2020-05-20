# Install the pracma package before using  
resample_SFC <- function(processed_SFC_path,output_resampled_SFC_path,desired_length){
  load(processed_SFC_path)
  for(i in 1:length(all_data_random_atlases)){
    for(j in 1:length(all_data_random_atlases[[i]])){
      for(k in 1:length(all_data_random_atlases[[i]][[j]])){
        for(l in 1:length(all_data_random_atlases[[i]][[j]][[k]])){
          # pull off the current data 
          cur_sfc_data = all_data_random_atlases[[i]][[j]][[k]][[l]]
          if(length(cur_sfc_data)!= desired_length){
            #in this case we have to interpolate to match the dimensions
            new_sfc_data = interp1(seq(1,length(cur_sfc_data)),cur_sfc_data,seq(1,length(cur_sfc_data),len = desired_length),method = "linear")
            
          } else{
            #no need to make any changes 
            new_sfc_data = cur_sfc_data
            
            
          }
          all_data_random_atlases[[i]][[j]][[k]][[l]] = new_sfc_data
          
        }
        
      }
    }
          
  }
  
  for(i in 1:length(all_data_standard_atlases)){
    for(j in 1:length(all_data_standard_atlases[[i]])){
      for(k in 1:length(all_data_standard_atlases[[i]][[j]])){
          # pull off the current data 
          cur_sfc_data = as.numeric(all_data_standard_atlases[[i]][[j]][[k]])
          if(length(cur_sfc_data)!= desired_length){
            #in this case we have to interpolate to match the dimensions
            new_sfc_data = interp1(seq(1,length(cur_sfc_data)),cur_sfc_data,seq(1,length(cur_sfc_data),len = desired_length),method = "linear")
            
          } else{
            #no need to make any changes 
            new_sfc_data = cur_sfc_data
            
            
          }
          all_data_standard_atlases[[i]][[j]][[k]] = new_sfc_data
          
        }
        
     }
  }
    
  
  
  
  save(all_data_random_atlases, all_data_standard_atlases, file = output_resampled_SFC_path)
  
  
  
}