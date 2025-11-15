## Week 12 Homework Assignment

For this analysis into the Cancer in a Bottle project data, I decided to look more into the LEP gene, which encodes leptin in humans. This small protein is a hormone produced by fat cells to regulate apetite, energy balance, and other aspects related to energy production and use in the body. Additionally, there are some tenuous links between this hormone and some cancers, although this link is not well studied.

Therefore, I thought it would be of interest to see if I could find anything in the Cancer in a Bottle genome that may interfere with the LEP gene.

For this analysis, I wanted to identify how varying sequencing platforms would affect sequencing efficacy and alignment for the LEP gene. From the Cancer in a Bottle Project, I identified Illumina, HiC, Revio, and Aviti sequencing platforms in this study. For each machine, I called a ```bam``` file to run analysis on and visualize the area where this gene is located.

### Makefile Instructions

The provided Makefile runs a simple program that downloads multiple bam files from a variety of sequencing platforms, along with the reference genome, extracts only data relevant to the LEP gene, and runs statistics on the ```bam``` files to learn about the quality of their alignment.

For this analysis, all of the variables are loaded into the Makefile already, so the file can be run with:
```make all```

This produces a genome file curated for the chromosome of interest, bam files with reads only along the region of interest, statistics on each alignment, and bigwig files for larger alignments if necessary.

### Overall Coverage

![Overall Coverage for Each Sequencing Platform](https://github.com/coledcaron/BMMB852Work/blob/main/Week_12/igv_images/Overall_cov.jpg)

Accross all four sequencing platforms, Revio sequencing stands out as being surprisingly even across the LEP gene. There are no real gaps in the sequencing, instead being characterized as long blocks of coverage that nicely cover the whole area. Aviti sequencing appears to look the worse, with gaps in coverage across the region, and in particularly around the 127,882.5 kb area, where there is a whole section with low coverage. Most of the sequencing region is characterized by spiky coverage across the region, which evens out to their average coverage.

### Aviti Alignment

![BAM alignment of Aviti platform sequencing](https://github.com/coledcaron/BMMB852Work/blob/main/Week_12/igv_images/igv_aviti.jpg)


In the Aviti platform sequencing, the most striking this is the large gap in sequencing towards the beginning of the LEP gene. There are also some regions of overrepresentation, such as at 127,889 kb, which has a higher peak than all surrounding areas.

```
6790 + 0 mapped (99.91% : N/A)
6762 + 0 primary mapped (99.91% : N/A)
Average Depth:  60.15
```
Mapping efficiency is extremely high, and average depth is very strong for Aviti.

### HiC Alignment

![BAM alignment of HiC platform sequencing](https://github.com/coledcaron/BMMB852Work/blob/main/Week_12/igv_images/igv_hic.jpg)

In the HiC platform sequencing, sequencing is relatively consistent across the LEP gene, with no regions of extreme under or overrepresentation. Overall decent quality of alignment.

```
13265 + 0 mapped (99.55% : N/A)
11518 + 0 primary mapped (99.48% : N/A)
Average Depth:  59.8329
```
Mapping efficiency is slighly lower than Aviti, but average depth is about the same compared to Aviti sequencing.

### Illumina Alignment

![BAM alignment of Illumina platform sequencing](https://github.com/coledcaron/BMMB852Work/blob/main/Week_12/igv_images/igv_illumina.jpg)

On the Illumina sequencing platform, big gaps in sequencing overall, with small peaks and troughs throughout the LEP gene. There are no areas of extreme under or overrepresentation, and the peaks and troughs are relatively close to each other.

```
11428 + 0 mapped (99.61% : N/A)
11401 + 0 primary mapped (99.61% : N/A)
Average Depth:  102.694
```
There is very good alignment overall, and a high average depth across the LEP gene.

### Revio Alignment

![BAM alignment of Revio platform sequencing](https://github.com/coledcaron/BMMB852Work/blob/main/Week_12/igv_images/igv_revio.jpg)

For the Revio sequencing platform, I am still surprised at how even the coverage is across the LEP gene. This is most likely caused by the length of fragments sequenced by Revio, lowering the total number of fragments for more continuous sequencing. However, this process has left larger gaps in the sequencing between some Revio reads, which is overall covered by other large reads spanning the area.

```
106 + 0 mapped (100.00% : N/A)
106 + 0 primary mapped (100.00% : N/A)
Average Depth:  28.4192
```
This average depth is a little low, all fragments have aligned properly, most likely due to the length of fragment preventing mismatches.

### Conclusion

Overall, all sequencing technology used for the Cancer in a Bottle genome appear to be of high quality for the LEP gene, with only the Aviti sequencing platform having any regions of sequencing irregularity. Based on this analysis, I would use any of these sequencing technologies to get data. However, Revio data seems to be of the highest quality, with extremely consistent read coverage across the length of the gene. Therefore, given the choice, I would preferably use Revio sequencing data in the future to get the data that I would need for an analysis.
