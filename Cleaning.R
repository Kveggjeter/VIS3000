# Author: Eirik
# This script is for cleaning and selecting relevant columns for a new dataframe. Currently only the example dataset
# A lot of data we don't need here, only using Base R here. Should not be necessary as it is now to make this abstract, as each
# dataset will differ.

getwd()
setwd("data")

# Got error from UTF-8, but Latin1 worked.
table <- read.csv("UnEst.csv", fileEncoding = "Latin1", stringsAsFactors = FALSE)

# Sub-setting
{
  df <- as.data.frame(table)
  df <- df[16:nrow(df), ]
  colnames(df) <- df[1, ]
  df <- df[-1, ]
  df <- subset(df, Year == "2018")
  df <- subset(df, Type == "Country/Area")
  df <- df[, -1]
  df <- df[, -1]
  rownames(df) <- df[, 1]
  df <- df[, -1]
}

# Inverting it so it can be used with our main df
newDf <- as.data.frame(t(df))
View(newDf)
write.csv(newDf, paste0("un_clean_2018.csv"), row.names = TRUE)