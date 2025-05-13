# Author: 7036 & 7012
# Here you can take full use of the functions we've made. You will find them all under src/modifiers. If you are doing any writes from the script, make
# sure to always do 'setwd("data/processed")' and close the action with 'setwd("../../)'. Else the application will fail and you will have to set 
# wd again. Remember to always work from the Main package and always return after going somewhere else.

modifierController <- function() {
  source("src/modifiers/cleaningTwoSets.R")
  source("src/modifiers/MergeFrames.R")
  source("src/modifiers/MirrorRowsAndColls.R")
  source("src/modifiers/IndustryCorrTool.R")
  source("src/modifiers/CorrelationData.R")
}

# Run this for importing each component!
modifierController()
  
  getwd()
  
  # For simple correlation matrix. Use a data set that is compatible with
  # s6a (column as countries and from 2018). 
  mainDf <- read.csv("data/processed/Figure.s6a_2018.csv", , row.names = 1)
  secondDf <- read.csv("data/processed/industry_value_added.csv", , row.names = 1)
  mergeFrames(mainDf, secondDf)
  correlationData(mainDf, secondDf)
  
  # Use this on a df in Tableau if you get weird values. 
  mirrorRowsAndColls(mainDf)

  # Here are some visualizations! (IndustryCorrTool.R) It uses 
  # ggCorrplot, ggplot2 and Hmisc. Download here if you don't have them locally. If 
  # you do, jump over these lines.
  install.packages("ggcorrplot")
  install.packages("Hmisc")
  install.packages("ggplot2")
  
  industryFilteredCorr(region = east_southeast_asia, title = "East and Southeast Asia", method = "spearman")
  filteredCorrMatrix(region = north_america, method = "spearman")

