library(ggplot2)
library(dplyr)
library(cowplot)
library(gridExtra)

df <- read.csv("transposon_3col.csv")

data <- read_csv("df.csv")
data$percentage <- (data$genes_overlap/data$Total_genes)
data$labels <- c("G. pyriformis","G. rosea","D. versiformis","R. cerebriforme","R. irregularis",
                 "R. microsporus","P. blakesleeanus","M. elongata","M. circinelloides")
data$percent_labels <- format(round(data$percentage,2),nsmall=2)
data$percent_labels <- sub("^","%",data$percent_labels)

g1 <- ggplot(df, aes(x=Species, y = TE, size = Number, color = Species)) +
  geom_point(alpha=0.7) +
  scale_size(range = c(5,35))+
  geom_text(data = df, aes(x= Species, y = TE, label=Number),
            color="white", size= 3, inherit.aes = F) +
  scale_x_discrete(labels=c("D. versiformis","G. pyriformis","G. rosea","M. elongata","M. circinelloides",
                            "P. blakesleeanus","R. irregularis","R. cerebriforme","R. microsporus")) +
  scale_y_discrete(labels = c('CACTA','Crypton','DDE1','gypsy','hAT','Helitron','ISa','ISC1316','LINE','roo',
                              'TC1/mariner','Ant1','MuDR','P','piggyBac','Ty1-copia'))+
  labs(x="", y= "Number of TEs overlapping with genes\n") +
  theme_minimal() +
  theme(
    legend.position = "none",
    axis.line = element_blank(),
    axis.ticks = element_blank(),
    axis.text.x = element_text(angle = 90,face = 'italic', size = 10))

p <- ggplot(data, aes(x= labels, y = percentage)) +
  geom_col(aes(fill=labels), width = 0.75, alpha =0.7) +
  scale_y_continuous(labels = scales::percent) +
  theme_classic()+
  theme(
    legend.position = "none",
    axis.line = element_blank(),
    axis.ticks = element_blank(),
    axis.text.x = element_blank(),
    axis.title.x = element_blank(),
    axis.text.y = element_text(size = 8.5),
    axis.title.y = element_text(size = 9.5),
    plot.margin = unit(c(0.7, 0.1, 0.1, 0.1), "cm"))+
  labs(x=NULL,y="Percentage of\nProtein Coding\nGenes Overlapping\nwith TEs")+
  theme(legend.position = "none")
#coord_flip()

aligned_plots <- align_plots(p,g1, align = "v", axis = "b")
grid.arrange(grobs = aligned_plots,nrow =2, heights = c(1,5))