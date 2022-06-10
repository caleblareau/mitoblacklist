#!/bin/bash

THREADS=4
ChrNameLength=6

REF=$1
FQ=$2
out=$3

bowtie2 -p $THREADS -x $REF -U $FQ | samtools view -bS - | samtools sort -@ $THREADS - -o "bam/${out}.all.sorted.bam"
samtools index "bam/${out}.all.sorted.bam"

chrs=`samtools view -H "bam/${out}.all.sorted.bam" | grep SQ | cut -f2 | sed 's/SN://g' | grep -v chrM | grep -v MT | grep -v Y | awk -v CNL="$ChrNameLength" '{if(length($0)<CNL)print}'`

# Generate clean .bam file 
samtools view -b "bam/${out}.all.sorted.bam" -o "bam/${out}.nomito.bam" `echo $chrs`
samtools index "bam/${out}.nomito.bam"

rm "bam/${out}.all.sorted.bam"
rm "bam/${out}.all.sorted.bam.bai"


