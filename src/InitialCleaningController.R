# Author: Eirik
# controller for cleaning our datasets. Can be instanced from Main or just directly one by one here. When we have what we need, we'll only include the main datasets in our 
# final file-folder. 

initialCleaningController <- function() {
  source("src/cleaner/SplittingUpMainDatasets.R")
  source("src/cleaner/CleaningUnitedNationDataset.R")
  source("src/cleaner/FoodSecurityData.R")
  source("src/cleaner/IndustryData.R")
  source("src/cleaner/AlzheimersData.R")
  
  print("Starting the splitting of the main datasets..")
  splittingUpMainDatasets()
  print("finished splitting the main datasets.")
  
  print("Starting cleaning of UN dataset..")
  cleaningUnitedNationDataset()
  print("Finished cleaning the UN dataset..")
  
  print("Starting cleaning of Food Security dataset..")
  foodSecurityData()
  print("Finished cleaning the Food Security dataset..")
  
  # Split this up, Hinrik?
  print("Starting cleaning of Industry Data dataset..")
  industryData()
  print("Finished cleaning of Industry Data dataset..")
  
  print("Starting cleaning of Alzheimer dataset..")
  cleaningAlzheimerDataset()
  print("Finished cleaning the Alzheimer dataset..")
  
}
