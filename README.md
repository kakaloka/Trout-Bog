# Trout-Bog
## NifH gene screening.

## About:
To measure nifH abundances we used merged (but unassembled reads from JGI/IMG) and two different approaches:  the first was aimed to compare all reads to genomes in IMG, including the MAGs from Trout Bog. The second was based on comparing all reads against a database of nifH from many organisms (from Buckley lab). In both approaches, we mapped (blasted) the reads to enumerate how many reads matched an annotated nitrogenase sequence. 
 

## Requirements:
Perl, R and very basic knowledge of shell scripting.

## 1) Enumeration of nifH genes using genomes in IMG:

**Step 1**:  Download a set of nitrogenase gene from IMG (reads classified as nitrogenase genes by comparison to Pfam, KO and COG databases (all these annotations were included in JGI/IMG))

**Step 2**: Blast the annotated nifH genes against MAGs and SAGs from Trout Bog to retrieve taxonomic information

**Step 3**: Blast again "no hit" annotated nitrogenase (after step 2) against the entire JGI/IMG collection of SAGs and MAGs 

Download the files with blast information from JGI/IMG. You can find all the files downloaded from JGI in the folder IMG_analysis included in this repository (the files are named missingGenes* and are organized into folders (per sample) and the folder name represent the sample code., e.g, IHUZ, IHXY .....).

**Step 4**: Filter out: chlorophyllide reductase gene and select only nitrogenase gene taxonomic annotation following this criteria: e-value < 10-20 and a percentage of identity > 95%

Type in the command line:

```shell
for i in */missingGenes*; do sed -n 2p $i | grep -v chlorophyll | awk  -F "\t" '$11 < 1e-20  {print $0}' |  awk  -F "\t" '$8 > 95  {print $0}' ; done >> $i.potential_NIFH.output
```

missingGenes* are the downloaded blast output files from IMG with information about Pfam, KO, COG and taxonomical annotation.

**Step 5**: nifH gene phylotypes enrichment calculation

```shell
for i in IMG_analysis/*/*potential_NIFH; do perl perl_script_to_get_taxonomy_abundances.pl info_and_taxo.csv $i $i.output; done 
```
Where (*)potential_NIFH are the output of the step 4, info_and_taxo.csv is the taxonomical mapping file and i.output are the output of the script perl_script_to_get_taxonomy_abundances.pl

```shell
for i in IMG_analysis/*/*potential_NIFH.output ; do awk -F ";" '{print $2}' $i | sort | uniq -c > $i.count; done 

```
where i.count will be the files with the nifH phylotypes abundances per sample. You can find an example of this files in the folder IMG_analysis_output


