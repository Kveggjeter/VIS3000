#Author: 7036
mirrorRowsAndColls <- function(df) {

  df <- as.data.frame(t(df))
  setwd("data/processed")
  write.csv(df, paste0("trunk.csv"), row.names = TRUE)
  setwd("../../")
}
