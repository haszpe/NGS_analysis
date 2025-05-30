#!/bin/bash
################################################################################
# Directories
REF_DIR="Data/ref_data"
KNOWN_SITES_DIR="Data/known_sites"
RAW_DIR="Data/raw_data"
ADAPTERS_DIR="Data/adapters"

#mkdir -p ${REF_DIR}
#mkdir -p ${KNOWN_SITES_DIR}
mkdir -p ${RAW_DIR}
#mkdir -p ${ADAPTERS_DIR}
################################################################################
# Downloading data
# 1. Download dbSNP VCF if it doesn't exist
if [ ! -f "${KNOWN_SITES_DIR}/Homo_sapiens_assembly38.dbsnp138.vcf" ]; then
    gsutil cp gs://gcp-public-data--broad-references/hg38/v0/Homo_sapiens_assembly38.dbsnp138.vcf.gz "${KNOWN_SITES_DIR}/Homo_sapiens_assembly38.dbsnp138.vcf.gz"
    gzip -d ${KNOWN_SITES_DIR}/Homo_sapiens_assembly38.dbsnp138.vcf.gz
    gatk IndexFeatureFile -I ${KNOWN_SITES_DIR}/Homo_sapiens_assembly38.dbsnp138.vcf
else
    echo "File already exists: ${KNOWN_SITES_DIR}/Homo_sapiens_assembly38.dbsnp138.vcf.gz"
fi

# 2. Download Ensembl reference FASTA if it doesn't exist
if [ ! -f "${REF_DIR}/Homo_sapiens.GRCh38.dna.primary_assembly.fa" ]; then
    wget -O "${REF_DIR}/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz" ftp://ftp.ensembl.org/pub/release-110/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
    gzip -d ${REF_DIR}/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
    bwa index -a bwtsw Homo_sapiens.GRCh38.dna.primary_assembly.fa
else
    echo "File already exists: ${REF_DIR}/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz"
fi

# 3. Download Trimmomatic adapter file if it doesn't exist
if [ ! -f "TruSeq3-PE.fa" ]; then
    wget -c https://raw.githubusercontent.com/usadellab/Trimmomatic/main/adapters/TruSeq3-PE.fa
else
    echo "File already exists: TruSeq3-PE.fa"
fi


# Download SRR32572150 if it doesn't exist
if [ ! -f "${RAW_DIR}/SRR32572150/SRR32572150.sra" ]; then
    prefetch SRR32572150 --output-directory "$RAW_DIR"
    fasterq-dump -v --split-3 -e 5 --outdir ${RAW_DIR} ${RAW_DIR}/SRR32572150
else
    echo "File already exists: ${RAW_DIR}/SRR32572150.sra"
fi

# Download SRR32572151 if it doesn't exist
if [ ! -f "${RAW_DIR}/SRR32572151/SRR32572151.sra" ]; then
    prefetch SRR32572151 --output-directory "$RAW_DIR"
    fasterq-dump -v --split-3 -e 5 --outdir ${RAW_DIR} ${RAW_DIR}/SRR32572151
else
    echo "File already exists: ${RAW_DIR}/SRR32572151.sra"
fi

gzip ${RAW_DIR}/*.fastq
################################################################################

if [ ! -f "${KNOWN_SITES_DIR}/Homo_sapiens_assembly38_fixed.dbsnp138.vcf" ]; then
    echo "chr1   1
    chr2    2
    chr3    3
    chr4    4
    chr5    5
    chr6    6
    chr7    7
    chr8    8
    chr9    9
    chr10   10
    chr11   11
    chr12   12
    chr13   13
    chr14   14
    chr15   15
    chr16   16
    chr17   17
    chr18   18
    chr19   19
    chr20   20
    chr21   21
    chr22   22
    chrX    X
    chrY    Y
    chrM    MT"  > index_map.txt

    echo "fixing known sites"
    
    bcftools annotate \
    --rename-chrs index_map.txt \
    -o ${KNOWN_SITES_DIR}/Homo_sapiens_assembly38_fixed.dbsnp138.vcf \
    ${KNOWN_SITES_DIR}/Homo_sapiens_assembly38.dbsnp138.vcf
else
    echo "Fixed file already present at ${KNOWN_SITES_DIR}/Homo_sapiens_assembly38_fixed.dbsnp138.vcf"
fi
