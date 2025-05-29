#!/bin/bash

REF="/mnt/ngs-analysis/Data/ref_data/Homo_sapiens.GRCh38.dna.primary_assembly.fa"
OUTDIR="Data/BcfVariantCalling"
mkdir -p "$OUTDIR"

for BSQR_BAM in Data/BQSR/*/*.bam; do
    SAMPLE=$(basename "$BSQR_BAM" _recal_bsqr.bam)
    echo "----------------------------------------------------------"
    echo "Variant Calling for: $BSQR_BAM"

    bcftools mpileup -Ou -f "$REF" "$BSQR_BAM" \
        | bcftools call -mv -Oz -o "${OUTDIR}/${SAMPLE}_variants.vcf.gz"

    bcftools index "${OUTDIR}/${SAMPLE}_variants.vcf.gz"

    echo "BCF Variant Calling for: $SAMPLE finished successfully"
    echo "-----------------------------------------------------------"
done