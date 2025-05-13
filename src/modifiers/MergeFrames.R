# Author: 7036
# Script for merging mainframe and the new frames

mergeFrames <- function(mainDf, secondDf){

  source("src/modifiers/CleaningTwoSets.R")
  data <- eqClean(mainDf, secondDf)
  secondDf <- data$secondDf
  mainDf <- data$mainDf
  newDf <- bind_rows(secondDf, mainDf)

}

