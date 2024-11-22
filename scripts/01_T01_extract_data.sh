#!/bin/bash

# 作業ディレクトリの設定
DATA_DIR=~/weather_data
EXTRACTED_DIR=$DATA_DIR/01_extracted
STATIONS_FILE=$DATA_DIR/stations.txt
MULTI_DATA=/mnt/usb/data/Structured_data

# データファイルの処理
for YEAR in {2009..2022}; do
    echo "Processing year: $YEAR"
    # 圧縮ファイルからデータを抽出して保存
    zcat $MULTI_DATA/amed_${YEAR}.txt.gz | \
    grep -Ff $STATIONS_FILE >> $EXTRACTED_DIR/all_data_utf8.txt
done

echo "Data extraction and encoding conversion completed."
