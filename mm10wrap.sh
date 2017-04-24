#!/bin/bash

REF_hg38="/data/aryee/pub/genomes/bowtie2_index_hg38/hg38"
REF_hg19="/data/aryee/pub/genomes/bowtie2_index/hg19"
REF_mm10="/data/aryee/pub/genomes/mm10/bt2/mm10"
REF_mm9="/data/aryee/pub/genomes/bowtie2_index_mm9/mm9"

REF=$REF_mm10
FQ="fastq/mm10_dat.fq.gz"
out="mm10"

sh runStuff.sh $REF $FQ $out
