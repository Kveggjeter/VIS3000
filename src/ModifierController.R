
# Here you can take full use of the functions we've made. You will find them all under src/modifiers. If you are doing any writes from the script, make
# sure to always do 'setwd("data/processed")' and close the action with 'setwd("../../)'. Else the application will fail and you will have to set 
# wd again. Remember to always work from the Main package and always return after going somewhere else.
modifierController <- function() {
  source("src/modifiers/cleaningTwoSets.R")
  source("src/modifiers/CorrelationData.R")
  source("src/modifiers/MergeFrames.R")
  source("src/modifiers/MirrorRowsAndColls.R")
}

  
  getwd()
  mainDf <- read.csv("data/processed/Figure.s6a_2018.csv", , row.names = 1)
  secondDf <- read.csv("data/processed/alzheimer_clean.csv", , row.names = 1)
  
  newDf <- mergeFrames(mainDf, secondDf)
  
  correlationData(mainDf, secondDf)
  
  # Use this on a df in Tableau if you get weird values. 
  newDf <- mirrorRowsAndColls(newDf)
  View(newDf)
  {
    setwd("data/processed")
    write.csv(newDf,
              paste0("mainDf_with_alzheimer.csv"),
              row.names = TRUE)
    setwd("../../")
  }




