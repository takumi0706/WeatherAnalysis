#!/bin/zsh

INPUT_FILE="/Volumes/BDP20240531/data/Structured_data/amed_2012.txt.gz"
OUTPUT_FILE="./KANAZAWA.txt"

# Extract data for the city
gzcat "$INPUT_FILE" | rg -w "56227 47605" > "$OUTPUT_FILE"