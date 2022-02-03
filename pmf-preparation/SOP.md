# Standard operating procedure

The following standard operating procedure (SOP) referes to the EPA's PMF data preparation for OPC data, 
avaliable at https://github.com/lokamigauti/surrey-extras/blob/main/pmf-preparation/data_format.R.

## Pre-requisites
1. Have R installed
2. Have library `tidyverse` installed
3. Have a dataset folder (can't be the same)
4. Have a dataset in .csv and with the same format than the avaliable `example.csv`[^1]

## Basic usage
Set a data directory in the `FILE_DIR` global variable located at the header of the script:

```R
library(tidyverse)

FILE_DIR <- "C:/Documents/dataset_folder/"
```
Remember to use `/` in the end of the paths.

Run the script.

The formatted dataset will be in the `Formatted` folder inside your data folder.
