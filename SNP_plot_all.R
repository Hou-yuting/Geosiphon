# Goal: Produce SNP distribution plot
#   Input: Tab file from VCFtools
#   Output: Figure describing distribution
# Date Created: 2018-01-09
#      Updated: 2018-05-29
#
# Description: Reads in .tab files generated from VCFtools. The VCFtools command is
#   "vcf-query -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO/RO\t%INFO/AO\n' Input.vcf > Output.tab
#   This script will generate "Figure 1", which is the composite 4-panel of A1, A4, A5, SL1


rm(list= ls())


# Input files

tab_A1 <- read.table(file ='Geo_P1_plot.tab', 
                     sep='\t', header = FALSE)

# Libraries
library(ggplot2)

# Functions
number_ticks <- function(n) {function(limits) pretty(limits, n)}
Get_Num_Bins <- function(data_vector){
  ## Obsolete, keeping for record
  myhist   <- hist(data_vector, breaks=20, plot=FALSE)
  new.data <- as.data.frame(myhist$counts)
  new.data$bin <- myhist$bin
  #new.data$bin <- labels_v2
  return(new.data)
}

Generate_XY_func <- function(t_in, isolate_type, plot_order, species) {
  # Description:
  #   Given a tab_in file, generate df containing xy pairing (x=ref, y=alt).
  t_ref <- (as.numeric(t_in$V1) / (as.numeric(t_in$V1) + as.numeric(t_in$V2))) * 100
  t_alt <- (as.numeric(t_in$V2) / (as.numeric(t_in$V1) + as.numeric(t_in$V2))) * 100
  t_xy <- as.data.frame(c(t_ref, t_alt))
  names(t_xy)[1] <- "val"
  #t_xy <- Get_Num_Bins(t_xy$val)
  t_xy$id <- as.character(isolate_type) 
  t_xy$plot_order <- as.factor(plot_order)
  t_xy$species <- as.factor(species)
  names(t_xy)[1] <- "val"
  return(t_xy)
}


# Loading and creating data
A1_d <- Generate_XY_func(tab_A1, "Geosiphon", 'Homokaryon', 'G. pyriformis')


final <- (A1_d)

#final <- rbind(AEHK_d, A1_d, A4_d, A5_d)
#final$plot_order <- factor(final$plot_order, levels=c('Heterokaryon', 'Homokaryon', 'Unknown')) # Set to show homokaryons first
#final$plot_order <- factor(final$plot_order, levels=c('Homokaryon', 'Heterokaryon', 'Unknown')) # Set to show homokaryons first

# Plotting
ggplot(data=final, aes(x=val, fill=species)) + geom_histogram( binwidth = 5, colour="black") + xlab("SNP Frequency (%)") + 
  #xlim(0,100) + 
  facet_wrap(plot_order~id, nrow = 2, strip.position = "bottom") + ylab("Count") +
  theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(), strip.background = element_blank(),
                     panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"),
                     legend.text = element_text(face = "italic")) + 
  geom_vline(aes(xintercept=mean(val)), colour="royalblue", linetype="dashed") +
  geom_density(aes(y=5*..count..), alpha=0.1) +
  scale_x_continuous(breaks= c(25, 50, 75), limits= c(0,100))
