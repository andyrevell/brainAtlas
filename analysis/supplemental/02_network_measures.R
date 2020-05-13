data_directory = "/Users/andyrevell/mount/USERS/arevell/papers/paper001/data_processed/supplemental_data"
figure_directory = "/Users/andyrevell/mount/USERS/arevell/papers/paper001/paper001/figures/supplemental/structure_function_video/"
figure_directory = "/Users/andyrevell/Desktop/SFC_video/"
setwd(data_directory)
library(ggplot2)
library(ggpubr)
library("cowplot")
library(reticulate) #read python files like pickle files
library(abind) #combin multidimention matrices
library(Hmisc) #for adjusting marigins of axis labels

pd <- import("pandas")
data_preictal = pickle_data <- pd$read_pickle("sub-RID0278_HUP138_phaseII_415933490000_416023190000_RA_N1000_Perm0001_matrices.pickle")
data_ictal = pickle_data <- pd$read_pickle("sub-RID0278_HUP138_phaseII_416023190000_416112890000_RA_N1000_Perm0001_matrices.pickle")
data_postictal = pickle_data <- pd$read_pickle("sub-RID0278_HUP138_phaseII_416112890000_416292890000_RA_N1000_Perm0001_matrices.pickle")


data_preictal_broadband = data_preictal[[1]]
data_ictal_broadband = data_ictal[[1]]
data_postictal_broadband = data_postictal[[1]]

structure = data_preictal[[6]]

data_broadband = abind( data_preictal_broadband, data_ictal_broadband, data_postictal_broadband, along = 3)
dim(data_broadband)
#to caluclate moving average:
ma <- function(x, n = 10){filter(x, rep(1 / n, n), sides = 2)}
#making colors

time = 0 - dim(data_preictal_broadband)[3] # for printing the time on the plot
color_time = c(rep('#00ee00',dim(data_preictal_broadband)[3] ), 
               rep('#0000ff',dim(data_ictal_broadband)[3] ),
               rep('#cc00cc',dim(data_postictal_broadband)[3] ))
#for (t in 1:length(data_broadband[1,1,] )){
cex = 0.4
for (t in 1:1){
  if (t == 1){time = 0 - dim(data_preictal_broadband)[3]
  corrrelation_vector = rep(NA, length(data_broadband[1,1,] ))}
  fname = paste0(figure_directory, "structure_function_",  sprintf('%03d',t), ".png")
  #png(fname, width = 450, height = 800, units = "px", res = 300)
  mgp_x = c(0.0,0.4,0)
  mgp_y = c(0.1,0.6,0)
  #par(mgp=mgp)
  #mgp.axis.labels(c(1,1,0), type='x')
  #mgp.axis.labels(c(0.2,0.8,0), type='y')
  #mgp.axis.labels(mgp_x, type='x')
  mgp.axis.labels(mgp_y, type='y')
  par("mar" = c(1.5,1.5,0.5,0.2)) 
  par(mfrow=c(2,1))
  
  x = upper.tri(structure, diag = FALSE) #getting just upper half of matrix because it is symmetric/non-directional
  y = upper.tri(data_broadband[,,t], diag = FALSE)
  x = structure[x]
  y = data_broadband[,,t][y]
  order = order(x)
  x = x[order]
  y = y[order]
  colors = rainbow(length(x), s = 0.7, v = 0.8, start = 0, end = 0.8, alpha =  0.9)
  correlation = cor(x, y,method = "pearson")
  corrrelation_vector[t] = correlation
  plot(x,y,  xlim = c(0,1), ylim = c(0,1), bty="n", col = colors, cex = cex-0.2, las = 1,
       ylab = "", xlab = "", pch =19,  xaxt='n', yaxt = 'n')
  mgp.axis(1, cex.axis = 0.4, cex.lab = cex-0.3, at = seq(0,1,0.1), line= 0.0)
  mgp.axis(2, cex.axis = 0.4, cex.lab = cex-0.1, las = 1)
  title( xlab="Structural Weight (log normalized )", line = 0.5, cex.lab = cex)
  title( ylab="Functional Correlation", line = 1.0, cex.lab = cex)
  
  
  
  
  title(main = "Structure vs Function", cex.main = cex+0.1)
  title(main = "RID0278 seizure 3", cex.main = 0.3, font.main = 1, line = -0.2)
  text(x = 0, y = 0, labels = paste0("correlation = ", sprintf('%.3f',round(correlation, digits = 3 )), "\ntime = "), adj = c(0, 0), cex = cex )
  text(x = 0, y = 0, labels = paste0("           ",time), adj = c(0, 0), col = color_time[t]  , cex = cex)
  time = time + 1
  
  #par(mgp=mgp)
  par(new=FALSE)
  mar=  c(1.5,1.5,0.5,0.2)
  ylim = c(0.10,0.5)
  par("mar" = mar) 
  plot(seq( 0 - dim(data_preictal_broadband)[3],  length(data_broadband[1,1,] ) - dim(data_preictal_broadband)[3]-1,1),
    corrrelation_vector,  xlim = c( 0 - dim(data_preictal_broadband)[3],  length(data_broadband[1,1,] ) - dim(data_preictal_broadband)[3]), 
    ylim = ylim, bty="n", col = color_time, cex = cex - 0.2, las = 1,  xaxt='n', yaxt = 'n',
    ylab = "", xlab = "", pch =19)
  mgp.axis(1, cex.axis = 0.4, cex = cex-0.1)
  mgp.axis(2, cex.axis = 0.4, cex.lab = cex-0.1, las = 1)
  title( xlab="Time (s)", line = 0.5, cex.lab = cex)
  title( ylab="Correlation", line = 1.0, cex.lab = cex)
  
  
  title(main = "Structure-Function Correlation", cex.main = cex +0.1)
  #calculate moving average
  moving_average = ma(corrrelation_vector, n=20)
  #pad moving average
  par(new=TRUE)
  par("mar" =mar) 
  plot(seq( 0 - dim(data_preictal_broadband)[3],  length(data_broadband[1,1,] ) - dim(data_preictal_broadband)[3]-1,1),
       moving_average,  xlim = c( 0 - dim(data_preictal_broadband)[3],  length(data_broadband[1,1,] ) - dim(data_preictal_broadband)[3]), 
       ylim = ylim, bty="n", col = "black", cex = 0.4, las = 1, xaxt='n', yaxt = 'n',
       ylab = "", xlab = "", type="l", lwd=2)
  par(new=FALSE)
  #dev.off()
  
}

