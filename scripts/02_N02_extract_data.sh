#!/bin/zsh

# Author: Namir Garib
# Date: 2024-11-15

# Description:
# This script extracts the temperature, wind speed, humidity, sunshine, and precipitation data for each city in the list.
# It calculates daily average temperature, mean daily minimum and maximum temperatures, temperature range,
# and based on these values, it calculates the annual average temperature, mean daily minimum and maximum temperatures.
# Furthermore, it calculates the annual average wind speed, humidity, total hours of sunshine, and total precipitation.

# UNITS:
# Temperature: Celsius
# Wind speed: m/s
# Humidity: percentage
# Sunshine: seconds
# Precipitation: mm

# OUTPUT FORMAT:
# YEAR ANNUAL_AVERAGE_TEMPERATURE ANNUAL_MEAN_DAILY_MIN_TEMPERATURE ANNUAL_MEAN_DAILY_MAX_TEMPERATURE TEMPERATURE_RANGE [ANNUAL_AVERAGE_WIND_SPEED] [ANNUAL_AVERAGE_HUMIDITY] TOTAL_HOURS_OF_SUNSHINE TOTAL_PRECIPITATION
# Example:
# 2012 14.9 11.5 18.7 7.3 3.8 71 1832.2 2675.5

INPUT_FOLDER="/Volumes/BDP20240531/data/Structured_data"
OUTPUT_FOLDER="../weather_metrics/comprehensive"
CITY_FILE="../02_data/places.txt"

# Create output folder if it doesn't exist
mkdir -p "$OUTPUT_FOLDER"

process_city() {
  local amed_no=$1
  local gnd_no=$2
  local city_name=$3

  OUTPUT_FILE="$OUTPUT_FOLDER/$city_name.txt"
  echo "Processing ${city_name}..."

  for year in {2009..2022}; do
    AMED_FILE="$INPUT_FOLDER/amed_${year}.txt.gz"

    # DEBUG: Check if the file exists
    if [[ ! -f "$AMED_FILE" ]]; then
      echo "File $AMED_FILE not found. Skipping $year."
      continue
    fi

    # PROCESS DATA
    gzcat "$AMED_FILE" | rg -w "$amed_no $gnd_no" | awk '
    BEGIN {
        OFS = " ";  # Output field separator
    }
    {
        date = $16;  # Extract date (YYYYMMDD)
        year = substr(date, 1, 4);  # Extract year

        # TEMPERATURE
        if ($52 <= 3) {
            # Track daily min and max temperatures
            if (!(date in daily_min) || $51 < daily_min[date]) {
                daily_min[date] = $51;
            }
            if (!(date in daily_max) || $51 > daily_max[date]) {
                daily_max[date] = $51;
            }
            annual_temp_sum[year] += $51;
            total_measurements[year]++;
        }

        # WIND SPEED
        if ($36 <= 3 && $40 < 3) {
            daily_wind_sum[date] += ($35 + $39) / 2;
            daily_wind_measurements[date]++;
        }

        # HUMIDITY
        if ($79 <= 3) {
            daily_humidity_sum[date] += $78;
            daily_humidity_measurements[date]++;
        }

        # SUNSHINE
        if ($60 <= 3) {
            total_sunshine += $59;
        }

        # PRECIPITATION
        if ($21 <= 3) {
            total_precipitation += $20;
        }
    }

    END {
        for (date in daily_min) {
            year = substr(date, 1, 4);
            annual_min_sum[year] += daily_min[date];
            annual_max_sum[year] += daily_max[date];
            day_count[year]++;
        }

        for (date in daily_wind_sum) {
            year = substr(date, 1, 4);
            annual_wind_sum[year] += (daily_wind_sum[date] / daily_wind_measurements[date]);
        }

        for (date in daily_humidity_sum) {
            year = substr(date, 1, 4);
            annual_humidity_sum[year] += (daily_humidity_sum[date] / daily_humidity_measurements[date]);
        }

        # OUTPUT RESULTS
        for (year in total_measurements) {
            mean_daily_min = annual_min_sum[year] / day_count[year];
            mean_daily_max = annual_max_sum[year] / day_count[year];
            mean_annual_temp = annual_temp_sum[year] / total_measurements[year];
            temperature_range = mean_daily_max - mean_daily_min;

            printf "%s %.1f %.1f %.1f %.1f ", year, mean_annual_temp, mean_daily_min, mean_daily_max, temperature_range;

            if (year in annual_wind_sum) {
                printf "%.1f ", annual_wind_sum[year] / day_count[year];
            }

            if (year in annual_humidity_sum) {
                printf "%d ", int(annual_humidity_sum[year] / day_count[year] + 0.5);
            }

            printf "%.1f %.1f\n", total_sunshine / 3600, total_precipitation;
        }
    }' > "$OUTPUT_FILE"

    echo "Completed calculation for $city_name."
  done
}

# PROCESS EACH CITY
while read -r amed_no gnd_no city_name; do
  process_city "$amed_no" "$gnd_no" "$city_name"
done < "$CITY_FILE"

echo "Processing complete. Results saved in $OUTPUT_FOLDER."