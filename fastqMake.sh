#!/bin/bash

NREADS=10000000

genomes="hg19 hg38 mm9 mm10"

for genome in $genomes
do
	./exec/art_illumina -ss NS50 -c $NREADS -i "fasta/${genome}_chrM.fa" -l 20 -o "fastq/${genome}_dat"
	rm "fastq/${genome}_dat.aln"
	gzip "fastq/${genome}_dat.fq"
done
