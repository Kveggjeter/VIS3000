# Author: Eirik
# Script for checking the correlation between data
# Will be differently, it doesn't give us anything at the moment
# setwd("data")

data <- read.csv("new_data.csv", row.names = 1)

correl = cor(t(data))

View(correl)