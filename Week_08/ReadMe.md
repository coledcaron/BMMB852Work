```
make get_genome index
```

```
cat design.csv | parallel --colsep , --header : -j 6 make get_fastq align bigwig fastq={run_accession} sample={sample_alias}
```
