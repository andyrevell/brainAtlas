setwd("/Users/andyrevell/Box/01_papers/paper001_brainAtlasChoiceSFC/data")
github_directory = "/Users/andyrevell/Documents/20_papers/paper001_brainAtlasChoiceSFC/figures/"
library(ggplot2)
library(ggpubr)
library("cowplot")


data_volumes = read.csv("01_atlas_volumes.csv", stringsAsFactors = F, header = T)
data_sphericity = read.csv("02_atlas_sphericity.csv", stringsAsFactors = F, header = T)
standard_major_atlas_index = c(1:15)
random_atlas_index = c(16:18)

data_volumes = log10(data_volumes)

#formatting data structures

#turning data into list and removing NAs
data_list_volumes = list()
for (i in 1:ncol(data_volumes)){data_list_volumes[[i]] = data_volumes[!is.na(data_volumes[,i]),i]}
data_list_sphericity = list()
for (i in 1:ncol(data_sphericity)){data_list_sphericity[[i]] = data_sphericity[!is.na(data_sphericity[,i]),i]}

#Calculating means
mean_volumes = lapply(data_list_volumes, mean)
mean_sphericity = lapply(data_list_sphericity, mean)


##########################################################################################################################################
#Standard Major Atlases
#graphing parameters
xlim = c(0,50000)
ylim = c(0,20e-5)




##########################################################################################################################################
q = 1

if (q == 1){
  index= random_atlas_index
  lim_vol = c(1.5,4)
  ylim = c(0,20e-0)
  lim_sphericity = c(0.3,0.7)
  pdf(paste0(github_directory, "figure3/atlas_random_volumesVSsphericity.pdf"), width = 7, height = 7)
  title = "Random Atlases:\n Volumes vs Sphericity"
}
if (q == 2){
  index = standard_major_atlas_index
  lim_vol = c(0,5)
  ylim = c(0,10e-0)
  lim_sphericity = c(0.0,0.8)
  pdf(paste0(github_directory, "figure3/atlas_standard_volumesVSsphericity.pdf"), width = 7, height = 7)
  title = "Neuroimaging Atlases:\n Volumes vs Sphericity"

}


##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################



xlim = lim_vol
start = 0
pch = start:(start+ncol(data_volumes))


color_standard = rainbow(length(standard_major_atlas_index), s = 0.8, v = 0.9, start = 0, alpha = 0.4)
random_atlas_colors =  paste0(colorRampPalette(c("#0000ff", "#990099"))(4), "66")
random_atlas_colors =  rainbow(length(random_atlas_index), s = 0.9, v = 0.9, start = 0.1, end = 0.75, alpha = 0.4)

colors = c(color_standard, random_atlas_colors)
par(new = F)
mar =  c(0,0,0,0)
mar_1 = 4
mar_2 = 4
mar_3 = 2
mar[2] = mar_2 
mar[3] = mar_3
par(mar = mar)

cutoffs = c(0.85,0.75)

par(fig=c(0,cutoffs[1],cutoffs[2],1), new=F)

for (i in index){
  d <- density(data_list_volumes[[i]] )
  plot(d,  xlim = xlim, ylim= ylim, xlab = "", ylab = "", axes=FALSE, main = "")
  polygon(d, col=colors[i], border=colors[i])
  par(new = T)
}

title(main = title,line = -1.7, font.lab = 2, cex.main = 2)

par(fig=c(cutoffs[1],1,0,cutoffs[2]), new=T)
mar[1] = mar_1
mar[2] = 0
mar[3] = 0
par(mar = mar)
xlim = lim_sphericity
ylim = c(0,30)
for (i in index){
  
  d <- density(data_list_sphericity[[i]] )
  e= d
  e$x = d$y
  e$y = d$x
  plot(e,  xlim = (ylim), ylim= (xlim), xlab = "", ylab = "", axes=FALSE, main = "")
  polygon(e, col=colors[i], border=colors[i])
  par(new = T)
}

par(fig=c(0,cutoffs[1],0,cutoffs[2]), new=T)
mar[2] = mar_2
par(mar = mar)
xlim = lim_vol
ylim = lim_sphericity
for (i in index){
  
  x = data_list_volumes[[i]]
  y = data_list_sphericity[[i]]
  plot(x,y,  xlim = xlim, ylim = ylim, 
       col = colors[i], pch = pch[i], cex = 0.5,
       xlab = "", ylab = "", axes=FALSE, main = "")
  par(new = T)
}
axis = par('usr')
axis(side=1,lwd=1)
axis(side=2,at=seq( floor( lim_sphericity[1]*10 )/10, ceiling( lim_sphericity[2]*10 )/10,0.1),lwd=1)

title(xlab = "Volume (voxels, log10)", line = 2.8,font.lab = 2, cex.lab = 2)
title(ylab = "Sphericity",line = 2, font.lab = 2, cex.lab = 2)

par(new = T)
plot(unlist(mean_volumes[index]),  unlist(mean_sphericity[index]),
     col = "black",  bg =substr(colors[index],1,7),  xlim = xlim, ylim = ylim,
     xlab = "", ylab = "", axes=FALSE, main = "", cex = 1.8,
     pch = pch)


#par(fig=c(cutoffs[1],1,cutoffs[2],1), new=T)


legend(x = "bottomleft", legend = gsub("[.]", "=",  names(data_volumes))[index], 
       col = substr(colors[index],1,7),
       bty = "n", cex= 1, pch = pch , xpd = T,
       y.intersp = 0.8, adj=0)

#legend(x = "bottomright", legend = "means", col = "black", bty = "n", cex= 1, pch = 23 , xpd = T, adj=0)


text(  xlim[1], ylim[2], "Small & \nSpherical", adj = c(0, 1)  , font = 2, cex = 1.2)
text(  xlim[2], ylim[1], "Large &      \nnon-spherical", adj = c(1, 0) , font = 2 , cex = 1.2)

#arrows(xlim[1]+1.3, ylim[2]-0.19, xlim[1]+1, ylim[2]-0.1, length = 0.2, angle = 30,
#       code = 2, col = par("fg"), lty = par("lty"),
#       lwd = 2)
#arrows(xlim[2]-1.3, ylim[1]+0.19, xlim[2]-1, ylim[1]+0.1, length = 0.2, angle = 30,
#       code = 2, col = par("fg"), lty = par("lty"),
#       lwd = 2)

dev.off()
##########################################################################################################################################

