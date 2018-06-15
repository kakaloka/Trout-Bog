# Trout-Bog
## NifH gene screening.

## About:
To measure nifH abundances we used merged (but unassembled reads from JGI/IMG) and two different approaches:  the first was aimed to compare all reads to genomes in IMG, including the MAGs from Trout Bog. The second was based on comparing all reads against a database of nifH from many organisms (from Buckley lab). In both approaches, we mapped (blasted) the reads to enumerate how many reads matched an annotated nitrogenase sequence. 
 

## Requirements:
- Perl, R and very basic knowledge of shell scripting.
- [Blast](https://blast.ncbi.nlm.nih.gov/Blast.cgi)
- [Prinseq](https://sourceforge.net/projects/prinseq/files/)
- [Megan] 

## 1) Enumeration of nifH genes using genomes in IMG:

**Step 1**:  Download a set of nitrogenase gene from IMG (reads classified as nitrogenase genes by comparison to Pfam, KO and COG databases (all these annotations were included in JGI/IMG))

**Step 2**: Blast the annotated nifH genes against MAGs and SAGs from Trout Bog to retrieve taxonomic information

**Step 3**: Blast again "no hit" annotated nitrogenase (after step 2) against the entire JGI/IMG collection of SAGs and MAGs 

Download the files with blast information from JGI/IMG. You can find all the files downloaded from JGI in the folder [IMG_analysis](./IMG_analysis.tar.gz) included in this repository (the files are named missingGenes* and are organized into folders (per sample) and the folder name represent the sample code., e.g, IHUZ, IHXY .....).

**Step 4**: Filter out: chlorophyllide reductase gene contamination and select only nitrogenase gene taxonomic annotation following this criteria: e-value < 10-20 and a percentage of identity > 95%

Type in the command line:

```shell
for i in */missingGenes*; do sed -n 2p $i | grep -v chlorophyll | awk  -F "\t" '$11 < 1e-20  {print $0}' |  awk  -F "\t" '$8 > 95  {print $0}' > $i.potential_NIFH; done
```

missingGenes* are the downloaded blast output files from IMG with information about Pfam, KO, COG and taxonomical annotation.

**Step 5**: nifH gene phylotypes enrichment calculation. Before this step is important to make a file with potential nifH per sample (concatenate all files with the extension .potential_nifH, see examples in the sample folders included in [IMG_analysis](./IMG_analysis.tar.gz)) 

```shell
for i in IMG_analysis/*/*potential_NIFH; do perl perl_script_to_get_taxonomy_abundances.pl info_and_taxo.csv $i $i.output; done 
```
Where (*)potential_NIFH are the output of the step 4, [info_and_taxo.csv](./info_and_taxo.csv) is the taxonomical mapping file and i.output are the output of the script [perl_script_to_get_taxonomy_abundances.pl](./perl_script_to_get_taxonomy_abundances.pl)

```shell
for i in IMG_analysis/*/*potential_NIFH.output ; do awk -F ";" '{print $2}' $i | sort | uniq -c > $i.count; done 

```
Where i.count will be the files with the nifH phylotypes abundances per sample. You can find an example of this files in the folder [IMG_analysis_output](./IMG_analysis_output.tar.gz)

**Step 6**: Printing a matrix suitable for data visualization (e.g., R). Notice here you need to create first a file listing all the nifH phylotype identified (example of file: [list_all_phyla_found_uniq](./list_all_phyla_found_uniq)

```shell
for i in *.count ; do echo $i; perl create_OTU_file_per_sample.pl list_all_phyla_found_uniq $i ; done >> phyla_count

```
oprtional sort sample per sample date:
```shell
perl sort_samples_per_date.pl <file_with_the_sorted_list> <phyla_count>

```

**Data visualization**

Some example of R code can be found in the file [Chapter4.Rhistory](./Chapter4.Rhistory) (example: barplot, NMDS plot)


## 2) Enumeration of nifH using a nitrogenase gene database ("in house pipeline")

**Step 1**: Convert the sequences downloaded from JGI site from fastq to fasta (corresponding to the metagenomic samples from hypolimnion and epilimnion in Trout Bog)

Example of command:

```shell
perl prinseq-lite-0.20.4/prinseq-lite.pl -fastq <input_file> -out_format 1 -out_good <output> 

```

**Step 2**:  BLASTN (e-value <= 10-20) and performed searches using a nifH sequence database available at the [Buckley Lab website](https://blogs.cornell.edu/buckley/nifh-sequence-database/)

```shell
blastn -query <.fasta_file> -db nifH_database_2012.fasta -outfmt 6 -evalue <1x10-20> -out <blast.output_file> 

```
**Step 3**:  Obtain the fasta file only with nifH gene sequences 


