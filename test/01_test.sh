#!/bin/zsh

INPUT_FILE="KANAZAWA.txt"

# AVERAGE TEMPERATURE, MINIMUM TEMPERATURE, MAXIMUM TEMPERATURE, TEMPERATURE RANGE

awk '
# Process rows where the 52nd column is less than 3
$52 < 3 {
    date = $16;                       # Extract date (YYYYMMDD) from the 16th column
    year = substr(date, 1, 4);        # Extract year from the date

    # Track daily min and max temperatures
    if (!(date in daily_min) || $51 < daily_min[date]) {
        daily_min[date] = $51;
    }
    if (!(date in daily_max) || $51 > daily_max[date]) {
        daily_max[date] = $51;
    }

    # Aggregate for annual average temperature
    annual_temp_sum[year] += $51;
    total_measurements[year]++;
}

END {
    # Calculate annual mean daily min and max temperatures
    for (date in daily_min) {
        year = substr(date, 1, 4);

        # Aggregate daily min and max into annual totals
        annual_min_sum[year] += daily_min[date];
        annual_max_sum[year] += daily_max[date];
        day_count[year]++;
    }

    # Output results for each year
    for (year in total_measurements) {
        mean_daily_min = annual_min_sum[year] / day_count[year];
        mean_daily_max = annual_max_sum[year] / day_count[year];
        mean_annual_temp = annual_temp_sum[year] / total_measurements[year]; # Annual average based on all measurements

        printf "YEAR: %s\n", year;
        printf "ANNUAL AVERAGE TEMPERATURE: %.1f\n", mean_annual_temp;
        printf "ANNUAL MEAN DAILY MIN TEMPERATURE: %.1f\n", mean_daily_min;
        printf "ANNUAL MEAN DAILY MAX TEMPERATURE: %.1f\n", mean_daily_max;
    }
}' "$INPUT_FILE"

# WIND SPEED
awk '
# Process rows where flags are valid (both < 3)
$36 < 3 && $40 < 3 {
    date = $16;                       # Extract date (YYYYMMDD) from the 16th column
    year = substr(date, 1, 4);        # Extract year from the date
    daily_wind_sum[date] += ($35 + $39) / 2;  # Add average wind speed for this row
    daily_measurements[date]++;       # Count valid rows for the day
}

END {
    # Calculate daily averages
    for (date in daily_wind_sum) {
        year = substr(date, 1, 4);
        daily_avg = daily_wind_sum[date] / daily_measurements[date];

        # Aggregate daily averages into annual totals
        annual_wind_sum[year] += daily_avg;
        day_count[year]++;
    }

    # Output results for each year
    for (year in day_count) {
        annual_avg = annual_wind_sum[year] / day_count[year];
        printf "ANNUAL AVERAGE WIND SPEED: %.1f\n", annual_avg;
    }
}' "$INPUT_FILE"

# HUMIDITY
awk '
# Process rows where the flag for relative humidity is valid (< 3)
$79 < 3 {
    date = $16;                        # Extract date (YYYYMMDD) from the 16th column
    year = substr(date, 1, 4);         # Extract year from the date
    daily_humidity_sum[date] += $78;   # Add humidity value for this row
    daily_measurements[date]++;        # Count valid rows for the day
}

END {
    # Calculate daily averages and aggregate them into annual totals
    for (date in daily_humidity_sum) {
        year = substr(date, 1, 4);
        daily_avg = daily_humidity_sum[date] / daily_measurements[date];

        # Aggregate daily averages into annual totals
        annual_humidity_sum[year] += daily_avg;
        day_count[year]++;
    }

    # Output results for each year
    for (year in day_count) {
        annual_avg = int(annual_humidity_sum[year] / day_count[year] + 0.5); # Round to nearest integer
        printf "YEAR: %s\n", year;
        printf "ANNUAL AVERAGE RELATIVE HUMIDITY: %d\n", annual_avg;
    }
}' "$INPUT_FILE"

# SUNSHINE
awk '$60 < 3 {sum += $59} END {print "SUNSHINE:", sum/3600}' "$INPUT_FILE"

# PRECIPITATION
awk '$21 < 3 {sum += $20} END {print "PRECIPITATION:", sum}' "$INPUT_FILE"
