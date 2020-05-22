
data_directory = '/Users/andyrevell/mount/USERS/arevell/papers/paper001/data_processed/figure4_data'
output_directory ='/Users/andyrevell/mount/USERS/arevell/papers/paper001/paper001/figures/figure4'
setwd(data_directory)
library(ggplot2)
library(ggpubr)
library("cowplot")

#Random Atlases
data_random = read.csv("network_measures_random_atlases.csv", stringsAsFactors = F, header = T)
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


data_random_volumes = 
##########################################################################################################################################
#Small Worldness


plot_list = list()
for (i in 1:6){
  
  
  name = names[i]
  p<-ggplot(data_random, aes_string(x="Node", y=names(data_random)[order[i]] , group="subject")) +
    geom_point(aes(color=subject)) +
    stat_summary(fun.y=mean, geom="line", aes(color = subject)) + 
    theme_classic() +
    theme(legend.text=element_text(size=rel(rel))) +
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(axis.text=element_text(size=rel(rel),face="bold"),
          title=element_text(size=rel(rel),face="bold")) 
  
  plot_list[[i]] = p + ggtitle(name) + 
    xlab("Number of Nodes (N)") + ylab(name) 
}

for (i in 1:6) {
  fname = paste0(output_directory,"/network_measures_random_atlases_", fnames[i], ".pdf")
  pdf(fname, width = 10, height = 10)
  print(plot_list[[i]])
  dev.off()
}
