# Author: Eirik

# This is the script for cleaning the main data we got. It contains some general functions that are reusable for similar datasets.
# Its still up for improvment.

# Remember to import the datafiles that are needed for cleaning. If you work from other directory, it's important that you
# place this script in that directory. The pathing is set to relative for where the script runs. If in doubt, i've added
# a "getwd()" for checking
# setwd("data")

splittingUpMainDatasets <- function() {
  getwd()
    
    # 4 and 5 are reversed for some reason, reverting 4 before the data is managed, 5 is reverted within it's own block of code, as it
    # was just a lot easier splitting it up that way
    s2df <- as.data.frame(read.csv("data/raw/microplastics_and_food_consumption/s2.csv"))
    s3df <- as.data.frame(read.csv("data/raw/microplastics_and_food_consumption/s3.csv"))
    s4df <- as.data.frame(read.csv("data/raw/microplastics_and_food_consumption/s4.csv"))
    s5df <- as.data.frame(read.csv(t("data/raw/microplastics_and_food_consumption/s5.csv")))
    s6df <- as.data.frame(read.csv("data/raw/microplastics_and_food_consumption/s6.csv"))
    
    print("setting the folder path")
    setwd("data/processed")
    getwd()
    
    # Splitting dataframes into subframes
    # Not that much in use, but I did not manage to make it more dynamic. 
    splittingDfIntoSubframe <- function(df, splitted, listName){
      listName <- split(df, cut(seq(1, nrow(df)), breaks = c(splitted, Inf), right = FALSE))
      return(listName)}
  
  # Fetching the fetchingFirstPartOfDf part of the dataset. "Title" is usually locked as columnheader
    fetchingFirstPartOfDf <- function(df) {
      newDf <- df[1:19, ]
      return(newDf)
    }
  
  # Fetching the second part, if the dataset only contains two sets. The table title is usually at [1,1]
    ifDfOnlyContainsTwoSets <- function(df) {
      nf <-df[20:39, ]
      return(nf)
    }
    
  # Writing to folder
    saving <- function(df){
      write.csv(df, paste0(sn, "_", year, ".csv"), row.names = TRUE)
    }
   
    
    # For cleaning the first df. The declaration and usage of "sn" and "year must be inside the function. Cannot use a modular 
    # saving function, they'll just mute and reassign the values to be what it originally was inside the saving function. 
    top <- function(df) {
      df
        nameOfSet <- names(df[1])
        if(nameOfSet == "V1") {
          nameOfSet <- rownames(df)[1]
        }
        year <- df[1,1]
        colnames(df) <- df[1, ]
        df <- df[-1, ]
        rownames(df) <- df[, 1]
        df <- df[, -1]
        write.csv(df, paste0(nameOfSet, "_", year, ".csv"), row.names = TRUE)
    }
    
    # Cleaning the rest of the data, same as top
    mid <- function(df) {
      
      nameOfSet <- df[1,1]
        if (is.na(nameOfSet) || nameOfSet == "") {
          nameOfSet <- rownames(df)[2]
        }
        year <- df[2,1]
        df <- df[-1, ]
        colnames(df) <- df[1, ]
        df <- df[-1, ]
        rownames(df) <- df[, 1]
        df <- df[, -1]
        write.csv(df, paste0(nameOfSet, "_", year, ".csv"), row.names = TRUE)
    }
    
    print("d1")
    # ********************  s2df  **********************
    {
    firstPart <- fetchingFirstPartOfDf(s2df)
    split <- c(20, seq(20 + 20, nrow(s2df), by = 20))
    j <- splittingDfIntoSubframe(s2df, split, j)
    
      top(firstPart)
      for (i in seq_along(j)) {
        mid(j[[i]])
      }
    }
    
    # ****************** s3, s4, s5  ******************
      {
        top(fetchingFirstPartOfDf(s3df))
        mid(ifDfOnlyContainsTwoSets(s3df))
        
        top(fetchingFirstPartOfDf(s4df))
        mid(ifDfOnlyContainsTwoSets(s4df))
        
        top(fetchingFirstPartOfDf(s5df))
        mid(ifDfOnlyContainsTwoSets(s5df))
      }
    
      
    print("warCrime")
    # A somewhat special case, some weird placement of data that made it not fit with the rest. It's to different from the others that
    # I see any necessity of creating an abstraction for this
    # ********************  s6df  **********************
    {
        # Reversing the orders, since s6df for some reason comes with columns and rows switched
        {
          a <- as.data.frame(t(s6df[1:110, ]))
          b <- as.data.frame(t(s6df[112:222, ]))
          c <- as.data.frame(t(s6df[224:334, ]))
          sets <- list(a, b, c)
        }
        
        
        # Cleans s6df and merges the weird double-columns.
        for (i in seq_along(sets)) {
          
          if (i == 1) {
            sn <- row.names(sets[[i]][1, ])
            year <- sets[[i]][1,1]
            
          } else {
            sn <- sets[[i]][1,1]
            year <- sets[[i]][1,2]
          }
          
          tempValue <- sets[[i]][1:19, ]
          tempLastValue <- sets[[i]][21:24, ]
          colnames(tempValue) <- tempValue[1, ]
          tempValue <- tempValue[-1, ]
          colnames(tempLastValue) <- tempLastValue[1, ]
          tempLastValue <- tempLastValue[-1, ]
          if (i == 1) {
            sets[[i]] <- rbind(tempValue, tempLastValue)
            rownames(sets[[i]]) <- sets[[i]][, 1]
            sets[[i]] <- sets[[i]][, -1]
          }else {
            tempValue <- tempValue[, -1]
            rownames(tempValue) <- tempValue[, 1]
            tempValue <- tempValue[, -1]
            
            tempLastValue <- tempLastValue[, -1]
            rownames(tempLastValue) <- tempLastValue[, 1]
            tempLastValue <- tempLastValue[, -1]
            
            sets[[i]] <- rbind(tempValue, tempLastValue)
          }
          saving(sets[[i]])
        }
      }
  
  setwd("../../")
}

