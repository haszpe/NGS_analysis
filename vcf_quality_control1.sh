#!/bin/bash

# Foldery z plikami VCF
FOLDER_GATK="Data/GatkVariantCalling"
FOLDER_BCF="Data/BcfVariantCalling"

FILES=( "$FOLDER_GATK"/*_variants.vcf "$FOLDER_BCF"/*_variants.vcf )

for VCF in "${FILES[@]}"; do

  BASENAME=$(basename "$VCF" .vcf)
  DIRNAME=$(dirname "$VCF")

  OUTPUT_STATS="${DIRNAME}/stats_${BASENAME}.txt"
  OUTPUT_PLOTS="${DIRNAME}/stats_${BASENAME}"

  bcftools stats "$VCF" > "$OUTPUT_STATS"

  
done

mkdir -p "Data/multiqc_vcf_stats"
multiqc Data/BcfVariantCalling -o "Data/multiqc_vcf_stats"
multiqc Data/GatkVariantCalling -o "Data/multiqc_vcf_stats"


echo "Finished stats for VCFs"
echo "--------------------------------------------------------------------------------------"