path = "/media/arevell/sharedSSD/linux/papers/paper001/" #path to where the paper directory is stored - locally or remotely

ifpath_network_measures = file.path(path, "data/data_processed/network_measures")
ifpath_mean_volumes_and_sphericity = file.path(path, "data/data_processed/volumes_and_sphericity_means")
ofpath_network_measures = file.path(path, "brainAtlas/figures/network_measures")

setwd(path)
library("ggplot2")
library("ggpubr")
library("cowplot")
library("gridExtra")
library("grid")

#pdf(file.path(ofpath_network_measures, "network_measures.pdf"), width = 11, height = 6)
png(file.path(ofpath_network_measures, "network_measures.png"), width = 11, height = 8,  units = "in", res = 600)
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

colnames(group_random_mean)[1] = colnames(data_random)[1]
colnames(group_random_mean)[2] = colnames(data_random)[2]


#Standard Atlases
data_standard = read.csv(file.path(ifpath_network_measures,"network_measures_standard_atlas.csv"), stringsAsFactors = T, header = T)
names(data_standard)[which(names(data_standard) == "RID")] = "subject"
#adding mean volumes to data 
data_standard = cbind(data_standard,"volume" =   0)
for (i in 1:length(data_standard$subject)){
  data_standard$volume[i] =  log10( data_volumes_means[data_volumes_means$X == data_standard$atlas[i], 2])
}

#rename atlases
levels(data_standard$atlas)[levels(data_standard$atlas)=="AAL"] <- "AAL v1"
levels(data_standard$atlas)[levels(data_standard$atlas)=="AAL2"] <- "AAL v2"
levels(data_standard$atlas)[levels(data_standard$atlas)=="AAL3v1_1mm"] <- "AAL v3"
levels(data_standard$atlas)[levels(data_standard$atlas)=="AAL_JHU_combined"] <- "AAL-JHU"
levels(data_standard$atlas)[levels(data_standard$atlas)=="AICHA"] <- "AICHA"
levels(data_standard$atlas)[levels(data_standard$atlas)=="BN_Atlas_246_1mm"] <- "BN"
levels(data_standard$atlas)[levels(data_standard$atlas)=="cc200_roi_atlas"] <- "cc200"
levels(data_standard$atlas)[levels(data_standard$atlas)=="cc400_roi_atlas"] <- "cc400"
levels(data_standard$atlas)[levels(data_standard$atlas)=="ez_roi_atlas"] <- "EZ"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Gordon_Petersen_2016_MNI"] <- "Gordon"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Hammersmith_atlas_n30r83_SPM5"] <- "Hammersmith"
levels(data_standard$atlas)[levels(data_standard$atlas)=="HarvardOxford-cort-maxprob-thr25-1mm"] <- "HO Cort only"
levels(data_standard$atlas)[levels(data_standard$atlas)=="HarvardOxford-sub-maxprob-thr25-1mm"] <- "HO Subcort"
levels(data_standard$atlas)[levels(data_standard$atlas)=="JHU-ICBM-labels-1mm"] <- "JHU"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Juelich-maxprob-thr25-1mm"] <- "Juelich"
levels(data_standard$atlas)[levels(data_standard$atlas)=="MNI-maxprob-thr25-1mm"] <- "MNI Lobar"
levels(data_standard$atlas)[levels(data_standard$atlas)=="OASIS-TRT-20_jointfusion_DKT31_CMA_labels_in_MNI152_v2"] <- "DKT"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Schaefer2018_100Parcels_17Networks_order_FSLMNI152_1mm"] <- "Schaefer 17 100"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Schaefer2018_100Parcels_7Networks_order_FSLMNI152_1mm"] <- "Schaefer 7 100"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Schaefer2018_200Parcels_17Networks_order_FSLMNI152_1mm"] <- "Schaefer 17 200"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Schaefer2018_200Parcels_7Networks_order_FSLMNI152_1mm"] <- "Schaefer 7 200"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Schaefer2018_300Parcels_17Networks_order_FSLMNI152_1mm"] <- "Schaefer 17 300"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Schaefer2018_300Parcels_7Networks_order_FSLMNI152_1mm"] <- "Schaefer 7 300"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Schaefer2018_400Parcels_17Networks_order_FSLMNI152_1mm"] <- "Schaefer 17 400"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Schaefer2018_400Parcels_7Networks_order_FSLMNI152_1mm"] <- "Schaefer 7 400"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Schaefer2018_500Parcels_17Networks_order_FSLMNI152_1mm"] <- "Schaefer 17 500"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Schaefer2018_500Parcels_7Networks_order_FSLMNI152_1mm"] <- "Schaefer 7 500"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Schaefer2018_600Parcels_17Networks_order_FSLMNI152_1mm"] <- "Schaefer 17 600"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Schaefer2018_600Parcels_7Networks_order_FSLMNI152_1mm"] <- "Schaefer 7 600"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Schaefer2018_700Parcels_17Networks_order_FSLMNI152_1mm"] <- "Schaefer 17 700"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Schaefer2018_700Parcels_7Networks_order_FSLMNI152_1mm"] <- "Schaefer 7 700"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Schaefer2018_800Parcels_17Networks_order_FSLMNI152_1mm"] <- "Schaefer 17 800"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Schaefer2018_800Parcels_7Networks_order_FSLMNI152_1mm"] <- "Schaefer 7 800"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Schaefer2018_900Parcels_17Networks_order_FSLMNI152_1mm"] <- "Schaefer 17 900"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Schaefer2018_900Parcels_7Networks_order_FSLMNI152_1mm"] <- "Schaefer 7 900"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_1mm"] <- "Schaefer 17 1000"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Schaefer2018_1000Parcels_7Networks_order_FSLMNI152_1mm"] <- "Schaefer 7 1000"
levels(data_standard$atlas)[levels(data_standard$atlas)=="Talairach-labels-1mm"] <- "Talairach"


#sequestering  atlases
data_standard['Plot_Group'] = as.character(data_standard$atlas)
group_random_mean['Plot_Group'] = "Random"
data_standard[grepl("Schaefer", data_standard$atlas), ]$Plot_Group = "Schaefer"
data_standard[grepl("AAL v", data_standard$atlas), ]$Plot_Group = "AAL"
data_standard[grepl("cc", data_standard$atlas), ]$Plot_Group = "CC"
data_standard[grepl("HO", data_standard$atlas), ]$Plot_Group = "HO"
data_standard['Plot_Group'] = as.factor(data_standard$Plot_Group)
group_random_mean['Plot_Group'] = as.factor(group_random_mean$Plot_Group)


group_standard_mean = data_standard # aggregate(data_standard[, c(3:8)], list( data_standard$subject, data_standard$atlas), mean)
group_standard_sd = aggregate(data_standard[, c(3:8)], list(data_standard$subject, data_standard$atlas), sd)
data = rbind(group_standard_mean, group_random_mean)

#Sizes of points
data$size = 2
size = 0.8
data[grepl("Random", data$atlas), ]$size = size
data[grepl("Schaefer", data$atlas), ]$size = size
data[grepl("AAL v", data$atlas), ]$size = size
data[grepl("HO", data$atlas), ]$size = size
data[grepl("cc", data$atlas), ]$size = size

levels(data$Plot_Group)
colors = rainbow(nlevels(data$Plot_Group)-5, s = 0.8, v = 0.8, start = 0.15)
colors_all = c("#993333", colors[1:4],"#3333cccc",colors[5:8],"#33993399",colors[9:11], "#99999966", colors[12], "#00000077"    )
shapes = c(16, 0:3,16,4:7,16,8:10,16,11, 16)
font_size = 14
density <- ggplot(data = data, aes(volume, Density , color=Plot_Group, shape=Plot_Group), size=data$size) + geom_point(size =data$size)  
degree_mean <- ggplot(data = data, aes(volume, degree_mean , color=Plot_Group, shape=Plot_Group), size=data$size) + geom_point(size =data$size)  
clustering_coefficient_mean <- ggplot(data = data, aes(volume, clustering_coefficient_mean , color=Plot_Group, shape=Plot_Group), size=data$size) + geom_point(size =data$size)  
characteristic_path_length <- ggplot(data = data, aes(volume, characteristic_path_length , color=Plot_Group, shape=Plot_Group), size=data$size) + geom_point(size =data$size)  
small_worldness <- ggplot(data = data, aes(volume, small_worldness , color=Plot_Group, shape=Plot_Group), size=data$size) + geom_point(size =data$size)  


p1 = density + scale_shape_manual(values=shapes) + scale_color_manual(values = colors_all) +  
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        panel.background = element_blank(), axis.line = element_line(colour = "black"), 
        axis.title.y = element_text(size=14),legend.position = "none",
        plot.title = element_text(lineheight=0.8,hjust = 0.5,size=font_size), axis.text=element_text(size = font_size)) +
  stat_summary(data = data, geom = "line", fun = "mean", size = 1,) +
  xlab("") +  ylab("") + ggtitle("Density") + scale_x_continuous(limits=c(2, 6)) 


p2 = degree_mean + scale_shape_manual(values=shapes) + scale_color_manual(values = colors_all) +  
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        panel.background = element_blank(), axis.line = element_line(colour = "black"), 
        axis.title.y = element_text(size=14),legend.position = "none",
        plot.title = element_text(lineheight=0.8,hjust = 0.5,size=font_size), axis.text=element_text(size = font_size)) +
  stat_summary(data = data, geom = "line", fun = "mean", size = 1,) +
  xlab("") +  ylab("") + ggtitle("Mean Degree")+ scale_x_continuous(limits=c(2, 6))


p3 = characteristic_path_length + scale_shape_manual(values=shapes) + scale_color_manual(values = colors_all) +  
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        panel.background = element_blank(), axis.line = element_line(colour = "black"), 
        axis.title.y = element_text(size=14),legend.position = "none",
        plot.title = element_text(lineheight=0.8,hjust = 0.5,size=font_size), axis.text=element_text(size = font_size)) +
  stat_summary(data = data, geom = "line", fun = "mean", size = 1,) +
  xlab("") +  ylab("")  + ggtitle("Characteristic Path Length")+ scale_x_continuous(limits=c(2, 6))

p4 = clustering_coefficient_mean + scale_shape_manual(values=shapes) + scale_color_manual(values = colors_all) +  
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        panel.background = element_blank(), axis.line = element_line(colour = "black"), 
        axis.title.y = element_text(size=14),legend.position = "none",
        plot.title = element_text(lineheight=0.8,hjust = 0.5,size=font_size), axis.text=element_text(size = font_size)) +
  stat_summary(data = data, geom = "line", fun = "mean", size = 1,) +
  xlab("") +  ylab("") + ggtitle("Mean Clustering Coefficient")+ scale_x_continuous(limits=c(2, 6))

p5 = small_worldness + scale_shape_manual(values=shapes) + scale_color_manual(values = colors_all) +  
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        panel.background = element_blank(), axis.line = element_line(colour = "black"), 
        axis.title.y = element_text(size=14),legend.position = "none",
        plot.title = element_text(lineheight=0.8,hjust = 0.5,size=font_size), axis.text=element_text(size = font_size)) +
  stat_summary(data = data, geom = "line", fun = "mean", size = 1,) +
  xlab("") +  labs(fill = "Atlas") +  ylab("") + ggtitle("Small Worldness")+ scale_x_continuous(limits=c(2, 6))
  
#top=textGrob("Network Measures Across Different Atlasese",gp=gpar(fontsize=40,font=3))

col3 <- guide_legend(ncol = 2, override.aes = list(size = 3))

small_worldness_leg = small_worldness + scale_shape_manual(values=shapes, guide = col3) +   scale_color_manual(values = colors_all) +
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