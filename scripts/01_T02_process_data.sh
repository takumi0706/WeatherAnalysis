#!/bin/bash

# 作業ディレクトリの設定
EXTRACTED_DIR=~/weather_data/01_extracted
STATION_NAMES_FILE=~/weather_data/station_names.txt

# データの分析と平均値の計算
awk -F' ' '{
    station=$1;
    date=$16;
    year=substr(date,1,4);
    temp_raw=$51;
    humidity=$78;

    # 欠損値や異常値のチェック
    if(temp_raw=="" || humidity=="" || temp_raw=="×" || humidity=="×") next;

    # 気温の変換
    temp=temp_raw;

    # 不快指数の計算
    discomfort_index = 0.81 * temp + 0.01 * humidity * (0.99 * temp - 14.3) + 46.3;

    # データの累積
    key=station","year;
    temp_sum[key]+=temp;
    humidity_sum[key]+=humidity;
    discomfort_sum[key]+=discomfort_index;
    count[key]++;
}
END {
    for (key in temp_sum) {
        split(key, arr, ",");
        station=arr[1];
        year=arr[2];
        avg_temp = temp_sum[key] / count[key];
        avg_humidity = humidity_sum[key] / count[key];
        avg_discomfort = discomfort_sum[key] / count[key];
        printf "%s,%s,%.2f,%.2f,%.2f\n", station, year, avg_temp, avg_humidity, avg_discomfort;
    }
}' $EXTRACTED_DIR/all_data_utf8.txt > $EXTRACTED_DIR/annual_averages.csv

# 観測所番号を都市名に変換
awk -F, 'NR==FNR{a[$1]=$2; next} {print a[$1]","$2","$3","$4","$5}' \
$STATION_NAMES_FILE $EXTRACTED_DIR/annual_averages.csv > $EXTRACTED_DIR/annual_averages_named.csv

echo "Data processing completed."
