# Standard operating procedure

The following standard operating procedure (SOP) referes to the cluster statistics analysis tool avaliable at https://github.com/lokamigauti/surrey-extras/blob/main/cluster-apportionment/cluster.R.

## Pre-requisites
1. Have R installed
2. Have libraries `tidyverse` and `fpc` installed
3. Have a dataset and output folders (can be the same)
4. Have a dataset in .csv and with the same format than the avaliable `example.csv`[^1]

[^1]: In case of OPC data, a script to format the data is avaliable at https://github.com/lokamigauti/surrey-extras/blob/main/pmf-preparation/data_format.R.

## Basic usage

Insert the dataset and output folders paths in the `FILE_DIR` and `OUTPUT_DIR` global variables,
and the range of numbers of clusters that you want to analyse in the `CLUSTERS_RANGE` global variable located in the header of the script:

```R
library(tidyverse)
library(fpc)

set.seed(42)
FILE_DIR <- "C:/Documents/dataset_folder/"
OUTPUT_DIR <- "C:/Documents/output_folder/"
CLUSTERS_RANGE <- 2:20
```

Remember to use `/` in the end of the paths.
The `CLUSTERS_RANGE` global variable needs to start from a positive integer greater than 1 and finish in another positive integer greater than 1.

Run the script.

In case you have a small dataset, you can remove the option `alternative = T` from the function `report_stats` call located in the `main` function, or set it to `F`:

```R
main <- function() {
  data <- import_dataset()
  kcluster_data <- data %>%
    select(-c(Timestamp, `MToF (us)`, `Period (s)`, `Flowrate (ml/s)`))
  stats <- iterate_statistics_by_center(kcluster_data, "k-means", CLUSTERS_RANGE)
  alt_sil <- iterate_statistics_by_center(kcluster_data, "k-means", CLUSTERS_RANGE, alternative = T)
  report_stats(stats, OUTPUT_DIR, plot_avg_per_cluster = F, alternative = F, alternative_stats = alt_sil)
}
```

In case you want to plot the average silhouettes for each cluster, you can set the `plot_avg_per_cluster` option to `T`:

```R
main <- function() {
  data <- import_dataset()
  kcluster_data <- data %>%
    select(-c(Timestamp, `MToF (us)`, `Period (s)`, `Flowrate (ml/s)`))
  stats <- iterate_statistics_by_center(kcluster_data, "k-means", CLUSTERS_RANGE)
  alt_sil <- iterate_statistics_by_center(kcluster_data, "k-means", CLUSTERS_RANGE, alternative = T)
  report_stats(stats, OUTPUT_DIR, plot_avg_per_cluster = T, alternative = T, alternative_stats = alt_sil)
}
```

All functions od the script can be used in other aplications via standard calling. The run_cluster function can be expanded for other clustering methods in the future.
