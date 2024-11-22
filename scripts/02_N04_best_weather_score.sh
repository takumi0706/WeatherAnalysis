#!/bin/zsh

# Author: Namir Garib
# Date: 2024-11-18

# Description:
# This script calculates the weather scores for each city based on the normalized weather metrics.
# It assigns weights to each weather metric and calculates the total score for each city.
# The scores are saved to a CSV file for each year.
# The files are later used for charting and analysis.

# **** IMPORTANT ****
# =============================================================================================
# NOTE: The weights are arbitrary and can be adjusted based on the importance of each metric.
# In this example, we assigned weights based on our subjective understanding of the impact of 
# each metric on the overall weather experience.
# It is not a scientifically validated method, but a simple example for demonstration purposes.
# =============================================================================================

export LANG=en_US.UTF-8

INPUT_FOLDER="../weather_metrics/comprehensive_norm"
OUTPUT_FOLDER="../weather_metrics/weather_scores"

if [[ ! -d $OUTPUT_FOLDER ]]; then
    mkdir -p "$OUTPUT_FOLDER"
fi

# WEIGHTS
WEIGHT_AVG_TEMP=0.25
WEIGHT_TEMP_RANGE=0.2
WEIGHT_WIND=0.15
WEIGHT_HUMIDITY=0.15
WEIGHT_SUNSHINE=0.15
WEIGHT_PRECIPITATION=0.1

for file in $INPUT_FOLDER/*.txt; do
    PLACE_NAME=$(basename "$file" .txt)
    echo "Processing $file..."

    while read -r line; do
        if [[ -z "$line" ]]; then
            continue
        fi
        
        values=$(echo "$line" | awk '{print $1, $2, $5, $6, $7, $8, $9}')
        read -r year avg_temp temp_range wind hum sun prec <<< "$values"

        echo "Debug: year=$year avg_temp=$avg_temp temp_range=$temp_range wind=$wind humidity=$hum sunshine=$sun precipitation=$prec"

        # CALCULATE METRIC SCORES
        if (( $(echo "$avg_temp < 0.5" | bc) )); then
            deviation=$(echo "scale=4; 0.5 - $avg_temp" | bc)
        else
            deviation=$(echo "scale=4; $avg_temp - 0.5" | bc)
        fi
        score_avg_temp=$(echo "scale=4; $WEIGHT_AVG_TEMP * (1 - 2 * $deviation)" | bc)
        score_temp_range=$(echo "scale=4; $WEIGHT_TEMP_RANGE * (1 - $temp_range)" | bc)
        score_wind=$(echo "scale=4; $WEIGHT_WIND * (1 - $wind)" | bc)
        score_hum=$(echo "scale=4; $WEIGHT_HUMIDITY * (1 - $hum)" | bc)
        score_sun=$(echo "scale=4; $WEIGHT_SUNSHINE * $sun" | bc)
        score_prec=$(echo "scale=4; $WEIGHT_PRECIPITATION * (1 - $prec)" | bc)

        # Calculate the total score
        total_score=$(echo "scale=4; ($score_avg_temp + $score_temp_range + $score_wind + $score_hum + $score_sun + $score_prec)*100" | bc)

        # Write to a temporary file
        echo "$PLACE_NAME,$total_score" >> "$OUTPUT_FOLDER/$year.csv"
    done < "$file"
done

echo "Weather scores have been calculated, sorted, and saved to $OUTPUT_FOLDER."