# Set the shell the commands run in.
SHELL = bash

# Execute all commands in a single shell.
.ONESHELL:

# Run the shell with strict error checking.
.SHELLFLAGS = -eu -o pipefail -c

# Delete target files if the command fails.
.DELETE_ON_ERROR:

# Indicate that these targets are not files
.PHONY: help get_data index align bigwig counts all

# Warn if a variable is not defined.
MAKEFLAGS += --warn-undefined-variables

# Disable built-in rules.
MAKEFLAGS += --no-builtin-rules

# Define Input Variables

SAMPLE=HBR_1
OUTPUT=Hsapiens
DATA_URL=http://data.biostarhandbook.com/data/uhr-hbr.tar.gz

# Help message for use of the program
help:
	

# Run the get_genome, get_fastq, index, and align functions in order
all: get_data index align bigwig counts

# Use a provided GCF value to download a genome and GFF file if needed)
get_data:

	if [ ! -f "${OUTPUT}/refs/chr22.genome.fa" ]; then

		mkdir -p ${OUTPUT}
		mkdir -p ${OUTPUT}/refs
		wget ${DATA_URL} -O ${OUTPUT}/refs/uhr-hbr.tar.gz
		tar xzvf ${OUTPUT}/refs/uhr-hbr.tar.gz -C ${OUTPUT}/
		rm ${OUTPUT}/refs/uhr-hbr.tar.gz
		echo "Genome and GFF files downloaded and extracted."

	else
		echo "Genome and GFF files already exist. Skipping download."
	fi

# Index the Genome using bwa and samtools faidx and place into an index directory if needed
index:
	mkdir -p ${OUTPUT}
	mkdir -p ${OUTPUT}/index
	if [ ! -f "${OUTPUT}/index/genome_index.bwt" ]; then
		bwa index -p ${OUTPUT}/index/genome_index ${OUTPUT}/refs/chr22.genome.fa
		samtools faidx ${OUTPUT}/refs/chr22.genome.fa
		hisat2-build --threads 4 ${OUTPUT}/refs/chr22.genome.fa ${OUTPUT}/index/hisat2
		echo "Genome indexed."
	else
		echo "Genome index files already exist. Skipping indexing."
	fi
	

# Align the reads to the indexed genome and output a sorted BAM file, along with stats
align:
	mkdir -p ${OUTPUT}
	mkdir -p ${OUTPUT}/alignments
	# Align reads to the indexed genome using bwa mem, sort the alignments, and create a BAM file
	bwa mem -t 4 ${OUTPUT}/index/genome_index ${OUTPUT}/reads/$(SAMPLE)_R1.fq | samtools sort -o ${OUTPUT}/alignments/$(SAMPLE).bam
	# Index the BAM file for efficient access
	samtools index ${OUTPUT}/alignments/$(SAMPLE).bam
	# Generate alignment statistics and save to a text file
	samtools flagstats ${OUTPUT}/alignments/$(SAMPLE).bam > ${OUTPUT}/alignments/$(SAMPLE)_align_stats.txt
	echo "Alignment stats written to ${OUTPUT}/alignments/$(SAMPLE)_align_stats.txt"
	echo "Reads aligned and sorted BAM file created in the alignments directory."


# Convert the BAM file to a BigWig file for visualization

bigwig:
	mkdir -p ${OUTPUT}
	mkdir -p ${OUTPUT}/bigwig
	mkdir -p ${OUTPUT}/index
	LC_ALL=C; bedtools genomecov -ibam ${OUTPUT}/alignments/$(SAMPLE).bam -split -bg | sort -k1,1 -k2,2n > ${OUTPUT}/bigwig/$(SAMPLE)_genomecov.bedgraph
	bedGraphToBigWig ${OUTPUT}/bigwig/$(SAMPLE)_genomecov.bedgraph ${OUTPUT}/refs/chr22.genome.fa.fai ${OUTPUT}/bigwig/$(SAMPLE).bw
	rm ${OUTPUT}/bigwig/$(SAMPLE)_genomecov.bedgraph
	echo "BigWig file created in the bigwig directory."

# Generate gene counts from the aligned BAM files using featureCounts
counts:
	bio code
	mkdir -p ${OUTPUT}
	mkdir -p ${OUTPUT}/counts
	cp ${OUTPUT}/alignments/*.bam .
	featureCounts -a ${OUTPUT}/refs/chr22.gtf -o ${OUTPUT}/counts/$(OUTPUT)_counts.txt -s 2 *.bam
	rm *.bam
	echo "Gene counts written to ${OUTPUT}/counts/$(OUTPUT)_counts.txt"
	micromamba run -n stats Rscript src/r/format_featurecounts.r -c ${OUTPUT}/counts/$(OUTPUT)_counts.txt -o ${OUTPUT}/counts/$(OUTPUT)_counts.csv
	micromamba run -n stats Rscript src/r/create_tx2gene.r -d hsapiens_gene_ensembl
	micromamba run -n stats Rscript src/r/format_featurecounts.r -c ${OUTPUT}/counts/$(OUTPUT)_counts.txt -t tx2gene.csv -o ${OUTPUT}/counts/counts.csv

analysis:
	mkdir -p ${OUTPUT}
	mkdir -p ${OUTPUT}/results
	micromamba run -n stats Rscript src/r/edger.r -d design.csv -c ${OUTPUT}/counts/counts.csv
	micromamba run -n stats Rscript src/r/plot_pca.r -c edger.csv -d design.csv -o ${OUTPUT}/results/pca.pdf
	micromamba run -n stats Rscript src/r/plot_heatmap.r -c edger.csv -d design.csv -o ${OUTPUT}/results/heatmap.pdf
	bio gprofiler -c edger.csv -d hsapiens
	

