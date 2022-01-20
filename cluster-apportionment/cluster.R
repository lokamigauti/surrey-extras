library(tidyverse)
library(fpc)

set.seed(42)
FILE_DIR <- "G:/My Drive/IC/Doutorado/Sandwich/Data/PMF/"
OUTPUT_DIR <- "G:/My Drive/IC/Doutorado/Sandwich/Output/PMF/"

import_dataset <- function(data_path) {
  #` Import colocation dataset into a tibble
  #`
  return(read_csv(paste0(FILE_DIR, "Formatted/data.csv")))
}

run_cluster <- function(data, method, ...) {
  #` Apply cluster in data and return cluster object
  #`
  if(method == "k-means") return(kmeans(data, ...))
  else stop("Invalid method")
}

get_statistics <- function(data, method, ...) {
  #` Calculate statistics and return list
  #`
  cluster <- run_cluster(data, method, ...)
  return(cluster.stats(d = dist(data), cluster$cluster, silhouette = T))
}

get_alternative_sil <- function(data, method, ...) {
  #` Alternative method to calculate silhouette for big datasets
  #`
  cluster <- run_cluster(data, method, ...)
  return(distcritmulti(data, cluster$cluster))
}

iterate_statistics_by_center <- function(data, method, range, alternative = F, ...) {
  #` Calculate statistics for a range of centers
  #`
  if(alternative == T) return(map(range, ~ get_alternative_sil(data, method, center = .x, ...)))
  range %>%
    map(~ get_statistics(data, method, center = .x, ...))
}

report_stats <- function(stats, save_path, alternative = F, alternative_stats = NULL) {
  #` Save Dunn, Avg. Silhouette and Silhouette plots
  #`
  range <- 1:length(stats)
  stats_report <- data.frame(
    k = map_dbl(range, ~ stats[[.x]]$cluster.number),
    dunn = map_dbl(range, ~ stats[[.x]]$dunn),
    sils = map_dbl(range, ~ stats[[.x]]$avg.silwidth)
  )
  clus_sils <- map(range, ~ stats[[.x]]$clus.avg.silwidths)

  stats_report %>%
    ggplot(aes(x = k, y = dunn)) +
      geom_point() +
      geom_line() +
      ggtitle("Dunn Number") +
      xlab("Number of Clusters") +
      ylab("Dunn Number")
  ggsave(paste0(save_path, "dunn.png"))

  stats_report %>%
    ggplot(aes(x = k, y = sils)) +
      geom_point() +
      geom_line() +
      ggtitle("Average Silhouette") +
      xlab("Number of Clusters") +
      ylab("Average Silhouette")
  ggsave(paste0(save_path, "avgsil.png"))

  print_sils <- function(n, clus_sils) {
    len <- length(clus_sils[[n]])
    clus_sils[[n]] %>%
      as.data.frame() %>%
      ggplot(aes(y = ., x = 1:len)) +
        geom_col() +
        ggtitle(glue::glue("Silhouette with {len} clusters")) +
        xlab("Cluster Number") +
        ylab("Silhouette")

    ggsave(paste0(save_path, "sil", len,".png"))
  }
  1:length(clus_sils) %>%
    walk(~ print_sils(.x, clus_sils))

  if(alternative==T) {
    clus_sils_alt <- map_dbl(range, ~ alternative_stats[[.x]]$crit.overall)
    data.frame(k = stats_report$k, avg_sil = clus_sils_alt) %>%
      ggplot(aes(x = k, y = avg_sil)) +
        geom_point() +
        geom_line() +
        ggtitle("Average Silhouette", subtitle = "Using Hennig and Liao (2013) method for large datasets") +
        xlab("Number of Clusters") +
        ylab("Average Silhouette")
    ggsave(paste0(save_path, "altsil.png"))
  }
}

main <- function() {
  data <- import_dataset()
  kcluster_data <- data %>%
    select(-c(Timestamp, `MToF (us)`, `Period (s)`, `Flowrate (ml/s)`))
  stats <- iterate_statistics_by_center(kcluster_data, "k-means", 2:20)
  alt_sil <- iterate_statistics_by_center(kcluster_data, "k-means", 2:20, alternative = T)
  report_stats(stats, OUTPUT_DIR, alternative = T, alternative_stats = alt_sil)
}

if (interactive()) {
  main()
}