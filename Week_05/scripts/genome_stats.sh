# Set flags for ease of coding
set -xeuo pipefail

# Define the fasta and gff files
fasta="GCF_000848505.1_genomic.fna"
gff="GCF_000848505.1_genomic.gff"

# Define output stats file
output="GCF_000848505.1_stats.txt"

# ------ No edits beyond this point ------

# Length of the genome
genome_length=$(grep -v ">" $fasta | tr -d '\n' | wc -c)

# Number of genome features
num_features=$(grep -c -v "^#" $gff)

# Length of the longest gene
longest_gene=$(awk '$3 == "gene" {print $5 - $4 + 1}' $gff | sort -nr | head -n 1)

# Write stats to output file
{
  echo "Genome Length: $genome_length"
  echo "Number of Features: $num_features"
  echo "Length of Longest Gene: $longest_gene"
} > $output
echo "Stats written to $output"
