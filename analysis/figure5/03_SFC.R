setwd("/Users/andyrevell/Documents/20_papers/paper001_brainAtlasChoiceSFC/data")
library("ggplot2")
library("ggpubr")
library("cowplot")
library("reshape2")
library("RColorBrewer")

data = read.csv("04_SFC_nodes.csv", stringsAsFactors = F, header = T)
data = data.frame(data)

data = melt(data, id="Sizes")
names(data)[2] = "Frequency"
#colors =  paste0(colorRampPalette(c("#0000ff", "#990099"))(5), "ff")
colors =  paste0(colorRampPalette(  c("#ff0000", "#0000ff")   )(5), "cc")

rel = 2
p<-ggplot(data, aes(x=Sizes, y=value, group = Frequency, color = Frequency)) + 
  
  geom_point(aes(color=Frequency),size = 2.5) +
  geom_line(size = 1.5) +
  scale_colour_manual("Frequency",values=colors[c(3,1,2,4,5)],breaks=c("Broad","Alpha", "Beta", "Low.Gam", "High.Gam"), labels=c("Broad","Alpha", "Beta", "Low.Gam", "High.Gam"))+

  ylim(c(-0.5, 0.5))+
  theme_classic() +
  theme(legend.text=element_text(size=rel(rel), face="bold")) +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text=element_text(size=rel(rel),face="bold"),
        title=element_text(size=rel(rel),face="bold"))

fname = paste0("../figures/SFC_nodes.pdf")
pdf(fname, width = 10, height = 10)
p + ggtitle("Structure-Function Correlation") + 
  xlab("Number of Nodes (N)") + ylab("Structure-Function Correlation")  +
  theme(legend.position = c(0.8, 0.5)) 
dev.off()


