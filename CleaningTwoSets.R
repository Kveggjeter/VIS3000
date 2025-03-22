# Author: Eirik
# Script for merging mainframe and new frames.

eqClean <- function(mp, un) {
  library(dplyr)
  commonCol <- intersect(colnames(un), colnames(mp))
  
  un <- un %>% select(all_of(commonCol))
  mp <- mp %>% select(all_of(commonCol))
  
  unDf <- as.data.frame(un)
  mpDf <- as.data.frame(mp)
  
  unDf[] <- lapply(unDf, as.character)
  mpDf[] <- lapply(mpDf, as.character)
  
  unDf[] <- lapply(unDf, function(x) as.numeric(as.character(x)))
  mpDf[] <- lapply(mpDf, function(x) as.numeric(as.character(x)))
  
  print(paste("Antall rader i unDf etter filtrering:", nrow(unDf)))
  print(paste("Antall rader i mpDf etter filtrering:", nrow(mpDf)))
  
  unDf[] <- lapply(unDf, as.numeric)
  mpDf[] <- lapply(mpDf, as.numeric)
  
  unDf <- na.omit(unDf)
  mpDf <- na.omit(mpDf)
  
  return(list(unDf = unDf, mpDf = mpDf))
}

