
# Here you can take full use of the functions we've made. You will find them all under src/modifiers. If you are doing any writes from the script, make
# sure to always do 'setwd("data/processed")' and close the action with 'setwd("../../)'. Else the application will fail and you will have to set 
# wd again. Remember to always work from the Main package and always return after going somewhere else.
modifierController <- function() {
  source("src/modifiers/cleaningTwoSets.R")
  source("src/modifiers/CorrelationData.R")
  source("src/modifiers/MergeFrames.R")
  source("src/modifiers/MirrorRowsAndColls.R")
  source("src/modifiers/IndustryCorrTool.R")
}

  
  getwd()
  mainDf <- read.csv("data/processed/Figure.s6a_2018.csv", , row.names = 1)
  secondDf <- read.csv("data/processed/industry_value_added.csv", , row.names = 1)
  
  mergeFrames(mainDf, secondDf)
  correlationData(mainDf, secondDf)
  
  # Use this on a df in Tableau if you get weird values. 
  mirrorRowsAndColls(mainDf)

  # here are some visualizations! (IndustryCorrTool.R)
  industryFilteredCorr(region = east_southeast_asia, title = "East and Southeast Asia", method = "spearman")
  filteredCorrMatrix(region = north_america, method = "spearman")

