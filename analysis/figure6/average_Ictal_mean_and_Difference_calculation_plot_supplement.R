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
  fname = paste0(output_plot_path, 'average_Ictal_mean_and_Difference_ALL', ".pdf")
  pdf(fname , width = 6, height = 8)
  load(average_Ictal_data_path)
  
  m <- matrix(c(1,2,3,4,5,6,7,8,9,10,11,11),nrow = 6,ncol = 2,byrow = TRUE)
  
  layout(mat = m,heights = c(1,1,1,1,1,0.5,0.5))
  
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
  
  
  
  
  #add_siezure_colors <- function(bottom,f){
    
    #Adding seizure colors
    #interictal
    colors_interictal = '#ffffff'
    colors_preictal = '#6666ff'
    colors_ictal = '#ff6666'
    colors_postictal = '#ffffff'
    
    transparency = '33'
    interictal_x = c(0:length(data_interictal_broadband_movingAvg ))
    polygon(  x = c(interictal_x, rev(interictal_x)  ), 
              y = c( rep(par("usr")[4], length(interictal_x) ) , rep(bottom, length(interictal_x))   ),
              border = NA, col = paste0(colors_interictal, transparency))
    
    
    
    preictal_x_start = length(c(averaged_resampled_random_atlases$RA_N0010$interictal$mean$broadband,filler))+1  
    preictal_x_end = preictal_x_start+length(averaged_resampled_random_atlases$RA_N0010$preictal$mean$broadband)
    ictal_x_start = preictal_x_end + 1
    ictal_x_end = ictal_x_start+length(averaged_resampled_standard_atlases[[atlas_index]]$ictal$broadband)
    postictal_x_start = ictal_x_end + 1
    postictal_x_end = length(y_moving_avg)
    
    polygon(  x = c(preictal_x_start:preictal_x_end, rev(preictal_x_start:preictal_x_end)  ), 
              y = c( rep(par("usr")[4], length(preictal_x_start:preictal_x_end) ) , rep(bottom, length(preictal_x_start:preictal_x_end))   ),
              border = NA, col = paste0(colors_preictal, transparency))
    polygon(  x = c(ictal_x_start:ictal_x_end, rev(ictal_x_start:ictal_x_end)  ), 
              y = c( rep(par("usr")[4], length(ictal_x_start:ictal_x_end) ) , rep(bottom, length(ictal_x_start:ictal_x_end))   ),
              border = NA, col = paste0(colors_ictal, transparency))
    polygon(  x = c(postictal_x_start:postictal_x_end, rev(postictal_x_start:postictal_x_end)  ), 
              y = c( rep(par("usr")[4], length(postictal_x_start:postictal_x_end) ) , rep(bottom, length(postictal_x_start:postictal_x_end))   ),
              border = NA, col = paste0(colors_postictal, transparency))
    
    if (f == 1){
    text(x = (preictal_x_start + ictal_x_start )/2,
         y = par("usr")[4]*0.9, labels = "Preictal")
    text(x = (ictal_x_start + ictal_x_end )/2,
         y = par("usr")[4]*0.9, labels = "Ictal")}
    
    
    
    
    
  }
  
  INDEX_FREQ = c(1:length(frequency_names))
  
  for (f in INDEX_FREQ){
    par(new = F)
    
    #plotting parameters
    
    ylim = c(-0.1, 0.6)
    xlim = c(min(data_standard_volumes$V2, data_random_volumes$V2), 5.5)
    standard_atlases_line_width = 3
    random_atlases_line_width = 3
    standard_atlas_colors_transparency = 'ff'
    CI95_color = "#99999966"
    
    mar_1 = 1
    mar_2 = 3
    mar_3 = 0
    mar_4 = 0
    #par(mfrow = c(2,1))
    mar = c(mar_1,mar_2,mar_3,mar_4)
    par(mar =mar)
    
    las = 1
    font_legend = 4
    cex_legend = 0.9
    cex_main = 1
    line_main = -1.0
    
    
    

    #Random Atlases MEANS
    for (a in 1:length(random_atlases_to_plot)){
      atlas_index_means = which(row.names(means_random_atlases[[f]]  ) == random_atlases_to_plot[a])
      SFC = means_random_atlases[[f]][atlas_index_means,]
      volume = data_random_volumes[which(row.names(means_random_atlases[[f]])[atlas_index_means] == data_random_volumes$V1),2]
      if (a == 1){par(new = F)}
      if (a > 1){par(new = T)}
      plot(x =  rep(volume,length(SFC)), SFC , xlim = xlim, ylim = ylim, bty="n" , col = random_atlas_colors[a] , ylab = "", xlab = "" , xaxt = "n" )
    
      
    }
    
    
    #Standard Atlases MEANS
    for (a in 1:length(standard_atlases_to_plot)){
      atlas_index_means = which(row.names(means_standard_atlases[[f]]  ) == standard_atlases_to_plot[a])
      SFC = means_standard_atlases[[f]][atlas_index_means,]
      volume = data_standard_volumes[which(row.names(means_standard_atlases[[f]])[atlas_index_means] == data_standard_volumes$V1),2]
      par(new = T)
      plot(x =  rep(volume,length(SFC)), SFC , xlim = xlim, ylim = ylim, bty="n" , col = standard_atlas_colors[a] , ylab = "", xlab = "", xaxt = "n" , yaxt= "n")
      
    }
    
    if (f == 1){
      mtext(text="Mean Ictal SFC",side=3,line=0.0,outer=F,cex=cex_main)
    }
    if (f ==5  ){
      axis(1, pos=-0.1, lty=1, las=1, tck=-0.1, lwd = 2, font = 1)
    }
    if (f <5  ){
      abline(h = -0.1, lwd = 1)
    }
    
    
    
    #Random Atlases DIFFERENCE
    for (a in 1:length(random_atlases_to_plot)){
      atlas_index_difference = which(row.names(difference_random_atlases[[f]]  ) == random_atlases_to_plot[a])
      difference = abs(difference_random_atlases[[f]][atlas_index_difference,])
      volume = data_random_volumes[which(row.names(means_random_atlases[[f]])[atlas_index_difference] == data_random_volumes$V1),2]
      if (a == 1){par(new = F)}
      if (a > 1){par(new = T)}
      plot(x =  rep(volume,length(difference)), difference , xlim = xlim, ylim = ylim, bty="n" , col = random_atlas_colors[a] , ylab = "", xlab = "" , xaxt = "n")
      
      
      
      
    }

    #Standard Atlases DIFFERENCE
    for (a in 1:length(standard_atlases_to_plot)){
      atlas_index_difference = which(row.names(difference_standard_atlases[[f]]  ) == standard_atlases_to_plot[a])
      difference = abs(difference_standard_atlases[[f]][atlas_index_difference,])
      volume = data_standard_volumes[which(row.names(means_standard_atlases[[f]])[atlas_index_difference] == data_standard_volumes$V1),2]
      par(new = T)
      plot(x =  rep(volume,length(difference)), difference , xlim = xlim, ylim = ylim, bty="n" , col = standard_atlas_colors[a] , ylab = "", xlab = "" , xaxt = "n", yaxt= "n")
  
      
      
      
    }
    
    if (f == 1){
      mtext(text="Ictal-Preictal SFC Difference",side=3,line=0.0,outer=F,cex=cex_main)
    }
    if (f ==5  ){
      axis(1, pos=-0.1, lty=1, las=1, tck=-0.1, lwd = 2, font = 1)
    }
    if (f <5  ){
      abline(h = -0.1, lwd = 1)
    }
   
  
   
    

    text(x = par("usr")[2]*1.03, y = (par("usr")[3] + par("usr")[4])/2, frequency_names[f], srt = 270, xpd = NA,cex=1.5)
    
    mtext(text="Spearman Rank Correlation",side=2,line=0.5,outer=TRUE,cex=1.2)
    mtext(text="Volume (log10 voxels)",side=1,line=-4,outer=TRUE,cex=0.9)
    

  

  }
  
  #mar_1 = 3
  mar_3 = 2
  mar = c(mar_1,mar_2,mar_3,mar_4)
  par(mar =mar)
   plot(1, type = "n", axes=FALSE, xlab="", ylab="")
   
   legend("bottom", inset=c(-0.1,-0.5), legend = c("Random Atlases",standard_atlases_legend), fill = c(random_atlas_colors[1], standard_atlas_colors), bty = 'n', bg ='n',horiz = F,
          xpd = NA, x.intersp=0.3, ncol = 7,
          xjust=0.5, yjust=0, cex = 0.8 )

 dev.off()
