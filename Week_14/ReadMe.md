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

### RNA-seq Results

Using the generated counts matrix, differential expression for each gene was calculated. The resulting differential expression analysis was used as a baseline to generate a heatmap, PCA, and functional analysis for the differentially expressed genes.

#### Differentially Expressed Genes

Differential expression was determined using the ```edger``` package. This program removes genes with low read counts, compares the read counts for each gene for changes in expression, and runs statistical analysis to determine significance.

```
# Input: 1371 rows
# Removed: 1004 rows
# Fitted: 367 rows
# Significant PVal:  299 ( 81.50 %)
# Significant FDRs:  291 ( 79.30 %)
```

Of the 1,371 input genes, only 26.8% of genes met the threshold to be included in analysis. Of the 367 genes that passed initial fitting, 299 genes exhibit significant p-values and 291 genes exhibit significant false discovery rates. Therefore, about 20% of genes exhibit significant differential expression from the initial input.

#### Heatmap

![Heatmap of differentially expressed genes](https://github.com/coledcaron/BMMB852Work/blob/main/Week_14/images/Heatmap.jpg)

This heatmap of the differentially expressed genes in HBR and UHR shows that there are strong differences in the expression profiles for each tissue type. Very few genes in this analysis show signs of mixed expression between the tissue types, with highly consistent expression across all replicates.

#### Principal Component Analysis

![PCA plot of differentially expressed genes](https://github.com/coledcaron/BMMB852Work/blob/main/Week_14/images/PCA.jpg)

This principal component analysis shows that these two tissue types are very polarized from each other. Most of the variance between samples is described by the first principal component, which wholly separates the HBR and UHR samples. This analysis shows that these two tissue types are very dissimilar from each other, with no overlap associated with the two groups.

#### Functional Analysis

```
# Found 366 functions
```

When looking through the genes for functional enrichment analysis, 366 enriched phenotypes were found from the two tissue types. The top 15 functions were taken from that output and placed below.

```
cellular response to nutrient levels
regulation of single stranded viral RNA replication via double stranded DNA intermediate
DNA cytosine deamination
transport
single stranded viral RNA replication via double stranded DNA intermediate
protein targeting to mitochondrion
DNA deamination
cellular response to starvation
viral RNA genome replication
establishment of localization
response to starvation
localization
negative regulation of single stranded viral RNA replication via double stranded DNA intermediate
macromolecule localization
cytidine to uridine editing
```

Of these highest enriched functions, many of these functions are related to viral RNA, such as viral RNA replication and cytidine to uridine editing. A few of the functions are related to cell survival, such as cellular response to nutrient levels, transport, cellular response to starvation, and response to starvation. These functions would be congruent with cancer cell lines, which would be altering survival gene expression to improve tumor survival. Finally, a few functions are linked to broad processes, such as transport, localization, and macromolecule localization. As these are broad categories, it is hard to say what may be causing these functions to be enriched.
