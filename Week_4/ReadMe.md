# Week 4 Homework Assignment

### Set up:
```
conda activate bioinfo
# Set up directory to store folders
mkdir week4data
cd week4data
# Download Zaire et al. 2014 Ebola Genome
datasets download genome accession GCF_000848505.1 --include genome,gff3,gtf
unzip -n ncbi_dataset.zip
mv ncbi_dataset/data/GCF_000848505.1/GCF_000848505.1_ViralProj14703_genomic.fna ebola_1976.fa
mv ncbi_dataset/data/GCF_000848505.1/genomic.gff ebola_1976.gff
```
### IGV Visualization of the Ebola Genome in IGV:
![IGV Visualization of the 1976 Zaire Ebola Genome](https://github.com/coledcaron/BMMB852Work/blob/main/Week_4/IGV_Screenshots/Ebola_IGV_Vis.jpg)
### Question: How big is the Ebola genome, and how many features are there?
Length:
```
cat ebola_1976.fa | grep -v ">" | tr -d '\n' | wc
```
Features:
```
cat ebola_1976.gff | cut -f 3 | grep -v "#" | sort | wc -l
```

### Question: What is the longest gene in Ebola?
```
awk '$3 == "gene" {
    len = $5 - $4 + 1
    split($9, a, /[;=]/)
    for (i = 1; i <= length(a); i++) {
        if (a[i] == "ID") id = a[i+1]
    }
    if (len > max) {
        max = len
        max_id = id
    }
} 
END {
    print max_id, max
}' ebola_1976.gff
```
### Question: What is the name and function of the longest Ebola gene and one other gene?

ZEBOVgp7 is labeled as an RNA-dependent RNA polymerase in many of the annotations associated with it. This protein in ebola is used to replicate the viral genome to produce more viruses, as well as make modifications to viral RNA to serve various purposes.

Another protein, ZEBOVgp4, 

### Question: Using IGV, what is the approximate coverage of the genome with coding sequences?
```
cat ebola_1976.gff | grep "\tCDS\t" > ebola_cds.gff
```
![Coverage of Ebola CDS across the Genome](https://github.com/coledcaron/BMMB852Work/blob/main/Week_4/IGV_Screenshots/Ebola_IGV_CDScoverage.jpg)
### Question: What other genome builds for Ebola are available, and what could they be used for?
