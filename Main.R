# Author: 7036
# Make sure to run getwd() to make sure you are in the right directory. You 
# have to boot the script from the same directory Main.R is in.
# Running this script will clean all the raw data and place the processed
# data into "data/processed".
# Install dplyr if not present in your environment, else jump over

install.packages("dplyr")
getwd()
source("src/InitialCleaningController.R")

main <- function(){
 initialCleaningController()
}

main()






