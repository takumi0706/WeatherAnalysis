#!/bin/zsh

INPUT_FILE="KANAZAWA.txt"

awk '
# Process temperature, wind, humidity, sunshine, and precipitation

{
    date = $16;  # Extract date (YYYYMMDD) from the 16th column
    year = substr(date, 1, 4);  # Extract year from the date
}

{
    # TEMPERATURE
    if ($52 < 3) {
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

    # WIND SPEED
    if ($36 < 3 && $40 < 3) {
        daily_wind_sum[date] += ($35 + $39) / 2;  # Add average wind speed for this row
        daily_wind_measurements[date]++;
    }

    # HUMIDITY
    if ($79 < 3) {
        daily_humidity_sum[date] += $78;  # Add humidity value for this row
        daily_humidity_measurements[date]++;
    }

    # SUNSHINE
    if ($60 < 3) {
        total_sunshine += $59;  # Aggregate sunshine values
    }

    # PRECIPITATION
    if ($21 < 3) {
        total_precipitation += $20;  # Aggregate precipitation values
    }
}

END {
    # Process all dates to compute annual metrics
    for (date in daily_min) {
        year = substr(date, 1, 4);

        # Aggregate daily min and max temperatures into annual totals
        annual_min_sum[year] += daily_min[date];
        annual_max_sum[year] += daily_max[date];
        day_count[year]++;
    }

    # Process daily averages for wind speed and humidity
    for (date in daily_wind_sum) {
        year = substr(date, 1, 4);
        annual_wind_sum[year] += (daily_wind_sum[date] / daily_wind_measurements[date]);
    }

    for (date in daily_humidity_sum) {
        year = substr(date, 1, 4);
        annual_humidity_sum[year] += (daily_humidity_sum[date] / daily_humidity_measurements[date]);
    }

    # Output results for each year
    for (year in total_measurements) {
        # Calculate temperature metrics
        mean_daily_min = annual_min_sum[year] / day_count[year];
        mean_daily_max = annual_max_sum[year] / day_count[year];
        mean_annual_temp = annual_temp_sum[year] / total_measurements[year];

        printf "%s ", year;
        printf "%.1f ", mean_annual_temp;
        printf "%.1f ", mean_daily_min;
        printf "%.1f ", mean_daily_max;
        printf "%.1f ", mean_daily_max - mean_daily_min;

        # Output wind speed
        if (year in annual_wind_sum) {
            annual_avg_wind = annual_wind_sum[year] / day_count[year];
            printf "%.1f ", annual_avg_wind;
        }

        # Output humidity
        if (year in annual_humidity_sum) {
            annual_avg_humidity = int(annual_humidity_sum[year] / day_count[year] + 0.5);
            printf "%d ", annual_avg_humidity;
        }
    }

    # Output sunshine and precipitation results
    printf "%.1f ", total_sunshine / 3600;  # Convert seconds to hours
    printf "%.1f\n", total_precipitation;
}' "$INPUT_FILE"