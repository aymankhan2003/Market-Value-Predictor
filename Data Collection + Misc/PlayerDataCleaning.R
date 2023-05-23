file <- read.csv("player_data.csv")


#NA Cleaning
file <- file %>%
  select(-X)


View(file)



#Name Cleaning
position_list <- c("CAM", "LW", "RW", "GK", "CB", "LB", "RB", "LWB", "RWB", "CM", "ST", "LM", "RM", "CF", "CDM")



file <- file %>%
  str_replace(Name, position_list, "xx")

for (pos in position_list) {
  file$Name <- str_remove_all(file$Name, pos)
}

#Team Cleaning
player_data$`Team & Contract` <- gsub(" ~ ", "", player_data$`Team & Contract`)
player_data$`Team & Contract` <- gsub("\\b\\d{8}\\b", "", player_data$`Team & Contract`)


