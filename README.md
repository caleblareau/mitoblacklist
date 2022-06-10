# Repo for hardmasking nuclear reference genome based on regions of high homology to mtDNA 
This repository enables the generation of  custom blacklist for reads originating from mitochondrial DNA to nuclear genome. This is useful for assays like mtscATAC-seq that enrich for mitochondrial DNA that can be errantly aligned to other contigs on the reference genome. 

### Overview

This workflow shows how to simulate reads using ART from the mitochondrial contig, align them to the reference with bowtie2, pull out non-mitochondrial contigs, then produce a bed file of reads that are mapped with macs2. We then recommend merging this file with an existing reference blacklist (e.g. ENCODE) to create a final combined blacklist. We include these combined blacklists for four common reference genomes (hg19, hg38, mm9, mm10) already in the [combinedBlacklist](https://github.com/caleblareau/mitoblacklist/tree/master/combinedBlacklist) folder. This bedfile can be used in conjugation with a hard masking of the reference genome [to increase coverage in one alignment as we outline here](https://github.com/caleblareau/mgatk/wiki/Increasing-coverage-from-10x-processing). 


### Updated June 10, 2022

*Contact:*

Raise an issue on the repository or contact [Caleb Lareau](mailto:clareau@stanford.edu)

### Streamlined execution

```

# Define reasonable parameters
THREADS=4
MERGEDIST=10
NREADS=10000000

# Set paths
REF=/path/to/bowtie2/reference
ENCODE_BL_FILE=/path/to/encode/blacklist

# Consider these carefully
MITOCHR="chrM" # update depending on your organism / reference genome
genome="hg19" # update depending on your organism / reference genome; 
# genome defines the prefix of output files; assumes "fasta/${genome}_mitochromosome.fa" exists

## DEPENDENCIES
# bowtie2
# macs2
# bedtools

# Simulate Reads from mitochondrial genome 
./art_illumina -ss NS50 -c $NREADS -i "fasta/${genome}_mitochromosome.fa" -l 20 -o "fastq/${genome}_dat"
rm "fastq/${genome}_dat.aln"
gzip "fastq/${genome}_dat.fq"

# Align to the full reference genome with bowtie2
bowtie2 -p $THREADS -x $REF -U "fastq/${genome}_dat.fq.gz" | samtools view -bS - | samtools sort -@ $THREADS - -o "bam/${out}.all.sorted.bam"
samtools index "bam/${genome}.all.sorted.bam"

# Extract non mitochondrial chromosomes
chrs=`samtools view -H "bam/${genome}.all.sorted.bam" | grep SQ | cut -f2 | sed 's/SN://g' | grep -v $MITOCHR`

# Generate clean .bam file 
samtools view -b "bam/${genome}.all.sorted.bam" -o "bam/${genome}.nomito.bam" `echo $chrs`
samtools index "bam/${genome}.nomito.bam"

# Call peaks on the other aligned reads
macs2 callpeak -t"bam/${genome}.nomito.bam" --nomodel --nolambda --keep-dup all -n "peaks/${genome}"

# Create the full blacklist file
cat $ENCODE_BL_FILE "peaks/${genome}_peaks.narrowPeak" | awk '{print $1"\t"$2"\t"$3}' | sortBed | mergeBed -i stdin -d $MERGEDIST  > "combinedBlacklist/${genome}.full.blacklist.bed"

```
