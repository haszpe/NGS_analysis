#!/bin/bash

input_dir="/data/raw_data"
output_dir="/data/trimmed"

for r1 in $input_dir/*_1.fastq.gz; do
    base_name=$(basename $r1 "_1.fastq.gz")   
    r2="$input_dir/${base_name}_2.fastq.gz"
    
    forward_paired="$output_dir/${base_name}_forward_paired.fq"
    forward_unpaired="$output_dir/${base_name}_forward_unpaired.fq"
    reverse_paired="$output_dir/${base_name}_reverse_paired.fq"
    reverse_unpaired="$output_dir/${base_name}_reverse_unpaired.fq"
    
    java -jar /usr/local/bin/trimmomatic.jar PE -phred33 \
        $r1 $r2 \
        $forward_paired $forward_unpaired \
        $reverse_paired $reverse_unpaired \
        ILLUMINACLIP:/usr/local/bin/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10 \
        LEADING:10 TRAILING:10 SLIDINGWINDOW:5:30 MINLEN:70
    
    echo "Trimming completed for ${base_name}"
done

