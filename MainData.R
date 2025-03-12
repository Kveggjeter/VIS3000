# Author: Eirik
# This is the script for cleaning the main data we got. Have not yet been able to finish up
# merging, because I'm not entirely sure what data belongs where tbh.

getwd()
# Remember to set your own path here or change this to file.choose() for running just one time
# The data has been pushed to my branch
setwd("C:\\Users\\sundb\\OneDrive\\Documents\\vis3000\\VIS3000\\data")
table1 <- read.csv("general.csv")
table2 <- read.csv("mp.csv")

# Splitting dataframes into subframes
# I started out using this method, but got deprecated pretty fast. I still want to use it, 
# so I've left it here for later. This is beeing used for df1
splitting <- function(df, splitted, listName){
  listName <- split(df, cut(seq(1, nrow(df)), breaks = c(splitted, Inf), right = FALSE))
  return(listName)
}

df1 <- as.data.frame(table1)
df2 <- as.data.frame(table2)

# Reversing the orders, since df2 for some reason comes with columns and rows swtiched
{
sub4 <- as.data.frame(t(df2[1:110, ]))
sub5 <- as.data.frame(t(df2[112:222, ]))
sub6 <- as.data.frame(t(df2[224:334, ]))
list2 <- list(sub4, sub5, sub6)
# View(list2[[1]])
# View(list2[[2]])
# View(list2[[3]])
}


# Warcrimes_1. Cleans df2
for (i in seq_along(list2)) {
  
  if (i == 1) {
    sn <- row.names(list2[[i]][1, ])
    year <- list2[[i]][1,1]
   
  } else {
    sn <- list2[[i]][1,1]
    year <- list2[[i]][1,2]
  }
  
  temp <- list2[[i]][1:19, ]
  tempLast <-list2[[i]][21:24, ]
  colnames(temp) <- temp[1, ]
  temp <- temp[-1, ]
  colnames(tempLast) <- tempLast[1, ]
  tempLast <- tempLast[-1, ]
  if (i == 1) {
  list2[[i]] <- rbind(temp, tempLast)
  rownames(list2[[i]]) <- list2[[i]][, 1]
  list2[[i]] <- list2[[i]][, -1]
  } else {
    temp <- temp[, -1]
    rownames(temp) <- temp[, 1]
    temp <- temp[, -1]
    
    tempLast <- tempLast[, -1]
    rownames(tempLast) <- tempLast[, 1]
    tempLast <- tempLast[, -1]
    
    list2[[i]] <- rbind(temp, tempLast)
  }
  print(sn)
  print(year)
  write.csv(list2[[i]], paste0(sn, "_", year, ".csv"), row.names = TRUE)
}

split1 <- seq(1, nrow(df1), by = 20)
list1 <- splitting(df1, split1, list1)

# Warcrimes_2, but with a lot less drama. This data was much better cleaned from before
for (i in seq_along(list1)) {
  year <- list1[[i]][1, 1]
  colnames(list1[[i]]) <- list1[[i]][1, ]
  list1[[i]] <- list1[[i]][-1, ]
  rownames(list1[[i]]) <- list1[[i]][, 1]
  list1[[i]] <- list1[[i]][, -1]
  write.csv(list1[[i]], paste0(year, ".csv"), row.names = TRUE)
}


