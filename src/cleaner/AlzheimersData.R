# Author: Eirik
# Cleans alzheimer dataset by counting every row belonging to a country
# (since the dataset is based on individuals) and calculating the mean
# instances of alzheimers diagnosis. Important notice:
#
# This dataset does not represent an actual statistic of the whole population,
# but rather a selection of seniors in the risk group.To add more attributes,
# simply add more in the dplyr "summarise" function. 
#

cleaningAlzheimerDataset <- function() {
  
  library(dplyr)
  alzheimerDf <- read.csv("data/raw/support/alzheimers_prediction_dataset.csv")
  alzheimerDf$Alzheimer.s.Diagnosis <- 
    ifelse(alzheimerDf$Alzheimer.s.Diagnosis == "Yes", 1, 0)
  
  selectionFromAlzheimerDf <- alzheimerDf %>%
    count(Country, name = "Count_Of_Country")
  
  selectionFromAlzheimerDf <- alzheimerDf %>%
    group_by(Country) %>%
    summarise(
      Count_Of_Country = n(),
      Alzheimer.s.Diagnosis = mean(Alzheimer.s.Diagnosis, na.rm = TRUE)
    )
  
  selectionFromAlzheimerDf <- subset(selectionFromAlzheimerDf, select=c(Country, Alzheimer.s.Diagnosis))
  selectionFromAlzheimerDf <- as.data.frame(t(selectionFromAlzheimerDf))
  colnames(selectionFromAlzheimerDf) <- selectionFromAlzheimerDf[1, ]
  selectionFromAlzheimerDf <- selectionFromAlzheimerDf[-1, ]
  View(selectionFromAlzheimerDf)
  setwd("data/processed")
  write.csv(selectionFromAlzheimerDf,
            paste0("alzheimer_clean.csv"),
            row.names = TRUE)
  setwd("../../")
}


