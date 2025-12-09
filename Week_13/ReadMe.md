## Week 13 Homework Assignment

### Single Sample

```
make all SAMPLE=HBR_1 DATA_URL=http://data.biostarhandbook.com/data/uhr-hbr.tar.gz OUTPUT=Hsapiens
```

This code is optimized for 1-sample runs to be run in a one command set-up. Providing the data, output name, and sample name generates indexes, ```.bam``` alignments, ```.bw``` visualizations, and a counts matrix for the input file.

### Processing multiple files at once

#### 1. Design file setup
```
sample,group
HBR_1,HBR
HBR_2,HBR
HBR_3,HBR
UHR_1,UHR
UHR_2,UHR
UHR_3,UHR
```

#### 2. Initialization
```
make get_data index DATA_URL=http://data.biostarhandbook.com/data/uhr-hbr.tar.gz OUTPUT=Hsapiens
```

#### 3. Run alignment and bigwig conversion in parallel
```
cat design.csv | parallel --colsep , --header : -j 6 make align bigwig SAMPLE={sample} OUTPUT=Hsapiens
```

#### 4. Combine all files into a final count matrix
```
make counts OUTPUT=Hsapiens
```

### RNA-seq Confirmation Using IGV Visualization

### Count Matrix Discussion
