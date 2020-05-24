# Ignore: For Alex Computer 
#processed_SFC_dir = "./processed_SFC/"
#resampled_SFC_dir = "./resampled_SFC/max/"

#Andy computer:
average_Ictal_data_path = "/Users/andyrevell/mount/USERS/arevell/papers/paper001/data_processed/figure6_data/average_Ictal_mean_and_Difference_calculation/average_Ictal_mean_and_Difference_calculation.RData"
volumes_path = '/Users/andyrevell/mount/USERS/arevell/papers/paper001/data_processed/figure4_data/mean_volumes.csv'
output_plot_path= "/Users/andyrevell/mount/USERS/arevell/papers/paper001/paper001/figures/figure6/average_Ictal_mean_and_Difference_calculation/"



#Borel:
#processed_SFC_dir = "/gdrive/public/USERS/arevell/papers/paper001/data_processed/figure5_data/structure_function_correlation/"
# change this to be either medians/up/downsample 
#resampled_SFC_dir = "/gdrive/public/USERS/arevell/papers/paper001/data_processed/figure6_data/average_SFC_ALL_PATIENTS/medians/"


#plot_averaged_resampled_data(averaged_resampled_data_path, output_plot_path)

#plot_averaged_resampled_data <- function(averaged_resampled_data_path, output_plot_path){
  
  options(scipen=999)#prevent scientifuc notation. iEEG org times are very long, so helps when reading files to read the number string verbatim
  
  dev.off(dev.list()["RStudioGD"])
  fname = paste0(output_plot_path, 'average_Ictal_mean_and_Difference_Figure6', ".pdf")
  pdf(fname , width = 4, height = 8)
  load(average_Ictal_data_path)
  
  m <- matrix(c(1,2,3),nrow = 3,ncol = 1,byrow = TRUE)
  
  layout(mat = m,heights = c(1,1,0.2))
  
  #par(mfrow = c(3,2))
  par(oma=c(1,3,4,2))
  
    
  frequency_names = names(means_random_atlases)
  frequency_names =c("Broadband", "Alpha/Theta", "Beta", "Low Gamma", 
                    "High Gamma")
    
  random_atlases=c('RA_N0010', 'RA_N0030', 'RA_N0050', 'RA_N0075','RA_N0100','RA_N0200','RA_N0300', 'RA_N0400', 'RA_N0500' , 'RA_N0750', 'RA_N1000', 'RA_N2000')
  standard_atlases=c('aal_res-1x1x1', 'AAL600', 'CPAC200_res-1x1x1', 'desikan_res-1x1x1','DK_res-1x1x1','JHU_res-1x1x1',
                     'Schaefer2018_100Parcels_17Networks_order_FSLMNI152_1mm', 'Schaefer2018_200Parcels_17Networks_order_FSLMNI152_1mm',
                     'Schaefer2018_300Parcels_17Networks_order_FSLMNI152_1mm' , 'Schaefer2018_400Parcels_17Networks_order_FSLMNI152_1mm', 
                     'Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_1mm', 'Talairach_res-1x1x1')
  
  random_atlases_to_plot = c('RA_N0010', 'RA_N0030', 'RA_N0050', 'RA_N0075','RA_N0100','RA_N0200','RA_N0300', 'RA_N0400', 'RA_N0500' , 'RA_N0750', 'RA_N1000', 'RA_N2000')
  standard_atlases_to_plot = c('aal_res-1x1x1', 'AAL600', 'CPAC200_res-1x1x1', 'desikan_res-1x1x1','DK_res-1x1x1','JHU_res-1x1x1',
                               'Schaefer2018_100Parcels_17Networks_order_FSLMNI152_1mm', 'Schaefer2018_200Parcels_17Networks_order_FSLMNI152_1mm',
                               'Schaefer2018_300Parcels_17Networks_order_FSLMNI152_1mm' , 'Schaefer2018_400Parcels_17Networks_order_FSLMNI152_1mm', 
                               'Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_1mm', 'Talairach_res-1x1x1')
  
  standard_atlases_legend = c('AAL', 'AAL600', 'CPAC', 'Desikan', 'DKT','JHU', 'Schaefer 100','Schaefer 200','Schaefer 300','Schaefer 400', 'Schaefer 1000','Talairach')
  random_atlases_legend = c('10', '30', '50', '75','100','200','300', '400', '500' , '750', '1000', '2000')
  
  
  
  standard_volumes_index = c(1:15)
  random_volumes_index = c(16:28)
  data_standard_volumes = read.csv(paste0(volumes_path), stringsAsFactors = F, header = F)[standard_volumes_index,]
  data_random_volumes = read.csv(paste0(volumes_path), stringsAsFactors = F, header = F)[random_volumes_index,]
  

  
  standard_atlas_colors = c(
    '#E61717E6',
    '#e6ad00E6',
    '#006400E6',
    '#178DE6E6',
    '#2F17E6E6'
  )
  
  standard_atlas_colors = rainbow(length(standard_atlases_to_plot), s= 0.9,v=0.9,start = 0, end = 0.8, alpha = 0.9)
  random_atlas_colors = rainbow(length(random_atlases_to_plot), s= 0.9,v=0.9,start = 0.0, end = 0.8, alpha = 0.9)
  random_atlas_colors = rep("#333333",  length(random_atlases_to_plot))
  

  
  INDEX_FREQ = c(1:length(frequency_names))
  f = 1 #broadband

  par(new = F)
  
  #plotting parameters
  
  ylim = c(0, 0.6)
  xlim = c(min(data_standard_volumes$V2, data_random_volumes$V2), 5.5)
  standard_atlases_line_width = 3
  random_atlases_line_width = 3
  standard_atlas_colors_transparency = 'ff'
  CI95_color = "#99999966"
  pch_random = 20
  pch_standard = c(0:length(standard_atlases_to_plot))
  
  mar_1 = 3
  mar_2 = 3
  mar_3 = 1
  mar_4 = 0
  #par(mfrow = c(2,1))
  mar = c(mar_1,mar_2,mar_3,mar_4)
  par(mar =mar)
  
  las = 1
  font_legend = 4
  cex_legend = 0.9
  cex_main = 1
  line_main = -1.0
  tick = 0.02
  cex_random_dots = 3
  cex_x_axis = 1.5
  
  

  #Random Atlases MEANS
  vols = c()
  means_all = c()
  standard_dev = c()
  for (a in 1:length(random_atlases_to_plot)){
    atlas_index_means = which(row.names(means_random_atlases[[f]]  ) == random_atlases_to_plot[a])
    SFC = means_random_atlases[[f]][atlas_index_means,]
    volume = data_random_volumes[which(row.names(means_random_atlases[[f]])[atlas_index_means] == data_random_volumes$V1),2]
    SFC_mean = mean(as.numeric(SFC))
    
    vols = c(vols, volume)
    means_all = c(means_all, SFC_mean)
    standard_dev = c(standard_dev,sd(as.numeric(SFC)))
    if (a == 1){par(new = F)}
    if (a > 1){par(new = T)}
    #plot(x =  rep(volume,length(SFC)), SFC , xlim = xlim, ylim = ylim, bty="n" , col = random_atlas_colors[a] , ylab = "", xlab = "" , xaxt = "n" )
  
  }
  par(new = F)
  plot(x = vols ,y = means_all, xlim = xlim, ylim = ylim , col = random_atlas_colors[a] , ylab = "", xlab = "" , xaxt = "n" ,yaxt = "n" , type = "l", lwd = 4, las = las)
  par(new = T)
  plot(x = vols ,y = means_all, xlim = xlim, ylim = ylim, bty="n" , col = random_atlas_colors[a] , ylab = "", xlab = "" , yaxt = "n", xaxt = "n" , pch = pch_random, cex = cex_random_dots)
  CI95_change = (2.011 * standard_dev)/sqrt(length(SFC))
  polygon(  x = c(vols, rev(vols)  ), 
            y = c(  means_all +   CI95_change  , rev( means_all -   CI95_change )   ),
            border = NA, col = paste0(CI95_color))
  axis(side=1, at= vols, labels =F , tck = tick )
  
  #Standard Atlases MEANS
  vols = c()
  means_all = c()
  standard_dev = c()
  for (a in 1:length(standard_atlases_to_plot)){
    atlas_index_means = which(row.names(means_standard_atlases[[f]]  ) == standard_atlases_to_plot[a])
    SFC = means_standard_atlases[[f]][atlas_index_means,]
    volume = data_standard_volumes[which(row.names(means_standard_atlases[[f]])[atlas_index_means] == data_standard_volumes$V1),2]
    SFC_mean = mean(as.numeric(SFC))
    
    vols = c(vols, volume)
    means_all =  c(means_all, SFC_mean)
    standard_dev =  c(standard_dev,sd(as.numeric(SFC)))
    par(new = T)
    #plot(x =  rep(volume,length(SFC)), SFC , xlim = xlim, ylim = ylim, bty="n" , col = standard_atlas_colors[a] , ylab = "", xlab = "", xaxt = "n" , yaxt= "n")
    
  }
  
  par(new = T)
  plot(x = vols ,y = means_all, xlim = xlim, ylim = ylim, bty="n" , col = standard_atlas_colors , ylab = "", xlab = "",  yaxt = "n", xaxt = "n" , pch =pch_standard, cex = 2)

  CI95_change = (2.011 * standard_dev)/sqrt(length(SFC))
  for (a in 1:length(standard_atlases_to_plot)){
  segments(x0 = vols[a] , y0= (means_all +   CI95_change)[a] , x1 = vols[a]  , y1 =   (means_all -   CI95_change)[a],col = standard_atlas_colors[a], lwd = 2  )
  }
  
  axis(side=1 , cex.axis = cex_x_axis, las= las)
  axis(side=2 , cex.axis = cex_x_axis, las= las)
  
  
  
  
  
  
  
  
  
  #Random Atlases DIFFERENCE
  vols = c()
  means_all = c()
  standard_dev = c()
  for (a in 1:length(random_atlases_to_plot)){
    atlas_index_difference = which(row.names(difference_random_atlases[[f]]  ) == random_atlases_to_plot[a])
    difference = abs(difference_random_atlases[[f]][atlas_index_difference,])
    volume = data_random_volumes[which(row.names(means_random_atlases[[f]])[atlas_index_difference] == data_random_volumes$V1),2]
    
    difference_mean = mean(as.numeric(difference))
    
    vols = c(vols, volume)
    means_all =  c(means_all, difference_mean)
    standard_dev =  c(standard_dev,sd(as.numeric(difference)))
    if (a == 1){par(new = F)}
    if (a > 1){par(new = T)}
    #plot(x =  rep(volume,length(difference)), difference , xlim = xlim, ylim = ylim, bty="n" , col = random_atlas_colors[a] , ylab = "", xlab = "" , xaxt = "n")
  }
  par(new = F)
  ylim = c(0.0,0.14)
  plot(x = vols ,y = means_all, xlim = xlim , ylim = ylim ,col = random_atlas_colors[a] , ylab = "", xlab = "" ,yaxt = "n", xaxt = "n" , type = "l", lwd = 4, las = las)
  par(new = T)
  plot(x = vols ,y = means_all, xlim = xlim, ylim = ylim, bty="n" , col = random_atlas_colors[a] , ylab = "", xlab = "" ,yaxt = "n", xaxt = "n" , pch = pch_random, cex = cex_random_dots)
  CI95_change = (2.011 * standard_dev)/sqrt(length(difference))
  polygon(  x = c(vols, rev(vols)  ), 
            y = c(  means_all +   CI95_change  , rev( means_all -   CI95_change )   ),
            border = NA, col = paste0(CI95_color))
  
  axis(side=1, at= vols, labels =F , tck = tick )
  #text(means$Group.1, par("usr")[4] *multiplier_parcellation_text_2, labels = Parcellation_sizes, srt = 90, xpd = NA, cex = cex_parcellations, adj = c(0.5,0.5), font = font_Parcellation_sizes, col = color)

  
  
  
  
  #Standard Atlases DIFFERENCE
  vols = c()
  means_all = c()
  standard_dev = c()
  for (a in 1:length(standard_atlases_to_plot)){
    atlas_index_difference = which(row.names(difference_standard_atlases[[f]]  ) == standard_atlases_to_plot[a])
    difference = abs(difference_standard_atlases[[f]][atlas_index_difference,])
    volume = data_standard_volumes[which(row.names(means_standard_atlases[[f]])[atlas_index_difference] == data_standard_volumes$V1),2]
    
    difference_mean = mean(as.numeric(difference))
    
    vols = c(vols, volume)
    means_all =  c(means_all, difference_mean)
    standard_dev =  c(standard_dev,sd(as.numeric(difference)))
    par(new = T)
    #plot(x =  rep(volume,length(difference)), difference , xlim = xlim, ylim = ylim, bty="n" , col = standard_atlas_colors[a] , ylab = "", xlab = "" , xaxt = "n", yaxt= "n")
  }
  
  
  par(new = T)
  plot(x = vols ,y = means_all, xlim = xlim, ylim = ylim, bty="n" , col = standard_atlas_colors , ylab = "", yaxt = "n", xlab = "" , xaxt = "n" , pch =pch_standard, cex = 2)
  
  CI95_change = (2.011 * standard_dev)/sqrt(length(SFC))
  for (a in 1:length(standard_atlases_to_plot)){
    segments(x0 = vols[a] , y0= (means_all +   CI95_change)[a] , x1 = vols[a]  , y1 =   (means_all -   CI95_change)[a],col = standard_atlas_colors[a], lwd = 2 , xpd = NA )
  }
  axis(side=1 , cex.axis = cex_x_axis, las= las)
  axis(side=2 , cex.axis = cex_x_axis, las= las)
  
  plot(1, type = "n", axes=FALSE, xlab="", ylab="")
  
  
  legend(x = "top", legend = c("Random Atlases",standard_atlases_legend) ,col = c(random_atlas_colors[1], standard_atlas_colors), cex = cex_legend,
         pch = c(pch_random, pch_standard), bty = "n", xpd = T, horiz = F, ncol = 4)
  
  

  
# 
#   text(x = par("usr")[2]*1.03, y = (par("usr")[3] + par("usr")[4])/2, frequency_names[f], srt = 270, xpd = NA,cex=1.5)
#   
#   mtext(text="Spearman Rank Correlation",side=2,line=0.5,outer=TRUE,cex=1.2)
#   mtext(text="Volume (log10 voxels)",side=1,line=-4,outer=TRUE,cex=0.9)
#   
# 
# 
# 
#   
#   
#   #mar_1 = 3
#   mar_3 = 2
#   mar = c(mar_1,mar_2,mar_3,mar_4)
#   par(mar =mar)
#    plot(1, type = "n", axes=FALSE, xlab="", ylab="")
#    
#    legend("bottomleft", inset=c(-0.1,-0.5), legend = c("Random Atlases",standard_atlases_legend), fill = c(random_atlas_colors[1], standard_atlas_colors), bty = 'n', bg ='n',horiz = F,
#           xpd = NA, x.intersp=0.3, ncol = 3,
#           xjust=0.5, yjust=0, cex = 0.5 )
#    plot(1, type = "n", axes=FALSE, xlab="", ylab="")
#    
#    legend("bottomleft", inset=c(-0.05,-0.5), legend =  paste0(random_atlases_legend," Parcellations"), fill = random_atlas_colors, bty = 'n', bg ='n',horiz = F,
#           xpd = NA, x.intersp=0.3, ncol = 3,
#           xjust=0.5, yjust=0, cex = 0.5)
 dev.off()
