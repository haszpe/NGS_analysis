#!/bin/bash

INPUT_DIR="Data/post_align"
REF="/mnt/ngs-analysis/Data/ref_data/Homo_sapiens.GRCh38.dna.primary_assembly.fa"
OUTPUT_BASE_DIR="Data/BQSR"

for FILE in "$INPUT_DIR"/*/*.final.bam; do
    echo "Recalibration: $FILE"

    BASENAME=$(basename "$FILE" .final.bam)
    INPUT_SUBDIR=$(basename "$(dirname "$FILE")")
    OUTPUT_DIR="$OUTPUT_BASE_DIR/$INPUT_SUBDIR"

    mkdir -p "$OUTPUT_DIR"

    RECAL_PREFIX="$OUTPUT_DIR/${BASENAME}_recal"

    gatk BaseRecalibrator \
        -I "$FILE" \
        -R "$REF" \
        --known-sites "/mnt/ngs-analysis/Data/known_sites/homo_sapiens_somatic.vcf" \
        -O "${RECAL_PREFIX}_bsqr_raw.table"

    gatk ApplyBQSR \
        -R "$REF" \
        -I "$FILE" \
        --bqsr-recal-file "${RECAL_PREFIX}_bsqr_raw.table" \
        -O "${RECAL_PREFIX}_bsqr.bam"

    samtools index "${RECAL_PREFIX}_bsqr.bam"

    #echo "BQSR completed for: $BASENAME"
    echo "--------------------------------------------"
done
