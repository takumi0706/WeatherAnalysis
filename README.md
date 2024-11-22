# 🌤 Weather data analysis toolkit

This repository contains a suite of scripts and tools for processing and analyzing weather data. The data is extracted, processed, and visualized from various metrics across multiple cities in Japan, in period from 2009 to 2022.

---

## ℹ️ About
This project is a part of our assigment on **"Big Data Processing"** using shell script. It focuses on extracting, processing, and visualizing comprehensive weather data across multiple metrics and cities.  
The assignment consisted of two tasks:
1.	Select three appropriate observation points (e.g., your hometown, a place you’d like to visit for sightseeing, or any other reason). Compare and investigate the trends in temperature, humidity, and discomfort index from 2009 to 2022.
2. Choose one observation point from each prefecture, and from the weather data, identify the locations with the best weather. Additionally, extract information on locations that experienced the most rainfall, the most foggy days, or other notable weather characteristics.

🗒️ **NOTE**: Scripts related to Assignment 1 and Assignment 2 are prefixed with `01_` and `02_`, respectively, for clear identification and organization.

---

## 🤝🏻 Team Members
- [**Namir Garib**](https://github.com/namirgarib) 金沢大学理工学域電子情報通信学類3年
- [**Takumi Oyamada**](https://github.com/takumi0706)　金沢大学理工学域電子情報通信学類3年
- **Shunsuke Shimura**　金沢大学理工学域1年

---

## Directory structure

- `scripts/`: Contains shell scripts for extracting, processing, and plotting data.
- `01_stations/`: 
  - `stations.txt` A list of the AMeDAS observation station numbers for the selected cities.
  - `station_names.txt`: A table of station numbers and city names.
- `02_data`:
  - `amedas_data.csv`
  - `file_path.txt`
  - `obs_list.csv`
  - `places.csv`
  - `places.txt`
- `01_extracted/`: contains extracted data for assignment 1
- `02_data`: contains files about AMeDAS data format and observatory list with their respective AMeDAS and Ground Observation Station numbers.
- `plots/`: Contains the results of our data analysis
- `scripts/`: Contains scripts used for our project
- `src/`: Contains Python script used for generating sorted bar charts for Assignment 2
- `test/`: Includes test scripts utilized during development, along with example data (`KANAZAWA.txt.gz`) for the year 2012. For detailed descriptions of each column, refer to `02_data/amedas_data.csv`.

---

## 📂 Data Availability and Configuration Notes

### 📊 Data Availability
Due to the large size of the datasets used in this assignment, the original data is not included in this repository. However, an example dataset for Kanazawa (year 2012) is provided in `/test/KANAZAWA.txt.gz` for testing and reference purposes.

**📥 AMeDAS Data Source**:  
The AMeDAS data is publicly available and can be accessed from their official website. Please refer to the AMeDAS platform for obtaining the full dataset.



### 🛠️ Repository Configuration
The scripts and instructions in this repository are configured based on the directory structure and file paths used during development. These paths, such as `../02_data/` and `../02_weather_metrics/`, point to specific locations and datasets that may differ from your environment.



### 🔧 Steps for Customization
To ensure the scripts function correctly in your setup, you must update the file paths and directory locations accordingly:

1. **🗂️ Update Input Paths**:  
   Replace `INPUT_FILE` paths in the scripts with the paths to your own input data files.

2. **📂 Modify Output Directories**:  
   Update `OUTPUT_FOLDER` paths to reflect your desired output directory structure.

3. **🔢 Adjust Column Numbers**:  
   If your dataset structure differs from the example data, adjust the column numbers in the `awk` commands and other relevant sections of the scripts to match your dataset's format.


### ⚠️ Important Note
Failure to make these adjustments may result in errors or incorrect outputs. Please review the scripts carefully and modify them as needed to match your environment, data, and file structure.

---

## 🚀 Features

1. 🔍 **Data Extraction**:
    - Extracts specific city data from comprehensive weather datasets.
    - Filters rows based on specific flags to ensure data accuracy.
    - Outputs results into neatly formatted CSV and TXT files.

2. 📊 **Data Processing**:
    - Calculates annual average temperature, mean daily minimum, and maximum temperatures.
    - Computes wind speed, relative humidity, sunshine hours, and precipitation totals.
    - Handles large datasets efficiently by minimizing redundant traversals.

3. 📈 **Visualization**:
    - Generates line graphs for discomfort index and bar charts for weather metrics (temperature, wind, humidity, sunshine, and precipitation).
    - Sorts data by values and creates visually appealing graphs.
    - Saves charts in high-resolution PNG format with labeled axes and descriptive titles.

4. 📏 **Metrics and Units**:
    - **Temperature**: Celsius
    - **Wind Speed**: m/s
    - **Humidity**: Percentage
    - **Sunshine**: Hours
    - **Precipitation**: mm

---

## 🗂 Input Files
- **ASSIGNMENT 1:**:
  - **Weather Data:** Located in the `01_extracted/` directory.
  - ****
- **ASSIGNMENT 2:**:
  - **Weather Data**: Located in the `02_data/` directory.
  - **City Metadata**: `obs_list.csv` and `places.txt` for city and station information.

---

## 📂 Output Files
- **Processed Data**: Saved in the `01_extracted/` directory for Assignment 1, and `../02_weather_metrics/comprehensive/` directory for Assignment 2.
- **Visualization Graphs**: Saved in `plots/bar_charts/`.

---

## 📜 Scripts
**ASSIGNMENT 1**
1. `01_T01_extract_data.sh`
2. `01_T02_process_data.sh`
3. `01_T03_plot_data.sh`

**ASSIGNMENT 2**
1. `02_N01_extract_places.sh`
2. `02_N02_extract_data.sh`
3. `02_N03_normalize_data.sh`
4. `02_N04_best_weather_score.sh`
5. `02_N05_other_weather_metrics.sh`

🗒️ **NOTE**: Scripts containing `T` are developed by [Takumi](https://github.com/takumi0706) and scripts containing `N` are developed by [Namir](https://github.com/namirgarib).

---

## ⚙️ How to Run
Assuming all input and output paths are correctly set, scripts should be executed in the sequential order.

### Prerequisites
- `gnuplot`
- `Unix/Linux` or `macOS` environment for executing `Bash/Zsh` scripts
- `Python 3.8` or above
- - Libraries: `matplotlib`, `csv`, `os`, `glob`


---
## 📐 Units and Descriptions

- Temperature (°C): Daily and annual averages.
- Wind Speed (m/s): Daily and annual averages.
- Humidity (%): Annual average of daily relative humidity.
- Sunshine Hours: Total hours of sunshine per year.
- Precipitation (mm): Total precipitation per year.

---

## 👤 Authors

**Namir Garib**  
🎓 Student at Kanazawa University  
📧 Contact: [namirgarib@gmail.com](mailto:namirgarib@gmail.com)  
💻 GitHub: [namirgarib](https://github.com/namirgarib)  
🌐 Website: [Namir Garib](https://www.namirgarib.com) 

**Takumi Oyamada**  
🎓 Student at Kanazawa University  
📧 Contact: [ganndamu0706@gmail.com](mailto:namirgarib@gmail.com)  
💻 GitHub: [takumi0706](https://github.com/takumi0706)  
