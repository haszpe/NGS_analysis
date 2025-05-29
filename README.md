# [Monoclonal antibodies derived from B cells in subjects with cystic fibrosis reduce _Pseudomonas aeruginosa_ burden in mice](https://pmc.ncbi.nlm.nih.gov/articles/PMC11030358/)** 

  Projekt koncentruje się na opracowaniu wysokoaffinicznych przeciwciał monoklonalnych (mAbs) skierowanych przeciwko PcrV — czynnikowi wirulencji Pseudomonas aeruginosa (PA).
W ramach tego projektu zastosowano innowacyjną strategię izolacji PcrV-specyficznych limfocytów B z krwi osób z mukowiscydozą, u których zachowana jest prawidłowa odpowiedź adaptacyjna. Przy użyciu tetrameru PcrV i technik sortowania pojedynczych komórek oraz sekwencjonowania łańcuchów zmiennych receptorów BCR, zidentyfikowano sekwencje umożliwiające produkcję wysokospecyficznych przeciwciał.  Otrzymane przeciwciała monoklonalne wykazywały silną aktywność przeciwko PA w modelu zapalenia płuc u myszy. 

  Kluczowy problem badawczy dotyczył nieskuteczności dotychczasowych terapii opartych na przeciwciałach przeciwko PcrV.
Projekt odpowiada na pytanie, czy izolacja naturalnych, wysokospecyficznych przeciwciał przeciwko PcrV z ludzi, a konkretnie z pwCF, pozwoli na uzyskanie bardziej skutecznych kandydatów terapeutycznych. Celem było nie tylko stworzenie nowych przeciwciał o wysokim powinowactwie, ale także lepsze zrozumienie odpowiedzi humoralnej przeciwko PA u pacjentów z mukowiscydozą.

## Etapy analizy
#### 1. Pobranie surowych danych eksperymentalnych z użyciem Fasta-Dump
Dane zostały ograniczone do dwóch próbek pochodzących od dwóch różnych osób, wykazujących różne natężenie zakażeń PA.

`fastq-dump --split-files -X 1000000 --gzip --progress SRR32572150 SRR32572151`

#### 2. Pobranie  danych referencyjnych i VCF 
Homo Sapiens Primary Assembly:


`wget ftp://ftp.ensembl.org/pub/release-110/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz`

Homo Sapiens Somatic VCF:

`wget https://ftp.ensembl.org/pub/release-114/variation/vcf/homo_sapiens/homo_sapiens_somatic.vcf.gz`

#### 3. Weryfikacja jakości danych przy pomocy FastQC 
`fastqc -o reports/ *.fastq`

#### 4. Trymowanie danych przy pomocy Trimmomatic (skrypt trimming.sh)
Z wykorzystaniem parametrów trymowania:
- PE -phred33
- ILLUMINACLIP:/usr/local/bin/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10
- LEADING:10 TRAILING:10 SLIDINGWINDOW:5:30 MINLEN:70

#### 5. Weryfikacja jakości strymowanych danych przy pomocy FastQC i wizualizacja raportów z MultiGC
`tutaj dorzucić zdjęcie`

#### 6. Alignment (skrypt alignment.sh) i dodanie Read Groups
Nagłówki danych użyte do zidentyfikowania ReadGroups:

```
@SRR32572147.1 M02172:273:000000000-DJPRD:1:1101:15616:1365 length=251
```
Alignment przeprowadzony z wykorzystaniem `bwa mem`

`bwa mem -R "@RG\\tID:${instrument}.${lane}\\tSM:${base_name}\\tPL:ILLUMINA\\tLB:lib1\\tPU:${instrument}.${lane}.${base_name}" ${REF} ${R1} ${R2} > "$ALIGN_DIR/${base_name}.sam"`

#### 7. Post-alignemnt (skrypt post_align.sh) 
Etap składający się z kilku kroków (wykorzystujących pakiet samtools):
- sort
- fixmate
- sort
- markdup
- index
- flagstat
- septh

#### 8. Base Quality Score Recalibration with GATK (skrypt bgsr.sh)
Z wykorzystaniem narzędzi BaseRecalibration i ApplyBQSR z pakietu GATK oraz indexowanie plików .bam z użyciem samtools.

#### 9. Analiza kowariancji (skrypt analyze_covariates.sh)
Przeprowadza ponowanie BaseRecalibraiton w celu porównania jakości wyników BQSR. 

# TODO: dodać plot z raportu

#### 10. Variant Calling V.1 z użyciem HaplotypeCaller GATK (skrypt gatk_variant_calling.sh) 

#### 11. Variant Calling V.2 z użyciem mpileup BCFTools (skrypt bcf_variant_calling.sh) 




