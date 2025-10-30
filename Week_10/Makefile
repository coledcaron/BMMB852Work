# Set the shell the commands run in.
SHELL = bash

# Execute all commands in a single shell.
.ONESHELL:

# Run the shell with strict error checking.
.SHELLFLAGS = -eu -o pipefail -c

# Delete target files if the command fails.
.DELETE_ON_ERROR:

# Indicate that these targets are not files
.PHONY: help get_genome get_fastq index align all bigwig vcf igv igv_check vcf_merge

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
F1 = -d 100 --annotate 'INFO/AD,FORMAT/DP,FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/SP'
F2 = --ploidy 2 --annotate 'FORMAT/GQ'
dir = $(shell pwd)

# Define variables and directories for outputs
output_dir = ZEBV_analysis


# ------ No edits beyond this point -----

# Help message to explain code
help:
	@echo "Makefile for downloading a genome and SRA reads, indexing the genome, and aligning the reads."
	@echo ""
	@echo "Functions:"
	@echo "  all: Run all steps in order."
	@echo "  igv_check: Check if IGV is running on port 60151."
	@echo "  get_genome: Download fasta and GFF files using a provided GCF accession."
	@echo "  get_fastq: Download fastq files using a provided SRA accession."
	@echo "  index: Index the downloaded genome using bwa."
	@echo "  align: Align the downloaded reads to the indexed genome and output alignment statistics."
	@echo "  bigwig: Convert the aligned BAM file to a BigWig file for visualization."
	@echo "  vcf: Call variants from the aligned BAM file and output a VCF.gz file."
	@echo "  vcf_merge: Merge multiple VCF files into a single VCF.gz file."
	@echo "  igv: Load the genome, annotations, alignments, and variants into IGV for visualization."
	@echo ""
	@echo "Usage:"
	@echo "  all: make all genome=<GCF_accession> fastq=<SRA_accession> genome_size=<genome_size_in_bp> coverage=<desired_coverage> read_length=<read_length_in_bp> sample=<sample_name>"
	@echo "  igv_check: make igv_check"
	@echo "  get_genome: make get_genome genome=<GCF_accession> sample=<sample_name>"
	@echo "  get_fastq: make get_fastq fastq=<SRA_accession> genome_size=<genome_size_in_bp> coverage=<desired_coverage> read_length=<read_length_in_bp> sample=<sample_name>"
	@echo "  index: make index sample=<sample_name>"
	@echo "  align: make align fastq=<SRA_accession> sample=<sample_name>"
	@echo "  bigwig: make bigwig sample=<sample_name>"
	@echo "  vcf: make vcf sample=<sample_name>"
	@echo "  vcf_merge: make vcf_merge"
	@echo "  igv: make igv sample=<sample_name>"

# Run the get_genome, get_fastq, index, and align functions in order
all: igv_check get_genome get_fastq index align bigwig vcf igv

# Checks to see if IGV is running
igv_check:
	if ! nc -z localhost 60151 >/dev/null 2>&1; then \
		echo "ERROR: IGV is not open or port 60151 is not active."; \
		exit 1; \
	fi

# Use a provided GCF value to download a genome and GFF file if needed)
get_genome:
	
	if [ ! -f "${output_dir}/sequences/${output_dir}_genomic.fna" ]; then
	
		mkdir -p ${output_dir}
		mkdir -p ${output_dir}/sequences
		datasets download genome accession $(genome) --filename ${genome}_genome.zip --include genome,gff3
		unzip -n -o ${genome}_genome.zip -d ${output_dir}/genome
		rm ${genome}_genome.zip
		mv ${output_dir}/genome/ncbi_dataset/data/$(genome)/*_genomic.fna ${output_dir}/genome/ncbi_dataset/data/$(genome)/*genomic.gff ./
		mv *genomic.fna ${output_dir}/sequences/$(output_dir).fna
		mv genomic.gff ${output_dir}/sequences/$(output_dir).gff
		rm -r ${output_dir}/genome
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
	fastq-dump -X $$num_reads -F --skip-technical --outdir ${output_dir}/reads --split-files $(fastq)
	# Use FASTQC to generate quality reports for the fastq files
	mkdir -p ${output_dir}/fastqc
	fastqc -o ${output_dir}/fastqc ${output_dir}/reads/$(fastq)*.fastq
	rm ${output_dir}/fastqc/$(fastq)*_fastqc.zip
	# Generate basic stats for the downloaded fastq files and output to a text file
	seqkit stats ${output_dir}/reads/$(fastq)*.fastq > ${output_dir}/fastqc/$(fastq)_fastq_stats.txt
	echo "Fastq stats written to $(fastq)_fastq_stats.txt"
	echo "FASTQC reports generated in the reads directory."

# Index the Genome using bwa and samtools faidx and place into an index directory if needed
index:
	mkdir -p ${output_dir}
	mkdir -p ${output_dir}/index
	if [ ! -f "${output_dir}/index/genome_index.bwt" ]; then
		bwa index -p ${output_dir}/index/genome_index ${output_dir}/sequences/$(output_dir).fna
		samtools faidx ${output_dir}/sequences/$(output_dir).fna
		echo "Genome indexed."
	else
		echo "Genome index files already exist. Skipping indexing."
	fi
	

# Align the reads to the indexed genome and output a sorted BAM file, along with stats
align:
	mkdir -p ${output_dir}
	mkdir -p ${output_dir}/alignments
	# Align reads to the indexed genome using bwa mem, sort the alignments, and output
	bwa mem -t 4 ${output_dir}/index/genome_index ${output_dir}/reads/$(fastq)*.fastq | samtools sort -o ${output_dir}/alignments/$(sample).bam
	samtools index ${output_dir}/alignments/$(sample).bam
	samtools flagstats ${output_dir}/alignments/$(sample).bam > ${output_dir}/alignments/$(sample)_align_stats.txt
	echo "Alignment stats written to $(sample)_align_stats.txt"
	echo "Reads aligned and sorted BAM file created in the alignments directory."

# Convert the BAM file to a BigWig file for visualization
bigwig:
	mkdir -p ${output_dir}
	mkdir -p ${output_dir}/bigwig
	mkdir -p ${output_dir}/index
	LC_ALL=C; bedtools genomecov -ibam ${output_dir}/alignments/$(sample).bam -split -bg | sort -k1,1 -k2,2n > ${output_dir}/bigwig/$(sample)_genomecov.bedgraph
	bedGraphToBigWig ${output_dir}/bigwig/$(sample)_genomecov.bedgraph ${output_dir}/sequences/$(output_dir).fna.fai ${output_dir}/bigwig/$(sample).bw
	rm ${output_dir}/bigwig/$(sample)_genomecov.bedgraph
	echo "BigWig file created in the bigwig directory."

# Use bcftools to call variants and output a VCF.gz file
vcf:
	mkdir -p ${output_dir}
	mkdir -p ${output_dir}/variants
	# Variant calling process
	bcftools mpileup ${F1} -O u -f ${output_dir}/sequences/$(output_dir).fna ${output_dir}/alignments/$(sample).bam | \
	bcftools call ${F2} -mv -O u | \
	bcftools norm -f ${output_dir}/sequences/$(output_dir).fna -d all -O u | \
	bcftools sort -O z -o ${output_dir}/variants/$(sample).vcf.gz
	bcftools index -t ${output_dir}/variants/$(sample).vcf.gz

# Merge multiple VCF files
vcf_merge:
	mkdir -p ${output_dir}
	mkdir -p ${output_dir}/variants
	# Merge VCF files using bcftools
	bcftools merge -O z -o ${output_dir}/variants/${output_dir}.vcf.gz ${output_dir}/variants/*.vcf.gz
	# tabix -p vcf ${output_dir}/variants/${output_dir}.vcf.gz
	echo "VCF files merged into ${output_dir}.vcf.gz"

# Open files in IGV to visualize
igv:
	# Custom error if IGV is not open
	if ! nc -z localhost 60151 >/dev/null 2>&1; then \
		echo "ERROR: IGV is not open or port 60151 is not active."; \
		exit 1; \
	fi
	# Send commands to IGV via nc
	echo "new" | nc localhost 60151
	echo "genome ${dir}/${output_dir}/sequences/$(output_dir).fna" | nc localhost 60151
	@if [ ! -f "${dir}/${output_dir}/variants/${output_dir}.vcf.gz" ]; then \
		echo "load ${dir}/${output_dir}/alignments/$(sample).bam" | nc localhost 60151
		echo "load ${dir}/${output_dir}/sequences/$(output_dir).gff" | nc localhost 60151
		echo "load ${dir}/${output_dir}/variants/$(sample).vcf.gz" | nc localhost 60151
		echo "load ${dir}/${output_dir}/bigwig/$(sample).bw" | nc localhost 60151
	else \
		echo "load ${dir}/${output_dir}/sequences/$(output_dir).gff" | nc localhost 60151
		echo "load ${dir}/${output_dir}/variants/${output_dir}.vcf.gz" | nc localhost 60151
	fi
	echo "expand" | nc localhost 60151
	echo "IGV has been updated with the new genome, annotations, alignments, and variants."