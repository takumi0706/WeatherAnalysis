#!/bin/zsh

# Author: Namir Garib
# Date: 2024-11-15

# Description:
# This script extracts the list of observation stations for each city in the list.
# It extracts the observation stations for each city and saves the results to a CSV file.
# It also saves the results to a text file in the format "AMED_NO GND_NO CITY_NAME", for easier processing.
# The script excludes the observation station with AMED_NO 23281 (Takamatsu), as it is a duplicate.

# I/O HANDLER
INPUT_FILE="../02_data/obs_list.csv" #入力フォルダ
OUTPUT_CSV="../02_data/places.csv"　#CSVフォルダ
OUTPUT_TXT="../02_data/places.txt"　#TXTフォルダ

places=(
    "SAPPORO" "AOMORI" "AKITA" "MORIOKA" "SENDAI" "YAMAGATA" "FUKUSHIMA"
    "MITO" "UTSUNOMIYA" "MAEBASHI" "KUMAGAYA" "CHIBA" "TOKYO" "YOKOHAMA"
    "NIIGATA" "TOYAMA" "KANAZAWA" "FUKUI" "KOFU" "NAGANO" "GIFU" "SHIZUOKA"
    "NAGOYA" "TSU" "HIKONE" "KYOTO" "OSAKA" "KOBE" "NARA" "WAKAYAMA" "TOTTORI"
    "MATSUE" "OKAYAMA" "HIROSHIMA" "YAMAGUCHI" "TOKUSHIMA" "TAKAMATSU"
    "MATSUYAMA" "KOCHI" "FUKUOKA" "SAGA" "NAGASAKI" "KUMAMOTO" "OITA"
    "MIYAZAKI" "KAGOSHIMA" "NAHA"
)

for place in "${places[@]}"; do
    grep -w "$place" "$INPUT_FILE" | grep -v '^23281' | grep -v '-' | sort -u >> "$OUTPUT_CSV"
done

awk -F ',' '{printf "%s %s %s\n", $1, $2, $4}' "$OUTPUT_CSV" >> "$OUTPUT_TXT"

echo "Extraction completed. Results saved to $OUTPUT_CSV and $OUTPUT_TXT."