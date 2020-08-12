library(reticulate)#read python pickle files
pd <- import("pandas")
#Plot SFC
# Alex computer
BIDS_directory = "/Users/asilva/mount/USERS/arevell/papers/paper001/data_processed/structure_function_correlation_AS/regress_out_struc_distance"
#BIDS_directory = "/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed"
output_directory = "/Users/asilva/mount/USERS/arevell/papers/paper001/paper001/figures/S1/structure_function_correlation_regress_struc_dist"
#output_directory= "/Users/andyrevell/mount/USERS/arevell/papers/paper001/data_processed/figure5_data/structure_function_correlation"
#video_directory = "/Users/andyrevell/Desktop/supplemental_videos/functional_matrices_win02/"
setwd(output_directory)

options(scipen=999)#prevent scientifuc notation. iEEG org times are very long, so helps when reading files to read the number string verb
for (z in 2:6){
  if (z == 1){sub_ID='RID0194'; iEEG_filename = 'HUP134_phaseII_D02'; interictal_time = c(157702933433,	157882933433); preictal_time = c(179223935812,	179302933433); ictal_time = c(179302933433,	179381931054); postictal_time = c(179381931054,	179561931054)}

  if (z == 2){sub_ID='RID0278'; iEEG_filename = 'HUP138_phaseII'; interictal_time = c(226925740000,	227019140000); preictal_time = c(248432340000,	248525740000); ictal_time = c(248525740000,	248619140000); postictal_time = c(248619140000,	248799140000)}
  if (z == 3){sub_ID='RID0278'; iEEG_filename = 'HUP138_phaseII'; interictal_time = c(317408330000,	317568440000); preictal_time = c(338848220000,	339008330000); ictal_time = c(339008330000,	339168440000); postictal_time = c(339168440000,	339348440000)}
  if (z == 4){sub_ID='RID0278'; iEEG_filename = 'HUP138_phaseII'; interictal_time = c(394423190000,	394512890000); preictal_time = c(415933490000,	416023190000); ictal_time = c(416023190000,	416112890000); postictal_time = c(416112890000,	416292890000)}
  if (z == 5){sub_ID='RID0278'; iEEG_filename = 'HUP138_phaseII'; interictal_time = c(407898590000,	407998350000); preictal_time = c(429398830000,	429498590000); ictal_time = c(429498590000,	429598350000); postictal_time = c(429598350000,	429778350000)}
  if (z == 6){sub_ID='RID0278'; iEEG_filename = 'HUP138_phaseII'; interictal_time = c(436904560000,	437015820000); preictal_time = c(458393300000,	458504560000); ictal_time = c(458504560000,	458615820000); postictal_time = c(458615820000,	458795820000)}


  if (z == 7){sub_ID='RID0309'; iEEG_filename = 'HUP151_phaseII'; interictal_time = c(473176000000,	473250000000); preictal_time = c(494702000000,	494776000000); ictal_time = c(494776000000,	494850000000); postictal_time = c(494850000000,	495030000000)}
  if (z == 8){sub_ID='RID0309'; iEEG_filename = 'HUP151_phaseII'; interictal_time = c(508411424682,	508484532533); preictal_time = c(529938316831,	530011424682); ictal_time = c(530011424682,	530084532533); postictal_time = c(530084532533,	530264532533)}

  #if (z == 9){sub_ID='RID0320'; iEEG_filename = 'HUP140_phaseII_D02'; interictal_time = c(310379921071,	310559921071); preictal_time = c(331624747156,	331979921071); ictal_time = c(331979921071,	332335094986); postictal_time = c(332335094986,	332635094986)}
  if (z == 9){sub_ID='RID0320'; iEEG_filename = 'HUP140_phaseII_D02'; interictal_time = c(310399132626,	310579132626); preictal_time = c(331624747156,	331979921071); ictal_time = c(331979921071,	332335094986); postictal_time = c(332335094986,	332635094986)}#####
  if (z == 10){sub_ID='RID0320'; iEEG_filename = 'HUP140_phaseII_D02'; interictal_time = c(318928040025,	319108040025); preictal_time = c(340243011431,	340528040025); ictal_time = c(340528040025,	340813068619); postictal_time = c(340813068619,	341113068619)}
  if (z == 11){sub_ID='RID0320'; iEEG_filename = 'HUP140_phaseII_D02'; interictal_time = c(302115130000,	302295130000); preictal_time = c(344266714798, 344573548935); ictal_time = c(344573548935,	344880383072); postictal_time = c(344880383072,	345180383072)}

  if (z == 12){sub_ID='RID0440'; iEEG_filename = 'HUP172_phaseII'; interictal_time = c(356850680000,	356903099171); preictal_time = c(402651841658,	402704260829); ictal_time = c(402704260829,	402756680000 ); postictal_time = c(402756680000,	402936680000)}
  if (z == 13){sub_ID='RID0440'; iEEG_filename = 'HUP172_phaseII'; interictal_time = c(367346290000, 367406750000); preictal_time = c(408637470000, 408697930000); ictal_time = c(408697930000, 408758390000); postictal_time = c(408758390000, 408938390000)}
  if (z == 14){sub_ID='RID0440'; iEEG_filename = 'HUP172_phaseII'; interictal_time = c(565390000000, 565452288685); preictal_time = c(586927711315, 586990000000); ictal_time = c(586990000000, 587052288685); postictal_time = c(587052288685, 587232288685)}
  if (z == 15){sub_ID='RID0440'; iEEG_filename = 'HUP172_phaseII'; interictal_time = c(643376000000, 643427219061); preictal_time = c(664924780939, 664976000000); ictal_time = c(664976000000, 665027219061); postictal_time = c(665027219061, 665207219061)}
  if (z == 16){sub_ID='RID0440'; iEEG_filename = 'HUP172_phaseII'; interictal_time = c(671279000000, 671337000000); preictal_time = c(692821000000, 692879000000); ictal_time = c(692879000000, 692937000000); postictal_time = c(692937000000, 693117000000)}

  if (z == 17){sub_ID='RID0536'; iEEG_filename = 'HUP195_phaseII_D01'; interictal_time = c(63129090000,	63309090000); preictal_time = c(84609521985,	84729094008); ictal_time = c(84729094008,	84848666031 ); postictal_time = c(84848666031,	85028666031)}
  if (z == 18){sub_ID='RID0536'; iEEG_filename = 'HUP195_phaseII_D01'; interictal_time = c(152892270000,	153072270000); preictal_time = c(164626956810,	164694572385); ictal_time = c(164694572385,	164762187960 ); postictal_time = c(164762187960,	164942187960)}
  if (z == 19){sub_ID='RID0536'; iEEG_filename = 'HUP195_phaseII_D01'; interictal_time = c(237460640000,	237640640000); preictal_time = c(250573896890,	250710930770); ictal_time = c(250710930770,	250847964650 ); postictal_time = c(250847964650,	251027964650)}
  if (z == 20){sub_ID='RID0536'; iEEG_filename = 'HUP195_phaseII_D01'; interictal_time = c(269881750000,	270061750000); preictal_time = c(286753301266,	286819539584); ictal_time = c(286819539584,	286885777902 ); postictal_time = c(286885777902,	287065777902)}




data_directory = paste0(BIDS_directory,'/', 'sub-', sub_ID)


#SFC Random Atlases
atlases=c('RA_N0010', 'RA_N0030', 'RA_N0050', 'RA_N0075','RA_N0100','RA_N0200','RA_N0300', 'RA_N0400', 'RA_N0500' , 'RA_N0750', 'RA_N1000', 'RA_N2000')
#initialize matrices to store all data for each atlas in a list
all_data_random_atlases = vector(mode = "list", length = length(atlases))
names(all_data_random_atlases) = atlases

for (a in 1:(length(atlases))){
  atlas_data_directory = paste0(data_directory, '/',atlases[a] )
  atlas_folder = atlases[a]
  perm = c(1:30)



  for (p in 1:(length(perm))){
    print(paste0(sub_ID, " Atlas ", atlas_folder, " perm ", p) )
    data_interictal_file_name = paste0('sub-', sub_ID, '_' , iEEG_filename, '_', interictal_time[1], '_', interictal_time[2], '_', atlas_folder, '_Perm', sprintf('%04d',perm[p]),'_regress_distance_correlation.pickle')
    data_preictal_file_name = paste0('sub-', sub_ID, '_' , iEEG_filename, '_', preictal_time[1], '_', preictal_time[2], '_', atlas_folder, '_Perm', sprintf('%04d',perm[p]),'_regress_distance_correlation.pickle')
    data_ictal_file_name = paste0('sub-', sub_ID, '_' , iEEG_filename, '_', ictal_time[1], '_', ictal_time[2], '_', atlas_folder ,'_Perm', sprintf('%04d',perm[p]),'_regress_distance_correlation.pickle')
    data_postictal_file_name = paste0('sub-', sub_ID, '_' , iEEG_filename, '_', postictal_time[1], '_', postictal_time[2], '_', atlas_folder ,'_Perm', sprintf('%04d',perm[p]),'_regress_distance_correlation.pickle')

    data_interictal_filepath = paste0(atlas_data_directory, '/', data_interictal_file_name)
    data_preictal_filepath = paste0(atlas_data_directory, '/', data_preictal_file_name)
    data_ictal_file_path = paste0(atlas_data_directory, '/', data_ictal_file_name)
    data_postictal_filepath = paste0(atlas_data_directory, '/', data_postictal_file_name)

    data_interictal <- pd$read_pickle(data_interictal_filepath)
        names(data_interictal) = data_interictal[6][[1]][,1]
    data_preictal <- pd$read_pickle(data_preictal_filepath)
        names(data_preictal) = data_preictal[6][[1]][,1]
    data_ictal <- pd$read_pickle(data_ictal_file_path)
        names(data_ictal) = data_ictal[6][[1]][,1]
    data_postictal <- pd$read_pickle(data_postictal_filepath)
        names(data_postictal) = data_postictal[6][[1]][,1]

    data_interictal = data_interictal[1:5]
    data_preictal = data_preictal[1:5]
    data_ictal = data_ictal[1:5]
    data_postictal = data_postictal[1:5]

    #initialize average data matrices
    if (p == 1){

      all_data_interictal = vector(mode = "list", length = 5)
          names(all_data_interictal) = names(data_interictal)
      all_data_preictal = vector(mode = "list", length = 5)
          names(all_data_preictal) = names(data_preictal)
      all_data_ictal = vector(mode = "list", length = 5)
          names(all_data_ictal) = names(data_ictal)
      all_data_postictal = vector(mode = "list", length = 5)
          names(all_data_postictal) = names(data_postictal)

      avg_data_interictal = vector(mode = "list", length = 5)
          names(avg_data_interictal) = names(data_interictal)
      avg_data_preictal = vector(mode = "list", length = 5)
          names(avg_data_preictal) = names(data_preictal)
      avg_data_ictal = vector(mode = "list", length = 5)
          names(avg_data_ictal) = names(data_ictal)
      avg_data_postictal = vector(mode = "list", length = 5)
          names(avg_data_postictal) = names(data_postictal)

      std_data_interictal = vector(mode = "list", length = 5)
          names(std_data_interictal) = names(data_interictal)
      std_data_preictal = vector(mode = "list", length = 5)
          names(std_data_preictal) = names(data_preictal)
      std_data_ictal = vector(mode = "list", length = 5)
          names(std_data_ictal) = names(data_ictal)
      std_data_postictal = vector(mode = "list", length = 5)
          names(std_data_postictal) = names(data_postictal)

      for (i in 1:5){
        all_data_interictal[i][[1]] = matrix(nrow = length(perm), ncol =length( data_interictal[1][[1]]) ,rep(0, length( data_interictal[1][[1]])  ))
        all_data_preictal[i][[1]] = matrix(nrow = length(perm), ncol =length( data_preictal[1][[1]]) ,rep(0, length( data_preictal[1][[1]])  ))
        all_data_ictal[i][[1]] = matrix(nrow = length(perm), ncol =length( data_ictal[1][[1]]) ,rep(0, length( data_ictal[1][[1]])  ))
        all_data_postictal[i][[1]] = matrix(nrow = length(perm), ncol =length( data_postictal[1][[1]]) ,rep(0, length( data_postictal[1][[1]])  ))
      }
    }

    #populate average data matrices for each perm
    for (i in 1:5){
      all_data_interictal[i][[1]][p,]  = data_interictal[i][[1]]
      all_data_preictal[i][[1]][p,] = data_preictal[i][[1]]
      all_data_ictal[i][[1]][p,] = data_ictal[i][[1]]
      all_data_postictal[i][[1]][p,] = data_postictal[i][[1]]
    }


  }#end p


  #calculate means and standard deviations

  for (i in 1:5){
    avg_data_interictal[i][[1]]  = apply(all_data_interictal[i][[1]], 2, mean)
    avg_data_preictal[i][[1]] =  apply(all_data_preictal[i][[1]], 2, mean)
    avg_data_ictal[i][[1]] =  apply(all_data_ictal[i][[1]], 2, mean)
    avg_data_postictal[i][[1]] =  apply(all_data_postictal[i][[1]], 2, mean)

    std_data_interictal[i][[1]]  =  apply(all_data_interictal[i][[1]], 2, sd)
    std_data_preictal[i][[1]] =  apply(all_data_preictal[i][[1]], 2, sd)
    std_data_ictal[i][[1]] =  apply(all_data_ictal[i][[1]], 2, sd)
    std_data_postictal[i][[1]] =   apply(all_data_postictal[i][[1]], 2, sd)
  }

  #initialize 95% confidence interval matrices
  CI95_data_interictal_upper  = avg_data_interictal
  CI95_data_preictal_upper = avg_data_preictal
  CI95_data_ictal_upper = avg_data_ictal
  CI95_data_postictal_upper =  avg_data_postictal

  CI95_data_interictal_lower  = avg_data_interictal
  CI95_data_preictal_lower = avg_data_preictal
  CI95_data_ictal_lower= avg_data_ictal
  CI95_data_postictal_lower =  avg_data_postictal

  #Populate 95% Confidence Interval using t-distribution
  t_dist= 2.042

  for (i in 1:5){
    CI95_data_interictal_upper[i][[1]]  = avg_data_interictal[i][[1]] + std_data_interictal[i][[1]]/sqrt(length(perm))*t_dist
    CI95_data_preictal_upper[i][[1]] = avg_data_preictal[i][[1]] + std_data_preictal[i][[1]]/sqrt(length(perm))*t_dist
    CI95_data_ictal_upper[i][[1]] = avg_data_ictal[i][[1]] + std_data_ictal[i][[1]]/sqrt(length(perm))*t_dist
    CI95_data_postictal_upper[i][[1]] =  avg_data_postictal[i][[1]] + std_data_postictal[i][[1]]/sqrt(length(perm))*t_dist

    CI95_data_interictal_lower[i][[1]]  = avg_data_interictal[i][[1]] - std_data_interictal[i][[1]]/sqrt(length(perm))*t_dist
    CI95_data_preictal_lower[i][[1]] = avg_data_preictal[i][[1]] - std_data_preictal[i][[1]]/sqrt(length(perm))*t_dist
    CI95_data_ictal_lower[i][[1]] = avg_data_ictal[i][[1]] - std_data_ictal[i][[1]]/sqrt(length(perm))*t_dist
    CI95_data_postictal_lower[i][[1]] =  avg_data_postictal[i][[1]] - std_data_postictal[i][[1]]/sqrt(length(perm))*t_dist
  }


  all_data_random_atlases[[a]] = vector(mode = "list", length = 4)
  names(all_data_random_atlases[[a]] ) = c("interictal", "preictal", "ictal", "postictal")


  for (i in 1:4){
    all_data_random_atlases[[a]][[i]] = vector(mode = "list", length = 3)
    names(all_data_random_atlases[[a]][[i]]) = c("mean", "CI95_upper", "CI95_lower")
  }
  all_data_random_atlases[[a]]$interictal$mean = avg_data_interictal
  all_data_random_atlases[[a]]$interictal$CI95_upper = CI95_data_interictal_upper
  all_data_random_atlases[[a]]$interictal$CI95_lower = CI95_data_interictal_lower

  all_data_random_atlases[[a]]$preictal$mean = avg_data_preictal
  all_data_random_atlases[[a]]$preictal$CI95_upper = CI95_data_preictal_upper
  all_data_random_atlases[[a]]$preictal$CI95_lower = CI95_data_preictal_lower

  all_data_random_atlases[[a]]$ictal$mean = avg_data_ictal
  all_data_random_atlases[[a]]$ictal$CI95_upper = CI95_data_ictal_upper
  all_data_random_atlases[[a]]$ictal$CI95_lower = CI95_data_ictal_lower

  all_data_random_atlases[[a]]$postictal$mean = avg_data_postictal
  all_data_random_atlases[[a]]$postictal$CI95_upper = CI95_data_postictal_upper
  all_data_random_atlases[[a]]$postictal$CI95_lower = CI95_data_postictal_lower

}#end atlases a.





#SFC Standard Atlases
atlases=c('aal_res-1x1x1', 'AAL600', 'CPAC200_res-1x1x1', 'desikan_res-1x1x1','DK_res-1x1x1','JHU_res-1x1x1',
          'Schaefer2018_100Parcels_17Networks_order_FSLMNI152_1mm', 'Schaefer2018_200Parcels_17Networks_order_FSLMNI152_1mm',
          'Schaefer2018_300Parcels_17Networks_order_FSLMNI152_1mm' , 'Schaefer2018_400Parcels_17Networks_order_FSLMNI152_1mm', 
          'Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_1mm', 'Talairach_res-1x1x1', 'JHU_aal_combined_res-1x1x1')

#initialize matrices to store all data for each atlas in a list
all_data_standard_atlases = vector(mode = "list", length = length(atlases))
names(all_data_standard_atlases) = atlases

for (a in 1:(length(atlases))){
  atlas_data_directory = paste0(data_directory, '/',atlases[a] )
  atlas_folder = atlases[a]
  
  data_interictal_file_name = paste0('sub-', sub_ID, '_' , iEEG_filename, '_', interictal_time[1], '_', interictal_time[2], '_', atlas_folder,'_correlation.pickle')
  data_preictal_file_name = paste0('sub-', sub_ID, '_' , iEEG_filename, '_', preictal_time[1], '_', preictal_time[2], '_', atlas_folder, '_correlation.pickle')
  data_ictal_file_name = paste0('sub-', sub_ID, '_' , iEEG_filename, '_', ictal_time[1], '_', ictal_time[2], '_', atlas_folder , '_correlation.pickle')
  data_postictal_file_name = paste0('sub-', sub_ID, '_' , iEEG_filename, '_', postictal_time[1], '_', postictal_time[2], '_', atlas_folder ,'_correlation.pickle')
  
  data_interictal_filepath = paste0(atlas_data_directory, '/', data_interictal_file_name)
  data_preictal_filepath = paste0(atlas_data_directory, '/', data_preictal_file_name)
  data_ictal_file_path = paste0(atlas_data_directory, '/', data_ictal_file_name)
  data_postictal_filepath = paste0(atlas_data_directory, '/', data_postictal_file_name)
  
  
  data_interictal <- pd$read_pickle(data_interictal_filepath)
  names(data_interictal) = data_interictal[6][[1]][,1]
  data_preictal <- pd$read_pickle(data_preictal_filepath)
  names(data_preictal) = data_preictal[6][[1]][,1]
  data_ictal <- pd$read_pickle(data_ictal_file_path)
  names(data_ictal) = data_ictal[6][[1]][,1]
  data_postictal <- pd$read_pickle(data_postictal_filepath)
  names(data_postictal) = data_postictal[6][[1]][,1]
  
  data_interictal = data_interictal[1:5]
  data_preictal = data_preictal[1:5]
  data_ictal = data_ictal[1:5]
  data_postictal = data_postictal[1:5]
    

  all_data_standard_atlases[[a]] = vector(mode = "list", length = 4)
  names(all_data_standard_atlases[[a]] ) = c("interictal", "preictal", "ictal", "postictal")
  
  all_data_standard_atlases[[a]]$interictal = data_interictal
  all_data_standard_atlases[[a]]$preictal = data_preictal
  all_data_standard_atlases[[a]]$ictal = data_ictal
  all_data_standard_atlases[[a]]$postictal= data_postictal
  
}#end atlases a. 

file_name = paste0('sub-', sub_ID, '_', iEEG_filename,  '_ICTAL_', ictal_time[1], '_SFC_All_Atlases.RData')
save(all_data_random_atlases, all_data_standard_atlases, file = paste0(output_directory, '/',file_name ))







}


