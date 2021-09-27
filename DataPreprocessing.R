clean <- function(data) {
  library(tidyverse)
  library(dplyr)
  
  data$Date <- as.Date(data$Date,format = "%d-%m-%Y")
  
  data <- rename(data, "StateAndUnionTerritories" = "State/UnionTerritory")
  
  data <- data %>% group_by(StateAndUnionTerritories) %>% 
    mutate(daily_confirmed = Confirmed - lag(Confirmed,default = 0))
  
  data <- data %>% group_by(StateAndUnionTerritories) %>% 
    mutate(daily_deaths = Deaths - lag(Deaths,default = 0))
  
  data <- data %>% group_by(StateAndUnionTerritories) %>% 
    mutate(daily_cured = Cured - lag(Cured,default = 0))
  
  
  data <- data %>% 
    mutate(StateAndUnionTerritories = case_when(
      StateAndUnionTerritories %in% c("Karanatka", "Karnataka") ~ "Karnataka",
      StateAndUnionTerritories %in% c("Telangana", "Telengana") ~ "Telengana",
      StateAndUnionTerritories %in% c("Himanchal Predesh", "Himachal Pradesh") ~ "Himachal Pradesh",
      TRUE ~ StateAndUnionTerritories
    )
    )
  
  data <- data[!(data$StateAndUnionTerritories == "Unassigned" | data$StateAndUnionTerritories == "Cases being reassigned to states" | 
                   data$StateAndUnionTerritories == "Daman & Diu" | data$StateAndUnionTerritories == "Dadra and Nagar Haveli"),]
  
  data <- data[!(data$daily_confirmed <0 | data$daily_deaths <0 | data$daily_cured <0),]
  return(data)
}