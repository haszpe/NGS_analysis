#!/bin/bash

INPUT_DIR="Data/post_align"
REF="/mnt/ngs-analysis/Data/ref_data/Homo_sapiens.GRCh38.dna.primary_assembly.fa"
OUTPUT_BASE_DIR="Data/BQSR"

for FILE in "$INPUT_DIR"/*/*.final.bam; do
    echo "Processing: $FILE"

    BASENAME=$(basename "$FILE" .final.bam)
    INPUT_SUBDIR=$(basename "$(dirname "$FILE")")
    OUTPUT_DIR="$OUTPUT_BASE_DIR/$INPUT_SUBDIR"

    mkdir -p "$OUTPUT_DIR"

    RECAL_TABLE="$OUTPUT_DIR/${BASENAME}.recal.table"
    RECAL_BAM="$OUTPUT_DIR/${BASENAME}.recal.bam"


	# Tutaj jest problem z referencyjnym a VCF - nazwy się nie zgadzają podobno, nie wiem jak to zmienić 

    gatk BaseRecalibrator \
        -I "$FILE" \
        -R "$REF" \
        --known-sites Data/vcf/homo_sapiens-ch7.vcf \
        -O "$RECAL_TABLE"

    gatk ApplyBQSR \
        -R "$REF" \
        -I "$FILE" \
        --bqsr-recal-file "$RECAL_TABLE" \
        -O "$RECAL_BAM"

    echo "BQSR completed for: $BASENAME"
    echo "--------------------------------------------"
done
