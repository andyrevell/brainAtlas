
data_directory = '/Users/andyrevell/mount/USERS/arevell/papers/paper001/data_processed/figure4_data'
output_directory ='/Users/andyrevell/mount/USERS/arevell/papers/paper001/paper001/figures/figure4'
setwd(data_directory)
library(ggplot2)
library(ggpubr)
library("cowplot")

fname = paste0(output_directory, "/figure4_network_measures_presentation01.pdf")
pdf(fname , width = 7, height = 8)
plot_standard = F #indicate whether or not to plot the standard atlases

#Random Atlases
data_random = read.csv(paste0(data_directory,"/network_measures_random_atlases.csv"), stringsAsFactors = F, header = T)
data_random = data.frame(data_random)
data_random$RID.SubID = as.factor(data_random$RID.SubID)
names(data_random)[which(names(data_random) == "RID.SubID")] = "subject"

data_random$subject = paste0("sub-RID",sprintf("%04d", as.numeric(as.character(data_random$subject))  ))
data_random$subject = as.factor(data_random$subject)
rel=2

names = c("Characteristic Path Legnth", "Clustering Coefficient",
          "Degree",  "Small Worldness", "Normalized \nCharacteristic Path Length",
          "Normalized \nClustering Coefficient")
fnames = c("charPathLength",
           "clust", "degree", "smallWorldness", "NormPathLength", "NormClust")
order = c(4:9)

random_volumes_index = c(16:28)
data_random_volumes = read.csv(paste0(data_directory,"/mean_volumes.csv"), stringsAsFactors = F, header = F)[random_volumes_index,]
data_random_volumes = cbind(data_random_volumes, "Node" = c(10,30,50,75,100,200,300,400,500,750,1000,2000,5000))

#initializing corresponding volumes to nodes
data_random = cbind(data_random,"volume" =   NA)
count = 1
for (i in data_random_volumes$Node){
  data_random$volume[which(data_random$Node == i)] = data_random_volumes[count,2]
  count = count +1
}

N_subjects = length(levels(data_random$subject))
t_value = 2.110 #from t table with N_subjects = 17
Parcellation_sizes = rev(unique(data_random$Node))

means = aggregate(data_random[,4:9], list(data_random$volume), mean)
standard_devs = aggregate(data_random[,4:9], list(data_random$volume), sd)


means_by_subject = aggregate(data_random[,4:9], by = list(data_random$volume, data_random$subject), mean)
standard_devs_by_subject = aggregate(data_random[,4:9], by =  list(data_random$volume, data_random$subject), sd)
CI95 = (t_value *standard_devs)/sqrt(N_subjects) 


##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################


#Standard Atlases
data_standard = read.csv(paste0(data_directory,"/network_measures_standard_atlases.csv"), stringsAsFactors = F, header = T)
data_standard = data.frame(data_standard)
data_standard$RID.SubID = as.factor(data_standard$RID.SubID)
names(data_standard)[which(names(data_standard) == "RID.SubID")] = "subject"

data_standard$subject = paste0("sub-RID",sprintf("%04d", as.numeric(as.character(data_standard$subject))  ))
data_standard$subject = as.factor(data_standard$subject)
rel=2

names = c("Characteristic Path Legnth", "Clustering Coefficient",
          "Degree",  "Small Worldness", "Normalized \nCharacteristic Path Length",
          "Normalized \nClustering Coefficient")
fnames = c("charPathLength",
           "clust", "degree", "smallWorldness", "NormPathLength", "NormClust")

standard_volumes_index = c(1:15)
data_standard_volumes = read.csv(paste0(data_directory,"/mean_volumes.csv"), stringsAsFactors = F, header = F)[standard_volumes_index,]

#initializing corresponding volumes to nodes
data_standard = cbind(data_standard,"volume" =   NA)
data_standard = cbind(data_standard,"color" =   NA)
data_standard = cbind(data_standard,"pch" =   NA)
standard_atlas_colors = rainbow(length(unique(data_standard_volumes$V1) ), s= 0.9,v=0.9,start = 0, end = 1.0, alpha = 0.9)
pch_standard = c(0:length(unique(data_standard_volumes$V1) ))
count = 1
for (i in data_standard_volumes$V1){
  data_standard$volume[which(data_standard$atlas == i)] = data_standard_volumes[count,2]
  data_standard$color[which(data_standard$atlas == i)] = standard_atlas_colors[count]
  data_standard$pch[which(data_standard$atlas == i)] = pch_standard[count]
  count = count +1
}

##########################################################################################################################################
N_subjects_standard = length(levels(data_standard$subject))
t_value_standard = 2.110 #from t table with N_subjects = 17

means_standard = aggregate(data_standard[,3:8], list(data_standard$volume, data_standard$atlas, data_standard$color,data_standard$pch), mean)
standard_devs_standard = aggregate(data_standard[,3:8], list(data_standard$volume, data_standard$atlas, data_standard$color,data_standard$pch), sd)


means_by_subject_standard = aggregate(data_standard[,4:9], by = list(data_standard$volume, data_standard$subject, data_standard$atlas, data_standard$color,data_standard$pch), mean)
standard_devs_by_subject_standard = aggregate(data_standard[,4:9], by =  list(data_standard$volume, data_standard$subject, data_standard$atlas, data_standard$color,data_standard$pch), sd)
#CI95_standard = (t_value_standard *standard_devs_standard)/sqrt(N_subjects_standard) 


##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################
##########################################################################################################################################




#plotting parameters

# ylim = c(-0.1, 0.6)
# standard_atlases_line_width = 3
# random_atlases_line_width = 3
# standard_atlas_colors_transparency = 'ff'
# CI95_color = "#99999922"

color = "#333333" #"#a500a5"
CI95_color = "#33333333" #"#ffccff66"
line_width = 3


las = 1
font_legend = 3
cex_legend = 1.2
cex_main = 1
cex_ylab = 1.5
cex_x_axis = 1.5
cex_y_axis = 1.5
line_main = -1.0
pch = 20
pch_cex = 1.5
pch_cex_standard = 1.5
tick = 0.025

cex_parcellations = 0.9
font_Parcellation_sizes = 1
cex_random_atlas_parcellation_title = 0.8
line_random_parcellation_title = -33
line_random_parcellation_title_x = 0.01
line_x_axis_label = -6
y_label_line= 3.5
cex_x_axis_label = 1.2
multiplier_parcellation_text_1 = 1.08
multiplier_parcellation_text_2 = 1.03
line_title = -2.2
cex_title=2
cex_corner_text_label = 1.5
offset_x_corner_text_label = 0.975
offset_y_corner_text_label = 0.9
#dev.off(dev.list()["RStudioGD"])

m <- matrix(c(1,2,3,4,5,5),nrow = 3,ncol = 2,byrow = TRUE)

layout(mat = m,heights = c(0.4,0.4,0.08))

#par(mfrow = c(3,2))
par(oma=c(0,0,0,0.2))

xlim = c( min(means$Group.1, means_standard$Group.1) , 5.5)
##########11111111111111111111111
mar_1 = 1.5; mar_2 = 3.5; mar_3 = 3; mar_4 = 0; mar = c(mar_1,mar_2,mar_3,mar_4); par(mar =mar)
ylim = c(0, max(means$Degree + standard_devs$Degree, means_standard$Degree +   standard_devs_standard$Degree  )   )
plot(x =NA, y =NA, xlab = "", ylab = "", las = las, xaxt = "n", xlim = xlim, ylim = ylim, cex.axis = cex_y_axis)
polygon(x = c(means$Group.1, rev(means$Group.1)), 
        y = c(means$Degree - standard_devs$Degree , rev(means$Degree + standard_devs$Degree )) ,
        border = CI95_color, col = CI95_color)
par(new = T)
plot(x = means_by_subject$Group.1, y = means_by_subject$Degree, xlab = "", ylab = "", las = las, xaxt = "n", yaxt = "n",
     xlim = xlim, ylim = ylim, pch = pch, col = color, cex = pch_cex)
par(new = T)
if (plot_standard){plot(x = means_by_subject_standard$Group.1, y = means_by_subject_standard$Degree, xlab = "", ylab = "", las = las, xaxt = "n",  yaxt = "n",
     xlim = xlim, ylim = ylim, pch = means_by_subject_standard$Group.5, cex = pch_cex_standard, col =means_by_subject_standard$Group.4 )
}
text(par("usr")[2]*offset_x_corner_text_label, par("usr")[4]*offset_y_corner_text_label, labels = "Degree",adj = c(1,1) , cex = cex_corner_text_label)
#title(ylab = "Degree", cex.lab = cex_ylab, line = y_label_line )
axis(side=1, at= means$Group.1, labels = FALSE, tck = tick )


##########2222222222222222222222
mar_1 = 1.5;  mar_3 = 3; mar_4 = 0; mar = c(mar_1,mar_2,mar_3,mar_4); par(mar =mar)
ylim = c(0, max(means$Small.Worldness + standard_devs$Small.Worldness, means_standard$Small.Worldness + standard_devs_standard$Small.Worldness   ))
plot(x =NA, y = NA, xlab = "", ylab = "", las = las, xaxt = "n", xlim = xlim, ylim = ylim , cex.axis = cex_y_axis  )
polygon(x = c(means$Group.1, rev(means$Group.1)), 
        y = c(means$Small.Worldness - standard_devs$Small.Worldness , rev(means$Small.Worldness + standard_devs$Small.Worldness )) ,
        border = CI95_color, col = CI95_color)
par(new = T)
plot(x = means_by_subject$Group.1, y = means_by_subject$Small.Worldness, xlab = "", ylab = "", las = las, xaxt = "n", yaxt = "n",
     xlim = xlim, ylim = ylim, pch = pch, col = color, cex = pch_cex)
par(new = T)
if (plot_standard){plot(x = means_by_subject_standard$Group.1, y = means_by_subject_standard$Small.Worldness, xlab = "", ylab = "", las = las, xaxt = "n", yaxt = "n",
     xlim = xlim, ylim = ylim, pch = means_by_subject_standard$Group.5, cex = pch_cex_standard, col =means_by_subject_standard$Group.4)
}
text(par("usr")[2]*offset_x_corner_text_label, par("usr")[4]*offset_y_corner_text_label, labels = "Small\nWorldness",adj = c(1,1) , cex = cex_corner_text_label)
#title(ylab = "Small Worldness", cex.lab = cex_ylab, line = y_label_line -0.5)
axis(side=1, at= means$Group.1, labels = FALSE, tck = tick)


##########3333333333333333333333333
mar_1 = 4;  mar_3 = 1.5; mar_4 = 0; mar = c(mar_1,mar_2,mar_3,mar_4); par(mar =mar)
ylim = c(0, max(means$Norm.Clust + standard_devs$Norm.Clust, means_standard$Norm.Clust + standard_devs_standard$Norm.Clust   ))
plot(x = NA, y = NA, xlab = "", ylab = "", las = las, xaxt = "n", xlim = xlim, ylim = ylim, cex.axis = cex_y_axis)
polygon(x = c(means$Group.1, rev(means$Group.1)), 
        y = c(means$Norm.Clust - standard_devs$Norm.Clust , rev(means$Norm.Clust + standard_devs$Norm.Clust )) ,
        border = CI95_color, col = CI95_color)
par(new = T)
plot(x = means_by_subject$Group.1, y = means_by_subject$Norm.Clust, xlab = "", ylab = "", las = las, xaxt = "n",yaxt = "n",
     xlim = xlim, ylim = ylim, pch = pch, col = color, cex = pch_cex)
par(new = T)
if (plot_standard){plot(x = means_by_subject_standard$Group.1, y = means_by_subject_standard$Norm.Clust, xlab = "", ylab = "", las = las, xaxt = "n", yaxt = "n",
     xlim = xlim, ylim = ylim, pch = means_by_subject_standard$Group.5, cex = pch_cex_standard, col =means_by_subject_standard$Group.4)
}
#title(ylab = "Clustering Coefficient", cex.lab = cex_ylab, line = y_label_line )
axis(side=3, at= means$Group.1, labels = FALSE, tck = tick)
text(par("usr")[2]*offset_x_corner_text_label, par("usr")[4]*offset_y_corner_text_label, labels = "Clustering\nCoefficient",adj = c(1,1) , cex = cex_corner_text_label)
text(means$Group.1, par("usr")[4] *multiplier_parcellation_text_1, labels = Parcellation_sizes, 
     srt = 90, xpd = NA, cex = cex_parcellations, adj = c(0.5,0.5), font = font_Parcellation_sizes, col = color)
axis(side=1 , tck = tick*0.8,cex.axis = cex_x_axis )

##########4444444444444444444444
mar_3 = 1; mar = c(mar_1,mar_2,mar_3,mar_4); par(mar =mar)
ylim = c(min(means$Norm.Char.Path - standard_devs$Norm.Char.Path, means_standard$Norm.Char.Path - standard_devs_standard$Norm.Char.Path   ), 
         max(means$Norm.Char.Path + standard_devs$Norm.Char.Path, means_standard$Norm.Char.Path + standard_devs_standard$Norm.Char.Path   ))
plot(x = NA, y = NA, xlab = "", ylab = "", las = las, xaxt = "n",xlim = xlim,  ylim = ylim, cex.axis = cex_y_axis)
polygon(x = c(means$Group.1, rev(means$Group.1)), 
        y = c(means$Norm.Char.Path - standard_devs$Norm.Char.Path , rev(means$Norm.Char.Path + standard_devs$Norm.Char.Path )) ,
        border = CI95_color, col = CI95_color)
par(new = T)
plot(x = means_by_subject$Group.1, y = means_by_subject$Norm.Char.Path, xlab = "", ylab = "", las = las, xaxt = "n", yaxt = "n",
     xlim = xlim, ylim = ylim, pch = pch, col = color, cex = pch_cex)
par(new = T)
if (plot_standard){plot(x = means_by_subject_standard$Group.1, y = means_by_subject_standard$Norm.Char.Path, xlab = "", ylab = "", las = las, xaxt = "n", yaxt = "n",
     xlim = xlim, ylim =ylim, pch = means_by_subject_standard$Group.5, cex = pch_cex_standard, col =means_by_subject_standard$Group.4)
}
#title(ylab = "Characteristic Path Length", cex.lab = cex_ylab, line = y_label_line-0.5 )
axis(side=3, at= means$Group.1, labels =F , tck = tick )
text(par("usr")[2]*offset_x_corner_text_label, par("usr")[4]*offset_y_corner_text_label*1.05, labels = "Characteristic\nPath\nLength",adj = c(1,1) , cex = cex_corner_text_label)
text(means$Group.1, par("usr")[4] *multiplier_parcellation_text_2, labels = Parcellation_sizes, 
     srt = 90, xpd = NA, cex = cex_parcellations, adj = c(0.5,0.5), font = font_Parcellation_sizes, col = color)

axis(side=1 , tck = tick*0.8 , cex.axis = cex_x_axis)
mtext("Volume (log10 voxels)", side = 1, line = line_x_axis_label, outer = TRUE, cex = cex_x_axis_label)
mtext("Random Atlas \nParcellation N:", side = 1,at = c(line_random_parcellation_title_x,2) ,line = line_random_parcellation_title, outer = TRUE, las = las, adj = 0, col = color, cex = cex_random_atlas_parcellation_title)
mtext("Network Measures", side = 3 ,line = line_title, outer = TRUE, las = las, adj = 0.5, cex = cex_title, font = 2)
mtext(paste0("N = ",N_subjects_standard ," subjects"), side = 3 ,line = line_title, outer = TRUE, las = las, adj = 1, cex = cex_title*0.5, font = 3)


plot(1, type = "n", axes=FALSE, xlab="", ylab="")

legend_names = c("Random Atlases","AAL", "AAL600", "JHU", "CPAC", "DKT", "Schaefer0100", "Schaefer0200", "Schaefer0300", "Schaefer0400", "Schaefer1000", "Talairach", "desikan")
legend(x = "top", legend = legend_names ,col = c(color, means_standard$Group.3), cex = cex_legend,
       pch = c(pch, means_standard$Group.4), bty = "n", xpd = T, horiz = F, ncol = 5)


dev.off()


# legend(x = "bottomleft", legend =standard_atlases_legend, 
#        col = substr(colors[index],1,7),
#        bty = "n", cex= 0.7, pch = pch , xpd = T,
#        y.intersp = 0.8, adj=0)
# for (i in 1:6){
#   
#   
#   name = names[i]
#   p<-ggplot(data_random, aes_string(x="volume", y=names(data_random)[order[i]] , group="subject")) +
#     geom_point(aes(color=subject)) +
#     stat_summary(fun.y=mean, geom="line", aes(color = subject)) + 
#     theme_classic() +
#     theme(legend.text=element_text(size=rel(rel))) +
#     theme(plot.title = element_text(hjust = 0.5)) +
#     theme(axis.text=element_text(size=rel(rel),face="bold"),
#           title=element_text(size=rel(rel),face="bold")) 
#   
#   plot_list[[i]] = p + ggtitle(name) + 
#     xlab("volume") + ylab(name) 
# }
# 
# for (i in 1:6) {
#   fname = paste0(output_directory,"/network_measures_random_atlases_", fnames[i], ".pdf")
#   pdf(fname, width = 10, height = 10)
#   print(plot_list[[i]])
#   dev.off()
# }
