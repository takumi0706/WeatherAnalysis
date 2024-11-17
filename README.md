# Weather Data Analysis

This repository contains scripts and configuration files for analyzing temperature, humidity, and discomfort index trends in Hachinohe, Yokohama, and Kofu from 2009 to 2022.

## Directory Structure

- `scripts/`: Contains shell scripts for data extraction, processing, and plotting.
- `stations.txt`: List of AMeDAS station numbers for the selected cities.
- `station_names.txt`: Mapping of station numbers to city names.
- `.gitignore`: Specifies files and directories to be ignored by Git.

## Usage

1. **Extract Data**:
    ```bash
    ./scripts/extract_data.sh
    ```

2. **Process Data**:
    ```bash
    ./scripts/process_data.sh
    ```

3. **Plot Data**:
    ```bash
    ./scripts/plot_data.sh
    ```

4. **Run All Steps Sequentially**:
    ```bash
    ./scripts/run_all.sh
    ```

## Requirements

- Git
- Gnuplot
- Unix/Linux environment
