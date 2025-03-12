# Author: Eirik

# This is the script for cleaning the main data we got. It contains some general functions that are reusable for similar datasets.
# Its still up for improvment.

# Remember to import the datafiles that are needed for cleaning. If you work from other directory, it's important that you
# place this script in that directory. The pathing is set to relative for where the script runs. If in doubt, i've added
# a "getwd()" for checking
setwd("data")
table1 <- read.csv("s2.csv")
table2 <- read.csv("s3.csv")
table3 <- read.csv("s4.csv")
table4 <- read.csv("s5.csv")
table5 <- read.csv("s6.csv")

# Splitting dataframes into subframes
# Not that much in use, but I did not manage to make it more dynamic. 
splitting <- function(df, splitted, listName){
  listName <- split(df, cut(seq(1, nrow(df)), breaks = c(splitted, Inf), right = FALSE))
  return(listName)
}

# Fetching the first part of the dataset. "Title" is usually locked as columnheader
first <- function(df) {
  nf <- df[1:19, ]
  return(nf)
}

# Fetching the second part, if the dataset only contains two sets. The table title is usually at [1,1]
dual <- function(df) {
  nf <-df[20:39, ]
  return(nf)
}


# Writing to folder
saving <- function(df){
  write.csv(df, paste0(sn, "_", year, ".csv"), row.names = TRUE)
}

# 4 and 5 are reversed for some reason, reverting 4 before the data is managed, 5 is reverted within it's own block of code, as it
# was just a lot easier splitting it up that way
df1 <- as.data.frame(table1)
df2 <- as.data.frame(table2)
df3 <- as.data.frame(table3)
df4 <- as.data.frame(t(table4))
df5 <- as.data.frame(table5)

# For cleaning the first df. The declaration and usage of "sn" and "year must be inside the function. Cannot use a modular 
# saving function, they'll just mute and reassign the values to be what it originally was inside the saving function. 
top <- function(df) {
  
    sn <- names(df[1])
    if(sn == "V1") {
      sn <- rownames(df)[1]
    }
    year <- df[1,1]
    colnames(df) <- df[1, ]
    df <- df[-1, ]
    rownames(df) <- df[, 1]
    df <- df[, -1]
    write.csv(df, paste0(sn, "_", year, ".csv"), row.names = TRUE)
}

# Cleaning the rest of the data, same as top
mid <- function(df) {
  
    sn <- df[1,1]
    if (is.na(sn) || sn == "") {
      sn <- rownames(df)[2]
    }
    year <- df[2,1]
    df <- df[-1, ]
    colnames(df) <- df[1, ]
    df <- df[-1, ]
    rownames(df) <- df[, 1]
    df <- df[, -1]
    write.csv(df, paste0(sn, "_", year, ".csv"), row.names = TRUE)
}


# ********************  df1  **********************
{
one <- first(df1)
split <- c(20, seq(20 + 20, nrow(df1), by = 20))
j <- splitting(df1, split, j)

  top(one)
  for (i in seq_along(j)) {
    mid(j[[i]])
  }
}

# ********************  df2  **********************
{
  top(first(df2))
  mid(dual(df2))
}

# ********************  df3  **********************
{
  top(first(df3))
  mid(dual(df3))
}

# ********************  df4  **********************
{
  top(first(df4))
  mid(dual(df4))
}
  
  
# A somewhat special case, some weird placement of data that made it not fit with the rest. It's to different from the others that
# I see any necessity of creating an abstraction for this
# ********************  df5  **********************
{
  # Reversing the orders, since df5 for some reason comes with columns and rows switched
  {
    sub5a <- as.data.frame(t(df5[1:110, ]))
    sub5b <- as.data.frame(t(df5[112:222, ]))
    sub5c <- as.data.frame(t(df5[224:334, ]))
    sets <- list(sub5a, sub5b, sub5c)
  }
  
  
  # Warcrimes_1. Cleans df5 and merges the weird double-columns 
  for (i in seq_along(sets)) {
    
    if (i == 1) {
      sn <- row.names(sets[[i]][1, ])
      year <- sets[[i]][1,1]
      
    } else {
      sn <- sets[[i]][1,1]
      year <- sets[[i]][1,2]
    }
    
    temp <- sets[[i]][1:19, ]
    tempLast <- sets[[i]][21:24, ]
    colnames(temp) <- temp[1, ]
    temp <- temp[-1, ]
    colnames(tempLast) <- tempLast[1, ]
    tempLast <- tempLast[-1, ]
    if (i == 1) {
      sets[[i]] <- rbind(temp, tempLast)
      rownames(sets[[i]]) <- sets[[i]][, 1]
      sets[[i]] <- sets[[i]][, -1]
    }else {
      temp <- temp[, -1]
      rownames(temp) <- temp[, 1]
      temp <- temp[, -1]
      
      tempLast <- tempLast[, -1]
      rownames(tempLast) <- tempLast[, 1]
      tempLast <- tempLast[, -1]
      
      sets[[i]] <- rbind(temp, tempLast)
    }
    saving(sets[[i]])
  }
}
