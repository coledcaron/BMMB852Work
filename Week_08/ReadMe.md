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
make all genome=<GCF_accession> fastq=<SRA_accession> genome_size=<genome_size_in_bp> coverage=<desired_coverage> read_length=<read_length_in_bp> sample=<sample_name> output_dir=<output_directory>
```

Runs each option within the makefile, starting from downloading the needed ```fasta``` and ```fastq``` files and ending with aligning the collected reads to the genome to create a ```bam``` file and a ```bigwig``` file.

### get_genome

```
make get_genome genome=<GCF_accession> sample=<sample_name> output_dir=<output_directory>
```

Using a provided NCBI genome accession number, downloads the ```.fasta``` and ```.gff``` file for the associated accession number, unzips the file, and moves these files to an alignment folder, renamed to a supplied sample name.

### get_fastq

```
make get_fastq fastq=<SRA_accession> genome_size=<genome_size_in_bp> coverage=<desired_coverage> read_length=<read_length_in_bp> sample=<sample_name> output_dir=<output_directory>
```

After being provided the genome size, desired coverage, and length of a read, downloads a set number of reads from a provided ```fastq``` SRA accession number, provides a list of basic statistics, and runs FASTQC to assess the quality of the reads. All items are placed in the reads directory.

### index

```
make index sample=<sample_name> output_dir=<output_directory>
```

Finds the ```fasta``` file bearing the sample name and creates an index using ```bwa``` indexing, and places them in an index directory.

### align

```
make align fastq=<SRA_accession> sample=<sample_name> output_dir=<output_directory>
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

## Multiple Fastq Alignment and Visualization



```
make get_genome index
```

```
cat design.csv | parallel --colsep , --header : -j 6 make get_fastq align bigwig fastq={run_accession} sample={sample_alias}
```
