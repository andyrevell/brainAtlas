setwd("/Users/andyrevell/Documents/20_papers/paper001_brainAtlasChoiceSFC/data")
library(ggplot2)
library(ggpubr)
library("cowplot")


data_volumes = read.csv("01_atlas_volumes.csv", stringsAsFactors = F, header = T)
data_sphericity = read.csv("02_atlas_sphericity.csv", stringsAsFactors = F, header = T)
standard_major_atlas_index = c(1,3)
random_atlas_index = c(2,4,5,6)


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
q = 2

if (q == 1){
  index= random_atlas_index
  lim_vol = c(0,5000)
  ylim = c(0,4e-3)
  pdf("../figures/atlas_random_volumesVSsphericity.pdf", width = 7, height = 7)
  title = "Random Atlases:\n Volumes vs Sphericity"
}
if (q == 2){
  index = standard_major_atlas_index
  lim_vol = c(0,40000)
  ylim = c(0,30e-5)
  pdf("../figures/atlas_standard_volumesVSsphericity.pdf", width = 7, height = 7)
  title = "Standard Atlases:\n Volumes vs Sphericity"
  
}



#Random Atlases

lim_sphericity = c(0.3,0.68)
xlim = lim_vol


random_atlas_colors =  paste0(colorRampPalette(c("#0000ff", "#990099"))(3), "66")
colors = c("#aa000066", "#aa0000aa", "#aaaa0066", random_atlas_colors)
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
ylim = c(0,10)
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
       col = colors[i], pch = 20, cex = 0.4,
       xlab = "", ylab = "", axes=FALSE, main = "")
  par(new = T)
}
axis = par('usr')
axis(side=1,lwd=1)
axis(side=2,at=seq( floor( lim_sphericity[1]*10 )/10, ceiling( lim_sphericity[2]*10 )/10,0.1),lwd=1)

title(xlab = "Volume (voxels)", line = 2.8,font.lab = 2, cex.lab = 2)
title(ylab = "Sphericity",line = 2, font.lab = 2, cex.lab = 2)

par(new = T)
plot(unlist(mean_volumes[index]),  unlist(mean_sphericity[index]),
     col = "black",  bg =substr(colors[index],1,7),  xlim = xlim, ylim = ylim,
     xlab = "", ylab = "", axes=FALSE, main = "", cex = 1.8,
     pch = 23)


#par(fig=c(cutoffs[1],1,cutoffs[2],1), new=T)


legend(x = "topright", legend = gsub("[.]", "=",  names(data_volumes))[index], 
       col = colors[index],
       bty = "n", cex= 1, pch = 16 , xpd = T,
       y.intersp = 0.8, adj=0)

legend(x = "bottomright", legend = "means", 
       col = "black",
       bty = "n", cex= 1, pch = 23 , xpd = T, adj=0)
dev.off()
##########################################################################################################################################

