path = "/Users/andyrevell/deepLearner/home/arevell/Documents/01_papers/paper001" #path to where the paper directory is stored - locally or remotely

ifpath_volumes = file.path(path, "data_processed/volumes_and_sphericity/volumes")
ifpath_sphericity = file.path(path, "data_processed/volumes_and_sphericity/sphericity")
ofpath_volumes_and_sphericity= file.path(path, "figures/volumes_and_sphericity")

setwd(path)
library(ggplot2)
library(ggpubr)
library("cowplot")

#pdf(paste0(figure_directory, "/figure3_atlas_standard_volumesVSsphericity.pdf"), width = 10, height = 7)






#extracting data into lists
atlas_names = list.files(ifpath_volumes)

data_volumes = list()
for (i in 1:length(atlas_names)){
  data_volumes[[i]] =  read.csv(file.path(ifpath_volumes, atlas_names[i], paste0(atlas_names[i], "_volumes.csv")  ), stringsAsFactors = F, header = T)[,2]
  data_volumes[[i]] = data_volumes[[i]][-1] #removing first rentry because this is region label = 0, which is outside the brain
  names(data_volumes)[i] = c(atlas_names[i])
  }

data_sphericity = list()
for (i in 1:length(atlas_names)){
  data_sphericity[[i]] =  read.csv(file.path(ifpath_sphericity, atlas_names[i], paste0(atlas_names[i], "_sphericity.csv")  ), stringsAsFactors = F, header = T)[,2]
  data_sphericity[[i]] = data_sphericity[[i]][-1] #removing first rentry because this is region label = 0, which is outside the brain
  names(data_sphericity)[i] = c(atlas_names[i])
  }

r = "RandomAtlas"
random_atlases_to_plot = c(75, 100, 200, 300, 400, 500, 1000, 2000)
standard_atlases_to_plot = c('aal_res-1x1x1',	'AAL600',	'JHU_res-1x1x1',	'CPAC200_res-1x1x1',	'DK_res-1x1x1',	
                             'Schaefer2018_100Parcels_17Networks_order_FSLMNI152_1mm',	'Schaefer2018_200Parcels_17Networks_order_FSLMNI152_1mm',	
                             'Schaefer2018_300Parcels_17Networks_order_FSLMNI152_1mm',	'Schaefer2018_400Parcels_17Networks_order_FSLMNI152_1mm',	
                             'Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_1mm',	'Talairach_res-1x1x1',	'desikan_res-1x1x1')

standard_atlases_legend = c('AAL',	'AAL600',	'JHU',	'CPAC',	'DKT',	'Schaefer0100',	'Schaefer0200',	'Schaefer0300',	'Schaefer0400',	'Schaefer1000',	'Talairach',		'Desikan')
random_atlases_legend = c('75', '100','200', '300', '400', '500','1000', '2000')
random_atlases_to_plot = paste0(r, sprintf("%04d", random_atlases_to_plot) )

standard_major_atlas_index = match( standard_atlases_to_plot,names(data_volumes))
random_atlas_index = match( random_atlases_to_plot,names(data_volumes))

#taking log10 of volumes
for (i in 1:length(data_volumes)){
  data_volumes[[i]] = log10(data_volumes[[i]])
  }

#Calculating means
mean_volumes = lapply(data_volumes, mean)
mean_sphericity = lapply(data_sphericity, mean)

# #save this mean volumes for figure 4
# volumes_save_data = matrix(NA, nrow = length(names(data_volumes)), ncol = 1 )
# volumes_save_data[,1] = unlist(mean_volumes)
# volumes_save_data = data.frame(volumes_save_data)
#
# sphericity_save_data = matrix(NA, nrow = length(names(data_volumes)), ncol = 1 )
# sphericity_save_data[,1] = unlist(mean_sphericity)
# sphericity_save_data = data.frame(sphericity_save_data)
#
# row.names(volumes_save_data) = names(data_volumes)
# row.names(sphericity_save_data) = names(data_volumes)
# write.table(volumes_save_data,paste0(save_data_directory, "/mean_volumes.csv"), row.names = T, col.names=FALSE, sep = ",")
# write.table(volumes_save_data,paste0(save_data_directory, "/mean_sphericity.csv"), row.names = T, col.names=FALSE, sep = ",")

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





##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################



xlim = lim_vol
start = 0
pch = start:(start+length(data_volumes))


color_standard = rainbow(length(standard_atlases_to_plot), s = 0.7, v = 0.9, start = 0, end = 0.9, alpha = 0.65)
random_atlas_colors =  paste0(colorRampPalette(c("#0000ff", "#990099"))(4), "66")
random_atlas_colors =  rainbow(length(random_atlases_legend), s = 0.7, v = 0.9, start = 0.00, end = 0.90, alpha = 0.3)
colors = c(color_standard, random_atlas_colors)


par(new = F)
mar =  c(0,0,0,0); mar_1 = 4; mar_2 = 4; mar_3 = 2; mar[2] = mar_2; mar[3] = mar_3; par(mar = mar)
#plotting example volume distribution - Schaefer1000, AAL CPAC, and Glasser:
cutoffs = c(0.8,0.75)
distributions_to_plot = c("aal_res-1x1x1", "JHU_res-1x1x1", "CPAC200_res-1x1x1" , "Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_1mm") #corresponds to index in standard_atlases_to_plot
distributions_to_plot_index = match( distributions_to_plot, standard_atlases_to_plot)
for (i in 1:length(distributions_to_plot_index)){#VOLUME
  example_indx = which(names(data_volumes) == standard_atlases_to_plot[distributions_to_plot_index[i]])
  example_data = data_volumes[[example_indx]]

  if (i ==1){par(fig=c(0,0.45,0.75,0.92), new=F, xpd = F)}
  if (i > 1){par(new = T)}
  d <- density(example_data )
  plot(d,  xlim = c(0,5), ylim= c(0,3), xlab = "", ylab = "", axes=T, main = "",  bty='n', zero.line = F, las = 1, cex.axis = 0.8)
  polygon(d, col=color_standard[distributions_to_plot_index[i]], border=color_standard[distributions_to_plot_index[i]])

}
legend(x = "bottomleft", legend = standard_atlases_legend[distributions_to_plot_index],
       fill = color_standard[distributions_to_plot_index],border = substr(color_standard[distributions_to_plot_index],1,7),
       bty = "n", cex= 0.9 , xpd = T,
       y.intersp = 1, adj=0)
mtext("Volume (log10 voxels)", side = 1, outer = F, line = 2.0 , font = 1, cex = 1)
mtext("Density", side = 2, outer = F, line = 2.5 , font = 1, cex = 1)
mtext("Volume Distributions", side = 3, outer = F, line = 0.2 , font = 3, cex = 1.3)
#par(new = T)
#hist(example_data, xlim = c(0,5),breaks=12, xlab = "", ylab = "", axes=T, main = "",  bty='l', las =1)
#title(main = "Volume Distribution",line = -1.7, font.lab = 2, cex.main = 2)
mtext("Survey of Neuroimaging Atlases: Sizes and Shapes", side = 3, outer = T, line = -2 , font = 2, cex = 2)

par(xpd=NA)
ltr_x = par("usr")[2]
ltr_y = par("usr")[4]
text(ltr_x - ltr_x*1.16 , ltr_y+ ltr_y*0.45  , labels = "A.", cex = 2, font = 2 )

par(new = T)
#plotting example SPHERICTY distribution -  Schaefer1000, AAL CPAC, and Glasser:
example_indx = which(colnames(data_sphericity) == "Schaefer1000")
example_data = data_sphericity[[example_indx]]
par(fig=c(0.5,0.95,0.75,0.92), new=T)
for (i in 1:length(distributions_to_plot)){#SPHERICITY
  example_indx = which(colnames(data_sphericity) == standard_atlases_to_plot[distributions_to_plot[i]])
  example_data = data_sphericity[[example_indx]]
  par(new = T)
  d <- density(example_data )
  plot(d,  xlim = c(0,0.8), ylim= c(0,11), xlab = "", ylab = "", axes=T, main = "",  bty='n',  zero.line = F, las = 1, cex.axis = 0.8)
  polygon(d, col=color_standard[example_indx], border=color_standard[example_indx])

}



mtext("Sphericity", side = 1, outer = F, line = 2.0 , font = 1, cex = 1)
mtext("Density", side = 2, outer = F, line = 2.5 , font = 1, cex = 1)
mtext("Sphericity Distributions", side = 3, outer = F, line = 0.2 , font = 3, cex = 1.3)
#par(new = T)
#hist(example_data, xlim = c(0,0.8),breaks=12, xlab = "", ylab = "", axes=T, main = "",  bty='l', las =1)
#title(main = "Volume Distribution",line = -1.7, font.lab = 2, cex.main = 2)

par(xpd=NA)
ltr_x = par("usr")[2]
ltr_y = par("usr")[4]
text(ltr_x - ltr_x*1.16 , ltr_y+ ltr_y*0.45  , labels = "B.", cex = 2, font = 2 )

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
  d <- density(data_volumes[[i]] )
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
  d <- density(data_sphericity[[i]] )
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

  x = data_volumes[[i]]
  y = data_sphericity[[i]]
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
     pch = pch[index])


#par(fig=c(cutoffs[1],1,cutoffs[2],1), new=T)


legend(x = "bottomleft", legend =standard_atlases_legend,
       col = substr(colors,1,7),
       bty = "n", cex= 0.7, pch = pch , xpd = T,
       y.intersp = 0.8, adj=0)

#legend(x = "bottomright", legend = "means", col = "black", bty = "n", cex= 1, pch = 23 , xpd = T, adj=0)


#text(  xlim[1], ylim[2], "Small & \nSpherical", adj = c(0, 1)  , font = 2, cex = 1.2)
#text(  xlim[2], ylim[1], "Large &      \nnon-spherical", adj = c(1, 0) , font = 2 , cex = 1.2)


#
#
#
# text(  text_x_1, text_y_1, " Small & \nSpherical", adj = c(0, 1)  , font = 2, cex = 1)
# text(  text_x_2, text_y_2, "Large &      \nnon-spherical", adj = c(1, 0) , font = 2 , cex = 1)
#
#
# arrows( text_x_1-0.05,  text_y_1+0.005, xlim[1], ylim[2], length = 0.1, angle = 30,
#         code = 2, col = par("fg"), lty = par("lty"),
#         lwd = 2)
# arrows(text_x_2+0.05, text_y_2-0.005, xlim[2], ylim[1], length = 0.1, angle = 30,
#        code = 2, col = par("fg"), lty = par("lty"),
#        lwd = 2)
#

































index= random_atlas_index
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
count = 1
for (i in index){
  d <- density(data_volumes[[i]] )
  plot(d,  xlim = xlim, ylim= ylim, xlab = "", ylab = "", axes=FALSE, main = "", zero.line = F)
  polygon(d, col=random_atlas_colors[count], border=random_atlas_colors[count])
  count =  count + 1
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
count =  1
for (i in index){

  d <- density(data_sphericity[[i]] )
  e= d
  e$x = d$y
  e$y = d$x
  plot(e,  xlim = (ylim), ylim= (xlim), xlab = "", ylab = "", axes=FALSE, main = "", zero.line = F)
  polygon(e, col=random_atlas_colors[count], border=random_atlas_colors[count])
  count =  count + 1
  par(new = T)
}





par(fig=c(0.5,0.95,0,0.505), new=T)
mar[2] = mar_2
par(mar = mar)
xlim = lim_vol
ylim = lim_sphericity
count =  1
pch_count = 0
for (i in index){

  x = data_volumes[[i]]
  y = data_sphericity[[i]]
  plot(x,y,  xlim = xlim, ylim = ylim,
       col = random_atlas_colors[count], pch = (pch_count+count-1), cex = 0.5,
       xlab = "", ylab = "", axes=FALSE, main = "")
  count =  count + 1
  par(new = T)
}
box()
axis = par('usr')
axis(side=1,lwd=1)
axis(side=2,at=seq( floor( lim_sphericity[1]*10 )/10, ceiling( lim_sphericity[2]*10 )/10,0.1),lwd=1, las = 1)

par(xpd=NA)
ltr_x = par("usr")[2]
ltr_y = par("usr")[4]
text(ltr_x - ltr_x*1.16 , ltr_y+ ltr_y*0.24  , labels = "D", cex = 2, font = 2 )


title(xlab = "Volume (log10 Voxels)", line = 2,font.lab = 1, cex.lab = 1.0)
title(ylab = "Sphericity",line = 2.5, font.lab = 1, cex.lab = 1.0)

par(new = T)
plot(unlist(mean_volumes[index]),  unlist(mean_sphericity[index]),
     col = "black",  bg =substr(random_atlas_colors,1,7),  xlim = xlim, ylim = ylim,
     xlab = "", ylab = "", axes=FALSE, main = "", cex = 1.8,
     pch = pch)


#par(fig=c(cutoffs[1],1,cutoffs[2],1), new=T)


legend(x = "bottomleft", legend = random_atlases_legend,
       col = substr(random_atlas_colors,1,7),
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

