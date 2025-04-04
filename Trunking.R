df <- read.csv("Figure.S6a_2018.csv", row.names = 1)
df <- as.data.frame(t(df))
View(df)

write.csv(df, paste0("trunk.csv"), row.names = TRUE)
