
library(dplyr)
library(tidyr)

#getwd()
#setwd("data")

df <- read.csv("Food_Security_Data_2018.csv", fileEncoding = "Latin1", stringsAsFactors = FALSE)

# Filter for 2018 data
df <- df[df$Year == "2018", ]

countries <- unique(df$Area)
indicators <- unique(df$Item)

print("Countries (Areas):")
print(countries)

print("Indicators (Items):")
print(indicators)

# Convert percentage columns to numeric
df <- df %>%
  mutate(across(contains("%"), ~ as.numeric(gsub("%", "", .))/100))

# Ensure all columns are of the correct data types
df <- df %>%
  mutate(across(where(is.character), as.factor))  # Convert character columns to factors

# Create pivot matrix with countries as rows and indicators as columns
pivot_matrix <- matrix(NA, nrow = length(countries), ncol = length(indicators))
rownames(pivot_matrix) <- countries
colnames(pivot_matrix) <- indicators

for (i in 1:nrow(df)) {
  country <- df$Area[i]
  indicator <- df$Item[i]
  pivot_matrix[country, indicator] <- df$Value[i]
}

# Convert the pivot matrix to a data frame
df_pivot <- as.data.frame(pivot_matrix)

# Clean column names
clean_column_names <- function(df) {
  # Map for renaming columns (you can add more mappings if needed)
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

# Apply column name cleaning
df_pivot <- clean_column_names(df_pivot)

# Handle missing values
df_pivot[df_pivot == "NA"] <- NA  # Replace "NA" strings with actual NAs

for (col in colnames(df_pivot)) {
  test_values <- as.character(df_pivot[[col]])
  test_values <- test_values[!is.na(test_values)]
  converted <- suppressWarnings(as.numeric(test_values))
  
  if (length(test_values) > 0 && mean(!is.na(converted)) > 0.7) {
    df_pivot[[col]] <- suppressWarnings(as.numeric(as.character(df_pivot[[col]])))
  }
}

# Handle outliers using IQR method
for (col in colnames(df_pivot)) {
  if (!is.numeric(df_pivot[[col]]) || sum(is.na(df_pivot[[col]])) > nrow(df_pivot) * 0.5) next
  
  q1 <- quantile(df_pivot[[col]], 0.25, na.rm = TRUE)
  q3 <- quantile(df_pivot[[col]], 0.75, na.rm = TRUE)
  iqr <- q3 - q1
  
  lower_bound <- q1 - 1.5 * iqr
  upper_bound <- q3 + 1.5 * iqr
  
  
  df_pivot[[col]][df_pivot[[col]] < lower_bound] <- lower_bound
  df_pivot[[col]][df_pivot[[col]] > upper_bound] <- upper_bound
}

# Transpose the data for final format (rows = countries, columns = indicators)
df_final <- as.data.frame(t(df_pivot))

# Save cleaned dataset to a new CSV file
write.csv(df_final, "Cleaned_Food_Security_Data_2018.csv", row.names = TRUE)


