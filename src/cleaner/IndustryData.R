# Author: 7012

# Script cleans dataset for values denoting industry value added (% of GDP) per year.
# This indicator was hinted towards in the study by Zhou & You as a possible correlative factor
# useful in estimating MP reduction. Our findings were not as conclusive.

# You can do visual correlation analyses with this dataset and the MP dataset with the 
# InudstryCorrTool.R script in the modifier directory.
industryData <- function() {

  {
    industryDf <- as.data.frame(read.csv("data/raw/support/industryData.csv", stringsAsFactors = FALSE))
    
    # remove columns for country code, indicator name and indicator code, plus last column, which is empty
    industryDf <- industryDf[-c(2:4, length(industryDf))]
    
    # Removes countries without data
    removeVector <- c()
    for(i in rownames(industryDf)) {
      countryName <- industryDf[i,1]
      nrCheck <- sum(industryDf[i, -c(1)], na.rm = TRUE)
      if(nrCheck == 0) {
        removeVector <- append(removeVector, as.numeric(i))
        # cat(i, nrCheck, "\n")
      }
    }
    industryDf <- industryDf[-c(as.numeric(removeVector)),]
    
    # Apply columnnames (transposed), transpose and replace NAs with 0s
    rownames(industryDf) <- industryDf[,1]
    industryDf <- t(industryDf[,-c(1)])
    industryDf <- replace(industryDf, is.na(industryDf), 0)
    
    # Add new "Year" column for proper indexing and better referencing when importing as csv
    yearVector <- sub(".", "", rownames(industryDf))
    industryDf <- data.frame(Year = yearVector, industryDf)
    rownames(industryDf) <- seq_len(nrow(industryDf))
    
    # correct country names
    names(industryDf)[names(industryDf) == "Gambia..The"]          <- "The.Gambia"
    names(industryDf)[names(industryDf) == "Congo..Rep."]          <- "Congo"
    names(industryDf)[names(industryDf) == "Lao.PDR"]              <- "Laos"
    names(industryDf)[names(industryDf) == "Russian.Federation"]   <- "Russia"
    names(industryDf)[names(industryDf) == "St..Lucia"]            <- "Saint.Lucia"
    names(industryDf)[names(industryDf) == "Slovak.Republic"]      <- "Slovakia"
    names(industryDf)[names(industryDf) == "Korea..Rep."]          <- "South.Korea"
    names(industryDf)[names(industryDf) == "Syrian.Arab.Republic"] <- "Syria"
    names(industryDf)[names(industryDf) == "Turkiye"]              <- "Turkey"
    names(industryDf)[names(industryDf) == "Venezuela..RB"]        <- "Venezuela"
    names(industryDf)[names(industryDf) == "Viet.Nam"]             <- "Vietnam"
    names(industryDf)[names(industryDf) == "Egypt..Arab.Rep."]     <- "Egypt"
    
    setwd("data/processed")
    
    write.csv(industryDf, paste0("industry_value_added.csv"), row.names = TRUE)

    # transposed for maximum tableau convenience
    tIndustryDf <- t(industryDf)
    colnames(tIndustryDf) <- tIndustryDf[1,]
    tIndustryDf <- tIndustryDf[-1,]
    write.csv(tIndustryDf, paste0("industry_value_added(countries_as_rows).csv"), row.names = TRUE)

    # only data fra 2018, in case that's easier to work with
    indData2018 <- as.data.frame(industryDf[59,-c(1, which(colnames(industryDf)=="Venezuela"))])
    write.csv(indData2018, paste0("industry_value_added_2018.csv"), row.names = TRUE)
    
    tIndData2018 <- t(indData2018)
    tIndData2018 <- tIndData2018[-1,]
    write.csv(tIndData2018, paste0("industry_value_added_2018(countries_as_rows).csv"), row.names = TRUE)
    
    setwd("../../")
  }
}
