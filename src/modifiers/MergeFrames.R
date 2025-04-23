# Author: Eirik
# Script for merging mainframe and the new frames

mergeFrames <- function(mainDf, secondDf){
  View(mainDf)
  View(secondDf)
  
  source("src/modifiers/CleaningTwoSets.R")
  data <- eqClean(mainDf, secondDf)
  secondDf <- data$secondDf
  mainDf <- data$mainDf
  
  View(mainDf)
  View(secondDf)
  newDf <- bind_rows(secondDf, mainDf)
  View(newDf)

}

