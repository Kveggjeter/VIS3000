library(dplyr)

getwd()
# Remember to set your own path here or change this to file.choose() for running just one time
setwd("C:\\Users\\sundb\\OneDrive\\Documents\\vis3000\\data")
table1 <- read.csv("general.csv")
table2 <- read.csv("mp.csv")

df1 <- as.data.frame(table1)
df2 <- as.data.frame(t(table2))

split2 <- seq(1, nrow(df2), by = 19)
list2 <- split(df2, cut(seq(1, nrow(df2)), breaks = c(split2, Inf), right = FALSE))

names(list2) <- paste0("df_", seq_along(list2))


colnames(list2[[1]]) <- list2[[1]][1, ]
list2[[1]] <- list2[[1]][-1, ]
list2[[2]] <- list2[[2]][-1, ]
colnames(list2[[2]]) <- list2[[2]][1, ]
list2[[2]] <- list2[[2]][-1, ]

View(list2[[2]])
View(list2[[1]])
new_df2 <- reduce(list2, full_join, by = intersect(names(list2[[1]]), names(list2[[2]])))
View(new_df2)

split1 <- seq(1, nrow(df1), by = 20)
list1 <- split(df1, cut(seq(1, nrow(df1)), breaks = c(split1, Inf), right = FALSE))

# Just for my own sanity
names(list1) <- paste0("df_", seq_along(list1))

# Jeg må huske å fjerne denne kommentaren, men hva slags språk er dette???
for (i in seq_along(list1)) {
  year <- list1[[i]][1, 1]
  colnames(list1[[i]]) <- list1[[i]][1, ]
  list1[[i]] <- list1[[i]][-1, ]
  rownames(list1[[i]]) <- list1[[i]][, 1]
  list1[[i]] <- list1[[i]][, -1]
  write.csv(list1[[i]], paste0(year, ".csv"), row.names = TRUE)
}


