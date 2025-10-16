# Week 7 Homework Assignment

## Set up:
```
mkdir week7data
cd week7data
conda activate bioinfo
```

This code creates a file to store all work for this assignment, as well as sets the environment for the provided Makefile.

------------------------------

## Download the Provided Makefile:

A makefile is provided with this assignment. The use of this makefile is to create a signle pipeline file to download ```.fasta```, ```.gff```, and ```.fastq``` files, creates a ```bwa``` index using the provided ```.fasta``` file, and aligns the ```.fastq``` file to the index to generate a ```.bam``` file and a ```.bw``` file for alignment visualization.

--------------------------------

## Makefile Options:

### help

```
make help
```

Provides in-terminal functions and usage for each option within the makefile.

### all

```
make all genome=<GCF_accession> fastq=<SRA_accession> genome_size=<genome_size_in_bp> coverage=<desired_coverage> read_length=<read_length_in_bp> sample=<sample_name>
```

Runs each option within the makefile, starting from downloading the needed ```fasta``` and ```fastq``` files and ending with aligning the collected reads to the genome to create a ```bam``` file and a ```bigwig``` file.

### get_genome

```
make get_genome genome=<GCF_accession> sample=<sample_name>
```

Using a provided NCBI genome accession number, downloads the ```.fasta``` and ```.gff``` file for the associated accession number, unzips the file, and moves these files to an alignment folder, renamed to a supplied sample name.

### get_fastq

```
make get_fastq fastq=<SRA_accession> genome_size=<genome_size_in_bp> coverage=<desired_coverage> read_length=<read_length_in_bp> sample=<sample_name>
```

After being provided the genome size, desired coverage, and length of a read, downloads a set number of reads from a provided ```fastq``` SRA accession number, provides a list of basic statistics, and runs FASTQC to assess the quality of the reads. All items are placed in the reads directory.

### index

```
make index sample=<sample_name>
```

Finds the ```fasta``` file bearing the sample name and creates an index using ```bwa``` indexing, and places them in an index directory.

### align

```
make align fastq=<SRA_accession> sample=<sample_name>
```

Aligns the targeted ```.fastq``` file to the indexes within the work file to generate a ```.bam``` file alignment for visualization and adds them to an alignments directory. Basic statistics are also calculated to determine the quality of the alignment.

### bigwig

```
make bigwig sample=<sample_name>
```

Finds the named ```bam``` file and converts it into a ```bigwig``` file, placed in the alignments folder.

------------------------------

## bam File Visualization for Zaire Ebolavirus (example)

### Option 1: Use the all option to run everything in one command

#### 1. Run the all function with each variable set
```
make all genome=GCF_000848505.1 fastq=SRR1553500 genome_size=18959 coverage=10 read_length=202 sample=ZEBV_illumina
```

#### 2. Visualize the bam file and bigwig file in on the Zaire Ebolavirus genome using IGV

![Zaire Ebolavirus IGV Alignment Overview](https://github.com/coledcaron/BMMB852Work/blob/main/Week_7/images/illumina_fastq_vis.jpg)

---------------------------------

### Option 2: Run each code option individually

#### 1. Download the Refseq for Zaire Ebolavirus
```
make get_genome genome=GCF_000848505.1 sample=ZEBV
```

#### 2. Download a number of reads to get 10x genome coverage of reads from an assoicated SRR accession file
```
make get_fastq genome_size=18959 coverage=10 read_length=202 fastq=SRR1553500 sample=ZEBV
```

#### 3. Index the genome
```
make index sample=ZEBV
```

#### 4. Align the Fastq file to the index to generate a bam file
```
make align fastq=SRR155350 sample=ZEBV
```

#### 5. Convert the bam file into a bigwig file
```
make bigwig sample=ZEBV
```

#### 6. Alignment of the .bam file to the Zaire Ebolavirus genome using IGV

![Zaire Ebolavirus IGV Alignment Overview](https://github.com/coledcaron/BMMB852Work/blob/main/Week_7/images/illumina_fastq_vis.jpg)

----------------------------

## Homework Questions:

### Visualize the GFF, BigWig, and BAM files generated for Zaire Ebolavirus from both Illumina and Nanopore instruments.

#### Illumina RNA-seq Visualization

```
make all genome=GCF_000848505.1 fastq=SRR1553500 genome_size=18959 coverage=10 read_length=202 sample=ZEBV_illumina
```

![Illumina RNA-seq BAM and BigWig Visualization](https://github.com/coledcaron/BMMB852Work/blob/main/Week_7/images/illumina_fastq_vis.jpg)

#### Nanopore RNA-seq Visualization

```
make all genome=GCF_000848505.1 fastq=SRR8959866 genome_size=18959 coverage=10 read_length=630 sample=ZEBV_nanopore
```

![Nanopore RNA-seq BAM and BigWig Visualization](https://github.com/coledcaron/BMMB852Work/blob/main/Week_7/images/nanopore_fastq_vis.jpg)

#### Combined Illumina and Nanopore Visualization

![Nanopore and Illumina RNA-seq Direct Visualization](https://github.com/coledcaron/BMMB852Work/blob/main/Week_7/images/Illumina_and_Nanopore_IGV_Visualization.jpg)


### Briefly describe the differences between the alignment in both files.

The Illumina RNA-seq alignment shows reads at almost every base pair, providing coverage to the entire genome. While there is some clumping of coverage, with a few high peaks across the genome, there is also consistent coverage across the length of the genome.

The Nanopore RNA-seq alignment shows a lot more clustering of reads into specific areas. When compared to the ```gff``` alignment, there appears to be no consistent pattern between read clusters and gene sections. A majority of the reads fall into about 14 regions, with little coverage outside of these areas. These could be areas that were more open during RNA-seq preparation that was then captured in the Nanopore.


### Briefly compare the statistics for the two BAM files.

The statistics for the Illumina and Nanopore RNA-seq are as follows:

##### Illumina RNA-seq Statistics
```
1960 + 0 in total (QC-passed reads + QC-failed reads)
1876 + 0 primary
0 + 0 secondary
84 + 0 supplementary
0 + 0 duplicates
0 + 0 primary duplicates
1926 + 0 mapped (98.27% : N/A)
1842 + 0 primary mapped (98.19% : N/A)
1876 + 0 paired in sequencing
938 + 0 read1
938 + 0 read2
1834 + 0 properly paired (97.76% : N/A)
1842 + 0 with itself and mate mapped
0 + 0 singletons (0.00% : N/A)
0 + 0 with mate mapped to a different chr
0 + 0 with mate mapped to a different chr (mapQ>=5)
```

##### Nanopore RNA-seq Statistics
```
398 + 0 in total (QC-passed reads + QC-failed reads)
300 + 0 primary
0 + 0 secondary
98 + 0 supplementary
0 + 0 duplicates
0 + 0 primary duplicates
382 + 0 mapped (95.98% : N/A)
284 + 0 primary mapped (94.67% : N/A)
0 + 0 paired in sequencing
0 + 0 read1
0 + 0 read2
0 + 0 properly paired (N/A : N/A)
0 + 0 with itself and mate mapped
0 + 0 singletons (N/A : N/A)
0 + 0 with mate mapped to a different chr
0 + 0 with mate mapped to a different chr (mapQ>=5)
```

Overall, the statistics between the Illumina and Nanopore RNA-seq appear to be very good. The total reads for Nanopore are a bit lower than Illumina RNA-seq, as the read length for Illumina is lower than Nanopore. Therefore, more reads are needed to reach the desired genome coverage.

Both sets of data mapped very well, with around 96% of reads mapping to the Zaire Ebolavirus genome. Illumina RNA-seq reads also paired very well, with 98% of reads being able to be paired to another. The Nanopore reads do not have paired reads, as this data was only single reads due to the length of reads that can be acquired through Nanopore RNA-seq. 


### How manhy primary alignments dows each of your BAM files contain?

The Illumina RNA-seq has 1,876 primary alignments, while the Nanopore RNA-seq has 300 primary alignments.


### What coordinate has the largest observed coverage?

Running the ```make align``` function of the program also produces a file listing the top twenty sites with the most coverage. 

For the Illumina RNA-seq data, the point with the most coverage is:
```
NC_002549.1	12187	25
```
This point falls near the beginning of protein L, which is the RNA-dependent RNA polymerase endcoded by Zaire Ebolavirus. This would make sense, as this region would want to be the most readily transcribed to make more polymerase to create more copies of the genome within its host, accelerating propagation.

For the Nanopore RNA-seq data, the points with the most coverage are:
```
NC_002549.1	9278	28
NC_002549.1	9279	28
NC_002549.1	9280	28
NC_002549.1	9281	28
NC_002549.1	9282	28
NC_002549.1	9283	28
NC_002549.1	9288	28
NC_002549.1	9289	28
NC_002549.1	9290	28
NC_002549.1	9291	28
NC_002549.1	9292	28
NC_002549.1	9294	28
NC_002549.1	9295	28
NC_002549.1	9296	28
NC_002549.1	9297	28
```
This region from 9278-9297 falls at the end of VP30, the transcription activator protien that helps initiate transcription / replication of the Zaire Ebolavirus genome.

### Select a gene of interest. How many alignments on a forward strand cover the gene?

For this, I decided to use the L protein gene, which is the RNA-depended RNA polymerase, as my gene of interest for this question.

```
samtools view -F 16 -c ZEBV_illumina/alignments/ZEBV_illumina_aligned_sorted.bam NC_002549.1:11501-18283
samtools view -F 16 -c ZEBV_nanopore/alignments/ZEBV_nanopore_aligned_sorted.bam NC_002549.1:11501-18283
```

The above commands take a ```bam``` file, filter it using the ```16``` flag, which marks strands as forward or reverse sequences, and counted all the entries between the 11501st and 18283rd base pairs in Zaire Ebolavirus, which correspond to the L protein sequence region.

When the following lines of code were ran, it returned that there were 429 aligning forward reads in the Illumina RNA-seq run, while there were 21 aligning forward reads in the Nanopore RNA-seq run. 
