# Assignment 3: Genomic Data Visualization

#### Set up:
```
conda activate bioinfo
mkdir week3data
cd week3data
wget https://ftp.ensemblgenomes.ebi.ac.uk/pub/bacteria/current/gff3/bacteria_0_collection/listeria_monocytogenes_egd_e_gca_000196035/Listeria_monocytogenes_egd_e_gca_000196035.ASM19603v1.62.gff3.gz
gunzip Listeria_monocytogenes_egd_e_gca_000196035.ASM19603v1.62.gff3.gz
mv Listeria_monocytogenes_egd_e_gca_000196035.ASM19603v1.62.gff3 Lmono.gff
wget https://ftp.ensemblgenomes.ebi.ac.uk/pub/bacteria/current/fasta/bacteria_0_collection/listeria_monocytogenes_egd_e_gca_000196035/dna/Listeria_monocytogenes_egd_e_gca_000196035.ASM19603v1.dna.toplevel.fa.gz
gunzip Listeria_monocytogenes_egd_e_gca_000196035.ASM19603v1.dna.toplevel.fa.gz
mv Listeria_monocytogenes_egd_e_gca_000196035.ASM19603v1.dna.toplevel.fa Lmono.fa
```

### Q1: Use IGV to visualize your genome and the annotations relative to the genome.

### Q2: How big is the genome, and how many features of each type does the GFF file contain?
```
seqkit stats Lmono.fa
```
#### Output:
The genome consists of one sequence of 2,944,528 base pairs

```
cat Lmono.gff | cut -f 3 | grep -v "#" | sort | wc -l
```

#### Output:
There are 15,374 features in the GFF file

### Q3: From your GFF file, separate the intervals of type "gene" or "transcript" into a different file. Show the commands you used to do this.

```
cat Lmono.gff | grep -E '\t(mRNA|gene)\t' > Lmono_gene.gff
```

#### Output:
A file containing both the mRNA and gene information for Listeria monocytes, separate from all other feature information

### Q4: Visualize the simplified GFF in IGV as a separate track. Compare the visualization of the originall GFF with the simplified GFF.




### Q5: Zoom in to see the sequences, expand the view to show the translation table in IGV. Note how the translation table needs to be displayed in the correct orientation for it to make sense.




### Q6: Visually verify that the first coding sequence of a gene starts with a start codon and that the last coding sequence of a gene ends with a stop codon.


