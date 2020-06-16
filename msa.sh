for filename in seq*.fa
do
 mafft --localpair --maxiterate 1000 $filename > $filename_aln.out
done  


