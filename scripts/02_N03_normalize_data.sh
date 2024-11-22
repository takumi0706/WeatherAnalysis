#!/bin/zsh

# Author: Namir Garib
# Date: 2024-11-17

# Description:
# This script normalizes the weather metrics data for each city based on the global minimum and maximum values.
# It calculates the normalized values for average temperature, minimum temperature, maximum temperature, temperature range,
# wind speed, humidity, sunshine duration, and precipitation.
# The normalized values are saved in a new directory with the same structure as the input directory.

INPUT_FOLDER="../weather_metrics/comprehensive"
OUTPUT_FOLDER="../weather_metrics/comprehensive_norm"

if [[ ! -d $OUTPUT_FOLDER ]]; then
    echo "Output directory does not exist. Creating $OUTPUT_FOLDER..."
    mkdir -p "$OUTPUT_FOLDER"
fi

# VARIABLES TO SAVE GLOBAL VALUES
GLOBAL_MIN_AVG_TEMP=100.0
GLOBAL_MAX_AVG_TEMP=-100.0
GLOBAL_MIN_AVG_TEMP_PLACE=""
GLOBAL_MAX_AVG_TEMP_PLACE=""

GLOBAL_MIN_MIN_TEMP=100.0
GLOBAL_MAX_MIN_TEMP=-100.0
GLOBAL_MIN_MIN_TEMP_PLACE=""
GLOBAL_MAX_MIN_TEMP_PLACE=""

GLOBAL_MIN_MAX_TEMP=100.0
GLOBAL_MAX_MAX_TEMP=-100.0
GLOBAL_MIN_MAX_TEMP_PLACE=""
GLOBAL_MAX_MAX_TEMP_PLACE=""

GLOBAL_MIN_TEMP_RANGE=100.0
GLOBAL_MAX_TEMP_RANGE=0.0
GLOBAL_MIN_TEMP_RANGE_PLACE=""
GLOBAL_MAX_TEMP_RANGE_PLACE=""

GLOBAL_MIN_WIND=20.0
GLOBAL_MAX_WIND=0.0
GLOBAL_MIN_WIND_PLACE=""
GLOBAL_MAX_WIND_PLACE=""

GLOBAL_MIN_HUM=100.0
GLOBAL_MAX_HUM=0.0
GLOBAL_MIN_HUM_PLACE=""
GLOBAL_MAX_HUM_PLACE=""

GLOBAL_MIN_SUN=100000.0
GLOBAL_MAX_SUN=0.0
GLOBAL_MIN_SUN_PLACE=""
GLOBAL_MAX_SUN_PLACE=""

GLOBAL_MIN_PREC=100000.0
GLOBAL_MAX_PREC=0.0
GLOBAL_MIN_PREC_PLACE=""
GLOBAL_MAX_PREC_PLACE=""

for file in $INPUT_FOLDER/*.txt; do
  PLACE_NAME=$(basename "$file" .txt)
  echo "Processing $file"

  while IFS=' ' read -r year avg_temp min_temp max_temp range wind hum sun prec; do
      # DEBUG: SKIP HEADER (There is no header in our case)
      if [[ $year == "Year" ]]; then
          continue
      fi

      # DEBUG: All values have to be numeric
      if [[ ! $avg_temp =~ ^[0-9]+(\.[0-9]+)?$ || ! $min_temp =~ ^[0-9]+(\.[0-9]+)?$ || \
            ! $max_temp =~ ^[0-9]+(\.[0-9]+)?$ || ! $range =~ ^[0-9]+(\.[0-9]+)?$ || \
            ! $wind =~ ^[0-9]+(\.[0-9]+)?$ || ! $hum =~ ^[0-9]+(\.[0-9]+)?$ || \
            ! $sun =~ ^[0-9]+(\.[0-9]+)?$ || ! $prec =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
          echo "Skipping malformed line in $file: $year $avg_temp $min_temp $max_temp $wind $hum $sun $prec"
          continue
      fi

      # UPDATE GLOBAL VALS
      if [[ $(echo "$avg_temp < $GLOBAL_MIN_AVG_TEMP" | bc) -eq 1 ]]; then
          GLOBAL_MIN_AVG_TEMP=$avg_temp
          GLOBAL_MIN_AVG_TEMP_PLACE=$PLACE_NAME
      fi
      if [[ $(echo "$avg_temp > $GLOBAL_MAX_AVG_TEMP" | bc) -eq 1 ]]; then
          GLOBAL_MAX_AVG_TEMP=$avg_temp
          GLOBAL_MAX_AVG_TEMP_PLACE=$PLACE_NAME
      fi

      if [[ $(echo "$min_temp < $GLOBAL_MIN_MIN_TEMP" | bc) -eq 1 ]]; then
          GLOBAL_MIN_MIN_TEMP=$min_temp
          GLOBAL_MIN_MIN_TEMP_PLACE=$PLACE_NAME
      fi
      if [[ $(echo "$min_temp > $GLOBAL_MAX_MIN_TEMP" | bc) -eq 1 ]]; then
          GLOBAL_MAX_MIN_TEMP=$min_temp
          GLOBAL_MAX_MIN_TEMP_PLACE=$PLACE_NAME
      fi

      if [[ $(echo "$max_temp < $GLOBAL_MIN_MAX_TEMP" | bc) -eq 1 ]]; then
          GLOBAL_MIN_MAX_TEMP=$max_temp
          GLOBAL_MIN_MAX_TEMP_PLACE=$PLACE_NAME
      fi
      if [[ $(echo "$max_temp > $GLOBAL_MAX_MAX_TEMP" | bc) -eq 1 ]]; then
          GLOBAL_MAX_MAX_TEMP=$max_temp
          GLOBAL_MAX_MAX_TEMP_PLACE=$PLACE_NAME
      fi

      if [[ $(echo "$range < $GLOBAL_MIN_TEMP_RANGE" | bc) -eq 1 ]]; then
          GLOBAL_MIN_TEMP_RANGE=$range
          GLOBAL_MIN_TEMP_RANGE_PLACE=$PLACE_NAME
      fi
      if [[ $(echo "$range > $GLOBAL_MAX_TEMP_RANGE" | bc) -eq 1 ]]; then
          GLOBAL_MAX_TEMP_RANGE=$range
          GLOBAL_MAX_TEMP_RANGE_PLACE=$PLACE_NAME
      fi

      if [[ $(echo "$wind < $GLOBAL_MIN_WIND" | bc) -eq 1 ]]; then
          GLOBAL_MIN_WIND=$wind
          GLOBAL_MIN_WIND_PLACE=$PLACE_NAME
      fi
      if [[ $(echo "$wind > $GLOBAL_MAX_WIND" | bc) -eq 1 ]]; then
          GLOBAL_MAX_WIND=$wind
          GLOBAL_MAX_WIND_PLACE=$PLACE_NAME
      fi

      if [[ $(echo "$hum < $GLOBAL_MIN_HUM" | bc) -eq 1 ]]; then
          GLOBAL_MIN_HUM=$hum
          GLOBAL_MIN_HUM_PLACE=$PLACE_NAME
      fi
      if [[ $(echo "$hum > $GLOBAL_MAX_HUM" | bc) -eq 1 ]]; then
          GLOBAL_MAX_HUM=$hum
          GLOBAL_MAX_HUM_PLACE=$PLACE_NAME
      fi

      if [[ $(echo "$sun < $GLOBAL_MIN_SUN" | bc) -eq 1 ]]; then
          GLOBAL_MIN_SUN=$sun
          GLOBAL_MIN_SUN_PLACE=$PLACE_NAME
      fi
      if [[ $(echo "$sun > $GLOBAL_MAX_SUN" | bc) -eq 1 ]]; then
          GLOBAL_MAX_SUN=$sun
          GLOBAL_MAX_SUN_PLACE=$PLACE_NAME
      fi

      if [[ $(echo "$prec < $GLOBAL_MIN_PREC" | bc) -eq 1 ]]; then
          GLOBAL_MIN_PREC=$prec
          GLOBAL_MIN_PREC_PLACE=$PLACE_NAME
      fi
      if [[ $(echo "$prec > $GLOBAL_MAX_PREC" | bc) -eq 1 ]]; then
          GLOBAL_MAX_PREC=$prec
          GLOBAL_MAX_PREC_PLACE=$PLACE_NAME
      fi
  done < "$file"
done

# PRINT THE RESULTS OF SEARCH IN TERMINAL
echo "Global Minimum and Maximum Values for Metrics (with Place Names):"
echo "Average Temperature: Min = $GLOBAL_MIN_AVG_TEMP ($GLOBAL_MIN_AVG_TEMP_PLACE), Max = $GLOBAL_MAX_AVG_TEMP ($GLOBAL_MAX_AVG_TEMP_PLACE)"
echo "Minimum Temperature: Min = $GLOBAL_MIN_MIN_TEMP ($GLOBAL_MIN_MIN_TEMP_PLACE), Max = $GLOBAL_MAX_MIN_TEMP ($GLOBAL_MAX_MIN_TEMP_PLACE)"
echo "Maximum Temperature: Min = $GLOBAL_MIN_MAX_TEMP ($GLOBAL_MIN_MAX_TEMP_PLACE), Max = $GLOBAL_MAX_MAX_TEMP ($GLOBAL_MAX_MAX_TEMP_PLACE)"
echo "Temperature Range: Min = $GLOBAL_MIN_TEMP_RANGE ($GLOBAL_MIN_TEMP_RANGE_PLACE), Max = $GLOBAL_MAX_TEMP_RANGE ($GLOBAL_MAX_TEMP_RANGE_PLACE)"
echo "Wind Speed: Min = $GLOBAL_MIN_WIND ($GLOBAL_MIN_WIND_PLACE), Max = $GLOBAL_MAX_WIND ($GLOBAL_MAX_WIND_PLACE)"
echo "Humidity: Min = $GLOBAL_MIN_HUM ($GLOBAL_MIN_HUM_PLACE), Max = $GLOBAL_MAX_HUM ($GLOBAL_MAX_HUM_PLACE)"
echo "Sunshine Duration: Min = $GLOBAL_MIN_SUN ($GLOBAL_MIN_SUN_PLACE), Max = $GLOBAL_MAX_SUN ($GLOBAL_MAX_SUN_PLACE)"
echo "Precipitation: Min = $GLOBAL_MIN_PREC ($GLOBAL_MIN_PREC_PLACE), Max = $GLOBAL_MAX_PREC ($GLOBAL_MAX_PREC_PLACE)"
# ================================================================================================================


# 2. NORMALIZE THE VALUES AND SAVE THEM IN OUTPUT_DIR
for file in $INPUT_FOLDER/*.txt; do
  PLACE_NAME=$(basename "$file" .txt)
  OUTPUT_FILE="$OUTPUT_FOLDER/$PLACE_NAME.txt"

  while IFS=' ' read -r year avg_temp min_temp max_temp range wind hum sun prec; do
      if [[ $year == "Year" ]]; then
          continue
      fi

      # DEBUG STATEMENT: Ensure all values are numeric
      if [[ ! $avg_temp =~ ^[0-9]+(\.[0-9]+)?$ || ! $min_temp =~ ^[0-9]+(\.[0-9]+)?$ || \
            ! $max_temp =~ ^[0-9]+(\.[0-9]+)?$ || ! $range =~ ^[0-9]+(\.[0-9]+)?$ || \
            ! $wind =~ ^[0-9]+(\.[0-9]+)?$ || ! $hum =~ ^[0-9]+(\.[0-9]+)?$ || \
            ! $sun =~ ^[0-9]+(\.[0-9]+)?$ || ! $prec =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
          continue
      fi

      # Normalize
      norm_avg_temp=$(echo "scale=5; ($avg_temp - $GLOBAL_MIN_AVG_TEMP) / ($GLOBAL_MAX_AVG_TEMP - $GLOBAL_MIN_AVG_TEMP)" | bc -l)
      norm_min_temp=$(echo "scale=5; ($min_temp - $GLOBAL_MIN_MIN_TEMP) / ($GLOBAL_MAX_MIN_TEMP - $GLOBAL_MIN_MIN_TEMP)" | bc -l)
      norm_max_temp=$(echo "scale=5; ($max_temp - $GLOBAL_MIN_MAX_TEMP) / ($GLOBAL_MAX_MAX_TEMP - $GLOBAL_MIN_MAX_TEMP)" | bc -l)
      norm_temp_range=$(echo "scale=5; ($range - $GLOBAL_MIN_TEMP_RANGE) / ($GLOBAL_MAX_TEMP_RANGE - $GLOBAL_MIN_TEMP_RANGE)" | bc -l)
      norm_wind=$(echo "scale=5; ($wind - $GLOBAL_MIN_WIND) / ($GLOBAL_MAX_WIND - $GLOBAL_MIN_WIND)" | bc -l)
      norm_hum=$(echo "scale=5; ($hum - $GLOBAL_MIN_HUM) / ($GLOBAL_MAX_HUM - $GLOBAL_MIN_HUM)" | bc -l)
      norm_sun=$(echo "scale=5; ($sun - $GLOBAL_MIN_SUN) / ($GLOBAL_MAX_SUN - $GLOBAL_MIN_SUN)" | bc -l)
      norm_prec=$(echo "scale=5; ($prec - $GLOBAL_MIN_PREC) / ($GLOBAL_MAX_PREC - $GLOBAL_MIN_PREC)" | bc -l)

      # WRITE TO OUTPUT FILE
      printf "%s %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f\n" "$year" "$norm_avg_temp" "$norm_min_temp" "$norm_max_temp" "$norm_temp_range" "$norm_wind" "$norm_hum" "$norm_sun" "$norm_prec" >> "$OUTPUT_FILE"
  done < "$file"
done

echo "Normalization completed. Output saved in $OUTPUT_FOLDER."