# Trout-Bog
NifH gene screening.

About:
To measure nifH abundances we used merged (but unassembled reads from JGI/IMG) and two different approaches:  the first was aimed to compare all reads to genomes in IMG, including the MAGs from Trout Bog. The second  was based on comparing all reads to a database of nifH from many organisms (from Buckley lab). In both approaches we mapped (blasted) the reads to enumerate how many reads matched an annotated nitrogenase sequence. 
 

Requirements:
Perl libraries and R

1)   Enumeration of nifH genes using genomes in IMG:

Step 1:  Download a set of nitrogenase gene from IMG (reads classified as nitrogenase genes by comparison to Pfam, KO and COG databases (all these annotations were included in JGI/IMG))

Step 2: Blast the annotated nifH genes against MAGs and SAGs from Trout Bog to retrieve taxonomic information

Step 3: Blast again "no hit" annotated nitrogenase (after step 2) against the entire JGI/IMG collection of SAGs and MAGs 

Dowload the file with blast information....

Example: you can an example of the file in the folder lklllll

Step 4: Filter out: chlorophyllide reductase gene and select only nitrogenase gene taxonomic annotation following this criteria:  

Type in the command line:

for i in */missingGenes*; do sed -n 2p $i | grep -v chlorophyll | awk  -F "\t" '$11 < 1e-20  {print $0}' |  awk  -F "\t" '$8 > 95  {print $0}' ; done >> $i.potential_NIFH.output


missingGenes* is the downoladed blast output files from IMG with information about Pfam, KO and COG annotation systems

Step 5: 







