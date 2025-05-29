#!/bin/bash

REF="/mnt/ngs-analysis/Data/ref_data/Homo_sapiens.GRCh38.dna.primary_assembly.fa"
KNOWN="/mnt/ngs-analysis/Data/known_sites/homo_sapiens_somatic.vcf"
BQSR_DIR="Data/BQSR"

for BSQR_BAM in "$BQSR_DIR"/*/*_recal_bsqr.bam; do
    RECAL_PREFIX="${BSQR_BAM%.bam}"
    echo "Analyzing covariates for: $RECAL_PREFIX"

    gatk BaseRecalibrator \
        -I "$BSQR_BAM" \
        -R "$REF" \
        --known-sites "$KNOWN" \
        -O "${RECAL_PREFIX}_after.table"

    gatk AnalyzeCovariates \
        -before "${RECAL_PREFIX}_raw.table" \
        -after "${RECAL_PREFIX}_after.table" \
        -plots "${RECAL_PREFIX}_covariates.pdf"
done
