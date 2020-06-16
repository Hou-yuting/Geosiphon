#/shared/programs/CONCOCT/scripts/cut_up_fasta.py meta_genome_geosiphon_out/contigs.fasta -c 10000 -o 0 --merge_last -b contigs_10k.bed >  contigs_10k.fa
#/shared/programs/CONCOCT/scripts/concoct_coverage_table.py contigs_10k.bed merged_Geosiphon.bam > coverage_table.tsv
#/shared/programs/CONCOCT/bin/concoct --composition_file contigs_10k.fa --threads 5 --coverage_file coverage_table.tsv -b concoct_output/
#/shared/programs/CONCOCT/scripts/merge_cutup_clustering.py concoct_output/clustering_gt1000.csv > concoct_output/clustering_merged.csv
/shared/programs/CONCOCT/scripts/extract_fasta_bins.py meta_genome_geosiphon_out/contigs.fasta concoct_output/clustering_merged.csv --output_path concoct_output/fasta_bins
