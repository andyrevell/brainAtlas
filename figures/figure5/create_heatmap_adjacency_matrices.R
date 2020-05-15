#Purpose: Generate fake adjacency heatmap figures for illustration purposes
library(igraph)
library(pheatmap)
library(R.matlab)#read matlab mat files
library(reticulate)#read python pickle files
library(abind) #combin multidimention matrices

#parameters to change:
data_directory = "/Users/andyrevell/mount/USERS/arevell/papers/paper001/data_processed/figure5_data/"
figure_directory = "/Users/andyrevell/mount/USERS/arevell/papers/paper001/paper001/figures/figure5/"
video_directory = "/Users/andyrevell/Desktop/supplemental_videos/functional_matrices_video/"
setwd(figure_directory)
n= 40 #number of cells in matrix
number_of_images = 5
color_matrix = 1 #1 = red, 2 = blue, 3 = red-blue matrices
#code to generate random adjacency matrix figures:
for (a in 1:number_of_images){  
  #making random matrix
  test = matrix(rnorm(n^2), n, n)*1
  test[1:10, seq(1, n, 2)] = test[1:10, seq(1, n, 2)] + 3
  test[11:20, seq(2, n, 2)] = test[11:20, seq(2, n, 2)] - 2
  test[15:20, seq(2, n, 2)] = test[15:20, seq(2, n, 2)] + 2
  test[21:40, seq(2, n, 2)] = test[21:40, seq(2, n, 2)] + 2
  test[31:40, seq(2, n, 2)] = test[31:40, seq(2, n, 2)] - 4
  for (x in 1:nrow(test)){
    for (y  in 1:ncol(test)){
      test[x,y] = test[y,x]
    }
  }
  #red
  if (color_matrix==1){
    pdf(paste0(figure_directory, "matrix_red_", sprintf("%02d",a), ".pdf") , width = 5, height = 5)
    color = colorRampPalette(c("#ffcccc", "#aa3333","#330000", "#111111"))(100)
    pheatmap(test, color = color, legend = F, border_color = NA, cluster_rows = T,cluster_cols = T, treeheight_row = 0, treeheight_col = 0)
    dev.off()
    }
  

  #blue
  if (color_matrix==2){
    pdf(paste0(figure_directory,"matrix_blue_", sprintf("%02d",a), ".pdf") , width = 5, height = 5)  
    color = colorRampPalette(c("#ffffff", "#3333aa"))(100)
    pheatmap(test, color = color, legend = F, border_color = NA, cluster_rows = T,cluster_cols = T, treeheight_row = 0, treeheight_col = 0)
    dev.off()
    }
  #red-blue
  if (color_matrix==3){
    pdf(paste0(figure_directory,"matrix_redBlue_", sprintf("%02d",a), ".pdf") , width = 5, height = 5)    
    color = colorRampPalette(c( "#aa3333","#eeeeee", "#3333aa"))(100)
    pheatmap(test, color = color, legend = F, border_color = NA, cluster_rows = T,cluster_cols = T, treeheight_row = 0, treeheight_col = 0)
    dev.off()
    }
}

######
#create real_adjacency matrix from structure
files_to_read = c(
  "sub-RID278_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz.trk.gz.aal_res-1x1x1.count.pass.connectivity",
  "sub-RID278_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz.trk.gz.Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_1mm.count.pass.connectivity",
  "sub-RID278_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz.trk.gz.Schaefer2018_400Parcels_17Networks_order_FSLMNI152_1mm.count.pass.connectivity",
  "sub-RID278_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz.trk.gz.RA_N075_Perm0001.count.pass.connectivity",
  "sub-RID278_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz.trk.gz.RA_N100_Perm0001.count.pass.connectivity",
  "sub-RID278_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz.trk.gz.RA_N500_Perm0001.count.pass.connectivity",
  "sub-RID278_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz.trk.gz.RA_N1000_Perm0001.count.pass.connectivity",
  "sub-RID0508_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz.trk.gz.RA_N030_Perm0001.count.pass.connectivity",
  "sub-RID0508_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz.trk.gz.DK_res-1x1x1.count.pass.connectivity",
  "sub-RID0508_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz.trk.gz.JHU_res-1x1x1.count.pass.connectivity"
)

for (i in 1:length(files_to_read)){
  
  structure = readMat(paste0(data_directory,files_to_read[i], ".mat" ))$connectivity
  structure_image = structure
  structure_image[structure_image == 0] = 1
  structure_image = log10(structure_image) 
  structure_image = structure_image/max(structure_image)
  color = colorRampPalette(c( "#000000","#ccd9ff","#6699ff","#ffcccc","#ffcccc","#ff8080", "#4d0000", "#330000"))(1000)
  color = colorRampPalette(c("#000000","#ffffff"))(2000)
  color = colorRampPalette(c( "#ccd9ff","#6699ff","#ffcccc","#ffcccc","#ff8080", "#4d0000", "#330000"))(1000)
  color = colorRampPalette(c( "#ffffff","#ccd9ff","#6699ff","#ffcccc","#ffcccc","#ff8080", "#4d0000", "#330000"))(1000)
  
  
  pdf(paste0(figure_directory, files_to_read[i], ".pdf") , width = 5, height = 5)
  pheatmap(structure_image, color = color, legend = F, border_color = NA, cluster_rows = T,cluster_cols = T, treeheight_row = 0, treeheight_col = 0)
  dev.off()
  

}
#####


#create real_adjacency matrix from function

pd <- import("pandas")
data_preictal <- pd$read_pickle(paste0(data_directory, "sub-RID0278_HUP138_phaseII_415933490000_416023190000_functionalConnectivity.pickle"))
data_ictal  <- pd$read_pickle(paste0(data_directory,"sub-RID0278_HUP138_phaseII_416023190000_416112890000_functionalConnectivity.pickle"))
data_postictal <- pd$read_pickle(paste0(data_directory,"sub-RID0278_HUP138_phaseII_416112890000_416292890000_functionalConnectivity.pickle"))


data_preictal_broadband = data_preictal[[1]]
data_ictal_broadband = data_ictal[[1]]
data_postictal_broadband = data_postictal[[1]]

data_broadband = abind( data_preictal_broadband, data_ictal_broadband, data_postictal_broadband, along = 3)
dim(data_broadband)
data_broadband[dim(data_broadband)[1], dim(data_broadband)[1], ] = 1#scaling so that colors in heatmap are always on the same scale. The last pixel (bottom right corner) will always be 1

times = c(1,40, 79, 90, 100,110, 200)

color_time = c(rep('#008800',dim(data_preictal_broadband)[3] ), 
               rep('#000088',dim(data_ictal_broadband)[3] ),
               rep('#880088',dim(data_postictal_broadband)[3] ))


time = 0 - dim(data_preictal_broadband)[3] # for printing the time on the plot
for (t in 1:dim(data_broadband)[3]){
  
  color = colorRampPalette(c( "#ffffff","#ccd9ff","#6699ff","#ffcccc","#ffcccc","#ff8080", "#4d0000", "#330000"))(1000)
  
  matrix = data_broadband[,,t]
  fname = paste0(video_directory, "function_",  sprintf('%03d',t), ".png")
  png(fname, width = 512, height = 512, units = "px", res = 300)
  par("mar" = c(0,0,0,0)) 
  plot(NA,NA,xlim = c(0,10), ylim = c(0,10), xaxt = 'n', yaxt = 'n', bty = 'n', xlab = "", ylab = "")
  pheatmap(matrix, color = color, legend = F, border_color = NA, cluster_rows = F,cluster_cols = F, treeheight_row = 0, treeheight_col = 0)
  par(new=TRUE)
  par("mar" = c(0,0,0,0)) 
  plot(NA,NA,xlim = c(0,10), ylim = c(0,10), xaxt = 'n', yaxt = 'n')
  cex = 0.5
  x = 0.1; y = 0.1
  text(x = x, y = y, labels = paste0("time = "), adj = c(0, 0), cex = cex, font = 2 )
  text(x = x, y = y, labels = paste0("           ",time), adj = c(0, 0), col = color_time[t]  , cex = cex, font = 2)
  time = time + 1
  dev.off()
  
  
}


data_broadband[101, 101, ]


