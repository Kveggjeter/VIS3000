# Author: Eirik, 7012
# To not waste space in other parts of the code, heres the vectoring of countries to continent

africa <- c("Algeria", "Angola", "Benin", "Burkina.Faso", "Cameroon", 
            "Central.African.Republic", "Chad", "Congo", "Cote.d.Ivoire", 
            "Djibouti", "Egypt", "Ethiopia", "Gabon", "Ghana", "Guinea", 
            "Guinea.Bissau", "Kenya", "Lesotho", "Madagascar", "Malawi", 
            "Mali", "Mauritania", "Mauritius", "Morocco", "Mozambique", 
            "Namibia", "Niger", "Nigeria", "Rwanda", "Senegal", "South.Africa", 
            "Tanzania", "The.Gambia", "Togo", "Tunisia", "Uganda", "Zambia")

north_africa <- c(
  "Algeria", "Egypt", "Mauritania", "Morocco", "Tunisia", "Mali", "Niger", "Chad"
)

west_africa <- c(
  "Benin", "Burkina.Faso", "Cote.d.Ivoire", "Ghana", "Guinea",
  "Guinea.Bissau", "Mali", "Niger", "Nigeria", "Senegal", "The.Gambia", "Togo"
)

central_africa <- c(
  "Cameroon", "Central.African.Republic", "Chad", "Congo", "Gabon"
)

gulf_of_guinea <- c("Benin", "Gabon", "Congo", "Cameroon", "Togo", "Nigeria", "Ghana", "Ivory.Coast")

southern_africa <- c(
  "Angola", "Lesotho", "Mauritius", "Mozambique", "Namibia", "South.Africa"
)

coastal_east_africa <- c("Somalia", "Kenya","Tanzania","Mozambique","Madagascar")

# Asia
asia <- c("Bangladesh", "Cambodia", "China", "India", "Indonesia", 
          "Iran", "Iraq", "Japan", "Jordan", "Kuwait", "Laos", "Malaysia", 
          "Mongolia", "Myanmar", "Pakistan", "Philippines", "Russia", 
          "Saudi.Arabia", "South.Korea", "Sri.Lanka", "Syria", "Thailand", 
          "Turkey", "Vietnam")

west_asia <- c("Iran", "Iraq", "Jordan", "Kuwait", "Saudi.Arabia", "Syria", "Turkey")

east_southeast_asia <- c("Bangladesh", "Cambodia", "China", "India", 
                               "Indonesia", "Japan", "Laos", "Malaysia", 
                               "Myanmar", 
                               "Philippines", "South.Korea", "Sri.Lanka", 
                               "Thailand", "Vietnam")

# Europe
europe <- c("Albania", "Austria", "Belgium", "Bosnia.and.Herzegovina", 
            "Bulgaria", "Croatia", "Denmark", "France", "Germany", "Greece", 
            "Hungary", "Iceland", "Ireland", "Luxembourg", "Montenegro", 
            "Netherlands", "Norway", "Portugal", "Romania", "Russia", 
            "Serbia", "Slovakia", "Slovenia", "Spain", "Sweden", "Switzerland", 
            "Turkey", "Ukraine", "United.Kingdom")

balkans <- c(
  "Albania", "Bosnia.and.Herzegovina", "Bulgaria", "Croatia", "Greece",
  "Montenegro", "Romania", "Serbia", "Slovenia", "Turkey"
)

northwest_europe <- c(
  "Austria", "Belgium", "Denmark", "France", "Germany", 
  "Iceland", "Ireland", "Luxembourg", "Netherlands", 
  "Norway", "Sweden", "United.Kingdom"
)

north_sea <- c(
  "Denmark", "Finland", "Sweden", "United.Kingdom", "Netherlands", "Belgium") 

# North America
north_america <- c("Antigua.and.Barbuda", "Barbados", "Canada", "Cuba", 
                   "Dominica", "Dominican.Republic", "Grenada", "Mexico", 
                   "Saint.Lucia", "Trinidad.and.Tobago", "United.States")

# South America
south_america <- c("Argentina", "Bolivia", "Brazil", "Colombia", 
                   "Paraguay", "Peru", "Uruguay", "Venezuela")

americas <- c(
  "Antigua.and.Barbuda", "Barbados", "Canada", "Cuba", "Dominica", 
  "Dominican.Republic", "Grenada", "Mexico", "Saint.Lucia", 
  "Trinidad.and.Tobago", "United.States",
  "Argentina", "Bolivia", "Brazil", "Colombia", "Paraguay", 
  "Peru", "Uruguay", "Venezuela"
)

caribbean <- c("Cuba", "Dominican.Republic","Antigua.and.Barbuda","Mexico","Dominica","Saint.Lucia","Barbados","Grenada","Colombia", "Trinidad.and.Tobago")

# Oceania
oceania <- c("Australia")

world <- unique(c(
  africa, north_africa, west_africa, central_africa, gulf_of_guinea, 
  southern_africa, coastal_east_africa, asia, west_asia, 
  east_southeast_asia, europe, balkans, northwest_europe, north_sea, 
  north_america, south_america, americas, caribbean, oceania
))
