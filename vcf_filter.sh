#!/bin/bash

REF="/mnt/ngs-analysis/Data/ref_data/Homo_sapiens.GRCh38.dna.primary_assembly.fa"

FOLDER_GATK="Data/GatkVariantCalling"
FOLDER_BCF="Data/BcfVariantCalling"

FILES=( "$FOLDER_GATK"/*_variants.vcf "$FOLDER_BCF"/*_variants.vcf )

for VCF in "${FILES[@]}"; do
  BASENAME=$(basename "$VCF" .vcf)
  DIRNAME=$(dirname "$VCF")

  FILTERED_VCF="${DIRNAME}/${BASENAME}_filtered.vcf"
  CLEAN_VCF="${DIRNAME}/${BASENAME}_clean.vcf"

  echo "Processing: $VCF"

  gatk VariantFiltration \
    -R "$REF" \
    -V "$VCF" \
    --filter-expression "QUAL < 30.0" \
    --filter-name "LowQual" \
    --filter-expression "DP > 500" \
    --filter-name "HighDepth" \
    --filter-expression "DP < 10" \
    --filter-name "LowDepth" \
    --filter-expression "vc.getNAlleles() > 2" \
    --filter-name "MultiAllelic" \
    -O "$FILTERED_VCF"

  gatk SelectVariants \
    -R "$REF" \
    -V "$FILTERED_VCF" \
    --exclude-filtered \
    -O "$CLEAN_VCF"

  echo "Finished filtering: $VCF → $CLEAN_VCF"
  echo "------------------------------------------------------"
done
