# Week 8 Homework Assignment

## Set up:
```
mkdir week8data
cd week8data
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

![Zaire Ebolavirus IGV Alignment Overview](https://github.com/coledcaron/BMMB852Work/blob/main/Week_07/images/Illumina_fastq_vis.jpg)

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

![Zaire Ebolavirus IGV Alignment Overview](https://github.com/coledcaron/BMMB852Work/blob/main/Week_07/images/Illumina_fastq_vis.jpg)

----------------------------

## Multiple Fastq Alignment

When aligning multiple ```fastq``` to a provided genomes, this process can be expedited with the use of ```GNU parallel``` to take a reference file and use this as the inputs for the Makefile. The steps to do this are as follows:

### 1. Create a CSV File With Sample Data (Example)

Create a CSV file that contains all of the variables that need to be changed. For this example, both the genome (labeled run_accession) and the sample alias need to be changed for each sample. An example of the layout is provided below.

```
run_accession,sample_alias
SRR1972855,G5295.1
```

If other inputs, such as read length or genome size, are variable from the defaults, the CSV file should also include columns for these values.

### 2. Set the Genome and Indexes

```
make get_genome index genome=GCF_000848505.1 output_dir=ZEBV_analysis
```

Since the same reference genome will be used to align each sample, this only needs to be downloaded once for the whole analysis. These files are referenced by all samples during alignment, so they only need to be generated once.

### 3. Use GNU Parallel to Initiate Multi-Sample Alignment to the genome

```
cat design.csv | parallel --colsep , --header : -j 6 make get_fastq align bigwig fastq={run_accession} sample={sample_alias}
```

This command takes a design file and provides it to ```parallel``` to run 6 jobs simultaneously. The column separator and header both need to be defined, along with the number of concurrent jobs. 

Since a genome index has already been created for the samples, that leaves only fastq acquisition, alignment, and bigwig creation as steps that need to be done to each sample. Finally, the columns in the spreadsheet need to be assigned to their respective variables in the Makefile.
