# VIS3000 datapreperation scripts

This is the scripts responsible for cleaning and preparing data fro analysis. It also contains functions to make visualizations on correlations. 

>[!TIP]
>How to use this to get the same results we refference in the report?

1. Make sure your working enviroment are in the same directory as the Main.R file is located
2. Run Main.R and follow the instructions given from the comments
3. After Main.R has been run (and only after!) can the controller scripts be used manually
4. ModifierController (located in /src/) imports all the modifier scripts and can be used for doing analysis on the prepared CSV documents

For navigation, the project strutcture is as follow:

├───data
│   ├───processed <- Source folder for the cleaned data
|   ├───raw <- Source folder for the raw data
├───src <- R scripts
|   ├───cleaner <- Scripts that cleans a dataset/or support cleaning
|   ├───constants <- Constants (only for representing continents as of current)
|   ├───deprecated <- Scripts we no longer use becuase of the irrelevance of the data it cleans 
|   ├───modifiers <- Data manipulations and other functions that dont directly are used in cleaning, but are used in analysing, visualization or general modification of the CSV files.


>[!NOTE]
>You might need to install a couple of libraries if they are not present in your enviroment. Mainly for anything related to the modifiers, further instructions are present in the comments.


