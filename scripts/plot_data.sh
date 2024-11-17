#!/bin/bash

# 作業ディレクトリの設定
EXTRACTED_DIR=~/weather_data/extracted
PLOT_DIR=~/weather_data/plots

mkdir -p $PLOT_DIR

# 都市ごとのデータを分割
cd $EXTRACTED_DIR
grep "Hachinohe" annual_averages_named.csv > hachinohe_data.csv
grep "Yokohama" annual_averages_named.csv > yokohama_data.csv
grep "Kofu" annual_averages_named.csv > kofu_data.csv
# 気温の推移グラフの作成
gnuplot << EOF_GNUPLOT
set terminal png size 1000,800
set output '$PLOT_DIR/temperature_trends.png'
set title 'Annual Average Temperature Trends (2009-2022)'
set xlabel 'Year'
set ylabel 'Average Temperature (C)
set xtics rotate by -45
set grid
set datafile separator ','
set xrange[2008:2023]
set yrange[*:*]
plot 'hachinohe_data.csv' using 2:3 with linespoints title 'Hachinohe', \
     'yokohama_data.csv' using 2:3 with linespoints title 'Yokohama', \
     'kofu_data.csv' using 2:3 with linespoints title 'Kofu'
EOF_GNUPLOT

# 湿度の推移グラフの作成
gnuplot << EOF_GNUPLOT
set terminal png size 1000,800
set output '$PLOT_DIR/humidity_trends.png'
set title 'Anuual Average Humidity Trends (2009-2022)'
set xlabel 'Year'
set ylabel 'Average Humidity(%)
set xtics rotate by -45
set grid
set datafile separator ','
set xrange[2008:2023]
set yrange[*:*]
plot 'hachinohe_data.csv' using 2:4 with linespoints title 'Hachinohe', \
     'yokohama_data.csv' using 2:4 with linespoints title 'Yokohama', \
     'kofu_data.csv' using 2:4 with linespoints title 'Kofu'
EOF_GNUPLOT

# 不快指数の推移グラフの作成
gnuplot << EOF_GNUPLOT
set terminal png size 1000,800
set output '$PLOT_DIR/discomfort_index_trends.png'
set title 'Annual Average Discomfort Index Trends(2009-2022)'
set xlabel 'Year'
set ylabel 'Discomfort Index'
set xtics rotate by -45
set grid
set datafile separator ','
set xrange[2008:2023]
set yrange[*:*]
plot 'hachinohe_data.csv' using 2:5 with linespoints title 'Hachinohe', \
     'yokohama_data.csv' using 2:5 with linespoints title 'Yokohama', \
     'kofu_data.csv' using 2:5 with linespoints title 'Kofu'
EOF_GNUPLOT
echo "Plotting completed. Plots are saved in $PLOT_DIR"
