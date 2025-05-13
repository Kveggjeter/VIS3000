# Author: 7008
foodSecurityData <- function() {
  library(dplyr)
  library(tidyr)
  
  # Load the food security dataset
  df <- read.csv("data/raw/support/Food_Security_Data_2018.csv", fileEncoding = "Latin1", stringsAsFactors = FALSE)
  
  # Keep only 2018 data
  df <- df[df$Year == "2018", ]
  
  # Get unique countries and indicators
  countries <- unique(df$Area)
  indicators <- unique(df$Item)
  
  print("Countries (Areas):")
  print(countries)
  
  print("Indicators (Items):")
  print(indicators)
  
  # Fix percentage columns - remove % symbol and convert to decimal
  df <- df %>%
    mutate(across(contains("%"), ~ as.numeric(gsub("%", "", .))/100))
  
  # Convert text columns to factors for better handling
  df <- df %>%
    mutate(across(where(is.character), as.factor))
  
  # Create a pivot table with countries as rows and indicators as columns
  pivot_matrix <- matrix(NA, nrow = length(countries), ncol = length(indicators))
  rownames(pivot_matrix) <- countries
  colnames(pivot_matrix) <- indicators
  
  # Fill the matrix with values from the dataset
  for (i in 1:nrow(df)) {
    country <- df$Area[i]
    indicator <- df$Item[i]
    pivot_matrix[country, indicator] <- df$Value[i]
  }
  
  # Convert matrix to data frame for easier manipulation
  df_pivot <- as.data.frame(pivot_matrix)
  
  # Function to make column names more readable
  clean_column_names <- function(df) {
    # Map abbreviated names to full names
    name_map <- c(
      "Avg Val Food Prod" = "Average Value of Food Production",
      "Pct Children Stunted" = "Percentage of Children Stunted",
      "Pct Pop Undernourshed" = "Percentage of Population Undernourished"
    )
    
    current_names <- colnames(df)
    for (old_name in names(name_map)) {
      matching_cols <- grep(old_name, current_names, fixed = TRUE)
      if (length(matching_cols) > 0) {
        current_names[matching_cols] <- name_map[old_name]
      }
    }
    colnames(df) <- current_names
    return(df)
  }
  
  # Clean up column names
  df_pivot <- clean_column_names(df_pivot)
  
  # Replace "NA" strings with actual missing values
  df_pivot[df_pivot == "NA"] <- NA
  
  # Convert columns to numeric if most values can be converted
  for (col in colnames(df_pivot)) {
    test_values <- as.character(df_pivot[[col]])
    test_values <- test_values[!is.na(test_values)]
    converted <- suppressWarnings(as.numeric(test_values))
    
    if (length(test_values) > 0 && mean(!is.na(converted)) > 0.7) {
      df_pivot[[col]] <- suppressWarnings(as.numeric(as.character(df_pivot[[col]])))
    }
  }
  
  # Remove extreme outliers using the IQR method
  for (col in colnames(df_pivot)) {
    if (!is.numeric(df_pivot[[col]]) || sum(is.na(df_pivot[[col]])) > nrow(df_pivot) * 0.5) next
    
    q1 <- quantile(df_pivot[[col]], 0.25, na.rm = TRUE)
    q3 <- quantile(df_pivot[[col]], 0.75, na.rm = TRUE)
    iqr <- q3 - q1
    
    # Set bounds for outliers
    lower_bound <- q1 - 1.5 * iqr
    upper_bound <- q3 + 1.5 * iqr
    
    df_pivot[[col]][df_pivot[[col]] < lower_bound] <- lower_bound
    df_pivot[[col]][df_pivot[[col]] > upper_bound] <- upper_bound
  }
  
  # Flip the table so countries are rows and indicators are columns
  df_final <- as.data.frame(t(df_pivot))
  
  # Save the cleaned data
  setwd("data/processed")
  write.csv(df_final, "Cleaned_Food_Security_Data_2018.csv", row.names = TRUE)
  setwd("../../")
}