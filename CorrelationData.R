# Author: Eirik
# Script for checking the correlation between data
# Testing different data
{
  #setwd(file.path("VIS3000","data"))
  library(ggplot2)
  library(reshape2)
  library(dplyr)
  library(tidyr)
  source("../CleaningTwoSets.R")
  source("../ContinentVector.R")
  
  un <- read.csv("industry_value_added.csv", row.names = 1)
  mp <- read.csv("Figure.S6a_2018.csv", row.names = 1)
  data <- eqClean(mp, un)
  unDf <- data$secondDf
  mpDf <- data$mainDf
 
# Seperating countries by continent in seperate df
  continent <- function(df1, df2, place) {
    
    unCols <- colnames(df1)[colnames(df1) %in% place]
    df1 <- df1[, unCols, drop = FALSE]
    
    mpCols <- colnames(df2)[colnames(df2) %in% place]
    df2 <- df2[, mpCols, drop = FALSE]
    return(list(df1 = df1, df2 = df2))
  }

# Making a df based on continent queried. Has some print statements
# in case the rows differs (it says ncol, but we're reversing the order later on)
  contDf <- function(unDf, mpDf, place) {
  
    temp <- continent(unDf, mpDf, place)
    newUn <- temp$df1
    newMp <- temp$df2
    
    print(ncol(newUn))
    print(ncol(newMp))
    
    newUn <- as.data.frame(t(newUn))
    newMp <- as.data.frame(t(newMp))
    return(list(newUn = newUn, newMp = newMp))
  }
# Setting up the correlation. Deciding what correlation value we want (cl) and the dataset (df)  
  correl <- function(cl, df) {
    df[abs(df) < cl] <- NA
    df[df == 1] <- NA
    df <- df[rowSums(!is.na(df)) > 0, colSums(!is.na(df)) > 0]
    return(df)
  }
  
  # Africa
  {
    af <- contDf(unDf, mpDf, africa)
    afUn <- af$newUn
    afMp <- af$newMp
    write.csv(afMp, paste0("africaMp.csv"), row.names = TRUE)
    afCor = cor(afUn, afMp, method = "spearman")
  }
  # Asia
  {
    as <- contDf(unDf, mpDf, asia)
    asUn <- as$newUn
    asMp <- as$newMp
    write.csv(asMp, paste0("asiaMp.csv"), row.names = TRUE)
    asCor = cor(asUn, asMp, method = "spearman")
  }
  # Europe
  {
    eu <- contDf(unDf, mpDf, europe)
    euUn <- eu$newUn
    euMp <- eu$newMp
    write.csv(euMp, paste0("europaMp.csv"), row.names = TRUE)
    euCor = cor(euUn, euMp, method = "spearman")
  }
  # North America
  {
    us <- contDf(unDf, mpDf, north_america)
    usUn <- us$newUn
    usMp <- us$newMp
    write.csv(usMp, paste0("usMp.csv"), row.names = TRUE)
    usCor = cor(usUn, usMp, method = "spearman")
  }
  # South America
  {
    sa <- contDf(unDf, mpDf, south_america)
    saUn <- sa$newUn
    saMp <- sa$newMp
    write.csv(saMp, paste0("saMp.csv"), row.names = TRUE)
    saCor = cor(saUn, saMp, method = "spearman")
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




