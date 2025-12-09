## Week 13 Homework Assignment

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

#### Step 3. Run alignment and bigwig conversion in parallel
```
cat design.csv | parallel --colsep , --header : -j 6 make align bigwig SAMPLE={sample} OUTPUT=Hsapiens
```

#### Step 4. Combine all files into a final count matrix
```
make counts OUTPUT=Hsapiens
```

### RNA-seq Confirmation Using IGV Visualization

### Count Matrix Discussion
