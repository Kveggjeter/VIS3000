# Author: Hinrik

# Script cleans dataset for rates of industrialization, measured in GDP value added (%) 
# from industry, per year.

setwd("data")

{
industryDf <- as.data.frame(read.csv("industryData.csv", stringsAsFactors = FALSE))

# remove columns for country code, indicator name and indicator code, plus last column, which is empty
industryDf <- industryDf[-c(2:4, length(industryDf))]

# Removes most unmeasured countries, though not all. I attribute the failure
# to remove all selected countries to divine intervention, and I have yet to 
# build up the courage to insist against His plans.
for(i in rownames(industryDf)) {
  countryName <- industryDf[i,1]
  nrCheck <- sum(industryDf[i, -c(1)], na.rm = TRUE)
  if(nrCheck == 0) {
    industryDf[-c(12),]
    industryDf <- industryDf[-c(as.numeric(i)),]
    
    # Print statement for debugging, for when i decide to act against God's will 
    # print(paste("removing", countryName, "(",i,")"))
  }
}

# Apply columnnames (transposed), transpose and replace NAs with 0s
rownames(industryDf) <- industryDf[,1]
industryDf <- t(industryDf[,-c(1)])
industryDf <- replace(industryDf, is.na(industryDf), 0)

# Add new "Year" column for proper indexing and better referencing when importing as csv
yearVector <- sub(".", "", rownames(industryDf))
industryDf <- data.frame(Year = yearVector, industryDf)
rownames(industryDf) <- seq_len(nrow(industryDf))

write.csv(industryDf, paste0("industry_value_added.csv"), row.names = TRUE)
}
