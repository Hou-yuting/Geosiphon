#creating the index files for the assembled genome
#bwa index filtered_after_removing_contamination.fasta
#map assembled genome to the paired end reads
#bwa mem -M -t 5 filtered_after_removing_contamination.fasta /media/madhu/WDR10T1/madhu/filtered_PE_geo_R1.fastq /media/madhu/WDR10T1/madhu/filtered_PE_geo_R2.fastq > Geo_paired.sam
#bwa mem -M -t 5 filtered_after_removing_contamination.fasta /media/madhu/WDR10T1/madhu/out_MP1_reads1.fastq /media/madhu/WDR10T1/madhu/out_MP2_reads2.fastq > Geo_matepair.sam
##convert sam file into sorted bam file
#../samtools-1.9/samtools view -b Geo_paired.sam | ../samtools-1.9/samtools sort > Geo_sorted_PE.bam
#../samtools-1.9/samtools view -b Geo_matepair.sam | ../samtools-1.9/samtools sort > Geo_sorted_MP.bam
#merging the sorted bam files and creating bam index
#../samtools-1.9/samtools merge merged_Geo.bam Geo_sorted_PE.bam Geo_sorted_MP.bam
#../samtools-1.9/samtools index merged_Geo.bam
##call SNPs using freebayes
#freebayes -f filtered_after_removing_contamination.fasta --ploidy 1  -m 20 -K -C 2 merged_Geo.bam > geo_p1.vcf
##calculate average coverage from bam file
#samtools depth  merged_Geo.bam |  awk '{sum+=$3} END { print "Average = ",sum/NR}'
##now filtering on a basis of + or - 25 from calculated average coverage
#/home/madhu/vcflib/bin/vcffilter -f "DP < 143.9" geo_p1.vcf > DP_filtered_P1.vcf
#/home/madhu/vcflib/bin/vcffilter -f "DP > 93.9" DP_filtered_P1.vcf > 2DP_filtered_P1.vcf
##filter by number of alternative alleles
#/home/madhu/vcflib/bin/vcffilter -f "NUMALT =1" 2DP_filtered_P1.vcf > 2DP_filtered_P1_NUMALT.vcf
##filtering the indels and here considering only the SNPs
#/home/madhu/vcflib/bin/vcffilter -f "TYPE =snp" 2DP_filtered_P1_NUMALT.vcf > 2DP_filtered_P1_NUMALT_snp.vcf
##extract only the count of reference and alternate allele
#/usr/local/bin/vcf-query -f '\t%INFO/RO\t%INFO/AO\n' 2DP_filtered_P1_NUMALT_snp.vcf > Geo_P1.tab
##output tab file in R
cut -f 2-5 Geo_P1.tab > Geo_P1_plot.tab
###this is for the purpose of looking into SNPs with scaffold names and stuff [ this is optional]
#/usr/local/bin/vcf-query -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO/RO\t%INFO/AO\n' 2DP_filtered_P1_NUMALT_snp.vcf > Output_test1.tab
