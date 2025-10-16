# Set flags for ease of coding
set -xeuo pipefail
# Set Accession Number
Acc=GCF_000848505.1


# ------ No edits beyond this point ------

# Download Genome from NCBI with genome, gff3, and gtf files
datasets download genome accession $Acc --filename ${Acc}_genome.zip --include genome,gff3,gtf

# Unzip the downloaded file
unzip -n ${Acc}_genome.zip -d ${Acc}_genome

# Delete the zip file
rm ${Acc}_genome.zip

# Move the genome fasta file and gff file folder to the current directory
mv ${Acc}_genome/ncbi_dataset/data/$Acc/*_genomic.fna ${Acc}_genome/ncbi_dataset/data/$Acc/genomic.gff ./

# Rename files to accession number and file type
mv *genomic.fna GCF_000848505.1_genomic.fna
mv genomic.gff GCF_000848505.1_genomic.gff
