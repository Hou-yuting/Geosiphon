#!/usr/bi/perl -w
###this file uses gff file from augustus and calculate stat, Author: Madhu

$file=$ARGV[0];
chomp $file;
@training_file= `cat $file`;
$min_gene_length=1000000;
$min_intron_length=1000000;
$min_CDS_length=1000000;
$sum_len_gene=0;
$sum_len_intron=0;
$sum_len_CDS=0;

foreach $line(@training_file){
	chomp $line;
	if($line=~/AUGUSTUS\tgene/)
	{
		my @gene= split("\t", $line);
		chomp $gene[3];
		chomp $gene[4];
		chomp $gene[0];
		$len_gene= ($gene[4]-$gene[3])+1;
		$max_gene_length = $max_gene_length < $len_gene ? $len_gene : $max_gene_length;
		$min_gene_length = $min_gene_length > $len_gene ? $len_gene : $min_gene_length;
		print "$gene[8] gene length $len_gene \n";
		$sum_len_gene +=$len_gene;
		$no_of_gene++;

	
             #print "$no_of_gene \n";
#	$avg_len_gene=$total_len_gene/$no_of_gene;
	}
	elsif($line=~/AUGUSTUS\tintron/)	
	{
		my @intron= split("\t", $line);
		chomp $intron[3];
		chomp $intron[4];
		$len_intron= ($intron[4]-$intron[3])+1;
		$max_intron_length = $max_intron_length < $len_intron ? $len_intron : $max_intron_length;
		$min_intron_length = $min_intron_length > $len_intron ? $len_intron : $min_intron_length;
		print "$intron[0] intron length $len_intron  \n";
		$sum_len_intron +=$len_intron;
		$no_of_intron++;
#	$avg_len_intron=$total_len_intron/$no_of_intron;
	}
	elsif($line=~/AUGUSTUS\tCDS/)
	{
		my @CDS= split("\t", $line);
		chomp $CDS[3];
		chomp $CDS[4];
		chomp $CDS[0];
		$len_CDS= ($CDS[4]-$CDS[3])+1;
		$max_CDS_length = $max_CDS_length < $len_CDS ? $len_CDS : $max_CDS_length;
		$min_CDS_length = $min_CDS_length > $len_CDS ? $len_CDS : $min_CDS_length;
		print "$CDS[0] CDS length $len_CDS $CDS[4]\n";
		$sum_len_CDS +=$len_CDS;
		$no_of_CDS++;
#	$avg_len_CDS=$total_len_CDS/$no_of_CDS;	
	}

}
	$avg_len_gene=$sum_len_gene/$no_of_gene;
	$avg_len_intron=$sum_len_intron/$no_of_intron;
	print "########gene $sum_len_gene\t$no_of_gene\n";
	print "########CDS	$sum_len_CDS\t$no_of_CDS\n";
	print "########intron $sum_len_intron\t$no_of_intron\n";
	$avg_len_CDS=$sum_len_CDS/$no_of_CDS;
	
	print " Average Gene Length= $avg_len_gene\nAverage cds Length = $avg_len_CDS\nAverage intron Length = $avg_len_intron\nMax gene Length= $max_gene_length\nMin gene Length= $min_gene_length\nMax intron Length= $max_intron_length\nMin intron Length= $min_intron_length\nMax CDS Length=$max_CDS_length\nMin CDS Length=$min_CDS_length\n";
