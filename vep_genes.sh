#!/bin/bash


for file in Data/VEP/*.vep.txt; do

    BASENAME=$(basename "$file" .vep.txt)
    OUTPUT="Data/VEP/${BASENAME}_genes_list.txt"

    cut -f4 "$file" | grep -v '^#' | grep -v '^$' | sort | uniq > "$OUTPUT"

done

echo "Getting genes lists finished"