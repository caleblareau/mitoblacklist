#!/bin/bash

macs2 callpeak -t bam/hg19.nomito.bam  --nomodel --nolambda --keep-dup all -g hs -n peaks/hg19
macs2 callpeak -t bam/hg38.nomito.bam  --nomodel --nolambda --keep-dup all -g hs -n peaks/hg38

macs2 callpeak -t bam/mm9.nomito.bam  --nomodel --nolambda --keep-dup all -g mm -n peaks/mm9
macs2 callpeak -t bam/mm10.nomito.bam  --nomodel --nolambda --keep-dup all -g mm -n peaks/mm10
