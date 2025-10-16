# Set the shell the commands run in.
SHELL = bash

# Execute all commands in a single shell.
.ONESHELL:

# Run the shell with strict error checking.
.SHELLFLAGS = -eu -o pipefail -c

# Delete target files if the command fails.
.DELETE_ON_ERROR:

# Warn if a variable is not defined.
MAKEFLAGS += --warn-undefined-variables

# Disable built-in rules.
MAKEFLAGS += --no-builtin-rules



# ------ No edits beyond this point -----

# Use a providded GCF value to download a genome and GFF file
get_genome:
	datasets download genome accession $(genome) --filename ${genome}_genome.zip --include genome,gff3
	unzip -n -o ${genome}_genome.zip -d genome
	rm ${genome}_genome.zip
	mv genome/ncbi_dataset/data/$(genome)/*_genomic.fna genome/ncbi_dataset/data/$(genome)/*genomic.gff ./
	mv *genomic.fna GCF_000848505.1_genomic.fna
	mv genomic.gff GCF_000848505.1_genomic.gff
	echo "Genome and GFF files downloaded and extracted."

# Use a provided SRA value to download fastq files
get_fastq:
	# Determine number of reads to download based on genome size, coverage, and read length
	num_reads=$$(( (genome_size * coverage) / (read_length) ))
	echo "Downloading $$num_reads reads for SRA accession $(fastq)"
	fastq-dump -X $$num_reads -F --skip-technical --outdir reads --split-files $(fastq)
	# Generate basic stats for the downloaded fastq files and output to a text file
	seqkit stats reads/$(fastq)*.fastq > reads/$(fastq)_fastq_stats.txt
	echo "Fastq stats written to $(fastq)_fastq_stats.txt"
	# Use FASTQC to generate quality reports for the fastq files
	fastqc -o reads reads/$(fastq)*.fastq
	echo "FASTQC reports generated in the reads directory"

# Index the Genome using bwa
index:
	bwa index -p genome_index $(genome)_genomic.fna
	echo "Genome indexed."

# Align the reads to the indexed genome and output a sorted BAM file, along with stats
align:
	mkdir -p alignments
	bwa mem -t 4 genome_index reads/$(fastq)*.fastq | samtools sort -o alignments/$(fastq)_aligned_sorted.bam
	samtools index alignments/$(fastq)_aligned_sorted.bam
	samtools stats alignments/$(fastq)_aligned_sorted.bam > alignments/$(fastq)_alignment_stats.txt
	echo "Alignment stats written to $(fastq)_alignment_stats.txt"
	echo "Reads aligned and sorted BAM file created in the alignments directory."
