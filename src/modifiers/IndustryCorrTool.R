# Author: 7012

# A script for dynamically creating correlation visualisations between MP and industry value added.
# Includes correlations with scatterplots, and another type that analysis the correlation for each 
# food type in a correlation matrix as well.

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

#' Create a ggplot2 correlation plot between MP and Industry datsets with region filter
#'
#' @param region a ContinentVector
#' @param title optional string
#' @param method optional string: pearson or spearman. Default is spearman
#' @param dataSelection optional string: sum, max, min or category. Default is sum
#' @param foodCategory optional string - Specify the name of the foodCategory from the MP dataset
#'
#' @examples
#' industryFilteredCorr(region=africa, title="Africa", method="pearson")
#' industryFilteredCorr(region=gulf_of_guinea, title"Guinea-gulf", dataSelection="foodCategory", foodCategory="Fish")
#' 
industryFilteredCorr <- function(region, title, method, dataSelection, foodCategory) {
  # validation for optional arguments
  if(missing(title)) {
    title <- ""
  }
  if(missing(method)) {
    method <- "spearman"
  }
  if(missing(dataSelection)) {
    dataSelection <- "sum"
  }
  if(missing(foodCategory)) {
    foodCategory <- ""
  }
  
  if(foodCategory != "" && dataSelection != "category") {
    warning('dataSelection must be "category" for foodCategory to be applied')
  }
  
  
  library(ggplot2)
  library(dplyr)
  source("src/modifiers/CleaningTwoSets.R")
  source("src/constants/ContinentVector.R")
  source("src/modifiers/CleaningTwoSets.R")
  
  # create vector containing all GDP rates in 2018. Leave venezuela, as it does not have data from 2018
  indData2018 <- as.data.frame(industryDf[59,-c(1, which(colnames(industryDf)=="Venezuela"))])
  mp <- as.data.frame(read.csv("data/processed/Figure.s6a_2018.csv", stringsAsFactors = FALSE))
  
  # modify MP data selection based on function arguments
  if(dataSelection == "category" && foodCategory != "") {
    mp <- as.data.frame(mp)[mp$X == foodCategory,-c(1)]
  }
  if(dataSelection == "max") {
    mp <- sapply(mp[,-c(1)], max) |>
      t()
  }
  if(dataSelection == "min") {
    mp <- sapply(mp[,-c(1)], min) |>
      t()
  }
  
  # filter by region
  contList <- continentDf(mp, indData2018, region)
  df1 <- contList$regionalMain
  df2 <- contList$regionalSecond
  
  cleanData <- eqClean(df1, df2)
  mp <- rowSums(t(cleanData$mainDf)) # sums MPs in modified dataset (not always an MP sum though)
  
  gdpVec <- as.character(cleanData$secondDf[1,])
  
  # put together MP and GDP
  corDf <- data.frame(mp, gdpVec)
  corDf <- type.convert(corDf, as.is = TRUE)
  
  # do correlation
  corCoefficient <- cor(corDf[,1], corDf[,2], method = method)
  result <- cor.test(corDf[,1], corDf[,2], method = method)
  pVal <- round(result$p.value,3)
  sharedVar <- round(corCoefficient*corCoefficient*100,2)
  
  # plot
  ggplot(corDf, aes(x=gdpVec, y=mp, label=rownames(corDf))) +
    geom_point(alpha=0.7) + geom_text()+geom_smooth(method=lm) +
    xlab("Industry value added (% of GDP) in 2018") + 
    ylab("Total average MP consumption (mg/capita/day)") +
    ggtitle(paste0(title, " (", method, ")", "\nR = ", round(corCoefficient,5), ", accounting for ",
                   sharedVar, "% of shared variance\n","P = ", pVal))
}

#' Industry data correlation matrix with Hmisc and ggcorrplot
#'
#' @param region a ContinentVector
#' @param sigLevel optional double: the threshold for the acceptance of the null hypothesis. Default is 0.05
#' @param method optional string: pearson or spearman correlation coefficients
#'
#' @examples
#' filteredCorrMatrix(region=europe, sigLevel=0.1, method="spearman")
#' filteredCorrMatrix(region=asia)
#' 
filteredCorrMatrix <- function(region, sigLevel, method) {
  if(missing(sigLevel)) {
    sigLevel <- 0.05
  }
  if(missing(method)) {
    method <- "spearman"
  }
  
  library(dplyr)
  library(ggplot2)
  library(ggcorrplot)
  library(Hmisc)
  
  source("src/modifiers/CleaningTwoSets.R")
  source("src/constants/ContinentVector.R")
  
  # very similar procedure as IndustryFilteredCorr()
  gdpVec <- as.data.frame(industryDf[59,-c(1, which(colnames(industryDf)=="Venezuela"))])
  mp <- as.data.frame(read.csv("data/processed/Figure.s6a_2018.csv", stringsAsFactors = FALSE))
  cols <- as.vector(mp[1])$X
  
  contList <- continentDf(mp, gdpVec, region)
  mp <- contList$regionalMain
  gdpVec <- contList$regionalSecond
  
  clean <- eqClean(mp, indData2018)
  df <- clean$mainDf
  
  df <- rbind(df, gdpVec) |>
    as.data.frame() |>
    t()
  
  colnames(df) <- c(cols, "gdp")
  
  res <- rcorr(as.matrix(df), type = method) # correlation result for p values
  res$P[is.na(res$P)] <- 1 # make a matrix for p values
  
  corr <- cor(df, method = method)
  ggcorrplot(corr, lab = TRUE, lab_size = 4, digits = 2, p.mat = res$P, insig = "blank",
             sig.level = sigLevel, type = "lower")
}
