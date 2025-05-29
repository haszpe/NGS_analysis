#!/bin/bash

REF="/mnt/ngs-analysis/Data/ref_data/Homo_sapiens.GRCh38.dna.primary_assembly.fa"
OUTDIR="Data/GatkVariantCalling"
mkdir -p "$OUTDIR"

for BSQR_BAM in Data/BQSR/*/*.bam; do
    SAMPLE=$(basename "$BSQR_BAM" _recal_bsqr.bam)
    echo "----------------------------------------------------------"
    echo "Variant Calling for: $BSQR_BAM"

    gatk HaplotypeCaller \
        -R "$REF" \
        -I "$BSQR_BAM" \
        -O "${OUTDIR}/${SAMPLE}_variants.g.vcf.gz" \
        -ERC GVCF

    echo "Variant Calling for: $SAMPLE finished successfully"
    echo "-----------------------------------------------------------"
done