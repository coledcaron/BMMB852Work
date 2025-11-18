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

# Set the URL of the reference genome
REF_URL=https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/references/GRCh38/GRCh38_GIABv3_no_alt_analysis_set_maskedGRC_decoys_MAP2K3_KMT2C_KCNJ18.fasta.gz
# Download the reference genome
REF=refs/GRCh38.fasta.gz
# The chromosome of interest.
CHR=chr7
# A subset of the reference genome for the region of interest.
REF=refs/${CHR}.fasta
# Set region of interest
REGION=chr7:127,881,331-127,897,682
# Get bam files for various sequencing platforms
BAM_ILLUMINA=https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data_somatic/HG008/Liss_lab/BCM_Illumina-WGS_20240313/HG008-T_Illumina_195x_GRCh38-GIABv3.bam
BAM_REVIO=https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data_somatic/HG008/Liss_lab/BCM_Revio_20240313/HG008-T_PacBio-HiFi-Revio_20240313_106x_GRCh38-GIABv3.bam
BAM_HIC=https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data_somatic/HG008/Liss_lab/Dovetail_LinkPrep-ILMN_HG8NP_20250625/HG008-N-P_LinkPrep_20250625_sorted_GRCh38.bam
BAM_AVITI=https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data_somatic/HG008/Liss_lab/Element-AVITI-20241216/HG008-T_Element-StdInsert_111x_GRCh38-GIABv3.bam

help:
	@echo "Makefile for downloading and processing genomic data for HG008 in a specific region."
	@echo ""
	@echo "Available targets:"
	@echo "  all          - Download reference genome, extract BAM files, and generate bigwig files."
	@echo "  get_genome   - Download and index the reference genome."
	@echo "  get_bam      - Extract specified region from BAM files and generate statistics."
	@echo "  bigwig       - Generate bigwig files from the extracted BAM files."
	@echo ""
	@echo "Variables to set:"
	@echo "  CHR          - Chromosome of interest (default: chr7)."
	@echo "  REGION       - Genomic region of interest (default: chr7:127,881,331-127,897,682)."

all: get_genome get_bam bigwig

get_genome:
	mkdir -p refs
	# Download whole genome reference fasta file.
	curl -L ${REF_URL} -o genome.fasta
	# Index the reference genome for use with samtools.
	samtools faidx genome.fasta
	# Extract the chromosome of interest.
	samtools faidx genome.fasta ${CHR} > refs/${CHR}.fasta
	# Index the extracted chromosome fasta file.
	samtools faidx refs/${CHR}.fasta
	# Remove the whole genome fasta file to save space.
	rm genome.fasta

get_bam:
	mkdir -p bams
	# Extract the region of interest from each bam file.
	samtools view -b ${BAM_ILLUMINA} ${REGION} > bams/HG008-Illumina.bam
	samtools view -b ${BAM_REVIO} ${REGION} > bams/HG008-Revio.bam
	samtools view -b ${BAM_HIC} ${REGION} > bams/HG008-HiC.bam
	samtools view -b ${BAM_AVITI} ${REGION} > bams/HG008-Aviti.bam

	# Index the bam files for use with samtools.
	samtools index bams/HG008-Illumina.bam
	samtools index bams/HG008-Revio.bam
	samtools index bams/HG008-HiC.bam
	samtools index bams/HG008-AVITI.bam
	# Generate statistics for each bam file.
	samtools flagstat bams/HG008-Illumina.bam > bams/HG008-Illumina.flagstat.txt
	samtools flagstat bams/HG008-Revio.bam > bams/HG008-Revio.flagstat.txt
	samtools flagstat bams/HG008-HiC.bam > bams/HG008-HiC.flagstat.txt
	samtools flagstat bams/HG008-Aviti.bam > bams/HG008-Aviti.flagstat.txt
	# Generate stats on average read depth.
	samtools depth bams/HG008-Illumina.bam | awk '{sum+=$$3} END { print "Average Depth: ",sum/NR}' > bams/HG008-Illumina.depth.txt
	samtools depth bams/HG008-Revio.bam | awk '{sum+=$$3} END { print "Average Depth: ",sum/NR}' > bams/HG008-Revio.depth.txt
	samtools depth bams/HG008-HiC.bam | awk '{sum+=$$3} END { print "Average Depth: ",sum/NR}' > bams/HG008-HiC.depth.txt
	samtools depth bams/HG008-Aviti.bam | awk '{sum+=$$3} END { print "Average Depth: ",sum/NR}' > bams/HG008-Aviti.depth.txt

bigwig:
	mkdir -p bigwigs
	# Generate bigwig files for each bam file.
	LC_ALL=C; bedtools genomecov -ibam bams/HG008-Illumina.bam -split -bg | sort -k1,1 -k2,2n > bigwigs/HG008-Illumina_genomecov.bedgraph
	bedGraphToBigWig bigwigs/HG008-Illumina_genomecov.bedgraph refs/${CHR}.fasta.fai bigwigs/HG008-Illumina.bw
	rm bigwigs/HG008-Illumina_genomecov.bedgraph

	LC_ALL=C; bedtools genomecov -ibam bams/HG008-Revio.bam -split -bg | sort -k1,1 -k2,2n > bigwigs/HG008-Revio_genomecov.bedgraph
	bedGraphToBigWig bigwigs/HG008-Revio_genomecov.bedgraph refs/${CHR}.fasta.fai bigwigs/HG008-Revio.bw
	rm bigwigs/HG008-Revio_genomecov.bedgraph

	LC_ALL=C; bedtools genomecov -ibam bams/HG008-HiC.bam -split -bg | sort -k1,1 -k2,2n > bigwigs/HG008-HiC_genomecov.bedgraph
	bedGraphToBigWig bigwigs/HG008-HiC_genomecov.bedgraph refs/${CHR}.fasta.fai bigwigs/HG008-HiC.bw
	rm bigwigs/HG008-HiC_genomecov.bedgraph

	LC_ALL=C; bedtools genomecov -ibam bams/HG008-Aviti.bam -split -bg | sort -k1,1 -k2,2n > bigwigs/HG008-Aviti_genomecov.bedgraph
	bedGraphToBigWig bigwigs/HG008-Aviti_genomecov.bedgraph refs/${CHR}.fasta.fai bigwigs/HG008-Aviti.bw
	rm bigwigs/HG008-Aviti_genomecov.bedgraph

.PHONY: bigwig get_bam get_genome all help