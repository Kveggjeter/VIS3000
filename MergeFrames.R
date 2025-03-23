library(dplyr)
# Author: Eirik
# Script for merging mainframe and the new frames
# setwd("data")
{
  un <- read.csv("un_clean_2018.csv", row.names = 1)
  mp <- read.csv("Figure.S6a_2018.csv", row.names = 1)
  
  source("../CleaningTwoSets.R")
  data <- eqClean(mp, un)
  
  unDf <- data$unDf
  mpDf <- data$mpDf
}

newDs <- bind_rows(unDf, mpDf)
View(newDs)

