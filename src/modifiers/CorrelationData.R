# Author: Eirik
# Script for checking the correlation between data
# Testing different data
correlationData <- function(mainDf, secondDf){
    library(ggplot2)
    library(reshape2)
    library(dplyr)
    library(tidyr)
    source("src/modifiers/CleaningTwoSets.R")
    source("src/constants/ContinentVector.R")
  
    data <- eqClean(mainDf, secondDf)
    secondDf <- data$secondDf
    mainDf <- data$mainDf
   
  # Seperating countries by continent in separate dfs
    continent <- function(df1, df2, place) {
      
      secondDfCols <- colnames(df1)[colnames(df1) %in% place]
      df1 <- df1[, secondDfCols, drop = FALSE]
      
      mainDfCols <- colnames(df2)[colnames(df2) %in% place]
      df2 <- df2[, mainDfCols, drop = FALSE]
      return(list(df1 = df1, df2 = df2))
    }
  
  # Making a df based on continent queried. Has some print statements
  # in case the rows differs (it says ncol, but we're reversing the order later on)
    contDf <- function(secondDf, mainDf, place) {
    
      temp <- continent(secondDf, mainDf, place)
      newSecondDf <- temp$df1
      newMainDf <- temp$df2
      
      print(ncol(newSecondDf))
      print(ncol(newMainDf))
      
      newSecondDf <- as.data.frame(t(newSecondDf))
      newMainDf <- as.data.frame(t(newMainDf))
      return(list(newSecondDf = newSecondDf, newMainDf = newMainDf))
    }
  # Setting up the correlation. Deciding what correlation value we want (cl) and the dataset (df)  
    correl <- function(cl, df) {
      df[abs(df) < cl] <- NA
      df[df == 1] <- NA
      df <- df[rowSums(!is.na(df)) > 0, colSums(!is.na(df)) > 0]
      return(df)
    }
    setwd("data/processed")
    # Africa
    {
      af <- contDf(secondDf, mainDf, africa)
      afSecondDf <- af$newSecondDf
      afMainDf <- af$newMainDf
      write.csv(afMainDf, paste0("africaMp.csv"), row.names = TRUE)
      afCor = cor(afSecondDf, afMainDf, method = "spearman")
    }
    # Asia
    {
      as <- contDf(secondDf, mainDf, asia)
      asSecondDf <- as$newSecondDf
      asMainDf <- as$newMainDf
      write.csv(asMainDf, paste0("asiaMp.csv"), row.names = TRUE)
      asCor = cor(asSecondDf, asMainDf, method = "spearman")
    }
    # Europe
    {
      eu <- contDf(secondDf, mainDf, europe)
      euSecondDf <- eu$newSecondDf
      euMainDf <- eu$newMainDf
      write.csv(euMainDf, paste0("europaMp.csv"), row.names = TRUE)
      euCor = cor(euSecondDf, euMainDf, method = "spearman")
    }
    # North America
    {
      us <- contDf(secondDf, mainDf, north_america)
      usSecondDf <- us$newSecondDf
      usMainDf <- us$newMainDf
      write.csv(usMainDf, paste0("usMainDf.csv"), row.names = TRUE)
      usCor = cor(usSecondDf, usMainDf, method = "spearman")
    }
    # South America
    {
      sa <- contDf(secondDf, mainDf, south_america)
      saSecondDf <- sa$newSecondDf
      saMainDf <- sa$newMainDf
      write.csv(saMainDf, paste0("saMainDf.csv"), row.names = TRUE)
      saCor = cor(saSecondDf, saMainDf, method = "spearman")
    }
    
    saCor <- correl(0.7, saCor)
    usCor <- correl(0.7, usCor)
    euCor <- correl(0.7, euCor)
    asCor <- correl(0.7, asCor)
    afCor <- correl(0.7, afCor)
    
    View(saCor)
    View(usCor)
    View(euCor)
    View(asCor)
    View(afCor)
    setwd("../../")
    
}
  
  # Purely for checking if there are similar result from the different dataframes. Not to really be used in the final
  # report. It didnt give much at all, but keeping it here for testing purposes. You never know, might find something interesting
  # with other data. 
  
    {
      contCors <- list(
        Africa = afCor,
        Asia = asCor,
        Europe = euCor,
        NorthAmerica = usCor,
        SouthAmerica = saCor
      )
      
      all_pairs <- lapply(names(contCors), function(cont) {
        melt(contCors[[cont]]) %>% 
          filter(abs(value) >= 0.7) %>% 
          mutate(Continent = cont)
      }) %>% bind_rows() %>% 
        rename(UN = Var1, MP = Var2, Correlation = value)
      
      
      aggregated <- all_pairs %>% 
        group_by(UN, MP) %>% 
        summarise(
          Avg_Correlation = mean(Correlation),
          Continents = n()
        ) %>% 
        arrange(desc(Continents), desc(Avg_Correlation))
      
      View(aggregated)
    }





