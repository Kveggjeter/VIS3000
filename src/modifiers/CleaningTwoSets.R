# Author: 7036
# Script for merging mainframe and new frames.

eqClean <- function(main, second) {
  library(dplyr)
  commonCol <- intersect(colnames(second), colnames(main))
  
  second <- second %>% select(all_of(commonCol))
  main <- main %>% select(all_of(commonCol))
  
  secondDf <- as.data.frame(second)
  mainDf <- as.data.frame(main)
  
  secondDf[] <- lapply(secondDf, as.character)
  mainDf[] <- lapply(mainDf, as.character)
  
  secondDf[] <- lapply(secondDf, function(x) as.numeric(as.character(x)))
  mainDf[] <- lapply(mainDf, function(x) as.numeric(as.character(x)))

  secondDf[] <- lapply(secondDf, as.numeric)
  mainDf[] <- lapply(mainDf, as.numeric)
  
  secondDf <- na.omit(secondDf)
  mainDf <- na.omit(mainDf)
  
  return(list(secondDf = secondDf, mainDf = mainDf))
}