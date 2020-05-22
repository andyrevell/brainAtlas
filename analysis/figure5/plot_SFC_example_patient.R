library(reticulate)#read python pickle files
pd <- import("pandas")
#Plot SFC
data_directory = "/Users/andyrevell/mount/USERS/arevell/papers/paper001/data_processed/figure5_data/structure_function_correlation"
output_directory= "/Users/andyrevell/mount/USERS/arevell/papers/paper001/paper001/figures/figure5/structure_function_correlation"
setwd(output_directory)

options(scipen=999)#prevent scientifuc notation. iEEG org times are very long, so helps when reading files to read the number string verbatim

for (z in 1:20){
  if (z == 1){sub_ID='RID0194'; iEEG_filename = 'HUP134_phaseII_D02'; ictal_start_time = 179302933433}
  
  if (z == 2){sub_ID='RID0278'; iEEG_filename = 'HUP138_phaseII'; ictal_start_time = 248525740000}
  if (z == 3){sub_ID='RID0278'; iEEG_filename = 'HUP138_phaseII'; ictal_start_time = 339008330000}
  if (z == 4){sub_ID='RID0278'; iEEG_filename = 'HUP138_phaseII'; ictal_start_time = 416023190000}
  if (z == 5){sub_ID='RID0278'; iEEG_filename = 'HUP138_phaseII'; ictal_start_time = 429498590000}
  if (z == 6){sub_ID='RID0278'; iEEG_filename = 'HUP138_phaseII'; ictal_start_time = 458504560000}
  
  if (z == 7){sub_ID='RID0309'; iEEG_filename = 'HUP151_phaseII'; ictal_start_time = 494776000000}
  if (z == 8){sub_ID='RID0309'; iEEG_filename = 'HUP151_phaseII';  ictal_start_time = 530011424682}
  
  if (z == 9){sub_ID='RID0320'; iEEG_filename = 'HUP140_phaseII_D02';  ictal_start_time = 331999132626}
  if (z == 10){sub_ID='RID0320'; iEEG_filename = 'HUP140_phaseII_D02';  ictal_start_time = 340528040025}
  if (z == 11){sub_ID='RID0320'; iEEG_filename = 'HUP140_phaseII_D02'; ictal_start_time = 344573548935}
  
  if (z == 12){sub_ID='RID0440'; iEEG_filename = 'HUP172_phaseII';  ictal_start_time = 402704260829}
  if (z == 13){sub_ID='RID0440'; iEEG_filename = 'HUP172_phaseII'; ictal_start_time = 408697930000}
  if (z == 14){sub_ID='RID0440'; iEEG_filename = 'HUP172_phaseII';  ictal_start_time = 586990000000}
  if (z == 15){sub_ID='RID0440'; iEEG_filename = 'HUP172_phaseII';  ictal_start_time = 664976000000}
  if (z == 16){sub_ID='RID0440'; iEEG_filename = 'HUP172_phaseII';  ictal_start_time = 692879000000}
  
  
  if (z == 17){sub_ID='RID0536'; iEEG_filename = 'HUP195_phaseII_D01';  ictal_start_time = 84729094008}
  if (z == 18){sub_ID='RID0536'; iEEG_filename = 'HUP195_phaseII_D01'; ictal_start_time = 164694572385}
  if (z == 19){sub_ID='RID0536'; iEEG_filename = 'HUP195_phaseII_D01'; ictal_start_time = 250710930770}
  if (z == 20){sub_ID='RID0536'; iEEG_filename = 'HUP195_phaseII_D01';  ictal_start_time = 286819539584}


file_name = paste0('sub-', sub_ID, '_', iEEG_filename,  '_ICTAL_', ictal_start_time, '_SFC_All_Atlases.RData')
load( paste0(data_directory, '/',file_name ))



#create filler data with NAs. Filler between interictal and preictal (becasue they are not continuous)
filler =  rep(NA,  length(all_data_random_atlases$RA_N0010$ictal$mean$broadband) *0.80  )# X% of ictal length 

#Make colors
colors_interictal = '#cc0000'
colors_preictal = '#00cc00'
colors_ictal = '#0000cc'
colors_postictal = '#cc00cc'


colors = c(rep(colors_interictal, length(all_data_random_atlases$RA_N0010$interictal$mean$broadband)),
    rep('#000000', length(filler)),
    rep(colors_preictal, length(all_data_random_atlases$RA_N0010$preictal$mean$broadband)),
    rep(colors_ictal, length(all_data_random_atlases$RA_N0010$ictal$mean$broadband)),
    rep(colors_postictal, length(all_data_random_atlases$RA_N0010$postictal$mean$broadband)))

random_atlases=c('RA_N0010', 'RA_N0030', 'RA_N0050', 'RA_N0075','RA_N0100','RA_N0200','RA_N0300', 'RA_N0400', 'RA_N0500' , 'RA_N0750', 'RA_N1000', 'RA_N2000')
standard_atlases=c('aal_res-1x1x1', 'AAL600', 'CPAC200_res-1x1x1', 'desikan_res-1x1x1','DK_res-1x1x1','JHU_res-1x1x1',
          'Schaefer2018_100Parcels_17Networks_order_FSLMNI152_1mm', 'Schaefer2018_200Parcels_17Networks_order_FSLMNI152_1mm',
          'Schaefer2018_300Parcels_17Networks_order_FSLMNI152_1mm' , 'Schaefer2018_400Parcels_17Networks_order_FSLMNI152_1mm', 
          'Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_1mm', 'Talairach_res-1x1x1')

random_atlases_to_plot = c('RA_N0010', 'RA_N0030','RA_N0100','RA_N1000')
standard_atlases_to_plot = c('aal_res-1x1x1',  'CPAC200_res-1x1x1',
                             'Schaefer2018_100Parcels_17Networks_order_FSLMNI152_1mm','Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_1mm',
                             'JHU_res-1x1x1')

standard_atlases_legend = c('AAL', 'CPAC', 'Schaefer 100', 'Schaefer 1000','JHU')
random_atlases_legend = c('10', '30','100', '1000')
#########
#to caluclate moving average:
ma <- function(x, n = 10){filter(x, rep(1 / n, n), sides = 2)}
  




standard_atlas_colors = c(
  '#E61717E6',
  '#e6ad00E6',
  '#006400E6',
  '#178DE6E6',
  '#2F17E6E6'
)

#standard_atlas_colors = rainbow(length(standard_atlases_to_plot), s= 0.9,v=0.9,start = 0, end = 0.8, alpha = 0.9)
random_atlas_colors = rainbow(length(random_atlases_to_plot), s= 0.9,v=0.9,start = 0.65, end = 0.75, alpha = 0.9)




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
  
  
  
  preictal_x_start = length(c(all_data_random_atlases$RA_N0010$interictal$mean$broadband,filler))+1  
  preictal_x_end = preictal_x_start+length(all_data_random_atlases$RA_N0010$preictal$mean$broadband)
  ictal_x_start = preictal_x_end + 1
  ictal_x_end = ictal_x_start+length(all_data_standard_atlases[[atlas_index]]$ictal$broadband)
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
  
  
  
  
  
  
}

fname = paste0(output_directory, '/sub-', sub_ID, '_', iEEG_filename,  '_ICTAL_', ictal_start_time,".pdf")
pdf(fname , width = 7, height = 6)

par(new = F)

#plotting parameters

ylim = c(-0.1, 0.6)
standard_atlases_line_width = 3
random_atlases_line_width = 3
standard_atlas_colors_transparency = 'ff'
CI95_color = "#99999922"

mar_1 = 0
mar_2 = 5
mar_3 = 3
mar_4 = 2
par(mfrow = c(2,1))
mar = c(mar_1,mar_2,mar_3,mar_4)
par(mar =mar)

las = 1
font_legend = 3
cex_legend = 0.75
cex_main = 1
line_main = -1.0




#Standard Atlases
for (a in 1:length(standard_atlases_to_plot)){
  atlas_index = which(names(all_data_standard_atlases) == standard_atlases_to_plot[a])
  #create running mean (moving average, convolution)
  N = 20 #length of window
  data_interictal_broadband_movingAvg = ma(all_data_standard_atlases[[atlas_index]]$interictal$broadband, N)
  data_other_broadband_movingAvg = ma( c(all_data_standard_atlases[[atlas_index]]$preictal$broadband, 
                                         all_data_standard_atlases[[atlas_index]]$ictal$broadband, 
                                         all_data_standard_atlases[[atlas_index]]$postictal$broadband  ), N  )
  
  
  #Calculating pad for the running mean
  pad_data_interictal_broadband_movingAvg = length(which(is.na(data_interictal_broadband_movingAvg)))
  pad_data_other_broadband_movingAvg = length(which(is.na(data_other_broadband_movingAvg)))
  #removing NAs from the original moving average function
  data_interictal_broadband_movingAvg = data_interictal_broadband_movingAvg[!is.na(data_interictal_broadband_movingAvg)]
  data_other_broadband_movingAvg = data_other_broadband_movingAvg[!is.na(data_other_broadband_movingAvg)]
  
  data_interictal_broadband_movingAvg = c(  rep(NA, pad_data_interictal_broadband_movingAvg),data_interictal_broadband_movingAvg )
  data_other_broadband_movingAvg = c(  rep(NA, pad_data_other_broadband_movingAvg),data_other_broadband_movingAvg )
  
  
  
  
  
  #plotting
  y_moving_avg = c(data_interictal_broadband_movingAvg, filler, data_other_broadband_movingAvg) 
  data_length = length(y_moving_avg)
  x = c(1:data_length)
  xlim = c(0, data_length)
  
  if (a == 1){par(new = F)}
  if (a > 1){par(new = T)}
  plot(x, y_moving_avg, xlim = xlim, ylim = ylim, bty="n", type = "l", lwd = standard_atlases_line_width, 
       col = standard_atlas_colors[a], ylab = "", xlab = "", xaxt = 'n', las = las)
  par(xpd = F)
  abline(h = c(par("usr")[3]))
  
  interictal_x = c(0:length(data_interictal_broadband_movingAvg ))
  #text(  x = (length(data_interictal_broadband_movingAvg )+(length(data_interictal_broadband_movingAvg ) +length(filler) + pad_data_other_broadband_movingAvg))/2  ,  
  #       y = (data_interictal_broadband_movingAvg[length(data_interictal_broadband_movingAvg)] +
  #         data_other_broadband_movingAvg[pad_data_other_broadband_movingAvg+1])/2,
  #     labels = standard_atlases_legend[a],adj = c(0.5,0.5), font = 2, cex = cex_legend)
  text(  x = (length(data_interictal_broadband_movingAvg ) +length(filler) + pad_data_other_broadband_movingAvg)  ,  
         y = (data_other_broadband_movingAvg[pad_data_other_broadband_movingAvg+1]),
         labels = standard_atlases_legend[a],adj = c(1,0.5), font = font_legend, cex = cex_legend, offset = 0.4, pos = 2)
  #legend('bottom', legend = standard_atlases_legend, fill = standard_atlas_colors, bty = 'n', bg ='n',horiz = T,
  #       text.width=c(50,50,70,40,70), xpd = TRUE, x.intersp=0.3,
  #       xjust=0, yjust=0)
  #Adding 95% confidence intervals
  #interictal
  
}
add_siezure_colors(par("usr")[3])
title(main = "Standard", line = line_main, cex.main = cex_main, font.main = 1)

par(xpd = T)
mtext(text="Structure-Function Correlation",side=3,line=-1.7,outer=TRUE,cex=2, font = 4)
mtext(text=paste0("Standard vs Random Atlases"),side=3,line=-3,outer=TRUE, cex=1, font = 3)
      
      
mtext(text=paste0("sub-", sub_ID, '_', iEEG_filename,  '_ICTAL_', ictal_start_time),
      side=1,line=-1,outer=TRUE, cex=0.6, font = 1, at = c(0),adj = 0)

par(xpd = F)
#plotting parameters

mar_1 = 3
mar_3 = 0
mar = c(mar_1,mar_2,mar_3,mar_4)

par(mar =mar)




#Random Atlases
for (a in 1:length(random_atlases_to_plot)){
  atlas_index = which(names(all_data_random_atlases) == random_atlases_to_plot[a])
  #create running mean (moving average, convolution)
  N = 20 #length of window
  data_interictal_broadband_movingAvg = ma(all_data_random_atlases[[atlas_index]]$interictal$mean$broadband, N)
  data_interictal_broadband_movingAvg_CI95_upper = ma(all_data_random_atlases[[atlas_index]]$interictal$CI95_upper$broadband, N)
  data_interictal_broadband_movingAvg_CI95_lower = ma(all_data_random_atlases[[atlas_index]]$interictal$CI95_lower$broadband, N)
  
  data_other_broadband_movingAvg = ma( c(all_data_random_atlases[[atlas_index]]$preictal$mean$broadband, 
                                         all_data_random_atlases[[atlas_index]]$ictal$mean$broadband, 
                                         all_data_random_atlases[[atlas_index]]$postictal$mean$broadband  ), N  )
  data_other_broadband_movingAvg_CI95_upper = ma( c(all_data_random_atlases[[atlas_index]]$preictal$CI95_upper$broadband, 
                                                    all_data_random_atlases[[atlas_index]]$ictal$CI95_upper$broadband, 
                                                    all_data_random_atlases[[atlas_index]]$postictal$CI95_upper$broadband  ), N  )
  data_other_broadband_movingAvg_CI95_lower = ma( c(all_data_random_atlases[[atlas_index]]$preictal$CI95_lower$broadband, 
                                                    all_data_random_atlases[[atlas_index]]$ictal$CI95_lower$broadband, 
                                                    all_data_random_atlases[[atlas_index]]$postictal$CI95_lower$broadband  ), N  )
  
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
  x = c(1:data_length)

  
  
  
  
  if (a == 1){par(new = F)}
  if (a > 1){par(new = T)}
  plot(x, y_moving_avg, xlim = xlim, ylim = ylim, bty="n", type = "l", lwd = random_atlases_line_width, col = random_atlas_colors[a],
       las = las, xlab = "", ylab = "", xaxt = 'n')
  
  
  
  text(  x = (length(data_interictal_broadband_movingAvg ) +length(filler) + pad_data_other_broadband_movingAvg)  ,  
         y = (data_other_broadband_movingAvg[pad_data_other_broadband_movingAvg+1]),
         labels = random_atlases_legend[a],adj = c(1,0.5), font = font_legend, cex = cex_legend, offset = 0.4, pos = 2)
  #Adding 95% confidence intervals
  #interictal
  polygon(c(1:length(data_interictal_broadband_movingAvg_CI95_lower), rev(1:length(data_interictal_broadband_movingAvg_CI95_lower))), 
          c(data_interictal_broadband_movingAvg_CI95_lower, rev(data_interictal_broadband_movingAvg_CI95_upper)) ,
          border = CI95_color, col = CI95_color)
  #other
  polygon(  x = c((length(c(data_interictal_broadband_movingAvg,filler))+1):data_length, rev((length(c(data_interictal_broadband_movingAvg,filler))+1):data_length)), 
            y = c(data_other_broadband_movingAvg_CI95_lower, rev(data_other_broadband_movingAvg_CI95_upper)),
            border = CI95_color, col = CI95_color)
  
  

  
  
  
}
add_siezure_colors(ylim[1])

title(main = "Random", line = line_main, cex.main = cex_main, font.main = 1)

interictal_start = 0 
interictal_end = length(data_interictal_broadband_movingAvg )

preictal_x_start = length(c(data_interictal_broadband_movingAvg,filler))+1
preictal_x_end = preictal_x_start+length(all_data_standard_atlases[[atlas_index]]$preictal$broadband)
ictal_x_start = preictal_x_end + 1
ictal_x_end = ictal_x_start+length(all_data_standard_atlases[[atlas_index]]$ictal$broadband)
postictal_x_start = ictal_x_end + 1
postictal_x_end = length(y_moving_avg)

axis(1, at=c(preictal_x_start, ictal_x_start, ictal_x_end,postictal_x_end), 
     labels=c(preictal_x_start-ictal_x_start,0, ictal_x_end -ictal_x_start+1, ictal_x_end -ictal_x_start+1 +180 ), 
     pos=-0.1, lty=1, las=1, tck=-0.03, lwd = 2, font = 2)
axis(1, at=pad_data_interictal_broadband_movingAvg, 
     labels=c("~6 hrs before" ), 
     pos=-0.1, lty=1, las=1, tck=-0.03, lwd = 2, font = 2, adj = 1)

abline(h = -0.1, lwd = 2)

mtext(text="Spearman Rank Correlation",side=2,line=-2,outer=TRUE,cex=1.7)
mtext(text="Time (s)",side=1,line=-1,outer=TRUE,cex=1.7)



dev.off()


}