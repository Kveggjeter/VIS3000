# Author: Hinrik

# Script cleans dataset for rates of industrialization, measured in GDP value added (%) 
# from industry, per year.

industryData <- function() {

  {
    industryDf <- as.data.frame(read.csv("data/raw/support/industryData.csv", stringsAsFactors = FALSE))
    
    # remove columns for country code, indicator name and indicator code, plus last column, which is empty
    industryDf <- industryDf[-c(2:4, length(industryDf))]
    
    # Removes countries without data
    removeVector <- c()
    for(i in rownames(industryDf)) {
      countryName <- industryDf[i,1]
      nrCheck <- sum(industryDf[i, -c(1)], na.rm = TRUE)
      if(nrCheck == 0) {
        removeVector <- append(removeVector, as.numeric(i))
        # cat(i, nrCheck, "\n")
      }
    }
    industryDf <- industryDf[-c(as.numeric(removeVector)),]
    
    # Apply columnnames (transposed), transpose and replace NAs with 0s
    rownames(industryDf) <- industryDf[,1]
    industryDf <- t(industryDf[,-c(1)])
    industryDf <- replace(industryDf, is.na(industryDf), 0)
    
    # Add new "Year" column for proper indexing and better referencing when importing as csv
    yearVector <- sub(".", "", rownames(industryDf))
    industryDf <- data.frame(Year = yearVector, industryDf)
    rownames(industryDf) <- seq_len(nrow(industryDf))
    
    # correct country names
    names(industryDf)[names(industryDf) == "Gambia..The"]          <- "The.Gambia"
    names(industryDf)[names(industryDf) == "Congo..Rep."]          <- "Congo"
    names(industryDf)[names(industryDf) == "Lao.PDR"]              <- "Laos"
    names(industryDf)[names(industryDf) == "Russian.Federation"]   <- "Russia"
    names(industryDf)[names(industryDf) == "St..Lucia"]            <- "Saint.Lucia"
    names(industryDf)[names(industryDf) == "Slovak.Republic"]      <- "Slovakia"
    names(industryDf)[names(industryDf) == "Korea..Rep."]          <- "South.Korea"
    names(industryDf)[names(industryDf) == "Syrian.Arab.Republic"] <- "Syria"
    names(industryDf)[names(industryDf) == "Turkiye"]              <- "Turkey"
    names(industryDf)[names(industryDf) == "Venezuela..RB"]        <- "Venezuela"
    names(industryDf)[names(industryDf) == "Viet.Nam"]             <- "Vietnam"
    names(industryDf)[names(industryDf) == "Egypt..Arab.Rep."]     <- "Egypt"
    
    setwd("data/processed")
    write.csv(industryDf, paste0("industry_value_added.csv"), row.names = TRUE)
    setwd("../../")
  }
  
  # from CorrelationData.R, changed slightly
  continentDf <- function(main,second,region) {
    unCols <- colnames(main)[colnames(main) %in% region]
    main <- main[, unCols, drop = FALSE]
    
    mpCols <- colnames(second)[colnames(second) %in% region]
    second <- second[, mpCols, drop = FALSE]
    
    main <- as.data.frame(main)
    second <- as.data.frame(second)
    
    return(list(regionalMain = main, regionalSecond = second))
  }
  
  mergeDf <- function(df1, df2, regionVec = NULL) {
    source("src/modifiers/CleaningTwoSets.R")
    
    if(!is.null(regionVec)) {
      contList <- continentDf(df1, df2, regionVec)
      df1 <- contList$regionalMain
      df2 <- contList$regionalSecond
    }
    
    cleanData <- eqClean(df1, df2)
    sumMp <- rowSums(t(cleanData$mainDf[-c(1),])) # MP sum per country 
    gdpVec <- as.character(cleanData$secondDf[1,])
    corDf <- data.frame(sumMp, gdpVec)
    corDf <- type.convert(corDf, as.is = TRUE)
    return(corDf)
  }
  
  # correlation with MP
  {
    library(ggplot2)
    library(dplyr)
    source("src/modifiers/CleaningTwoSets.R")
    source("src/constants/ContinentVector.R")
    
    # create vector containing all GDP rates in 2018. Leave venezuela, as it does not have data from 2018
    indData2018 <- as.data.frame(industryDf[59,-c(1, which(colnames(industryDf)=="Venezuela"))])
    mp <- as.data.frame(read.csv("data/processed/Figure.s6a_2018.csv", stringsAsFactors = FALSE))
    
    corDf <- mergeDf(mp, indData2018, africa)
    corCoefficient <- cor(corDf[,1], corDf[,2], method = "spearman")
    
    ggplot(corDf, aes(x=gdpVec, y=sumMp, label=rownames(corDf))) +
      geom_point(alpha=0.7) + geom_text()+geom_smooth(method=lm) +
      xlab("Industry value added (% of GDP) in 2018") + 
      ylab("Total average MP consumption (mg/capita/day)") +
      ggtitle(paste(" Africa\nR =", corCoefficient))
  }

}