data_directory = "/Users/andyrevell/Box/01_papers/paper001_brainAtlasChoiceSFC/figure3_data"
figure_directory = "/Users/andyrevell/Documents/01_writing/00_thesis_work/06_papers/paper001_brainAtlasChoiceSFC/figures/figure3/"
setwd(data_directory)
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

index = standard_major_atlas_index
lim_vol = c(0,5)
density_lim = c(0,20e-0)
ylim = density_lim
lim_sphericity = c(0.0,0.8)
pdf(paste0(figure_directory, "figure3_atlas_standard_volumesVSsphericity.pdf"), width = 10, height = 7)





##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################



xlim = lim_vol
start = 0
pch = start:(start+ncol(data_volumes))


color_standard = rainbow(length(standard_major_atlas_index), s = 0.8, v = 0.9, start = 0, alpha = 0.4)
random_atlas_colors =  paste0(colorRampPalette(c("#0000ff", "#990099"))(4), "66")
random_atlas_colors =  rainbow(length(random_atlas_index), s = 0.9, v = 0.9, start = 0.1, end = 0.75, alpha = 0.2)

colors = c(color_standard, random_atlas_colors)
par(new = F)
mar =  c(0,0,0,0)
mar_1 = 4
mar_2 = 4
mar_3 = 2
mar[2] = mar_2 
mar[3] = mar_3
par(mar = mar)




#plotting example volume distribution - Schaefer1000:
cutoffs = c(0.8,0.75)
example_indx = which(colnames(data_volumes) == "Schaefer1000")
example_data = data_list_volumes[[example_indx]]

par(fig=c(0,0.45,0.75,0.92), new=F)
d <- density(example_data )
plot(d,  xlim = c(0,5), ylim= c(0,1.7), xlab = "", ylab = "", axes=F, main = "",  bty='n', zero.line = F)
polygon(d, col="#2222cc22", border="#2222cc22")
mtext("Volume (log10 voxels)", side = 1, outer = F, line = 2.0 , font = 1, cex = 1)
mtext("Frequency", side = 2, outer = F, line = 2.5 , font = 1, cex = 1)
mtext("Volume Distribution: Schaefer 1000", side = 3, outer = F, line = 0.2 , font = 3, cex = 1.3)
par(new = T)
hist(example_data, xlim = c(0,5),breaks=12, xlab = "", ylab = "", axes=T, main = "",  bty='l', las =1)
#title(main = "Volume Distribution",line = -1.7, font.lab = 2, cex.main = 2)
mtext("Survey of Neuroimaging Atlases: Sizes and Shapes", side = 3, outer = T, line = -2 , font = 2, cex = 2)

par(xpd=NA)
ltr_x = par("usr")[2]
ltr_y = par("usr")[4]
text(ltr_x - ltr_x*1.16 , ltr_y+ ltr_y*0.45  , labels = "A", cex = 2, font = 2 )

par(new = T)
#plotting example SPHERICTY distribution - Schaefer1000:
example_indx = which(colnames(data_sphericity) == "Schaefer1000")
example_data = data_list_sphericity[[example_indx]]

par(fig=c(0.5,0.95,0.75,0.92), new=T)
d <- density(example_data )
plot(d,  xlim = c(0,0.8), ylim= c(0,11), xlab = "", ylab = "", axes=F, main = "",  bty='n',  zero.line = F)
polygon(d, col="#2222cc22", border="#2222cc22")
mtext("Sphericity", side = 1, outer = F, line = 2.0 , font = 1, cex = 1)
mtext("Frequency", side = 2, outer = F, line = 2.5 , font = 1, cex = 1)
mtext("Sphericity Distribution: Schaefer 1000", side = 3, outer = F, line = 0.2 , font = 3, cex = 1.3)
par(new = T)
hist(example_data, xlim = c(0,0.8),breaks=12, xlab = "", ylab = "", axes=T, main = "",  bty='l', las =1)
#title(main = "Volume Distribution",line = -1.7, font.lab = 2, cex.main = 2)

par(xpd=NA)
ltr_x = par("usr")[2]
ltr_y = par("usr")[4]
text(ltr_x - ltr_x*1.16 , ltr_y+ ltr_y*0.45  , labels = "B", cex = 2, font = 2 )

mar =  c(0,0,0,0)
mar_1 = 4
mar_2 = 4
mar_3 = 2
mar[2] = mar_2 
mar[3] = mar_3
par(mar = mar)

par(xpd=F)

cutoffs = c(0.5,0.75)
par(fig=c(0.00,0.45,0.5,0.75), new=T)
xlim = lim_vol
ylim = density_lim
for (i in index){
  d <- density(data_list_volumes[[i]] )
  plot(d,  xlim = xlim, ylim= ylim, xlab = "", ylab = "", axes=FALSE, main = "", zero.line = F)
  polygon(d, col=colors[i], border=colors[i])
  par(new = T)
}

mtext("Common Neuroimaging Atlases:\nVolumes vs Sphericity", side = 3, outer = F, line = -4.5 , font = 3, cex = 1.3)

#title(main = title,line = -1.7, font.lab = 2, cex.main = 2)

par(fig=c(0.45,0.5,0,0.5), new=T)
mar[1] = mar_1
mar[2] = 0
mar[3] = 0
par(mar = mar)
xlim = lim_sphericity
ylim = c(0,30)
for (i in index){
  
  par(xpd = F)
  d <- density(data_list_sphericity[[i]] )
  e= d
  e$x = d$y
  e$y = d$x
  plot(e,  xlim = (ylim), ylim= (xlim), xlab = "", ylab = "", axes=FALSE, main = "", zero.line = F)
  polygon(e, col=colors[i], border=colors[i])
  par(new = T)
}



par(fig=c(0,0.45,0,0.505), new=T)
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
box()
axis = par('usr')
axis(side=1,lwd=1)
axis(side=2,at=seq( floor( lim_sphericity[1]*10 )/10, ceiling( lim_sphericity[2]*10 )/10,0.1),lwd=1, las = 1)

par(xpd=NA)
ltr_x = par("usr")[2]
ltr_y = par("usr")[4]
text(ltr_x - ltr_x*1.16 , ltr_y+ ltr_y*0.24  , labels = "C", cex = 2, font = 2 )


title(xlab = "Volume (log10 Voxels)", line = 2,font.lab = 1, cex.lab = 1.0)
title(ylab = "Sphericity",line = 2.5, font.lab = 1, cex.lab = 1.0)
#mtext("Volume (log10 voxels)", side = 1, outer = T, line = -1.1 , font = 1, cex = 1.5)

par(new = T)
plot(unlist(mean_volumes[index]),  unlist(mean_sphericity[index]),
     col = "black",  bg =substr(colors[index],1,7),  xlim = xlim, ylim = ylim,
     xlab = "", ylab = "", axes=FALSE, main = "", cex = 1.8,
     pch = pch)


#par(fig=c(cutoffs[1],1,cutoffs[2],1), new=T)


legend(x = "bottomleft", legend = gsub("[.]", "=",  names(data_volumes))[index], 
       col = substr(colors[index],1,7),
       bty = "n", cex= 0.7, pch = pch , xpd = T,
       y.intersp = 0.8, adj=0)

#legend(x = "bottomright", legend = "means", col = "black", bty = "n", cex= 1, pch = 23 , xpd = T, adj=0)


#text(  xlim[1], ylim[2], "Small & \nSpherical", adj = c(0, 1)  , font = 2, cex = 1.2)
#text(  xlim[2], ylim[1], "Large &      \nnon-spherical", adj = c(1, 0) , font = 2 , cex = 1.2)








index= random_atlas_index
lim_vol = c(0,5)
ylim = c(0,20e-0)
lim_sphericity = c(0.0,0.8)
#pdf(paste0(github_directory, "figure3/atlas_random_volumesVSsphericity.pdf"), width = 7, height = 7)
title = "Random Atlases:\n Volumes vs Sphericity"







mar =  c(0,0,0,0)
mar_1 = 4
mar_2 = 4
mar_3 = 2
mar[2] = mar_2 
mar[3] = mar_3
par(mar = mar)



cutoffs = c(0.5,0.75)
par(fig=c(0.5,0.95,0.5,0.75), new=T)
xlim = lim_vol
ylim = density_lim
for (i in index){
  d <- density(data_list_volumes[[i]] )
  plot(d,  xlim = xlim, ylim= ylim, xlab = "", ylab = "", axes=FALSE, main = "", zero.line = F)
  polygon(d, col=colors[i], border=colors[i])
  par(new = T)
}
mtext("Random Atlases:\nVolumes vs Sphericity", side = 3, outer = F, line = -4.5 , font = 3, cex = 1.3)


#title(main = title,line = -1.7, font.lab = 2, cex.main = 2)

par(fig=c(0.95,1,0,0.5), new=T)
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
  plot(e,  xlim = (ylim), ylim= (xlim), xlab = "", ylab = "", axes=FALSE, main = "", zero.line = F)
  polygon(e, col=colors[i], border=colors[i])
  par(new = T)
}





par(fig=c(0.5,0.95,0,0.505), new=T)
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
box()
axis = par('usr')
axis(side=1,lwd=1)
axis(side=2,at=seq( floor( lim_sphericity[1]*10 )/10, ceiling( lim_sphericity[2]*10 )/10,0.1),lwd=1)

par(xpd=NA)
ltr_x = par("usr")[2]
ltr_y = par("usr")[4]
text(ltr_x - ltr_x*1.16 , ltr_y+ ltr_y*0.24  , labels = "D", cex = 2, font = 2 )


title(xlab = "Volume (log10 Voxels)", line = 2,font.lab = 1, cex.lab = 1.0)
title(ylab = "Sphericity",line = 2.5, font.lab = 1, cex.lab = 1.0)

par(new = T)
plot(unlist(mean_volumes[index]),  unlist(mean_sphericity[index]),
     col = "black",  bg =substr(colors[index],1,7),  xlim = xlim, ylim = ylim,
     xlab = "", ylab = "", axes=FALSE, main = "", cex = 1.8,
     pch = pch)


#par(fig=c(cutoffs[1],1,cutoffs[2],1), new=T)


legend(x = "bottomleft", legend = gsub("[.]", "=",  names(data_volumes))[index], 
       col = substr(colors[index],1,7),
       bty = "n", cex= 0.7, pch = pch , xpd = T,
       y.intersp = 0.8, adj=0)

#legend(x = "bottomright", legend = "means", col = "black", bty = "n", cex= 1, pch = 23 , xpd = T, adj=0)

text_x_1 =  xlim[1]+(xlim[2] - xlim[1])*0.1
text_y_1 = ylim[2]- ylim[2]*0.1
text_x_2 =  xlim[2]-xlim[2]*0.1
text_y_2 = ylim[1] + (ylim[2]- ylim[1])*0.1

text(  text_x_1, text_y_1, " Small & \nSpherical", adj = c(0, 1)  , font = 2, cex = 1)
text(  text_x_2, text_y_2, "Large &      \nnon-spherical", adj = c(1, 0) , font = 2 , cex = 1)


arrows( text_x_1-0.05,  text_y_1+0.005, xlim[1], ylim[2], length = 0.1, angle = 30,
       code = 2, col = par("fg"), lty = par("lty"),
       lwd = 2)
arrows(text_x_2+0.05, text_y_2-0.005, xlim[2], ylim[1], length = 0.1, angle = 30,
       code = 2, col = par("fg"), lty = par("lty"),
       lwd = 2)



dev.off()
##########################################################################################################################################

