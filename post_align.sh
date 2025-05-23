#!/bin/bash

INPUT_DIR="Data/align_data"
mkdir -p "Data/post_align"

for SAM_FILE in "$INPUT_DIR"/*.sam; do
    BASENAME=$(basename "$SAM_FILE" .sam)
    echo "File to be processed: $BASENAME.sam"

    OUTPUT_DIR="Data/post_align/$BASENAME"
    mkdir -p "$OUTPUT_DIR"

    FINAL_BAM="$OUTPUT_DIR/${BASENAME}.final.bam"
    BAM_INDEX="${FINAL_BAM}.bai"
    FLAGSTAT="$OUTPUT_DIR/${BASENAME}.flagstat.txt"
    DEPTH="$OUTPUT_DIR/${BASENAME}.depth.txt"

    samtools sort -n -o "$OUTPUT_DIR/${BASENAME}.sortedname.bam" "$SAM_FILE"
    samtools fixmate -m "$OUTPUT_DIR/${BASENAME}.sortedname.bam" "$OUTPUT_DIR/${BASENAME}.fixmate.bam"
    samtools sort -o "$OUTPUT_DIR/${BASENAME}.sorted.bam" "$OUTPUT_DIR/${BASENAME}.fixmate.bam"
    samtools markdup -r "$OUTPUT_DIR/${BASENAME}.sorted.bam" "$FINAL_BAM"

    samtools index "$FINAL_BAM"
    samtools flagstat "$FINAL_BAM" > "$FLAGSTAT"
    samtools depth "$FINAL_BAM" > "$DEPTH"

    echo "File processing ended successfully: $BASENAME"
    echo "--------------------------------"
done

