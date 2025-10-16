# Week 2 Data Analysis Assignment

#### Workspace Setup and Data Acquisition
```
conda activate bioinfo
mkdir Week2Data
cd Week2Data
wget http://ftp.ensembl.org/pub/current_gff3/serinus_canaria/Serinus_canaria.SCA1.115.gff3.gz
gunzip Serinus_canaria.SCA1.115.gff3.gz
cat Serinus_canaria.SCA1.115.gff3 > canary.gff
```

### Q1: What is *Serinus canaria*?

*Serinus canaria* is a canary from the true finch family of birds. This small, yellow bird is common in both in and around the Canary Islands and in captivity, 
primarily bred as a colorful pet. These birds are about 11 cm in height, and have a 22 cm wingspan.

### Q2: How many sequence regions (chromosomes) does the file contain? Does that match with the expectation for this organism?
```
cat canary.gff | cut -f 1 |grep "sequence-region" | sort | uniq | wc -l
```

#### Output: <br>
304,399 sequence regions <br>
<br>

304,399 unique sequence regions are in this file. While birds are known to have around 40 chromomsomes pairs, this output seems excessive. This indicates that this 
genome assembly is only at a scaffold level, and that full chromosome assemblies are not part of this assembly.

### Q3: How many features does the file contain?

```
cat canary.gff | grep -v '^#' | wc -l
```
#### Output: <br>

1,025,317 features

### Q4: How many genes are listed for this organism?
```
cat canary.gff | cut -f 3 | grep 'gene' | grep -v 'u' | grep -v 'c' | sort | uniq -c | head
```
#### Output: <br>
15225 genes


### Q5: Is there a feature type that you may have not heard about before? What is the feature and how is it defined? (If there is no such feature, pick a common feature.)

One feature type I had not heard of before analyzing this genome data was the "biological region" annotation. This appears to be a miscellaneous feature to catch any 
sequences that match known sequence ontologies,
but can't be categorized anywhere else. This includes sequences such as enhancer elements and regulatory regions, or any other regions with biological significance, 
but no further classification.

### Q6: What are the top-ten most annotated feature types (column 3) across the genome?

```
cat canary.gff | cut -f 3 | grep -v "#" | sort | uniq -c | sort -nr  | head
```
#### Output: <br>
309492 exon <br>
304399 region <br>
295737 CDS <br>
44778 biological_region <br>
24281 mRNA <br>
16223 five_prime_UTR <br>
15225 gene <br>
10299 three_prime_UTR <br>
2057 lnc_RNA <br>
2031 ncRNA_gene

### Q7: Having analyzed this GFF file, does it seem like a complete and well-annotated organism?

Overall, while I would say that while good work has been done on the *Serinus canaria* genome, more needs to be done to get a complete picture of this organism. 
From the amount of different sequence ids, it can be seen that this is a scaffold level assembly of the genome, which has not been assembled into chromsomes. 
While this does provide good data on how some of the genes are laid out, a full assembly would a better understanding on how genes are laid out in this organism. 
Annotation in *Serinus canaria* appears robust, with a high number of genes and other genome features, such as UTR's and RNA sequences, captured and annotated.

### Q8: Share any other insights you might note.

The submission for the *Serinus canaria* genome also included an abinitio.gff3 file. Taking a quick look around showed that this is a genome assembly 
using predictive modeling to identify genes. This analysis only used the standard .gff3 file associated with the species, but another analysis looking 
at the ab initio file may be warranted. <br>
<br>
Another interesting idea comes from the number of exons and genes in this assembly. According to my analysis, there are 309,492 exons and 15,225 genes,
or approximately 20 exons per gene. This number of exons per gene seems exceedingly high, and is either an indicator for how many introns are in the canary genome,
or that there are multiple genes left unannotated or exons misidentifed. More work would need to be done on the *Serinus canaria* genome assembly to determine 
which it is.
