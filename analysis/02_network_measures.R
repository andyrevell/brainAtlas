setwd("/Users/andyrevell/Documents/20_papers/paper001_brainAtlasChoiceSFC/data")
library(ggplot2)
library(ggpubr)
library("cowplot")


data = read.csv("03_network_measures.csv", stringsAsFactors = F, header = T)
data = data.frame(data)
data$RID.SubID = as.factor(data$RID.SubID)
names(data)[which(names(data) == "RID.SubID")] = "subject"

rel=2

names = c("Characteristic Path Legnth", "Clustering Coefficient",
          "Degree",  "Small Worldness", "Normalized \nCharacteristic Path Length",
          "Normalized \nClustering Coefficient")
fnames = c("charPathLength",
           "clust", "degree", "smallWorldness", "NormPathLength", "NormClust")
order = c(4:9)
##########################################################################################################################################
#Small Worldness


plot_list = list()
for (i in 1:6){
  
  
  name = names[i]
  p<-ggplot(data, aes_string(x="Node", y=names(data)[order[i]] , group="subject")) +
    geom_point(aes(color=subject)) +
    stat_summary(fun.y=mean, geom="line", aes(color = subject)) + 
    theme_classic() +
    theme(legend.text=element_text(size=rel(rel), face="bold")) +
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(axis.text=element_text(size=rel(rel),face="bold"),
          title=element_text(size=rel(rel),face="bold")) 
  
  plot_list[[i]] = p + ggtitle(name) + 
    xlab("Number of Nodes (N)") + ylab(name) 
}

for (i in 1:6) {
  fname = paste0("../figures/networkMeasures_", fnames[i])
  pdf(fname, width = 10, height = 10)
  print(plot_list[[i]])
  dev.off()
}
