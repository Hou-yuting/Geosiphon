##command line used for doing pfam analysis
perl /shared/programs/PfamScan/pfam_scan.pl -fasta orfs.fa -dir /shared/programs/PfamScan > pfam_out
##commandline used for eggnog analysis
python /shared/programs/eggnog-mapper/emapper.py -i orfs_merged_trinity.fa --override --output Trinitymerged_annotation.txt -d fuNOG  --cpu 15
##commandline for doing diamond blast analysis
/shared/programs/diamond-0.9.14/diamond blastp -d /shared/programs/diamond-0.9.14/refseq -o blast_res -q final_protein.fa -f 0  -k 1 -e 1e-5
####command line used for running fastortho analysis
./FastOrtho --option_file options.txt
##mafft commandline [ L-INS-i] model was used
./msa.sh
##concatenating the alignment
/home/madhu/catfasta2phyml/catfasta2phyml.pl .out* > all_alignment.out
###trimal command line 
/home/madhu/trimal/source/trimal -in all_alignment.aln -strict -automated1 -phylip  -out all_scp_trimalout.phy -gt 0.9
###constructing iqtree
/home/madhu/iqtree-1.6.12-Linux/bin/iqtree -nt AUTO -s all_scp_trimalout.phy -m TEST -alrt 1000 -b 1000 -pre all_scp_trimalout
##cafe commandline
./cafexp -t new_mod_scp-test -i ../Geosiphon/filtered_cafe_input.txt -p -o testlambda
