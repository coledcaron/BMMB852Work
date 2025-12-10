## Week 14 Homework Assignment

### Introduction

The provided Makefile provides a program that downloads data from an input source, aligns the RNA seq data to the genome, creates a bigwig file to easily visualize the genome, and create a counts matrix that associates each gene in all provided fastq files to each other for easier comparison.

This analysis seeks to use the Human chromosome 22 and cancer fastq files to align RNA transcripts to find any changes in expression between total RNA and cancer cell RNA. After visualization, a counts matrix of each human gene is created to relate overall transcript abundance to each other sample. 

As of now, there is no normalization present in this program, so all conclusions derived by transcript counts must be verified against the total transcript count.

### Single Sample Program Usage

```
make all SAMPLE=HBR_1 DATA_URL=http://data.biostarhandbook.com/data/uhr-hbr.tar.gz OUTPUT=Hsapiens
```

This code is optimized for 1-sample runs to be run in a one command set-up. Providing the data, output name, and sample name generates indexes, ```.bam``` alignments, ```.bw``` visualizations, and a counts matrix for the input file.

### Processing multiple files at once

This pipeline is used to process multiple files to create a single count matrix for all samples. This allows for easier comparison between samples.

#### Step 1. Design file setup
```
sample,group
HBR_1,HBR
HBR_2,HBR
HBR_3,HBR
UHR_1,UHR
UHR_2,UHR
UHR_3,UHR
```

This layout for sample and group name is referenced throughout the program for use in various processes. This file should be a ```.csv``` file and created prior to running the program.

#### Step 2. Initialization
```
make get_data index DATA_URL=http://data.biostarhandbook.com/data/uhr-hbr.tar.gz OUTPUT=Hsapiens
```

This downloads the required data and sets up the indexes needed to run other processes. As these indexes are needed for each sample, they are created once and referenced in subsequent steps.

#### Step 3. Run alignment and bigwig conversion in parallel
```
cat design.csv | parallel --colsep , --header : -j 6 make align bigwig SAMPLE={sample} OUTPUT=Hsapiens
```

This aligns and creates bigwig files for each sample in the design file.

#### Step 4. Combine all files into a final count matrix and analyze the resulting file.
```
make counts analysis OUTPUT=Hsapiens
```


This code runs the remaining step to merge each ```.bam``` file into a single count matrix with gene names. It then runs a series of analyses to determine differentially expressed genes, create a PCA plot and heatmap, and determine functional expression analysis.

### RNA-seq Confirmation Using IGV Visualization

![RNA Sequencing Data Visualization 1](https://github.com/coledcaron/BMMB852Work/blob/main/Week_13/igv_images/RNA_seq_ver1.jpg)

![RNA Sequencing Data Visualization 2](https://github.com/coledcaron/BMMB852Work/blob/main/Week_13/igv_images/RNA_seq_ver2.jpg)

Above are two examples of the IGV Visualization from one of the samples (HBR_1) analyzed. To confirm that this data is RNA-seq data, reads from the ```.fastq``` files should best align to exons within the genome sequence. In both of the two above examples, sequence alignments are most contained to exonic regions, with minimal alignments to regions outside of exons. Therefore, this confirms that the input data analyzed is RNA-seq data.

### Count Matrix Discussion

From the count matrix, I found a few genes of interest that have similar read counts relative to their overall library depth. Some of these genes are listed below:

```
name	gene	HBR_1	HBR_2	HBR_3	UHR_1	UHR_2	UHR_3
ENSG00000177663.13	IL17RA	60	66	62	102	73	93
ENSG00000070371.15	CLTCL1	39	45	38	118	67	88
ENSG00000099942.12	CRKL	353	429	374	776	490	636
ENSG00000185651.14	UBE2L3	218	256	203	527	333	376
```

![IL17RA IGV Visualization](https://github.com/coledcaron/BMMB852Work/blob/main/Week_13/igv_images/IL17RA.jpg)

IL17RA shows a fair bit of noise within the sequence alignment due to the low read count associated within this gene. It is also surprising that the maximum reads are relatively low across the gene, despite reads for this gene being reported to be above 60 reads. Looking at genes with higher reads may remove some of this noise and discrepancy.

![CLTCL1 IGV Visualization](https://github.com/coledcaron/BMMB852Work/blob/main/Week_13/igv_images/CLTCL1.jpg)

CLTCL1 follows a similar trend, with a low read count resulting in a lot of visual noise in IGV. The highly fragmented exons of this gene makes IGV visualization more difficult as well.

![CRKL IGV Visualization](https://github.com/coledcaron/BMMB852Work/blob/main/Week_13/igv_images/CRKL.jpg)

CRKL has a high overall read count, which can be seen clearly in the IGV visualization. While there is some intermediate background noise, this gene forms three distinct exon regions that closely align to the exons in the known gene. This is a clear example that this is RNA-seq data.

![UBE2L3 IGV Visualization](https://github.com/coledcaron/BMMB852Work/blob/main/Week_13/igv_images/UBE2L3.jpg)

UBE2L3 also has a strong read count, and contains three exon regions with high read counts, with a little background reads throughout the whole sequence.
