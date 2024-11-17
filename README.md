# Weather data analysis

This repository contains scripts and configuration files for analyzing trends in temperature, humidity, and discomfort index for Hachinohe, Yokohama, and Kofu from 2009 to 2022.

## Directory structure

- `scripts/`: Contains shell scripts for extracting, processing, and plotting data.
- `stations.txt`: A list of the AMeDAS observation station numbers for the selected cities.
- `station_names.txt`: A table of station numbers and city names.
- `.gitignore`: Specifies files and directories to be ignored by Git.

## Usage

1. **Extracting the data**:
```bash
vi /scripts/extract_data.sh
```
Please adapt the settings for specifying the working directory to your environment.
Specify the location of the AMeDAS data in MULTI_DATA.
```bash.
/scripts/extract_data.sh
```

2. **Data processing**:
```bash.
/scripts/process_data.sh
```

3. **Data plotting**:
```bash.
/scripts/plot_data.sh
```

4. **Executing all steps sequentially**:
```bash.
/scripts/run_all.sh
```


## Requirements

- Git
- Gnuplot
- Unix/Linux environment
