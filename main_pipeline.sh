#!/bin/bash

set -e  # Zatrzymaj skrypt jeśli którykolwiek z poniższych poleceń zakończy się błędem

echo "0. Pobranie i przygotowanie referencji"
./prepare_references.sh

echo "1. Trimming..."
./trimming.sh

echo "2. Alignment..."
./alignment.sh

echo "3. Post-alignment processing..."
./post_align.sh

echo "4. Base Quality Score Recalibration (BQSR)..."
./bqsr.sh

echo "5. Analyze covariates..."
./analyze_covariates.sh

echo "6. GATK variant calling..."
./gatk_variant_calling.sh

echo "7. BCF variant calling..."
./bcf_variant_calling.sh

echo "8. VCF quality control (step 1)..."
./vcf_quality_control1.sh

echo "9. VCF filtering..."
./vcf_filter.sh

echo "10. VEP gene annotation..."
./vep_genes.sh

echo "Wszystkie kroki zostały zakończone pomyślnie."
