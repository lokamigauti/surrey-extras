library(tidyverse)

FILE_DIR <- "G:/My Drive/IC/Doutorado/Sandwich/Data/PMF/"

append_file <- function(data, filepaths) {
  first_interaction <- missing(data)

  if(length(filepaths) == 0) return(data) # stop condition

  filepaths[1] %>%
    read_csv(col_types = cols(Timestamp = col_datetime(format = "%Y-%m-%d %H:%M:%S"))) %>%
    {if(!first_interaction) bind_rows(data) else .} %>%
    append_file(filepaths = filepaths[-1]) %>%
    return()
}

import_data <- function(file_path = FILE_DIR) {
  filepaths <- list.files(file_path, full.names = T, pattern = "*.csv")
  return(append_file(filepaths = filepaths))
}

main <- function() {
  data <- import_data()
  data_unc <- data %>%
    mutate(across(!Timestamp, function(x) return(0.1)))

  data %>%
    write_csv(paste0(FILE_DIR, "Formatted/data.csv"))
  data_unc %>%
    write_csv(paste0(FILE_DIR, "Formatted/data_unc.csv"))
}

if (interactive()) {
  main()
}