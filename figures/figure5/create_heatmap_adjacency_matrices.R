#Purpose: Generate fake adjacency heatmap figures for illustration purposes
library(igraph)
library(pheatmap)
library(R.matlab)

#parameters to change:
data_directory = "/Users/andyrevell/Box/01_papers/paper001_brainAtlasChoiceSFC/figure5_data/"
figure_directory = "/Users/andyrevell/Documents/01_writing/00_thesis_work/06_papers/paper001_brainAtlasChoiceSFC/figures/figure5/"
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



#create real_adjacency matrix from structure
structure = readMat(paste0(data_directory,
                           "sub-RID278_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz.trk.gz.
                           aal_res-1x1x1.count.pass.connectivity.mat"))$connectivity
structure = readMat(paste0(data_directory,
                           "sub-RID278_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz.trk.gz.
                           Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_1mm.count.pass.connectivity.mat"))$connectivity
structure = readMat(paste0(data_directory,
                           "sub-RID278_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz.trk.gz.
                           Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_1mm.count.pass.connectivity.mat"))$connectivity
structure = readMat(paste0(data_directory,
                           "sub-RID278_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz.trk.gz.RA_N075_Perm0001.count.pass.connectivity.mat"))$connectivity
structure = readMat(paste0(data_directory,
                           "sub-RID278_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz.trk.gz.RA_N100_Perm0001.count.pass.connectivity.mat"))$connectivity
structure = readMat(paste0(data_directory,
                           "sub-RID278_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz.trk.gz.RA_N500_Perm0001.count.pass.connectivity.mat"))$connectivity
structure = readMat(paste0(data_directory,
                           "sub-RID278_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz.trk.gz.RA_N1000_Perm0001.count.pass.connectivity.mat"))$connectivity


#normalize
structure[structure == 0] = 1
structure = log10(structure) 
structure = structure/max(structure)
color = colorRampPalette(c( "#ffffff","#ccd9ff","#6699ff","#ffcccc","#ffcccc","#ff8080", "#4d0000", "#330000"))(1000)
pdf(paste0(figure_directory, "sturctural_network", ".pdf") , width = 5, height = 5)
pheatmap(structure, color = color, legend = F, border_color = NA, cluster_rows = T,cluster_cols = T, treeheight_row = 0, treeheight_col = 0)
dev.off()



structure[log10(structure) == -Inf] = 0


madeup_data <- 1:30*(rnorm(30)+3)


par(mai = c(1.7, 1 , 0, 0.0))

par(mai = c(0.1,0.1 , 0, 0.0))
plot(madeup_data, col = "#aa00aa", pch = 16, cex = 2.5, 
     xlab = "",
     ylab = "", 
     cex.lab = 3, font.lab = 2, xaxt="n", yaxt="n", bty='n' )

#title(ylab="iEEG FC", line=0.4, cex.lab=5, font.lab = 2)
#title(xlab="Training \nNetwork Features", line=7.4, cex.lab=5, font.lab = 2)

model <- lm(madeup_data ~ c(1:30))
abline(model,   col="#aa00aaff", lwd=15, lty=1)
abline(h=-1.5,   col="black", lwd=18, lty=1)
abline(v=0,   col="black", lwd=18, lty=1)

















sim_logistic_data = function(sample_size = 25, beta_0 = -2, beta_1 = 3) {
  x = rnorm(n = sample_size)
  eta = beta_0 + beta_1 * x
  p = 1 / (1 + exp(-eta))
  y = rbinom(n = sample_size, size = 1, prob = p)
  data.frame(y, x)
}

example_data = sim_logistic_data()

# more detailed call to glm for logistic regression
fit_glm = glm(y ~ x, data = example_data, family = binomial(link = "logit"))
par(mai = c(0.09,0 , 0, 0.0))
plot(y ~ x, data = example_data, 
     pch = 16, cex = 2.5,
     main = "", 
     col = "#aa00aa", 
     xlab = "",
     ylab = "", 
     cex.lab = 3, font.lab = 2, xaxt="n", yaxt="n", bty='n' )

curve(predict(fit_glm, data.frame(x), type = "response"), 
      add = TRUE, col = "#aa00aaff",lwd=12, lty=1)

correct = 0.1
par(xpd=T)
abline(h=-0.04,   col="black", lwd=18, lty=1)
abline(v=min(example_data[,2])-correct,   col="black", lwd=18, lty=1)
