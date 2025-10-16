# Week 5 Homework Assignment:

### Set up:
```
#Set up directory to store command outputs
mkdir week5data
cd week5data
```

### Finding the BioProject and a SRR Accession Number:

In the paper "Genomic surveillance elucidates Ebola virus origin and transmission during the 2014 outbreak", the project number provided by the authors on NCBI is PRJNA257197. This links to a collection 891 SRA accessions. From this, I pulled a random SRR accession number, SRR1972941, for use in this assignment.

### Create Bash Scripts for Genome Download and Basic Assessment:

Based on the Week 4 assignment, I created the scripts ```get_genome.sh``` and ```genome_stats.sh```. These two scripts replicate the code used in the previous assignment, using variables for the accession numbers to provide more modularity of the code. 

```
bash get_genome.sh
```
```get_genome.sh``` uses a provided NCBI GCF accession number to download the FASTA and GFF files associated with the entry. It then works to unzip the files and rename them for ease of use in future coding applications.

```
bash genome_stats.sh
```
```genome_stats.sh``` takes the downloaded FASTA file and associated GFF file and determines the length of the genome, the number of annotated features, and the longest gene based on these inputs. These results are then outputted to a ```.txt``` file.

### Create a Bash Script for Downloading and Assessing a FASTQ File:

```get_fastq.sh``` is a script that uses a provided SRR accession number, along with a provided genome size, desired genome coverage, and read length to download a needed number of reads from a FASTQ file, runs some basic statistics on the download using ```seqkits``` to be outputted to a ```.txt``` file, and finally uses ```FASTQC``` to assess the quality of the FASTQ file.
```
bash get_fastq.sh
```
For this assignment, 10x genome coverage was desired to make a good assessment for the FASTQ quality. The amount of reads requried to get this coverage was estimated by multiplying the genome length by the coverage amount, then dividing by the length of a read. This value can then be provided to ```fastq-dump``` to download a subset of the data from the provided SRR accession number.

```
seqkit stats SRR1972941_1.fastq SRR1972941_2.fastq > SRR1972941_fastq_stats.txt
```

Since the SRR accession number referenced is a paired Illumina-seq run, two FASTQ files are present within the file, one for forward reads (SRR1972941_1.fastq) and one for reverse reads (SRR1972941_2.fastq).

#### Output:
```
file                      format  type  num_seqs  sum_len  min_len  avg_len  max_len
reads/SRR1972941_1.fastq  FASTQ   DNA        938   94,738      101      101      101
reads/SRR1972941_2.fastq  FASTQ   DNA        938   94,738      101      101      101
```
These files both have 938 reads, all of which are 101 base pairs in length. 

### FASTQ Quality Control:

To verify the quality of the FASTQ data, both files were assessed using FASTQC to assess read quality, base read quality, sequence homology, N count, overrepresentation, and adaptor content.

```
fastqc -o reads SRR1972941_1.fastq SRR1972941_2.fastq
```

Overall, the quality of the FASTQ data in this assignment is questionable. The per base sequence quality for both is pretty bad, with forward reads losing quality around the 70 bp mark, while reverse reads are highly variable in quality. This leaves the forward reads to have a sequence quality score around 25, while the reverse reads has an average quality around 1. Per base sequence count and GC content are variable, but fall within expected ranges.

Both N content and sequence length distribution are very good, with no N's being reported and no variance in sequence length away from 101 bp. Finally, while the revese reads look fine, the forward reads suffer from sequence overrepresentation.

### Comparing the Quality of Data from Varying Sequencing Platforms:

To compare the quality of RNA-seq platforms to each other, I found another set of Ziare ebolavirus RNA-seq data run on an Oxford Nanopore system to serve as a comparison to the original Illumina-seq data from this paper.
```
bash get_fastq_Nanopore.sh
```

When comparing Oxford Nanopore data quality to Illumina data quality, they come up to be pretty similar to each other. For the Nanopore sequences, the per base sequencing quality is pretty low for the first 700 bp, where most of the sequencing information is. This makes the sequence quality score pretty low, hovering around 12. N content and sequence length distribution are both pretty consistent, with zero reported N's and high distribution of reads around 650 bp, where the target read length resides. Additionally, there is no sequence duplication in this set of data, and there are no seuqnces labeled as overrepresented accross the data set.

Overall, while the Nanopore reads are longer than Illumina reads, when comparing these two data sources for Zaire ebolavirus, the quality of reads appears to be pretty similar, and overall of low to middling quality.
