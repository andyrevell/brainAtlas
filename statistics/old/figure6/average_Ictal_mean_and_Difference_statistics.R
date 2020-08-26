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
  
  #dev.off(dev.list()["RStudioGD"])
  fname = paste0(output_plot_path, 'average_Ictal_mean_and_Difference_Figure6', ".pdf")

  load(average_Ictal_data_path)
  
  means_random_atlases$broadband$`sub-RID0194_HUP134_phaseII_D02_ICTAL_179302933433`
  difference_random_atlases$broadband
  

  
    
  frequency_names = names(means_random_atlases)
  frequency_names =c("Broadband", "Alpha/Theta", "Beta", "Low Gamma", 
                    "High Gamma")
    
  random_atlases=c('RA_N0010', 'RA_N0030', 'RA_N0050', 'RA_N0075','RA_N0100','RA_N0200','RA_N0300', 'RA_N0400', 'RA_N0500' , 'RA_N0750', 'RA_N1000', 'RA_N2000')
  standard_atlases=c('aal_res-1x1x1', 'AAL600', 'CPAC200_res-1x1x1', 'desikan_res-1x1x1','DK_res-1x1x1','JHU_res-1x1x1',
                     'Schaefer2018_100Parcels_17Networks_order_FSLMNI152_1mm', 'Schaefer2018_200Parcels_17Networks_order_FSLMNI152_1mm',
                     'Schaefer2018_300Parcels_17Networks_order_FSLMNI152_1mm' , 'Schaefer2018_400Parcels_17Networks_order_FSLMNI152_1mm', 
                     'Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_1mm', 'Talairach_res-1x1x1','JHU_aal_combined_res-1x1x1')
  
  random_atlases_to_plot = c('RA_N0010', 'RA_N0030', 'RA_N0050', 'RA_N0075','RA_N0100','RA_N0200','RA_N0300', 'RA_N0400', 'RA_N0500' , 'RA_N0750', 'RA_N1000', 'RA_N2000')
  standard_atlases_to_plot = c('aal_res-1x1x1', 'AAL600', 'CPAC200_res-1x1x1', 'desikan_res-1x1x1','DK_res-1x1x1',
                               'Schaefer2018_100Parcels_17Networks_order_FSLMNI152_1mm', 'Schaefer2018_200Parcels_17Networks_order_FSLMNI152_1mm',
                               'Schaefer2018_300Parcels_17Networks_order_FSLMNI152_1mm' , 'Schaefer2018_400Parcels_17Networks_order_FSLMNI152_1mm', 
                               'Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_1mm', 'Talairach_res-1x1x1','JHU_aal_combined_res-1x1x1')
  
  standard_atlases_legend = c('AAL', 'AAL600', 'CPAC', 'Desikan', 'DKT','JHU', 'Schaefer 100','Schaefer 200','Schaefer 300','Schaefer 400', 'Schaefer 1000','Talairach')
  random_atlases_legend = c('10', '30', '50', '75','100','200','300', '400', '500' , '750', '1000', '2000')
  
  
  
  standard_volumes_index = c(1:15)
  random_volumes_index = c(16:28)
  data_standard_volumes = read.csv(paste0(volumes_path), stringsAsFactors = F, header = F)[standard_volumes_index,]
  data_random_volumes = read.csv(paste0(volumes_path), stringsAsFactors = F, header = F)[random_volumes_index,]
  

  #separating bootstrap by patients
  event_names = names(difference_random_atlases$broadband)
  sub = substring(event_names, 1,11)

  
  INDEX_FREQ = c(1:length(frequency_names))
  f = 1 #broadband

  library(mgcv)
  library(ggplot2)
 #simulate boostrap
  total_vol = 10^3.226126 * 1000
  bootstrap_results_mean = c()
  bootstrap_results_mean_max = c()
  N = 1000
  for (i in 1:N){
  
    #separating bootstrap by patients
    number_of_patients = length(unique(sub))
    bootstrap = means_random_atlases
    patients_bootstrap = sample(1:number_of_patients, number_of_patients, replace = T)
    #separating bootstrap by patients
    unique(sub)[patients_bootstrap]
    index = c()
    for (z in 1:length(patients_bootstrap)){
      index = c(index, which( sub ==  unique(sub)[patients_bootstrap[z]]    )  )
      
    }
 
    for (b in 1:length(bootstrap)){
      bootstrap[[b]] = means_random_atlases[[b]][,index]
    }

    #Random Atlases MEANS
    vols = c()
    for (a in 1:length(random_atlases_to_plot)){
      atlas_index_means = which(row.names(bootstrap[[f]]  ) == random_atlases_to_plot[a])
      volume = data_random_volumes[which(row.names(bootstrap[[f]])[atlas_index_means] == data_random_volumes$V1),2]
      vols = c(vols, volume)
  
    }
    

    
    x = rep(vols, length(index))
    y = as.vector((unlist(bootstrap$broadband)))
    all_names = names(unlist(bootstrap$broadband))
    
    seizures=sub('\\..*', '', all_names)
    df = data.frame("volumes" = x, "mean" = y)
    
    df = cbind(df, seizures)
    
    GAM = F
    GAMM= F
    MEAN= T
    
    PLOT= F
    
    if (GAM){
      model = gam(mean ~ s(volumes) , data = df)
      volumes_new = data.frame("volumes"=seq(min(vols),max(vols),0.001))
      predicted_data = predict(model,newdata = volumes_new, se.fit=T)
      max = volumes_new[which(predicted_data$fit == max(predicted_data$fit))[1],1   ]
      
      
      df2 = data.frame(volumes_new,
                       ymin = predicted_data$fit-1.96*predicted_data$se.fit,
                       ymax = predicted_data$fit+1.96*predicted_data$se.fit) 
      names(df2) = c("new", "ymin", "ymax")
      if (PLOT){
        ggplot(data=df , aes(volumes, y) ) + geom_point(aes(colour=factor(seizures))) + theme(legend.position = "none") +
          geom_ribbon(data = df2, aes(x = new,ymin=ymin,
                                      ymax=ymax), alpha=0.7, fill="gray", inherit.aes = FALSE) +
          geom_line(data = data.frame( volumes_new,predicted_data$se.fit ),aes(x = volumes ,y=predicted_data$fit), col="black", lwd=1)+
          ggtitle("Ictal Mean: Bootstrapping and Plotting GAM") +
          xlab("Volume (voxels log10)") + ylab("Ictal Means") 
        ggsave(filename = paste0("ictal_mean_GAM_",i,".png"))
        
      }
      
    }
    if (GAMM){
      model = gamm(mean ~ s(volumes) , data = df, random=list( seizures = ~1))
      volumes_new = data.frame("volumes"=seq(min(vols),max(vols),0.001))
      predicted_data = predict(model$gam,newdata = volumes_new, se.fit=T)
      max = volumes_new[which(predicted_data$fit == max(predicted_data$fit))[1],1   ]
      
      
      df2 = data.frame(volumes_new,
                       ymin = predicted_data$fit-1.96*predicted_data$se.fit,
                       ymax = predicted_data$fit+1.96*predicted_data$se.fit) 
      names(df2) = c("new", "ymin", "ymax")
      if (PLOT){
        ggplot(data=df , aes(volumes, y) ) + geom_point(aes(colour=factor(seizures))) + theme(legend.position = "none") +
          geom_ribbon(data = df2, aes(x = new,ymin=ymin,
                                      ymax=ymax), alpha=0.7, fill="gray", inherit.aes = FALSE) +
          geom_line(data = data.frame( volumes_new,predicted_data$se.fit ),aes(x = volumes ,y=predicted_data$fit), col="#000099", lwd=1)+
          ggtitle("Ictal Mean: Bootstrapping and Plotting GAMM") +
          xlab("Volume (voxels log10)") + ylab("Ictal Means") 
        ggsave(filename = paste0("ictal_mean_GAMM_",i,".png"))
      }
      
    }
    
    if (MEAN){
      atlas_means =rowMeans(bootstrap$broadband)
      max = vols[which(atlas_means == max(atlas_means))    ]
      
      
      x = rep(vols, length(index))
      y = as.vector((unlist(bootstrap$broadband)))
      all_names = names(unlist(bootstrap$broadband))
      
      seizures=sub('\\..*', '', all_names)
      df = data.frame("volumes" = x, "mean" = y)
      
      df = cbind(df, seizures)
      
      if (PLOT){
        ggplot(df , aes(volumes, mean) ) + geom_point(aes(colour=factor(seizures)))  + theme(legend.position = "none")+
          stat_summary(geom="ribbon", fun.data=mean_cl_normal, fill="#99999944")+
          stat_summary(aes(y = mean,group=1), fun.y=mean, colour="black", geom="line",group=1)+
          stat_summary(geom="point", fun.y=mean, color="black") +
          ggtitle("Ictal Mean: Bootstrapping and Plotting Means") +
          xlab("Volume (voxels log10)") + ylab("Ictal Means")
        ggsave(filename = paste0("ictal_mean_MEAN_",i,".png"))
      }
    }
    
    bootstrap_results_mean_max = c(bootstrap_results_mean_max, max)
    print(paste0(i, " ", round(total_vol / (10^max) )) )
    
    
    
   
    
  }
  
  
  bootstrap_vol_mean = mean(na.omit(bootstrap_results_mean_max))
  bootstrap_vol_sd = sd(na.omit(bootstrap_results_mean_max))
  
  st_error = bootstrap_vol_sd*qt(.975,df=N-1)/sqrt(N)
  bootstrap_vol_CI95_upper =  bootstrap_vol_mean + st_error
  bootstrap_vol_CI95_lower =  bootstrap_vol_mean - st_error
  
  
  total_vol = 10^3.226126 * 1000
  parcellations_mean = total_vol / (10^bootstrap_vol_mean)
  
  parcellations_CI95_upper = total_vol / (10^bootstrap_vol_CI95_upper)
  parcellations_CI95_lower = total_vol / (10^bootstrap_vol_CI95_lower)
  
  cat(paste0("mean parcellations: ", round(parcellations_mean), "\n95% CI: ",round(parcellations_CI95_upper), " to ", round(parcellations_CI95_lower) ))
  cat(paste0("mean volume: ", round(10^bootstrap_vol_mean), "\n95% CI: ",round(10^bootstrap_vol_CI95_lower), " to ", round(10^bootstrap_vol_CI95_upper)  ))
  cat(paste0("mean volume: ", bootstrap_vol_mean, "\n95% CI: ",bootstrap_vol_CI95_lower, " to ", bootstrap_vol_CI95_upper ))
  
  
  
  
  
  
  
  
  
  
  
  #simulate boostrap
  bootstrap_results_difference = c()
  N = 1000
  for (i in 1:N){
    
    #separating bootstrap by patients
    number_of_patients = length(unique(sub))
    bootstrap = difference_random_atlases
    patients_bootstrap = sample(1:number_of_patients, number_of_patients, replace = T)
    #separating bootstrap by patients
    unique(sub)[patients_bootstrap]
    index = c()
    for (z in 1:length(patients_bootstrap)){
      index = c(index, which( sub ==  unique(sub)[patients_bootstrap[z]]    )  )
      
    }
    
    for (b in 1:length(bootstrap)){
      bootstrap[[b]] = difference_random_atlases[[b]][,index]
    }
    
    
      
    total_vol = 10^3.226126 * 1000

    #Random Atlases DIFFERENCE
    vols = c()
    for (a in 1:length(random_atlases_to_plot)){
      atlas_index_difference = which(row.names(bootstrap[[f]]  ) == random_atlases_to_plot[a])
      volume = data_random_volumes[which(row.names(bootstrap[[f]])[atlas_index_difference] == data_random_volumes$V1),2]
      vols = c(vols, volume)
    }
    x = rep(vols, length(index))
    y = as.vector((unlist(bootstrap$broadband)))
    all_names = names(unlist(bootstrap$broadband))

    seizures=sub('\\..*', '', all_names)
    df = data.frame("volumes" = x, "difference" = y)
    
    df = cbind(df, seizures)

    
    GAM = T
    GAMM= F
    MEAN= F
    
    PLOT= F
    
    if (GAM){
      model = gam(difference ~ s(volumes) , data = df)
      volumes_new = data.frame("volumes"=seq(min(vols),max(vols),0.001))
      predicted_data = predict(model,newdata = volumes_new, se.fit=T)
      max = volumes_new[which(predicted_data$fit == max(predicted_data$fit))[1],1   ]
      
      
      df2 = data.frame(volumes_new,
                       ymin = predicted_data$fit-1.96*predicted_data$se.fit,
                       ymax = predicted_data$fit+1.96*predicted_data$se.fit) 
      names(df2) = c("new", "ymin", "ymax")
      if (PLOT){
        ggplot(data=df , aes(volumes, y) ) + geom_point(aes(colour=factor(seizures))) + theme(legend.position = "none") +
          geom_ribbon(data = df2, aes(x = new,ymin=ymin,
                                      ymax=ymax), alpha=0.7, fill="gray", inherit.aes = FALSE) +
          geom_line(data = data.frame( volumes_new,predicted_data$se.fit ),aes(x = volumes ,y=predicted_data$fit), col="black", lwd=1)+
          ggtitle("Preictal-Ictal Difference: Bootstrapping and Plotting GAM") +
          xlab("Volume (voxels log10)") + ylab("Preictal-Ictal Difference") 
        ggsave(filename = paste0("difference_GAM_",i,".png"))
        
      }
      
    }
    if (GAMM){
      model = gamm(difference ~ s(volumes) , data = df, random=list( seizures = ~1))
      volumes_new = data.frame("volumes"=seq(min(vols),max(vols),0.001))
      predicted_data = predict(model$gam,newdata = volumes_new, se.fit=T)
      max = volumes_new[which(predicted_data$fit == max(predicted_data$fit))[1],1   ]
      
      
      df2 = data.frame(volumes_new,
                       ymin = predicted_data$fit-1.96*predicted_data$se.fit,
                       ymax = predicted_data$fit+1.96*predicted_data$se.fit) 
      names(df2) = c("new", "ymin", "ymax")
      if (PLOT){
        ggplot(data=df , aes(volumes, y) ) + geom_point(aes(colour=factor(seizures))) + theme(legend.position = "none") +
          geom_ribbon(data = df2, aes(x = new,ymin=ymin,
                                      ymax=ymax), alpha=0.7, fill="gray", inherit.aes = FALSE) +
          geom_line(data = data.frame( volumes_new,predicted_data$se.fit ),aes(x = volumes ,y=predicted_data$fit), col="#000099", lwd=1)+
          ggtitle("Preictal-Ictal Difference: Bootstrapping and Plotting GAMM") +
          xlab("Volume (voxels log10)") + ylab("Preictal-Ictal Difference") 
        ggsave(filename = paste0("difference_GAMM_",i,".png"))
      }
      
    }
    
    if (MEAN){
      atlas_means =rowMeans(bootstrap$broadband)
      max = vols[which(atlas_means == max(atlas_means))    ]
      
      
      x = rep(vols, length(index))
      y = as.vector((unlist(bootstrap$broadband)))
      all_names = names(unlist(bootstrap$broadband))
      
      seizures=sub('\\..*', '', all_names)
      df = data.frame("volumes" = x, "mean" = y)
      
      df = cbind(df, seizures)
      
      if (PLOT){
        ggplot(df , aes(volumes, mean) ) + geom_point(aes(colour=factor(seizures)))  + theme(legend.position = "none")+
          stat_summary(geom="ribbon", fun.data=mean_cl_normal, fill="#99999944")+
          stat_summary(aes(y = mean,group=1), fun.y=mean, colour="black", geom="line",group=1)+
          stat_summary(geom="point", fun.y=mean, color="black") +
          ggtitle("Preictal-Ictal Difference: Bootstrapping and Plotting Means") +
          xlab("Volume (voxels log10)") + ylab("Preictal-Ictal Difference")
        ggsave(filename = paste0("difference_MEAN_",i,".png"))
      }
    }
    
    
    
    
    
    
    
    # #model = gam(difference ~ s(volumes) , data = df)
    # 
    # model = gamm(difference ~ s(volumes) , data = df, random=list( seizures = ~1))
    # 
    # 
    # 
    # volumes_new = data.frame("volumes"=seq(min(vols),max(vols),0.001))
    # predicted_data = predict(model$gam,newdata = volumes_new, se.fit=T)
    # 
    # max = volumes_new[which(predicted_data$fit == max(predicted_data$fit))[1],1   ]
    # #ggplot(df , aes(volumes, difference) ) + geom_point(aes(colour=factor(seizures))) + stat_smooth(method = gam, formula = y ~ s(x)) + theme(legend.position = "none")
    # 
    # 
    # 
    # df2 = data.frame(volumes_new,
    #                   ymin = predicted_data$fit-1.96*predicted_data$se.fit,
    #                   ymax = predicted_data$fit+1.96*predicted_data$se.fit) 
    # names(df2) = c("new", "ymin", "ymax")
    # if (F){
    # ggplot(data=df , aes(volumes, y) ) + geom_point(aes(colour=factor(seizures))) + theme(legend.position = "none") +
    #   geom_ribbon(data = df2, aes(x = new,ymin=ymin,
    #                   ymax=ymax), alpha=0.7, fill="gray", inherit.aes = FALSE) +
    #   geom_line(data = data.frame( volumes_new,predicted_data$se.fit ),aes(x = volumes ,y=predicted_data$fit), col="black", lwd=1) 
    # }
    bootstrap_results_difference = c(bootstrap_results_difference, max)
    print(paste0(i, " ", round(total_vol / (10^max) )) )
  }
  
  
  bootstrap_vol_mean = mean(bootstrap_results_difference)
  bootstrap_vol_sd = sd(bootstrap_results_difference)

  st_error = bootstrap_vol_sd*qt(.975,df=N-1)/sqrt(N)
  bootstrap_vol_CI95_upper =  bootstrap_vol_mean + st_error
  bootstrap_vol_CI95_lower =  bootstrap_vol_mean - st_error
  

  total_vol = 10^3.226126 * 1000
  parcellations_mean = total_vol / (10^bootstrap_vol_mean)
  
  parcellations_CI95_upper = total_vol / (10^bootstrap_vol_CI95_upper)
  parcellations_CI95_lower = total_vol / (10^bootstrap_vol_CI95_lower)
  

  cat(paste0("mean parcellations: ", round(parcellations_mean), "\n95% CI: ",round(parcellations_CI95_upper), " to ", round(parcellations_CI95_lower) ))
  cat(paste0("mean volume: ", round(10^bootstrap_vol_mean), "\n95% CI: ",round(10^bootstrap_vol_CI95_lower), " to ", round(10^bootstrap_vol_CI95_upper)  ))
  cat(paste0("mean volume: ", bootstrap_vol_mean, "\n95% CI: ",bootstrap_vol_CI95_lower, " to ", bootstrap_vol_CI95_upper ))
  
  
  
  
  
  
  
  
  
  
  
  
  #power calculation
  library(pwr)
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

  }
  
  means_all
  standard_dev
  standard_atlases_to_plot

  
  mean_AAL = means_all[1]
  mean_AAL600 = means_all[2]
  
  std_AAL = standard_dev[1]
  std_AAL600 = standard_dev[2]
  
  mean_AAL/std_AAL
  mean_AAL600/std_AAL600
  
  powers = c()
  for (i in 1:length(standard_atlases_to_plot)){
    pwrs = pwr.t.test(d = means_all[i]/standard_dev[i], n= NULL, sig.level = 0.05/length(standard_atlases_to_plot), power = 0.8, type = "paired")$n
    powers = c(powers, pwrs)
  }
  
  powers[6]/powers[5]
  
  matrix(data = c(standard_atlases_to_plot,powers), ncol = 2)
