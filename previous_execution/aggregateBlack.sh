#!/bin/bash

DIST=10

mkdir -p combinedBlacklist

cat encodeBlacklist/hg19.encode.blacklist.bed peaks/hg19_peaks.narrowPeak | awk '{print $1"\t"$2"\t"$3}' | sortBed | mergeBed -i stdin -d $DIST  > combinedBlacklist/hg19.full.blacklist.bed
cat encodeBlacklist/mm9.encode.blacklist.bed peaks/mm9_peaks.narrowPeak | awk '{print $1"\t"$2"\t"$3}' | sortBed | mergeBed -i stdin -d $DIST  > combinedBlacklist/mm9.full.blacklist.bed
cat encodeBlacklist/hg38.encode.blacklist.bed peaks/hg38_peaks.narrowPeak | awk '{print $1"\t"$2"\t"$3}' | sortBed | mergeBed -i stdin -d $DIST  > combinedBlacklist/hg38.full.blacklist.bed
cat encodeBlacklist/mm10.encode.blacklist.bed peaks/mm10_peaks.narrowPeak | awk '{print $1"\t"$2"\t"$3}' | sortBed | mergeBed -i stdin -d $DIST  > combinedBlacklist/mm10.full.blacklist.bed

# make species mixed blacklist
awk '{print substr($0,4)}' combinedBlacklist/hg19.full.blacklist.bed | awk '{print "human"$0}' > combinedBlacklist/hg19_mm10_c.full.blacklist.bed

awk '{print substr($0,4)}' combinedBlacklist/mm10.full.blacklist.bed | awk '{print "mouse"$0}' >> combinedBlacklist/hg19_mm10_c.full.blacklist.bed



