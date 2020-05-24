setwd("/Users/andyrevell/Documents/20_papers/paper001_brainAtlasChoiceSFC/data")
library(ggplot2)
library(ggpubr)
library("cowplot")


data_volumes = read.csv("01_atlas_volumes.csv", stringsAsFactors = F, header = T)
data_sphericity = read.csv("02_atlas_sphericity.csv", stringsAsFactors = F, header = T)
standard_major_atlas_index = c(1,3)
random_atlas_index = c(2,4,5,6)


#formatting data structures

#turning data into list and removing NAs
data_list_volumes = list()
for (i in 1:ncol(data_volumes)){data_list_volumes[[i]] = data_volumes[!is.na(data_volumes[,i]),i]}
data_list_sphericity = list()
for (i in 1:ncol(data_sphericity)){data_list_sphericity[[i]] = data_sphericity[!is.na(data_sphericity[,i]),i]}

#Calculating means
mean_volumes = lapply(data_list_volumes, mean)
mean_sphericity = lapply(data_list_sphericity, mean)



#stats
names(data_list_volumes) = names(data_volumes)
names(data_list_sphericity) = names(data_sphericity)
names(data_list_volumes)

#Bonferroni correction:
#multiplying by 24 because of 24 t tests being done
t.test(data_list_sphericity$N.850, data_list_sphericity$N.1000, conf.level=0.95)$p.val*24#Not Significant
t.test(data_list_sphericity$N.850, data_list_sphericity$N.5000, conf.level=0.95)$p.val*24
t.test(data_list_sphericity$N.1000, data_list_sphericity$N.5000, conf.level=0.95)$p.val*24

t.test(data_list_sphericity$AAL600, data_list_sphericity$N.850, conf.level=0.95)$p.val*24##significant
t.test(data_list_sphericity$AAL600, data_list_sphericity$N.1000, conf.level=0.95)$p.val*24##
t.test(data_list_sphericity$AAL600, data_list_sphericity$N.5000, conf.level=0.95)$p.val*24##

t.test(data_list_sphericity$AAL, data_list_sphericity$N.850, conf.level=0.95)$p.val*24##
t.test(data_list_sphericity$AAL, data_list_sphericity$N.1000, conf.level=0.95)$p.val*24##
t.test(data_list_sphericity$AAL, data_list_sphericity$N.5000, conf.level=0.95)$p.val*24##

t.test(data_list_sphericity$JHU, data_list_sphericity$N.850, conf.level=0.95)$p.val*24##
t.test(data_list_sphericity$JHU, data_list_sphericity$N.1000, conf.level=0.95)$p.val*24##
t.test(data_list_sphericity$JHU, data_list_sphericity$N.5000, conf.level=0.95)$p.val*24##







t.test(data_list_volumes$N.850, data_list_volumes$N.1000, conf.level=0.95)$p.val*24##
t.test(data_list_volumes$N.850, data_list_volumes$N.5000, conf.level=0.95)$p.val*24##
t.test(data_list_volumes$N.1000, data_list_volumes$N.5000, conf.level=0.95)$p.val*24##

t.test(data_list_volumes$AAL600, data_list_volumes$N.850, conf.level=0.95)$p.val*24#Not significant
t.test(data_list_volumes$AAL600, data_list_volumes$N.1000, conf.level=0.95)$p.val*24##
t.test(data_list_volumes$AAL600, data_list_volumes$N.5000, conf.level=0.95)$p.val*24##

t.test(data_list_volumes$AAL, data_list_volumes$N.850, conf.level=0.95)$p.val*24##
t.test(data_list_volumes$AAL, data_list_volumes$N.1000, conf.level=0.95)$p.val*24##
t.test(data_list_volumes$AAL, data_list_volumes$N.5000, conf.level=0.95)$p.val*24##

t.test(data_list_volumes$JHU, data_list_volumes$N.850, conf.level=0.95)$p.val*24##
t.test(data_list_volumes$JHU, data_list_volumes$N.1000, conf.level=0.95)$p.val*24##
t.test(data_list_volumes$JHU, data_list_volumes$N.5000, conf.level=0.95)$p.val*24##



