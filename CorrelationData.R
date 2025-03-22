library(ggplot2)
library(reshape2)
# Author: Eirik
# Script for checking the correlation between data
# Testing different data

un <- read.csv("un_clean_2018.csv", row.names = 1)
mp <- read.csv("Figure.S6a_2018.csv", row.names = 1)

source("../CleaningTwoSets.R")
data <- eqClean(mp, un)

unDf <- data$unDf
mpdf <- data$mpDf

{
  unDf <- as.data.frame(t(unDf))
  unDf$'Location code' <- NULL
  unDf$`SDMX code**`<- NULL
  unDf$`Parent code`<- NULL
  unDf$Year <- NULL
  mpDf <- as.data.frame(t(mpDf))
}
  correl = cor(unDf, mpDf, method = "spearman")


{
  correl[abs(correl) < 0.7] <- NA
  correl[correl == 1 ] <- NA
  correl <- correl[rowSums(!is.na(correl)) > 0, colSums(!is.na(correl)) > 0]
  }
  
  View(correl)

correlM <- melt(correl) 

ggplot(correlM, aes(x = Var1, y = value, fill = Var2)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Correlations", x = "UN stats", y = "Correlation value", fill = "MP in foods")


