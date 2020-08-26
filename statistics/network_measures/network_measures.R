path = "/Users/andyrevell/deepLearner/home/arevell/Documents/01_papers/paper001" #path to where the paper directory is stored - locally or remotely

ifpath_network_measures = file.path(path, "data_processed/network_measures")
ifpath_mean_volumes_and_sphericity = file.path(path, "data_processed/volumes_and_sphericity_means")
ofpath_network_measures = file.path(path, "paper001/figures/network_measures")

setwd(path)
library("ggplot2")
library("ggpubr")
library("cowplot")
library("gridExtra")
library("grid")

#pdf(file.path(ofpath_network_measures, "network_measures.pdf"), width = 11, height = 6)
png(file.path(ofpath_network_measures, "network_measures.png"), width = 11, height = 6,  units = "in", res = 600)
#Get mean volumes and sphericity data
data_volumes_means = read.csv(file.path(ifpath_mean_volumes_and_sphericity,"volumes_and_sphericity.csv"), stringsAsFactors = F, header = T) 





#Random Atlases
data_random = read.csv(file.path(ifpath_network_measures,"network_measures_random_atlas.csv"), stringsAsFactors = T, header = T)
names(data_random)[which(names(data_random) == "RID")] = "subject"
#adding mean volumes to data 
data_random = cbind(data_random,"volume" =   0)
for (i in 1:length(data_random$subject)){
  data_random$volume[i] =  log10( data_volumes_means[data_volumes_means$X == data_random$atlas[i], 2])
}
group_random_mean = aggregate(data_random[, c(4:9)], list( data_random$subject, data_random$atlas), mean)
group_random_sd = aggregate(data_random[, c(4:9)], list(data_random$subject, data_random$atlas), sd)



#Standard Atlases
data_standard = read.csv(file.path(ifpath_network_measures,"network_measures_standard_atlas.csv"), stringsAsFactors = T, header = T)
names(data_standard)[which(names(data_standard) == "RID")] = "subject"
#adding mean volumes to data 
data_standard = cbind(data_standard,"volume" =   0)
for (i in 1:length(data_standard$subject)){
  data_standard$volume[i] =  log10( data_volumes_means[data_volumes_means$X == data_standard$atlas[i], 2])
}

#rename atlases
levels(data_standard$atlas)[levels(data_standard$atlas)=="AAL_JHU_combined_res-1x1x1"] <- "AAL-JHU"
levels(data_standard$atlas)[levels(data_standard$atlas)=="CPAC200_res-1x1x1"] <- "CPAC"
levels(data_standard$atlas)[levels(data_standard$atlas)=="aal_res-1x1x1"] <- "AAL"
levels(data_standard$atlas)[levels(data_standard$atlas)=="desikan_res-1x1x1"] <- "Desikan"
levels(data_standard$atlas)[levels(data_standard$atlas)=="DK_res-1x1x1"] <- "DKT"
levels(data_standard$atlas)[levels(data_standard$atlas)=="JHU_res-1x1x1"] <- "JHU"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_1mm"] <- "Schaefer1000"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Schaefer2018_100Parcels_17Networks_order_FSLMNI152_1mm"] <- "Schaefer0100"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Schaefer2018_200Parcels_17Networks_order_FSLMNI152_1mm"] <- "Schaefer0200"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Schaefer2018_300Parcels_17Networks_order_FSLMNI152_1mm"] <- "Schaefer0300"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Schaefer2018_400Parcels_17Networks_order_FSLMNI152_1mm"] <- "Schaefer0400"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Talairach_res-1x1x1"] <- "Talairach"

#reorder atlases
legend_order = c( "AAL", "AAL600", "AAL-JHU" , "CPAC", "Desikan", "DKT", "JHU","Talairach", "Schaefer0100", "Schaefer0200", "Schaefer0300", "Schaefer0400","Schaefer1000")
data_standard$atlas <- factor(data_standard$atlas, levels = legend_order)

group_standard_mean = aggregate(data_standard[, c(3:8)], list( data_standard$subject, data_standard$atlas), mean)
group_standard_sd = aggregate(data_standard[, c(3:8)], list(data_standard$subject, data_standard$atlas), sd)



density <- ggplot(group_random_mean, aes(volume, Density)) + geom_point() + geom_point(data=group_standard_mean, aes(volume, Density, color=Group.2, shape=Group.2 ), size=2)  
degree_mean <- ggplot(group_random_mean, aes(volume, degree_mean)) + geom_point() + geom_point(data=group_standard_mean, aes(volume, degree_mean, color=Group.2, shape=Group.2 ), size=2)  
clustering_coefficient_mean <- ggplot(group_random_mean, aes(volume, clustering_coefficient_mean)) + geom_point() + geom_point(data=group_standard_mean, aes(volume, clustering_coefficient_mean, color=Group.2, shape=Group.2 ), size=2)  
characteristic_path_length <- ggplot(group_random_mean, aes(volume, characteristic_path_length)) + geom_point() + geom_point(data=group_standard_mean, aes(volume, characteristic_path_length, color=Group.2, shape=Group.2 ), size=2)  
small_worldness <- ggplot(group_random_mean, aes(volume, small_worldness)) + geom_point() + geom_point(data=group_standard_mean, aes(volume, small_worldness, color=Group.2, shape=Group.2 ), size=2)  
  
font_size = 14
p1 = density + scale_shape_manual(values=1:nlevels(group_standard_mean$Group.2)) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        panel.background = element_blank(), axis.line = element_line(colour = "black"), 
        axis.title.y = element_text(size=14),legend.position = "none",
        plot.title = element_text(lineheight=0.8,hjust = 0.5,size=font_size), axis.text=element_text(size = font_size)) +
  xlab("") +  ylab("") + ggtitle("Density") + scale_x_continuous(limits=c(2, 6))
p2 = degree_mean + scale_shape_manual(values=1:nlevels(group_standard_mean$Group.2)) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        panel.background = element_blank(), axis.line = element_line(colour = "black"), 
        axis.title.y = element_text(size=14),legend.position = "none",
        plot.title = element_text(lineheight=0.8,hjust = 0.5,size=font_size), axis.text=element_text(size = font_size)) +
  xlab("") +  ylab("") + ggtitle("Mean Degree")+ scale_x_continuous(limits=c(2, 6))
p3 = characteristic_path_length + scale_shape_manual(values=1:nlevels(group_standard_mean$Group.2)) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        panel.background = element_blank(), axis.line = element_line(colour = "black"), 
        axis.title.y = element_text(size=14), legend.position = "none",
        plot.title = element_text(lineheight=0.8,hjust = 0.5,size=font_size), axis.text=element_text(size = font_size)) +
  xlab("") +  ylab("")  + ggtitle("Characteristic Path Length")+ scale_x_continuous(limits=c(2, 6))
p4 = clustering_coefficient_mean + scale_shape_manual(values=1:nlevels(group_standard_mean$Group.2)) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        panel.background = element_blank(), axis.line = element_line(colour = "black"), 
        axis.title.y = element_text(size=14), legend.position = "none",
        plot.title = element_text(lineheight=0.8,hjust = 0.5,size=font_size), axis.text=element_text(size = font_size)) + 
  xlab("") +  ylab("") + ggtitle("Mean Clustering Coefficient")+ scale_x_continuous(limits=c(2, 6))
p5 = small_worldness + scale_shape_manual(values=1:nlevels(group_standard_mean$Group.2)) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        panel.background = element_blank(), axis.line = element_line(colour = "black"), 
        axis.title.y = element_text(size=14),legend.position = "none", legend.key=element_blank(),
        plot.title = element_text(lineheight=0.8,hjust = 0.5,size=font_size), axis.text=element_text(size = font_size)) + 
  xlab("") +  labs(fill = "Atlas") +  ylab("") + ggtitle("Small Worldness")+ scale_x_continuous(limits=c(2, 6))
  
#top=textGrob("Network Measures Across Different Atlasese",gp=gpar(fontsize=40,font=3))

col3 <- guide_legend(ncol = 2, override.aes = list(size = 3))

small_worldness_leg = small_worldness + scale_shape_manual(values=1:nlevels(group_standard_mean$Group.2), guide = col3) + 
  theme(legend.key=element_blank(), legend.text = element_text(colour="black", size =font_size), legend.title=element_blank(), legend.spacing.x = unit(0.4, 'cm'),
        plot.title = element_text(lineheight=0.8,hjust = 0.5,size=font_size))  + ggtitle("Atlas")

l <- get_legend(small_worldness_leg)


title = textGrob("Network Measure Differences Between Atlases", gp=gpar(fontsize=font_size*1.35, fontface="bold"))
label = expression(paste("Volume (log"["10"],"voxels or log"["10"] ,"mm"^"3",") "))
xlab = textGrob(label, gp=gpar(fontsize=font_size))

grid.arrange(p1, p2, p3, p4, p5,l, nrow = 2, top = title, bottom = xlab, padding = unit(0.5, "line"),  heights=unit(c(2.6,2.6), c("in", "in")))


#title(xlab = "Volume (log10 Voxels)", line = 2,font.lab = 1, cex.lab = 1.0)
dev.off()


#legend.position =c(0.8, 0.6)