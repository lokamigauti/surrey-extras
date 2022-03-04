library(tidyverse)

FILE_DIR <- "G:/My Drive/IC/Doutorado/Sandwich/Data/PMF/"

append_file <- function(data, filepaths) {
  if(length(filepaths) == 0) return(data)
  filepaths[1] %>%
    read_csv(col_types = cols(Timestamp = col_datetime(format = "%Y-%m-%d %H:%M:%S"))) %>%
    bind_rows(data) %>%
    append_file(filepaths = filepaths[-1]) %>% 
    return()
}

import_data <- function(file_path = FILE_DIR) {
  filepaths <- list.files(file_path, full.names = T, pattern = "*.csv")
  data <- filepaths[1] %>%
    read_csv(col_types = cols(Timestamp = col_datetime(format = "%Y-%m-%d %H:%M:%S")))
  data <- append_file(data = data, filepaths = filepaths[-1])
  return(data)
}

main <- function() {
  data <- import_data() %>%
    arrange(Timestamp)
  data[is.na(data)] <- -999
  data_unc <- data %>%
    mutate(across(!Timestamp, function(x) return(0.000001))) # PMF do not accept 0 uncertainty

  data %>%
    write_csv(paste0(FILE_DIR, "Formatted/data.csv"))
  data_unc %>%
    write_csv(paste0(FILE_DIR, "Formatted/data_unc.csv"))
}

if (interactive()) {
  main()
}