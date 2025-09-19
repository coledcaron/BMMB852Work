# Week 4 Homework Assignment

### Set up:
```
conda activate bioinfo
# Set up directory to store folders
mkdir week4data
cd week4data
# Download Zaire et al. 2014 Ebola Genome
datasets download genome accession GCF_000848505.1 --include genome,gff3,gtf
unzip -n ncbi_dataset.zip
mv ncbi_dataset/data/GCF_000848505.1/GCF_000848505.1_ViralProj14703_genomic.fna ebola_1976.fa
mv ncbi_dataset/data/GCF_000848505.1/genomic.gff ebola_1976.gff
```
This code is used to set up the environment, create a folder to store all the files associated with this analysis, and download the necessary FASTA and GFF files for this analysis. These files were also renamed for easier reference in future code.
### IGV Visualization of the Ebola Genome:
![IGV Visualization of the 1976 Zaire Ebola Genome](https://github.com/coledcaron/BMMB852Work/blob/main/Week_4/IGV_Screenshots/Ebola_IGV_Vis.jpg)
The annotations associated with zaire ebola virus were aligned to the genome sequence to visualize this dense assortment of features. 
### Question: How big is the Ebola genome, and how many features are there?
Length: <br>
The best way to find the length of the zaire ebola genome is by simply counting the nucleotides. An easy way to do this is to call the FASTA file of the genome, remove any header information with the ``` grep ``` command, remove the line breaks with ```tr```, and finally take the count of the characters remaining in the file with ```wc -m```.
```
cat ebola_1976.fa | grep -v ">" | tr -d '\n' | wc -m
```
Output: <br>
```
18959
```
This value represents the number of nucleotides in the ebola genome, which is approximately 19 kB.
Features: <br>

For the features, we turn to the GFF file, which lists all the different features associated with the ebola genome. From this, we excise the third column, which contains the names of each feature type, using the ```cut``` command. We then remove any excess information from the list uisng the ```grep -v``` command on ```#``` to remove any entries with this character. Finally, the list is checked for the number of entries using the ```wc -l``` command to print the number of lines in the list.

```
cat ebola_1976.gff | cut -f 3 | grep -v "#" | wc -l
```

Output: <br>
```
55
```
There are 55 total features in the genome of zaire ebola virus.

### Question: What is the longest gene in Ebola?
Since there are only seven genes in the zaire ebola genome, the simplest way to find out what the longest gene is would be to extract the start position, end position, and the identification for each gene and compare these values manually to see which is the longest.
```
cat ebola_1976.gff | grep "\tgene\t" | cut -f 4,5,9 | grep -v "#"
```
The code above pulls all entries with the word "gene" separated by tabs into one group, which is only the seven genes in ebola. From here, the 4th, 5th, and 9th columns (which represent the starting base, end base, and IDs) were extracted from the list. Finally, any comment text was removed using the ```grep -v``` command.<br>

Output: <br>
```
56	3026	ID=gene-ZEBOVgp1;Dbxref=GeneID:911830;Name=NP;gbkey=Gene;gene=NP;gene_biotype=protein_coding;locus_tag=ZEBOVgp1
3032	4407	ID=gene-ZEBOVgp2;Dbxref=GeneID:911827;Name=VP35;gbkey=Gene;gene=VP35;gene_biotype=protein_coding;locus_tag=ZEBOVgp2
4390	5894	ID=gene-ZEBOVgp3;Dbxref=GeneID:911825;Name=VP40;gbkey=Gene;gene=VP40;gene_biotype=protein_coding;locus_tag=ZEBOVgp3
5900	8305	ID=gene-ZEBOVgp4;Dbxref=GeneID:911829;Name=GP;gbkey=Gene;gene=GP;gene_biotype=protein_coding;locus_tag=ZEBOVgp4
8288	9740	ID=gene-ZEBOVgp5;Dbxref=GeneID:911826;Name=VP30;gbkey=Gene;gene=VP30;gene_biotype=protein_coding;locus_tag=ZEBOVgp5
9885	11518	ID=gene-ZEBOVgp6;Dbxref=GeneID:911828;Name=VP24;Note=putative;gbkey=Gene;gene=VP24;gene_biotype=protein_coding;locus_tag=ZEBOVgp6
11501	18282	ID=gene-ZEBOVgp7;Dbxref=GeneID:911824;Name=L;gbkey=Gene;gene=L;gene_biotype=protein_coding;locus_tag=ZEBOVgp7
```
Comparing each entry, the final gene, ZEBOVgp7, named "L", is by far the largest gene, with 6,781 bp.

### Question: What is the name and function of the longest Ebola gene and one other gene?

The gene known as L is labeled as an RNA-dependent RNA polymerase in many of the annotations associated with it. This protein in ebola is used to replicate the viral genome to produce more viruses, as well as make modifications to viral RNA to serve various purposes. <br>

Another protein, GP, is labeled as a spike glycoprotein. This protein is attached to the surface of the viral particle and serves as the connection point between virus and host cell during viral infiltration.

### Question: Using IGV, what is the approximate coverage of the genome with coding sequences?
To see how much of the genome is covered by coding sequences, we first need to make a new GFF file with only coding sequences in it. This was accomplished by using the ```grep``` command to look for entries tagged as CDS (coding sequence) in the GFF file, and adding the result to a new GFF file.
```
cat ebola_1976.gff | grep "\tCDS\t" > ebola_cds.gff
```
The resulting file could then be uploaded to IGV, showing the following:
![Coverage of Ebola CDS across the Genome](https://github.com/coledcaron/BMMB852Work/blob/main/Week_4/IGV_Screenshots/Ebola_IGV_CDScoverage.jpg)
Overall, the coverage of coding sequence accross the genome is pretty good, with only small gaps for regulatory and promoter sequences. The zaire ebola genome appears to be approximately 75% covered with coding sequences.

### Question: What other genome builds for zaire ebola virus are available, and what could they be used for?


In NCBI, there is a second assembly for zaire ebola virus submitted in 2015 from another outbreak of ebola in Sierra Leone (Accession GCA_900007085.1). This could be used as another reference source to see how the virus has mutated over time, which falls in line with the goals of the reference paper, which seeks to identify how ebola has evolved over time to cause the 2014 ebola outbreak. Additionally, another sequence based on a German imported Sierra Leone sample of zaire ebola is also available (Accession GCA_900094155.1) to serve as another point for how the sequence of ebola has mutated during the 2014 ebola outbreak. <br>

Other availabe genomes related to ebola are also available, such as Sudan ebolavirus (Accession GCF_000855585.1) and Reston ebolavirus (Accession GCA_031113305). These could be used to compare different strains of ebola to see how different mutations and polymorphisms may affect ebola virulence.
