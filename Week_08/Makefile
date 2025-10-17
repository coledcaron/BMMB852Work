# Set the shell the commands run in.
SHELL = bash

# Execute all commands in a single shell.
.ONESHELL:

# Run the shell with strict error checking.
.SHELLFLAGS = -eu -o pipefail -c

# Delete target files if the command fails.
.DELETE_ON_ERROR:

# Indicate that these targets are not files
.PHONY: help get_genome get_fastq index align all bigwig

# Warn if a variable is not defined.
MAKEFLAGS += --warn-undefined-variables

# Disable built-in rules.
MAKEFLAGS += --no-builtin-rules

# Define Input Variables
genome = GCF_000848505.1
fastq = SRR1553500
genome_size = 18959
coverage = 10
read_length = 202
sample = ZEBV

# Define variables and directories for outputs
output_dir = ZEBV_analysis


# ------ No edits beyond this point -----

# Help message to explain code
help:
	@echo "Makefile for downloading a genome and SRA reads, indexing the genome, and aligning the reads."
	@echo ""
	@echo "Functions:"
	@echo "  all: Run all steps in order."
	@echo "  get_genome: Download fasta and GFF files using a provided GCF accession."
	@echo "  get_fastq: Download fastq files using a provided SRA accession."
	@echo "  index: Index the downloaded genome using bwa."
	@echo "  align: Align the downloaded reads to the indexed genome and output alignment statistics."
	@echo "  bigwig: Convert the aligned BAM file to a BigWig file for visualization."
	@echo ""
	@echo "Usage:"
	@echo "  all: make all genome=<GCF_accession> fastq=<SRA_accession> genome_size=<genome_size_in_bp> coverage=<desired_coverage> read_length=<read_length_in_bp> sample=<sample_name>"
	@echo "  get_genome: make get_genome genome=<GCF_accession> sample=<sample_name>"
	@echo "  get_fastq: make get_fastq fastq=<SRA_accession> genome_size=<genome_size_in_bp> coverage=<desired_coverage> read_length=<read_length_in_bp> sample=<sample_name>"
	@echo "  index: make index sample=<sample_name>"
	@echo "  align: make align fastq=<SRA_accession> sample=<sample_name>"
	@echo "  bigwig: make bigwig sample=<sample_name>"

# Run the get_genome, get_fastq, index, and align functions in order
all: get_genome get_fastq index align bigwig

# Use a provided GCF value to download a genome and GFF file if needed)
get_genome:
	
	if [ ! -f "${output_dir}/sequences/${output_dir}_genomic.fna" ]; then
	
		mkdir -p ${output_dir}
		mkdir -p ${output_dir}/sequences
		datasets download genome accession $(genome) --filename ${genome}_genome.zip --include genome,gff3
		unzip -n -o ${genome}_genome.zip -d ${output_dir}/genome
		rm ${genome}_genome.zip
		mv ${output_dir}/genome/ncbi_dataset/data/$(genome)/*_genomic.fna ${output_dir}/genome/ncbi_dataset/data/$(genome)/*genomic.gff ./
		mv *genomic.fna ${output_dir}/sequences/$(output_dir)_genomic.fna
		mv genomic.gff ${output_dir}/sequences/$(output_dir)_genomic.gff
		echo "Genome and GFF files downloaded and extracted."

	else
		echo "Genome and GFF files already exist. Skipping download."
	fi

# Use a provided SRA value to download fastq files
get_fastq:
	mkdir -p ${output_dir}
	mkdir -p ${output_dir}/reads
	# Determine number of reads to download based on genome size, coverage, and read length
	num_reads=$$(( ($(genome_size) * $(coverage)) / $(read_length) ))
	echo "Downloading $$num_reads reads for SRA accession $(fastq)"
	fastq-dump -X $$num_reads -F --skip-technical --outdir ${output_dir}/reads/fastq/$(sample) --split-files $(fastq)
	# Use FASTQC to generate quality reports for the fastq files
	mkdir -p ${output_dir}/reads/fastqc/$(sample)
	fastqc -o ${output_dir}/reads/fastqc/$(sample) ${output_dir}/reads/fastq/$(sample)/*.fastq
	rm ${output_dir}/reads/fastqc/$(sample)/*_fastqc.zip
	# Generate basic stats for the downloaded fastq files and output to a text file
	seqkit stats ${output_dir}/reads/fastq/$(sample)/*.fastq > ${output_dir}/reads/fastqc/$(sample)/$(sample)_fastq_stats.txt
	echo "Fastq stats written to $(sample)_fastq_stats.txt"
	echo "FASTQC reports generated in the reads directory."

# Index the Genome using bwa and samtools faidxand place into an index directory if needed
index:
	mkdir -p ${output_dir}
	mkdir -p ${output_dir}/index
	if [ ! -f "${output_dir}/index/genome_index.bwt" ]; then
		bwa index -p ${output_dir}/index/genome_index ${output_dir}/sequences/$(output_dir)_genomic.fna
		samtools faidx ${output_dir}/sequences/$(output_dir)_genomic.fna
		echo "Genome indexed."
	else
		echo "Genome index files already exist. Skipping indexing."
	fi
	

# Align the reads to the indexed genome and output a sorted BAM file, along with stats
align:
	mkdir -p ${output_dir}
	mkdir -p ${output_dir}/alignments
	mkdir -p ${output_dir}/alignments/$(sample)
	# Align reads to the indexed genome using bwa mem, sort the alignments, and output
	bwa mem -t 4 ${output_dir}/index/genome_index ${output_dir}/reads/fastq/$(sample)/*.fastq | samtools sort -o ${output_dir}/alignments/$(sample)/$(sample)_aligned_sorted.bam
	samtools index ${output_dir}/alignments/$(sample)/$(sample)_aligned_sorted.bam
	samtools flagstats ${output_dir}/alignments/$(sample)/$(sample)_aligned_sorted.bam > ${output_dir}/alignments/$(sample)/$(sample)_alignment_stats.txt
	echo "Alignment stats written to $(sample)_alignment_stats.txt"
	echo "Reads aligned and sorted BAM file created in the alignments directory."

# Convert the BAM file to a BigWig file for visualization
bigwig:
	mkdir -p ${output_dir}
	mkdir -p ${output_dir}/alignments
	mkdir -p ${output_dir}/index
	LC_ALL=C; bedtools genomecov -ibam ${output_dir}/alignments/$(sample)/$(sample)_aligned_sorted.bam -split -bg | sort -k1,1 -k2,2n > ${output_dir}/alignments/$(sample)/$(sample)_genomecov.bedgraph
	bedGraphToBigWig ${output_dir}/alignments/$(sample)/$(sample)_genomecov.bedgraph ${output_dir}/sequences/$(output_dir)_genomic.fna.fai ${output_dir}/alignments/$(sample)/$(sample)_genomecov.bw
	rm ${output_dir}/alignments/$(sample)/$(sample)_genomecov.bedgraph
	echo "BigWig file created in the alignments directory."
