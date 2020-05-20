#Purpose: Generate fake adjacency heatmap figures for illustration purposes
library(igraph)
library(pheatmap)
library(R.matlab)#read matlab mat files
library(reticulate)#read python pickle files
library(abind) #combin multidimention matrices
pd <- import("pandas")

#sub_ID='RID0194'; iEEG_filename = 'HUP134_phaseII_D02'; interictal_time = c(157702933433,	157882933433); preictal_time = c(179223935812,	179302933433); ictal_time = c(179302933433,	179381931054); postictal_time = c(179381931054,	179561931054)

#sub_ID='RID0278'; iEEG_filename = 'HUP138_phaseII'; interictal_time = c(226925740000,	227019140000); preictal_time = c(248432340000,	248525740000); ictal_time = c(248525740000,	248619140000); postictal_time = c(248619140000,	248799140000)
#sub_ID='RID0278'; iEEG_filename = 'HUP138_phaseII'; interictal_time = c(317408330000,	317568440000); preictal_time = c(338848220000,	339008330000); ictal_time = c(339008330000,	339168440000); postictal_time = c(339168440000,	339348440000)
#sub_ID='RID0278'; iEEG_filename = 'HUP138_phaseII'; interictal_time = c(394423190000,	394512890000); preictal_time = c(415933490000,	416023190000); ictal_time = c(416023190000,	416112890000); postictal_time = c(416112890000,	416292890000)
sub_ID='RID0278'; iEEG_filename = 'HUP138_phaseII'; interictal_time = c(407898590000,	407998350000); preictal_time = c(429398830000,	429498590000); ictal_time = c(429498590000,	429598350000); postictal_time = c(429598350000,	429778350000)
#sub_ID='RID0278'; iEEG_filename = 'HUP138_phaseII'; interictal_time = c(436904560000,	437015820000); preictal_time = c(458393300000,	458504560000); ictal_time = c(458504560000,	458615820000); postictal_time = c(458615820000,	458795820000)

#sub_ID='RID0309'; iEEG_filename = 'HUP151_phaseII'; interictal_time = c(473176000000,	473250000000); preictal_time = c(494702000000,	494776000000); ictal_time = c(494776000000,	494850000000); postictal_time = c(494850000000,	495030000000)
#sub_ID='RID0309'; iEEG_filename = 'HUP151_phaseII'; interictal_time = c(508411424682,	508484532533); preictal_time = c(529938316831,	530011424682); ictal_time = c(530011424682,	530084532533); postictal_time = c(530084532533,	530264532533)

#sub_ID='RID0536'; iEEG_filename = 'HUP195_phaseII_D01'; interictal_time = c(63129090000,	63309090000); preictal_time = c(84609521985,	84729094008); ictal_time = c(84729094008,	84848666031 ); postictal_time = c(84848666031,	85028666031)
#sub_ID='RID0536'; iEEG_filename = 'HUP195_phaseII_D01'; interictal_time = c(152892270000,	153072270000); preictal_time = c(164626956810,	164694572385); ictal_time = c(164694572385,	164762187960 ); postictal_time = c(164762187960,	164942187960)
#sub_ID='RID0536'; iEEG_filename = 'HUP195_phaseII_D01'; interictal_time = c(237460640000,	237640640000); preictal_time = c(250573896890,	250710930770); ictal_time = c(250710930770,	250847964650 ); postictal_time = c(250847964650,	251027964650)
#sub_ID='RID0536'; iEEG_filename = 'HUP195_phaseII_D01'; interictal_time = c(269881750000,	270061750000); preictal_time = c(286753301266,	286819539584); ictal_time = c(286819539584,	286885777902 ); postictal_time = c(286885777902,	287065777902)



BIDS_processed = "/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed"
functional_connectivity_directory = paste0(BIDS_processed, "/sub-", sub_ID, "/connectivity_matrices/functional/eeg" )
video_output_directory = "/Users/andyrevell/Box/video_images/functional_connectivity_matrices"
output_directory = paste0(video_output_directory, "/sub-", sub_ID,"/",ictal_time[1])
setwd(output_directory)

file_name = paste0(functional_connectivity_directory,"/sub-",sub_ID, "_", iEEG_filename,"_", preictal_time[1],"_", preictal_time[2], "_functionalConnectivity.pickle"  )
data_preictal <- pd$read_pickle(file_name)
file_name = paste0(functional_connectivity_directory,"/sub-",sub_ID, "_", iEEG_filename,"_", ictal_time[1],"_", ictal_time[2], "_functionalConnectivity.pickle"  )
data_ictal  <- pd$read_pickle(file_name)
file_name = paste0(functional_connectivity_directory,"/sub-",sub_ID, "_", iEEG_filename,"_", postictal_time[1],"_", postictal_time[2], "_functionalConnectivity.pickle"  )
data_postictal <- pd$read_pickle(file_name)



#create real_adjacency matrix from function


data_preictal_broadband = data_preictal[[1]]
data_ictal_broadband = data_ictal[[1]]
data_postictal_broadband = data_postictal[[1]]

data_broadband = abind( data_preictal_broadband, data_ictal_broadband, data_postictal_broadband, along = 3)
dim(data_broadband)
data_broadband[dim(data_broadband)[1], dim(data_broadband)[1], ] = 1#scaling so that colors in heatmap are always on the same scale. The last pixel (bottom right corner) will always be 1


color_time = c(rep('#008800',dim(data_preictal_broadband)[3] ), 
               rep('#000088',dim(data_ictal_broadband)[3] ),
               rep('#880088',dim(data_postictal_broadband)[3] ))


time = 0 - dim(data_preictal_broadband)[3] # for printing the time on the plot

percent_of_a_second = 1
time = seq( 0- dim(data_preictal_broadband)[3] *percent_of_a_second,  dim(data_ictal_broadband)[3] *percent_of_a_second + dim(data_postictal_broadband)[3] *percent_of_a_second,percent_of_a_second )
for (t in 1:dim(data_broadband)[3]){
  
  color = colorRampPalette(c( "#ffffff","#ccd9ff","#6699ff","#ffcccc","#ffcccc","#ff8080", "#4d0000", "#330000"))(1000)
  
  matrix = data_broadband[,,t]
  fname = paste0('sub-', sub_ID, '_', iEEG_filename,  '_ICTAL_', ictal_time[1], '_SFC_All_Atlases.RData')
  fname = paste0(output_directory,'/sub-', sub_ID, '_', iEEG_filename,  '_ICTAL_', ictal_time[1],  "_matrix_",  sprintf('%04d',t), ".png")
  png(fname, width = 1024, height = 1024, units = "px", res = 300)
  par("mar" = c(0,0,0,0)) 
  plot(NA,NA,xlim = c(0,10), ylim = c(0,10), xaxt = 'n', yaxt = 'n', bty = 'n', xlab = "", ylab = "")
  pheatmap(matrix, color = color, legend = F, border_color = NA, cluster_rows = F,cluster_cols = F, treeheight_row = 0, treeheight_col = 0)
  par(new=TRUE)
  par("mar" = c(0,0,0,0)) 
  plot(NA,NA,xlim = c(0,10), ylim = c(0,10), xaxt = 'n', yaxt = 'n')
  cex = 0.7
  x = 0.1; y = 0.1
  text(x = x, y = y, labels = paste0("time = "), adj = c(0, 0), cex = cex, font = 2 )
  text(x = x, y = y, labels = paste0("           ",  round(time[t]) ), adj = c(0, 0), col = color_time[t]  , cex = cex, font = 2)
  x = 0.1; y = -0.1
  text(x = x, y = y, labels = paste0('sub-', sub_ID, '_', iEEG_filename,  '_ICTAL_', ictal_time[1]), adj = c(0,0), cex = cex/2, font = 2 )
       #time = time + 1
  dev.off()
       
       
}

#To makes video, run in terminal
#ffmpeg -framerate 15 -pattern_type glob -i '*.png' -y -c:v libx264 01_functional_connectivity.mp4
#Run directly in R:


system(  sprintf("ffmpeg -framerate 15 -pattern_type glob -i '*.png' -y -c:v libx264 sub-%s_%s_ICTAL_%s_functionalConnectivityVideo.mp4", sub_ID, iEEG_filename, ictal_time[1] ) )
