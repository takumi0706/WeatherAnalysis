# Created by: Namir Garib
# Date: 2024-11-21

import os
import glob
import matplotlib.pyplot as plt
import csv

input_base_folder = "../weather_metrics/results/weather_scores"
output_base_folder = "../weather_metrics/bar_charts"

os.makedirs(output_base_folder, exist_ok=True)


metric_labels = {
    "avg_temp": {"title": "Average Temperature Ranking", "xlabel": "Temperature [°C]"},
    "best_weather": {"title": "Best Weather Ranking", "xlabel": "Weather Score (0-100)"},
    "wind": {"title": "Windiest Place Ranking", "xlabel": "Wind Speed (m/s)"},
    "humidity": {"title": "Humidity Ranking", "xlabel": "Relative Humidity [%]"},
    "sunshine_hours": {"title": "Sunniest Place Ranking", "xlabel": "Sunlight Hours [h]"},
    "precipitation": {"title": "Rainiest Place Ranking", "xlabel": "Amount of Precipitation [mm]"}
}


def generate_chart(file_path, output_path, metric):
    """
    Generate a horizontal bar chart from a CSV file containing place and value data.

    Args:
        file_path: Path to the input CSV file
        output_path: Path to save the output bar chart image
        metric: The metric being visualized
    """
    data = []
    with open(file_path, "r") as f:
        reader = csv.reader(f)
        for row in reader:
            place, value = row
            data.append((place, float(value)))

    data.sort(key=lambda x: x[1], reverse=True)

    places, values = zip(*data)

    # PLOTTING
    plt.figure(figsize=(10, 8))
    plt.barh(places, values, color="skyblue", zorder=4)
    plt.grid(axis='x', color='lightgray', linestyle='--', linewidth=0.5, zorder=0)
    plt.xlabel(metric_labels[metric]["xlabel"], fontsize=12)
    plt.title(f"{metric_labels[metric]['title']} {os.path.basename(file_path).replace('.csv', '')}", fontsize=16)
    plt.gca().invert_yaxis()
    plt.tight_layout()
    plt.savefig(output_path)
    plt.close()
    print(f"Bar chart saved to {output_path}")


metrics = ["avg_temp", "best_weather", "humidity", "precipitation", "sunshine_hours", "wind"]

# PROCESSING EACH METRIC
for metric in metrics:
    input_folder = os.path.join(input_base_folder, metric)
    output_folder = os.path.join(output_base_folder, metric)
    os.makedirs(output_folder, exist_ok=True)
    csv_files = glob.glob(os.path.join(input_folder, "*.csv"))
    for csv_file in csv_files:
        year = os.path.basename(csv_file).replace(".csv", "")
        output_file = os.path.join(output_folder, f"{metric}_{year}.png")
        generate_chart(csv_file, output_file, metric)

print("Bar charts have been generated for all metrics.")