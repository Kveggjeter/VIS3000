# Author: 7036
# This script is for cleaning and selecting relevant columns for a new dataframe. Currently only the example dataset
# A lot of data we don't need here, only using Base R here. Should not be necessary as it is now to make this abstract, as each
# dataset will differ.


cleaningPoliticsDataset <- function(){
  # Got error from UTF-8, but Latin1 worked.
  table <- read.csv("data/raw/support/politics.csv", fileEncoding = "Latin1", stringsAsFactors = FALSE)
  
  {
    df <- as.data.frame(table)
    print(colnames(df))
    df <- subset(df, df$year == 2018)
    df <- as.data.frame(t(df))
    colnames(df) <- df[1, ]
    df <- df[-1, ]
    df <- df[22:nrow(df), ]
    print(nrow(df))
    print(ncol(df))
  }
  
  setwd("data/processed")
  write.csv(df, paste0("cleanPol.csv"), row.names = TRUE)
  setwd("../../")
}
