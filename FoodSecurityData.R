# Author: Yazan 

# Checking working directory and load data
getwd()
df <- read.csv("FoodSecurityData.csv", fileEncoding = "Latin1", stringsAsFactors = FALSE)

# Filter for 2018 data
df <- df[df$Year == "2018", ]

# Create pivot table with countries as rows and indicators as columns
countries <- unique(df$Area)
indicators <- unique(df$Item)

# Create and fill the pivot matrix
pivot_matrix <- matrix(NA, nrow = length(countries), ncol = length(indicators))
rownames(pivot_matrix) <- countries
colnames(pivot_matrix) <- indicators

for (i in 1:nrow(df)) {
  country <- df$Area[i]
  indicator <- df$Item[i]
  pivot_matrix[country, indicator] <- df$Value[i]
}

# Convert to data frame
df_pivot <- as.data.frame(pivot_matrix)

clean_data <- function(df) {
  # Fix column names 
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
  
  # Handling missing values 
  df[df == "NA"] <- NA
  
  # Convert columns to numeric where appropriate 
  for (col in colnames(df)) {
    test_values <- as.character(df[[col]])
    test_values <- test_values[!is.na(test_values)]
    converted <- suppressWarnings(as.numeric(test_values))
    
    if (length(test_values) > 0 && mean(!is.na(converted)) > 0.7) {
      df[[col]] <- suppressWarnings(as.numeric(as.character(df[[col]])))
    }
  }
  
  # Handle outliers using IQR method 
  for (col in colnames(df)) {
    if (!is.numeric(df[[col]]) || sum(is.na(df[[col]])) > nrow(df) * 0.5) next
    
    q1 <- quantile(df[[col]], 0.25, na.rm = TRUE)
    q3 <- quantile(df[[col]], 0.75, na.rm = TRUE)
    iqr <- q3 - q1
    
    lower_bound <- q1 - 1.5 * iqr
    upper_bound <- q3 + 1.5 * iqr
    
    # Cap outliers
    df[[col]][df[[col]] < lower_bound] <- lower_bound
    df[[col]][df[[col]] > upper_bound] <- upper_bound
  }
  
  return(df)
}

# Apply cleaning
df_clean <- clean_data(df_pivot)
df_final <- as.data.frame(t(df_clean))

# Save cleaned dataset
write.csv(df_final, "food_security_clean_2018.csv", row.names = TRUE)
