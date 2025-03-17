library(dplyr)
# Author: Eirik
# Script for merging mainframe and the new frames
# setwd("data")
un <- read.csv("un_clean_2018.csv")
mp <- read.csv("Figure.S6a_2018.csv")
commonCol <- intersect(colnames(un), colnames(mp))

un <- un %>% select(all_of(commonCol))
mp <- mp %>% select(all_of(commonCol))

unDf <- as.data.frame(un)
mpDf <- as.data.frame(mp)

unDf[] <- lapply(unDf, as.character)
mpDf[] <- lapply(mpDf, as.character)

unDf <- unDf[apply(unDf, 1, function(x) all(!is.na(as.numeric(x)))), ]
mpDf <- mpDf[apply(mpDf, 1, function(x) all(!is.na(as.numeric(x)))), ]

unDf[] <- lapply(unDf, as.numeric)
mpDf[] <- lapply(mpDf, as.numeric)

unDf <- na.omit(unDf)
mpDf <- na.omit(mpDf)

newDs <- bind_rows(unDf, mpDf)
View(newDs)

