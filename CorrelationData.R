library(ggplot2)
library(reshape2)
# Author: Eirik
# Script for checking the correlation between data
# Testing different data

{
un <- read.csv("un_clean_2018.csv", row.names = 1)
mp <- read.csv("Figure.S6a_2018.csv", row.names = 1)

source("../CleaningTwoSets.R")
data <- eqClean(mp, un)

unDf <- data$unDf
mpDf <- data$mpDf
mpDf <- as.data.frame(t(mpDf))

source("../ContinentVector.R")

trashRemover <- function(df) {
  df <- as.data.frame(t(df))
  df$'Location code' <- NULL
  df$`SDMX code**`<- NULL
  df$`Parent code`<- NULL
  df$Year <- NULL
  return(df)
}

continent <- function(df1, df2, cont) {
  unCols <- colnames(df1)[colnames(df1) %in% cont]
  df1 <- df1[, unCols, drop = FALSE]
  
  mpCols <- colnames(df2)[colnames(df2) %in% cont]
  df2 <- df2[, mpCols, drop = FALSE]
  return(list(df1 = df1, df2 = df2))
}

mpDf <- as.data.frame(t(mpDf))
temp <- continent(unDf, mpDf, asia)
unEf <- temp$df1
mpEf <- temp$df2


print(ncol(unEf))
print(ncol(mpEf))

unEf <- as.data.frame(t(unEf))
mpEf <- as.data.frame(t(mpEf))
trashRemover(unEf)


correl = cor(unEf, mpEf, method = "spearman")
View(correl)


{
  correl[abs(correl) < 0.5] <- NA
  correl[correl == 1 ] <- NA
  correl <- correl[rowSums(!is.na(correl)) > 0, colSums(!is.na(correl)) > 0]
  }
  
  
}

correlM <- melt(correl) 

ggplot(correlM, aes(x = Var1, y = value, fill = Var2)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Correlations", x = "UN stats", y = "Correlation value", fill = "MP in foods")


