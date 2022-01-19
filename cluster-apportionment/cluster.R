library(tidyverse)
library(fpc)

set.seed(42)
FILE_DIR <- "G:/My Drive/IC/Doutorado/Sandwich/Data/PMF/"

import_dataset <- function(data_path) {
  #` Import colocation dataset into a tibble
  #`
  return(read_csv(paste0(FILE_DIR, "Formatted/data.csv")))
}

run_cluster <- function(data, method, ...) {
  #` Apply cluster in data and return
  #`
  if(method == "k-means") return(kmeans(data, ...))
  else stop("Invalid method")
}

main <- function() {
  data <- import_dataset()
  kcluster_data <- data %>%
    select(-c(Timestamp, `MToF (us)`, `Period (s)`, `Flowrate (ml/s)`))
  kcluster <- kcluster_data %>%
    run_cluster("k-means", centers = 3)
  kcluster_statistics <- cluster.stats(d = dist(kcluster_data), kcluster$cluster, silhouette = T)
}

if (interactive()) {
  main()
}