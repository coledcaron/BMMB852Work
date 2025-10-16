# Set flags for ease of coding
set -xeuo pipefail

# Define the fastq file accession numbers
fastq=SRR1972941

# Define variables for genome size, coverage, and read length
genome_size=18959
coverage=10
read_length=202

# ------ No edits beyond this point ------

# Determine the numbers of reads needed for the desired coverage
num_reads=$(( (genome_size * coverage) / read_length ))

# Download the fastq files from NCBI SRA
mkdir -p reads
fastq-dump -X $num_reads -F --outdir reads --split-files $fastq

# Generate basic stats for the downloaded fastq files and output to a text file
seqkit stats reads/${fastq}_1.fastq reads/${fastq}_2.fastq > reads/${fastq}_fastq_stats.txt
echo "Fastq stats written to ${fastq}_fastq_stats.txt"

# Use FASTQC to generate quality reports for the fastq files
fastqc -o reads reads/${fastq}_1.fastq reads/${fastq}_2.fastq
echo "FASTQC reports generated in the reads directory"
