# Trout-Bog
## NifH gene screening.

## About:
To measure nifH abundances we used merged (but unassembled reads from JGI/IMG) and two different approaches:  the first was aimed to compare all reads to genomes in IMG, including the MAGs from Trout Bog. The second was based on comparing all reads against a database of nifH from many organisms (from Buckley lab). In both approaches, we mapped (blasted) the reads to enumerate how many reads matched an annotated nitrogenase sequence. 
 

## Requirements:
- Perl, R and very basic knowledge of shell scripting.
- [Blast](https://blast.ncbi.nlm.nih.gov/Blast.cgi)
- [Prinseq](https://sourceforge.net/projects/prinseq/files/)
- [Megan](http://ab.inf.uni-tuebingen.de/software/megan/)

## 1) Enumeration of nifH genes using genomes in IMG:

**Step 1**:  Download a set of nitrogenase gene from IMG (reads classified as nitrogenase genes by comparison to Pfam, KO and COG databases (all these annotations were included in JGI/IMG)) See the file: IMG_downloads_and analysis.pdf

**Step 2**: Blast the annotated nifH genes against MAGs and SAGs from Trout Bog to retrieve taxonomic information

**Step 3**: Blast again "no hit" annotated nitrogenase (after step 2) against the entire JGI/IMG collection of SAGs and MAGs 

Download the files with blast information from JGI/IMG. You can find all the files downloaded from JGI in the folder [IMG_analysis](./IMG_analysis.tar.gz) included in this repository (the files are named missingGenes* and are organized into folders (per sample) and the folder name represent the sample code., e.g, IHUZ, IHXY .....).

**Step 4**: Filter out: chlorophyllide reductase gene contamination and select only nitrogenase gene taxonomic annotation following this criteria: e-value < 10-20 and a percentage of identity > 95%

Type in the command line:

```shell
for i in */missingGenes*; do sed -n 2p $i | grep -v chlorophyll | awk  -F "\t" '$11 < 1e-20  {print $0}' |  awk  -F "\t" '$8 > 95  {print $0}' > $i.potential_NIFH; done
```

missingGenes* are the downloaded blast output files from IMG with information about Pfam, KO, COG and taxonomical annotation.

**Step 5**: nifH gene phylotypes enrichment calculation. Before this step is important to make a file with potential nifH per sample (concatenate all files with the extension .potential_nifH, see examples in the sample folders included in  [IMG_analysis](./IMG_analysis.tar.gz))

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

Some example of R code can be found in the file [Barplot_and_NMDSplot.Rhistory](./Barplot_and_NMDSplot.Rhistory) (example: barplot, NMDS plot) and the Figure 3 scripts are in the file [Figure3_ABCD_troutbog2.Rhistory](./Figure3_ABCD_troutbog2.Rhistory)


## 2) Enumeration of nifH using a nitrogenase gene database ("in house pipeline")

see [Figure1:Pipeline](./Fig1_pipeline_troutbog_nifh.eps)

**Step 1**: Convert the sequences downloaded from JGI site from fastq to fasta (corresponding to the metagenomic samples from hypolimnion and epilimnion in Trout Bog)

Example of command:

```shell
perl prinseq-lite-0.20.4/prinseq-lite.pl -fastq <input_file> -out_format 1 -out_good <output> 

```

**Step 2**:  BLASTN (e-value <= 10-20) and performed searches using a nifH sequence database available at the [Buckley Lab website](https://blogs.cornell.edu/buckley/nifh-sequence-database/)

```shell
blastn -query <.fasta_file> -db nifH_database_2012.fasta -outfmt 6 -evalue 1x10-20 -out <blast.output_file> 

```
**Step 3** Creating the file containing the id of the reads identified as nifH. Example : [trout_bog_blasted_file_example](./nifH_blasted_files.tar.gz)

```shell
for i in <dir_with_the_blastout_files> ; do awk  -F "\t" '$3 >= 95 {print $1}' | sort | uniq > $i.95cutoff.name ; done
```


**Step 4**:  Obtain the fasta file only with nifH gene sequences using the script [get_NifH_fasta.pl](./get_NifH_fasta.pl)


```shell
perl get_NifH_fasta.pl <genes_ID> <fasta_file> <output> 
```
**Step 5**:  Fasta files with nifH sequences can be analised using Megan. For instance, taxonomic assignment, check of contaminants etc. 


## 3) 16S rRNA gene analysis using metagenomic data ("in house pipeline")

**Step 1**:  Format the RDP database (in our case we used realease11_2_Bacteria_unaligned.fa). Then, delete first column of the database prior to format. After we have obtained the file column_RDP.fasta, then we formatted column_RDP.fasta using makedb.

**Step 2**:  Blast the fasta files against the formatted database
Blast command example:

```shell
blastn -query <fasta_files> -db  column_RDP.fasta -outfmt 6 -evalue 1x10-20 -out <blastout_file>
```
 **Step 4**: Next steps are implemented in the script [get_OTU.sh](./get_OTU.sh). The script get_OTU.sh requiere [APIPE](./SourceCodeV1.zip) (RDP Classifier 2.4 (Wanget al.,January 2012)). An example of output files can be found in the directory [OTU_RDP_files.tar.gz](./OTU_RDP_files.tar.gz)
