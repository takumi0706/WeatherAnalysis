#!/bin/zsh

# Author: Namir Garib
# Date: 2024-11-18

# Description:
# This script calculates weather metrics other than weather score for each city based on the extracted data.
# The metrics include average temperature, wind speed, humidity, sunshine hours, and precipitation.
# The metrics are saved to CSV files for each year and later used for charting and analysis.
# The files are saved in a separate directory for each metric.

export LANG=en_US.UTF-8

INPUT_FOLDER="../weather_metrics/comprehensive"
AVG_TEMP_RANKING="../weather_metrics/weather_scores/avg_temp"
WIND_RANKING="../weather_metrics/weather_scores/wind"
HUM_RANKING="../weather_metrics/weather_scores/humidity"
SUN_RANKING="../weather_metrics/weather_scores/sunshine_hours"
PREC_RANKING="../weather_metrics/weather_scores/precipitation"

DIRS=($AVG_TEMP_RANKING $WIND_RANKING $HUM_RANKING $SUN_RANKING $PREC_RANKING)

for DIR in $DIRS; do
    if [[ ! -d $DIR ]]; then
        mkdir -p "$DIR"
        echo "Created directory: $DIR"
    fi
done

for file in $INPUT_FOLDER/*.txt; do
    PLACE_NAME=$(basename "$file" .txt)
    echo "Processing $file..."

    while read -r line; do
        if [[ -z "$line" ]]; then
            continue
        fi

        values=$(echo "$line" | awk '{print $1, $2, $6, $7, $8, $9}')
        read -r year avg_temp wind hum sun prec <<< "$values"

        # echo "Debug: year=$year avg_temp=$avg_temp wind=$wind humidity=$hum sunshine=$sun precipitation=$prec"
        echo "$PLACE_NAME,$avg_temp" >> "$AVG_TEMP_RANKING/$year.csv"
        echo "$PLACE_NAME,$wind" >> "$WIND_RANKING/$year.csv"
        echo "$PLACE_NAME,$hum" >> "$HUM_RANKING/$year.csv"
        echo "$PLACE_NAME,$sun" >> "$SUN_RANKING/$year.csv"
        echo "$PLACE_NAME,$prec" >> "$PREC_RANKING/$year.csv"
    done < "$file"
done

echo "Metrics successfully calculated."