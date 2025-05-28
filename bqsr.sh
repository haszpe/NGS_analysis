#!/bin/bash

INPUT_DIR="Data/post_align"
REF="./Data/ref_data/Homo_sapiens.GRCh38.dna.primary_assembly.fa"
OUTPUT_BASE_DIR="Data/BQSR"

for FILE in "$INPUT_DIR"/*/*.final.bam; do
    echo "Processing: $FILE"

    BASENAME=$(basename "$FILE" .final.bam)
    INPUT_SUBDIR=$(basename "$(dirname "$FILE")")
    OUTPUT_DIR="$OUTPUT_BASE_DIR/$INPUT_SUBDIR"

    mkdir -p "$OUTPUT_DIR"

    RECAL_PREFIX="$OUTPUT_DIR/${BASENAME}_recal"


	# Tutaj jest problem z referencyjnym a VCF - nazwy się nie zgadzają podobno, nie wiem jak to zmienić 
    # Pobranie known sites : wget https://ftp.ensembl.org/pub/release-114/variation/vcf/homo_sapiens/homo_sapiens_somatic.vcf.gz
    gatk IndexFeatureFile -I ./Data/known_sites/homo_sapiens_somatic.vcf

    gatk BaseRecalibrator \
        -I "$FILE" \
        -R "$REF" \
        --known-sites "./Data/known_sites/homo_sapiens_somatic.vcf" \
        -O "${RECAL_PREFIX}_raw.table"

    gatk ApplyBQSR \
        -R "$REF" \
        -I "$FILE" \
        --bqsr-recal-file "${RECAL_PREFIX}_raw.table" \
        -O "${RECAL_PREFIX}_bsqr.bam"

    gatk BaseRecalibrator \
        -I "${RECAL_PREFIX}_bsqr.bam" \
        -R "$REF" \
        --known-sites "./Data/known_sites/homo_sapiens_somatic.vcf" \
        -O "${RECAL_PREFIX}_after.table"

    gatk AnalyzeCovariates \
        -before "${RECAL_PREFIX}_raw.table" \
        -after "${RECAL_PREFIX}_after.table" \
        -plots "${RECAL_PREFIX}_covariates.pdf"

    gatk HaplotypeCaller \
        -R "$REF" \
        -I "${RECAL_PREFIX}_bsqr.bam" \
        -O "${RECAL_PREFIX}_variants.vcf.gz" \
        -ERC GVCF

    #echo "BQSR completed for: $BASENAME"
    echo "--------------------------------------------"
done
