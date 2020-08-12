# Ignore: For Alex Computer 
#processed_SFC_dir = "./processed_SFC/"
#resampled_SFC_dir = "./resampled_SFC/max/"

SFC_type = "increase" #increase, decrease, all
#Andy computer:
averaged_resampled_data_path = paste0("/Users/andyrevell/mount/USERS/arevell/papers/paper001/data_processed/figure6_data/average_SFC_ALL_PATIENTS/averaged_resampled_data/medians/", SFC_type, "/averaged_resampled_data.RData")
output_plot_path= paste0("/Users/andyrevell/mount/USERS/arevell/papers/paper001/paper001/figures/figure6/average_SFC_ALL_PATIENTS/averaged_resampled_data/medians/", SFC_type, "/")


#Borel:
#processed_SFC_dir = "/gdrive/public/USERS/arevell/papers/paper001/data_processed/figure5_data/structure_function_correlation/"
# change this to be either medians/up/downsample 
#resampled_SFC_dir = "/gdrive/public/USERS/arevell/papers/paper001/data_processed/figure6_data/average_SFC_ALL_PATIENTS/medians/"


#plot_averaged_resampled_data(averaged_resampled_data_path, output_plot_path)

#plot_averaged_resampled_data <- function(averaged_resampled_data_path, output_plot_path){
  
  options(scipen=999)#prevent scientifuc notation. iEEG org times are very long, so helps when reading files to read the number string verbatim
  
  #dev.off(dev.list()["RStudioGD"])
  fname = paste0(output_plot_path, 'averaged_resampled_data', ".pdf")
  pdf(fname , width = 12, height = 6)
  load(averaged_resampled_data_path)
  
  m <- matrix(c(1,2,3,4,5,6,7,8,9,10),nrow = 2,ncol = 5,byrow = T)
  
  layout(mat = m,heights = c(1,1,1,1,1,1))
  #layout.show(n=10)
  #par(mfrow = c(3,2))
  par(oma=c(1,3,4,2))
  
  #create filler data with NAs. Filler between interictal and preictal (becasue they are not continuous)
  filler =  rep(NA,  length(averaged_resampled_random_atlases$RA_N0010$ictal$mean$broadband) *0.20  )# X% of ictal length 
  
  #Make colors
  colors_interictal = '#cc0000'
  colors_preictal = '#00cc00'
  colors_ictal = '#0000cc'
  colors_postictal = '#cc00cc'
  
  
  frequency_names = names(averaged_resampled_random_atlases$RA_N0010$interictal$mean)
  frequency_names =c("Broadband", "Alpha/Theta", "Beta", "Low Gamma", 
                    "High Gamma")
  
  colors = c(rep(colors_interictal, length(averaged_resampled_random_atlases$RA_N0010$interictal$mean$broadband)),
             rep('#000000', length(filler)),
             rep(colors_preictal, length(averaged_resampled_random_atlases$RA_N0010$preictal$mean$broadband)),
             rep(colors_ictal, length(averaged_resampled_random_atlases$RA_N0010$ictal$mean$broadband)),
             rep(colors_postictal, length(averaged_resampled_random_atlases$RA_N0010$postictal$mean$broadband)))
  
  random_atlases=c('RA_N0010', 'RA_N0030', 'RA_N0050', 'RA_N0075','RA_N0100','RA_N0200','RA_N0300', 'RA_N0400', 'RA_N0500' , 'RA_N0750', 'RA_N1000', 'RA_N2000')
  standard_atlases=c('aal_res-1x1x1', 'AAL600', 'CPAC200_res-1x1x1', 'desikan_res-1x1x1','DK_res-1x1x1','JHU_res-1x1x1',
                     'Schaefer2018_100Parcels_17Networks_order_FSLMNI152_1mm', 'Schaefer2018_200Parcels_17Networks_order_FSLMNI152_1mm',
                     'Schaefer2018_300Parcels_17Networks_order_FSLMNI152_1mm' , 'Schaefer2018_400Parcels_17Networks_order_FSLMNI152_1mm', 
                     'Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_1mm', 'Talairach_res-1x1x1', 'JHU_aal_combined_res-1x1x1')
  
  random_atlases_to_plot = c('RA_N0010', 'RA_N0030','RA_N0100','RA_N1000','RA_N2000')
  standard_atlases_to_plot = c('CPAC200_res-1x1x1',
                               'Schaefer2018_100Parcels_17Networks_order_FSLMNI152_1mm',
                               'Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_1mm',
                               'aal_res-1x1x1', 'JHU_aal_combined_res-1x1x1')
  
  standard_atlases_legend = c('CPAC', 'Schaefer 100', 'Schaefer 1000','AAL','AAL-JHU')
  random_atlases_legend = c('10', '30','100', '1000', '2000')
  #########
  #to caluclate moving average:
  ma <- function(x, n = 10){filter(x, rep(1 / n, n), sides = 2)}
  
  
  standard_atlas_colors = c(
    '#e6ad00E6',
    '#006400E6',
    '#178DE6E6',
    '#E61717E6',
    '#2F17E6E6'
  )
  line_type=c(1,1,1,1,1)
  #standard_atlas_colors = rainbow(length(standard_atlases_to_plot), s= 0.9,v=0.9,start = 0, end = 0.8, alpha = 0.9)
  random_atlas_colors = rainbow(length(random_atlases_to_plot), s= 0.9,v=0.9,start = 0.0, end = 0.8, alpha = 0.9)
  #random_atlas_colors = rep("#333333",  length(random_atlases_to_plot))
  
  
  
  add_siezure_colors <- function(bottom){
    
    #Adding seizure colors
    #interictal
    colors_interictal = '#ffffff'
    colors_preictal = '#6666ff'
    colors_ictal = '#ff6666'
    colors_postictal = '#ffffff'
    
    transparency = '22'
    interictal_x = c(0:length(data_interictal_broadband_movingAvg ))
    polygon(  x = c(interictal_x, rev(interictal_x)  ), 
              y = c( rep(par("usr")[4], length(interictal_x) ) , rep(bottom, length(interictal_x))   ),
              border = NA, col = paste0(colors_interictal, transparency))
    

    
    preictal_x_start = length(c(atlas_data[[1]]$interictal$mean$broadband,filler))+1  
    preictal_x_end = preictal_x_start+length(atlas_data[[1]]$preictal$mean$broadband)
    ictal_x_start = preictal_x_end + 1
    ictal_x_end = ictal_x_start+length(atlas_data[[1]]$ictal$mean$broadband)
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
    
    
    # text(x = (preictal_x_start + ictal_x_start )/2,
    #      y = par("usr")[4]*0.9, labels = "Preictal")
    # text(x = (ictal_x_start + ictal_x_end )/2,
    #      y = par("usr")[4]*0.9, labels = "Ictal")
    # 
    
    
    
    
  }
  
  
  

  INDEX_FREQ = c(1:5)
  f=1
  #for (f in INDEX_FREQ){
    par(new = F)
    
    #plotting parameters
    
    ylim = c(-0.1, 0.4)
    standard_atlases_line_width = 3.5
    random_atlases_line_width = 2.5
    standard_atlas_colors_transparency = 'ff'
    CI95_color = "#99999944"
    
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
    cex_main = 1.2
    line_main = -1.0
    
    
    
    ictal_colors = c(rainbow(5, s= 0.8,v=0.9,start = 0.0, end = 0.03, alpha = 0.7))
    interictal_colors = rainbow(5, s= 0.8,v=0.9,start = 0.67, end = 0.73, alpha = 0.7)
    #Standard Atlases
    for (w in 1:2){#w=1 is standard atlases, w=2 is random atalses
      for (a in 1:length(standard_atlases_to_plot)){
        if (w == 1){
          atlas_data = averaged_resampled_standard_atlases
          atlas_index = which(names(atlas_data) == standard_atlases_to_plot[a])
          atlas_colors = standard_atlas_colors[a]
          line_type_atlas = line_type[a]
          }
        if (w == 2){
          atlas_data = averaged_resampled_random_atlases
          atlas_index = which(names(atlas_data) == random_atlases_to_plot[a])
          atlas_colors = "black"
          line_type_atlas = 1
          }
        #create running mean (moving average, convolution)
        N = 20 #length of window
        interictal = atlas_data[[atlas_index]]$interictal$mean[[f]] #getting rid of end of vector because averaging code cant deal with edges and makes it zero
        interictal = c(interictal[-length(interictal)],interictal[length(interictal)-1 ])
        interictal_CI95_upper = atlas_data[[atlas_index]]$interictal$CI95_upper[[f]]
        interictal_CI95_upper = c(interictal_CI95_upper[-length(interictal_CI95_upper)],interictal_CI95_upper[length(interictal_CI95_upper)-1 ])
        interictal_CI95_lower =atlas_data[[atlas_index]]$interictal$CI95_lower[[f]]
        interictal_CI95_lower = c(interictal_CI95_lower[-length(interictal_CI95_lower)],interictal_CI95_lower[length(interictal_CI95_lower)-1 ])
        preictal = atlas_data[[atlas_index]]$preictal$mean[[f]]
        preictal = c(preictal[-length(preictal)],preictal[length(preictal)-1 ])
        preictal_CI95_upper = atlas_data[[atlas_index]]$preictal$CI95_upper[[f]]
        preictal_CI95_upper = c(preictal_CI95_upper[-length(preictal_CI95_upper)],preictal_CI95_upper[length(preictal_CI95_upper)-1 ])
        preictal_CI95_lower =atlas_data[[atlas_index]]$preictal$CI95_lower[[f]]
        preictal_CI95_lower = c(preictal_CI95_lower[-length(preictal_CI95_lower)],preictal_CI95_lower[length(preictal_CI95_lower)-1 ])
        ictal = atlas_data[[atlas_index]]$ictal$mean[[f]]
        ictal = c(ictal[-length(ictal)],ictal[length(ictal)-1 ])
        ictal_CI95_upper = atlas_data[[atlas_index]]$ictal$CI95_upper[[f]]
        ictal_CI95_upper = c(ictal_CI95_upper[-length(ictal_CI95_upper)],ictal_CI95_upper[length(ictal_CI95_upper)-1 ])
        ictal_CI95_lower =atlas_data[[atlas_index]]$ictal$CI95_lower[[f]]
        ictal_CI95_lower = c(ictal_CI95_lower[-length(ictal_CI95_lower)],ictal_CI95_lower[length(ictal_CI95_lower)-1 ])
        postictal = atlas_data[[atlas_index]]$postictal$mean[[f]]
        postictal = c(postictal[-length(postictal)],postictal[length(postictal)-1 ])
        postictal_CI95_upper = atlas_data[[atlas_index]]$postictal$CI95_upper[[f]]
        postictal_CI95_upper = c(postictal_CI95_upper[-length(postictal_CI95_upper)],postictal_CI95_upper[length(postictal_CI95_upper)-1 ])
        postictal_CI95_lower =atlas_data[[atlas_index]]$postictal$CI95_lower[[f]]
        postictal_CI95_lower = c(postictal_CI95_lower[-length(postictal_CI95_lower)],postictal_CI95_lower[length(postictal_CI95_lower)-1 ])
        
    
        
        #####
        
        data_interictal_broadband_movingAvg = ma(interictal, N)
        data_interictal_broadband_movingAvg_CI95_upper = ma(interictal_CI95_upper, N)
        data_interictal_broadband_movingAvg_CI95_lower = ma(interictal_CI95_lower, N)
        
        data_other_broadband_movingAvg = ma( c(preictal, ictal, postictal), N  )
        data_other_broadband_movingAvg_CI95_upper = ma( c(preictal_CI95_upper, ictal_CI95_upper, postictal_CI95_upper), N  )
        data_other_broadband_movingAvg_CI95_lower = ma( c(preictal_CI95_lower, ictal_CI95_lower, postictal_CI95_lower), N  )
        
        #Calculating pad for the running mean
        pad_data_interictal_broadband_movingAvg = length(which(is.na(data_interictal_broadband_movingAvg)))
        pad_data_other_broadband_movingAvg = length(which(is.na(data_other_broadband_movingAvg)))
        #removing NAs from the original moving average function
        data_interictal_broadband_movingAvg = data_interictal_broadband_movingAvg[!is.na(data_interictal_broadband_movingAvg)]
        data_interictal_broadband_movingAvg_CI95_upper = data_interictal_broadband_movingAvg_CI95_upper[!is.na(data_interictal_broadband_movingAvg_CI95_upper)]
        data_interictal_broadband_movingAvg_CI95_lower = data_interictal_broadband_movingAvg_CI95_lower[!is.na(data_interictal_broadband_movingAvg_CI95_lower)]
        data_other_broadband_movingAvg = data_other_broadband_movingAvg[!is.na(data_other_broadband_movingAvg)]
        data_other_broadband_movingAvg_CI95_upper = data_other_broadband_movingAvg_CI95_upper[!is.na(data_other_broadband_movingAvg_CI95_upper)]
        data_other_broadband_movingAvg_CI95_lower = data_other_broadband_movingAvg_CI95_lower[!is.na(data_other_broadband_movingAvg_CI95_lower)]
        
        data_interictal_broadband_movingAvg = c(  rep(NA, pad_data_interictal_broadband_movingAvg),data_interictal_broadband_movingAvg )
        data_interictal_broadband_movingAvg_CI95_upper = c(  rep(NA, pad_data_interictal_broadband_movingAvg),data_interictal_broadband_movingAvg_CI95_upper )
        data_interictal_broadband_movingAvg_CI95_lower = c(  rep(NA, pad_data_interictal_broadband_movingAvg),data_interictal_broadband_movingAvg_CI95_lower )
        data_other_broadband_movingAvg = c(  rep(NA, pad_data_other_broadband_movingAvg),data_other_broadband_movingAvg )
        data_other_broadband_movingAvg_CI95_upper = c(  rep(NA, pad_data_other_broadband_movingAvg),data_other_broadband_movingAvg_CI95_upper )
        data_other_broadband_movingAvg_CI95_lower = c(  rep(NA, pad_data_other_broadband_movingAvg),data_other_broadband_movingAvg_CI95_lower )
        
        
  
        
        
        #plotting
        y_moving_avg = c(data_interictal_broadband_movingAvg, filler, data_other_broadband_movingAvg)
        y_moving_avg_CI95_upper = c(data_interictal_broadband_movingAvg_CI95_upper, filler, data_other_broadband_movingAvg_CI95_upper)
        y_moving_avg_CI95_lower = c(data_interictal_broadband_movingAvg_CI95_lower, filler, data_other_broadband_movingAvg_CI95_lower)
        data_length = length(y_moving_avg)
        CI95_upper = c(preictal_CI95_upper,ictal_CI95_upper,postictal_CI95_upper)
        CI95_lower = c(preictal_CI95_lower,ictal_CI95_lower,postictal_CI95_lower)
        x = c(1:data_length)
        xlim = c(0, data_length)
        
        
  
        colbar = c(interictal_colors[a], interictal_colors[a], ictal_colors[a], interictal_colors[a])
        #if (a == 1){par(new = F)}
        #if (a > 1){par(new = T)}
        interictal_start = 1
        interictal_end = length(averaged_resampled_random_atlases$RA_N0010$interictal$mean$broadband)
        preictal_x_start = interictal_end+length(filler)+1  
        preictal_x_end = preictal_x_start+length(averaged_resampled_random_atlases$RA_N0010$preictal$mean$broadband)-1
        ictal_x_start = preictal_x_end + 1
        ictal_x_end = ictal_x_start+length(averaged_resampled_standard_atlases[[atlas_index]]$ictal$mean$broadband)-1
        postictal_x_start = ictal_x_end + 1
        postictal_x_end = postictal_x_start+length(averaged_resampled_standard_atlases[[atlas_index]]$postictal$mean$broadband)-1
        starts = c(1,preictal_x_start ,ictal_x_start,postictal_x_start)
        ends = c(interictal_end,preictal_x_end ,ictal_x_end,postictal_x_end)
        
        
        
        par(new = F)
        plot(NA, NA, xlim = xlim, ylim = ylim, bty="n", ylab = "", xlab = "", xaxt = 'n', las = las)
        bottom = ylim[1]#par("usr")[3]
        add_siezure_colors(bottom)
        polygon(c(1:length(interictal), rev(1:length(interictal))), 
                c(interictal_CI95_lower, rev(interictal_CI95_upper)) ,
                border = CI95_color, col = CI95_color)
        polygon(  x = c((preictal_x_start:postictal_x_end), rev(preictal_x_start:postictal_x_end)), 
                  y = c(CI95_lower, rev(CI95_upper)),
                  border = CI95_color, col = CI95_color)
        
        for (s in 1:4){
          par(new = T)
          points = atlas_data[[atlas_index]][[s]]$mean[[f]]
          plot(starts[s]:ends[s], c(points[-length(points)],points[length(points)-1]), xlim = xlim, ylim = ylim, bty="n", 
               col = "#00000033", ylab = "", xlab = "", xaxt = 'n', las = las, pch = 20, )
        }
        
        
        par(new = T)
        plot(x, y_moving_avg, xlim = xlim, ylim = ylim, bty="n", type = "l", lwd = standard_atlases_line_width, 
             col = atlas_colors, ylab = "", xlab = "", xaxt = 'n', yaxt = 'n',las = las, lty = line_type_atlas)
        
       
        
        if (w ==1){
          mtext(text=standard_atlases_legend[a],side=3,line=-0,outer=F,cex=cex_main)
          axis(1, at=c(at=pad_data_interictal_broadband_movingAvg,preictal_x_start, ictal_x_start, ictal_x_end,postictal_x_end), 
               labels=NA, 
               pos=ylim[1], lty=1, las=1, tck=0.03, lwd = 2, font = 2)}
        if (w ==2){
          mtext(text=random_atlases_legend[a],side=3,line=-0,outer=F,cex=cex_main)
          axis(1, at=c(preictal_x_start, ictal_x_start, ictal_x_end,postictal_x_end), 
               labels=c(preictal_x_start-ictal_x_start,0, ictal_x_end -ictal_x_start+1, ictal_x_end -ictal_x_start+1 +180 ), 
               pos=ylim[1], lty=1, las=1, tck=0.03, lwd = 2, font = 2, cex.axis = 1.2)
          axis(1, at=pad_data_interictal_broadband_movingAvg, 
               labels=c("~6 hrs\nbefore" ), 
               pos=ylim[1], lty=1, las=1, tck=0.03, lwd = 2, font = 2, adj = 1, cex.axis = 1)
          
          if (a == 3){mtext(text=paste0("Random Atlases"),side=3,line=2,outer=F,cex=1.2, font = 2)}
          }
        abline(h = ylim[1], lwd = 2)

      
        #adding in labels to point to next figure
        if (w == 1 && a == 1){
          x1 = ictal_x_start*0.95
          y1 = y_moving_avg[ictal_x_start]
          x2 = ictal_x_start*0.9
          y2 = max(na.omit(y_moving_avg) )
          lwd = 3
          cex_fig=1.4
          x0 = x1 *0.9
          y0 = y1 *1.2
          segments(x1, y0, x0,y0, lwd = lwd)
          segments(x0, y0, x0,y2, lwd = lwd)
          segments(x1, y2, x0,y2, lwd = lwd)
          text(x = x0, y = (y0+y2)/2, labels = "Figure\n7B  ", pos = 2, cex = cex_fig, font = 2)
          
          
          
          
          
          
          x1 = ictal_x_start
          y1 = y_moving_avg[ictal_x_start]
          x2 = ictal_x_end
          lwd = 3
          y0 = y1 *0.7
          y2 = y0*0.7
          segments(x1, y0, x1,y2, lwd = lwd)
          segments(x1, y2, x2,y2, lwd = lwd)
          segments(x2, y0, x2,y2, lwd = lwd)
          text(x = (x1+x2)/2, y = y2, labels = "Figure\n7A", pos = 1, offset =0.75, cex =cex_fig, font = 2)
          
        }
          
      }
    }

    mtext(text="Spearman Rank Correlation",side=2,line=0.5,outer=TRUE,cex=1.2)
    mtext(text="Time Normalized to Median Seizure Length (s)",side=1,line=-0.3,outer=TRUE,cex=1.2)
    mtext(text=paste0("Average of All Patients and Seizures"),side=3,line=2,outer=TRUE,cex=1.9, font = 2)

    


  #}#end for (f in INDEX_FREQ)
  
  dev.off()
