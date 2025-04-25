#!/bin/bash

TRIMMED_DIR="/mnt/ngs-analysis/Data/trimmed_data"
ALIGN_DIR="/mnt/ngs-analysis/Data/align_data"
REF="/mnt/ngs-analysis/Data/ref_data/Homo_sapiens.GRCh38.dna.primary_assembly.fa"


for R1 in "$TRIMMED_DIR"/*_forward_paired.fq; do
    base_name=$(basename $R1 "_forward_paired.fq")   
    R2="$TRIMMED_DIR/${base_name}_reverse_paired.fq"

    header_line=$(head -n 1 "$R1")
    instrument=$(echo "$header_line" | cut -d ' ' -f2 | cut -d ':' -f1)
    lane=$(echo "$header_line" | cut -d ' ' -f2 | cut -d ':' -f4)

    echo "Aligning sample: $base_name"

    bwa mem -R "@RG\\tID:${instrument}.${lane}\\tSM:${base_name}\\tPL:ILLUMINA\\tLB:lib1\\tPU:${instrument}.${lane}.${base_name}" ${REF} ${R1} ${R2} > "$ALIGN_DIR/${base_name}.sam"

    echo "Aligning completed for ${base_name}"
done