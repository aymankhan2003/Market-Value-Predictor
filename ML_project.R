library(rvest)
library(tidyverse)
library(stringr)
library(stringdist)

#Scraping league data from transfermarkt.com
# Define URLs and league names
urls <- c(
  "https://www.transfermarkt.com/premier-league/tabelle/wettbewerb/GB1?saison_id=2018",
  "https://www.transfermarkt.com/serie-a/tabelle/wettbewerb/IT1?saison_id=2018",
  "https://www.transfermarkt.com/laliga/tabelle/wettbewerb/ES1?saison_id=2018",
  "https://www.transfermarkt.com/bundesliga/tabelle/wettbewerb/L1?saison_id=2018",
  "https://www.transfermarkt.us/liga-nos/tabelle/wettbewerb/PO1/saison_id/2018",
  "https://www.transfermarkt.us/eredivisie/tabelle/wettbewerb/NL1/saison_id/2018",
  "https://www.transfermarkt.us/super-lig/tabelle/wettbewerb/TR1?saison_id=2018",
  "https://www.transfermarkt.us/professional-football-league/jahrestabelle/wettbewerb/AR1N/saison_id/2018",
  "https://www.transfermarkt.us/campeonato-brasileiro-serie-a/tabelle/wettbewerb/BRA1/saison_id/2017",
  "https://www.transfermarkt.us/ligue-1/tabelle/wettbewerb/FR1?saison_id=2018"
)

leagues <- c("Premier League", "Serie A", "LaLiga", "Bundesliga","LigaNOS","Eredivisie","SuperLig","ProfessionalFootballLeague","CampeonatoBrasileiroSerieA","League 1")

# Initialize an empty data frame to store the scraped data
all_data <- data.frame()
View(all_data)

# Loop over the URLs and scrape data
for (i in seq_along(urls)) {
  
  url <- urls[i]
  league_name <- leagues[i]
  
  tablexpath <- '//*[@id="yw1"]/table' 
  # Try to scrape the table, and skip the iteration if it's not found
  league_data <- try(url %>%
                       read_html() %>%
                       html_element(xpath = tablexpath) %>%
                       html_table(), silent = TRUE)
  
  if (inherits(league_data, "try-error")) {
    next
  }
  
  colnames(league_data) <- c("Pos", "img", "Club", "GP", "W", "D", "L", "GR", "GD", "Points")
  league_data$img <- NULL
  
  league_data <- mutate(league_data, league = league_name)
  
  # Append the scraped data to the all_data data frame
  all_data <- all_data %>% 
    bind_rows(league_data)
}

#Adding data from the Argentinian league manually from transfermarkt.com
link_arg<-"https://www.transfermarkt.us/professional-football-league/jahrestabelle/wettbewerb/AR1N/saison_id/2018"
tablexpath_arg <- '//*[@id="main"]/main/div[2]/div[1]/div/table' 
# Try to scrape the table, and skip the iteration if it's not found
league_arg <- try(link_arg%>%
                     read_html() %>%
                     html_element(xpath = tablexpath_arg) %>%
                     html_table(), silent = TRUE)

colnames(league_arg) <- c("Pos", "img", "Club", "GP", "W", "D", "L", "GR", "GD", "Points")
league_arg$img <- NULL
league_arg$league<-"Professional League"
# Assuming that league_arg and all_data have the same column names
all_data <- rbind(all_data, league_arg)


all_data$Club <- gsub(" FC", "", all_data$Club, ignore.case = TRUE)
all_data$League<-all_data$league
all_data$league<-NULL

View(all_data)

# Scraping Club's transfer market data from transfermarkt.com
league_links <- c(
  "https://www.transfermarkt.com/premier-league/startseite/wettbewerb/GB1/plus/?saison_id=2018",
  "https://www.transfermarkt.com/serie-a/startseite/wettbewerb/IT1/plus/?saison_id=2018",
  "https://www.transfermarkt.com/laliga/startseite/wettbewerb/ES1/plus/?saison_id=2018",
  "https://www.transfermarkt.com/bundesliga/startseite/wettbewerb/L1/plus/?saison_id=2018",
  "https://www.transfermarkt.us/liga-portugal/startseite/wettbewerb/PO1/plus/saison_id2018?saison_id=2018",
  "https://www.transfermarkt.us/eredivisie/startseite/wettbewerb/NL1/plus/?saison_id=2018",
  "https://www.transfermarkt.us/super-lig/startseite/wettbewerb/TR1/plus/?saison_id=2018",
  "https://www.transfermarkt.us/professional-football-league/startseite/wettbewerb/AR1N/plus/?saison_id=2018",
  "https://www.transfermarkt.us/campeonato-brasileiro-serie-a/startseite/wettbewerb/BRA1/plus/?saison_id=2017",
  "https://www.transfermarkt.com/ligue-1/tabelle/wettbewerb/FR1?saison_id=2018"
)

# create a vector of league names
league_names <- c(
  "Premier League","Serie A","LaLiga","Bundesliga","LigaNOS","Eredivisie","SuperLig","ProfessionalFootballLeague","CampeonatoBrasileiroSerieA", "League 1")

# create an empty dataframe to store the results
club_df <- data.frame()

# loop through the league links
for (i in seq_along(league_links)) {
  # scrape the data for the current league
  xpath2 <- '//*[@id="yw1"]/table'
  p <- try(
    league_links[i] %>% read_html() %>% html_element(xpath = xpath2) %>% html_table(),
    silent = TRUE
  )
  p$Club <- NULL
  colnames(p) <- c("Club", "Squad", "AVGage", "Foreigners", "AVGPlayerValue", "TotalPlayerValue")
  p[7] <- NULL
  p[5] <- NULL
  p <- p[-1,]
  # add a column for the current league name
  p$League <- league_names[i]
  # bind the results to the club_df dataframe
  club_df <- rbind(club_df, p)
}

#manually adding league 1(French League)
link1<-"https://www.transfermarkt.com/ligue-1/startseite/wettbewerb/FR1/plus/?saison_id=2018"
club1<-data.frame()
xpath3 <- '//*[@id="yw1"]/table'
p1 <- try(
  link1 %>% read_html() %>% html_element(xpath = xpath3) %>% html_table(),
  silent = TRUE
)
p1$Club <- NULL
colnames(p1) <- c("Club", "Squad", "AVGage", "Foreigners", "AVGPlayerValue", "TotalPlayerValue")
p1[7] <- NULL
p1[5] <- NULL
p1 <- p1[-1,]
# add a column for the current league name
p1$League <- "League 1"
# bind the results to the club_df dataframe
club_df <- rbind(club_df, p1)

#Cleaning the club_df dataset
# reset the row names of the club_df dataframe
rownames(club_df) <- NULL

# remove "FC" from all Club names in club_df
club_df$Club <- gsub(" FC", "", club_df$Club, ignore.case = TRUE)

View(club_df)

updated_data <- all_data

#Trying to match the name of clubs in the Club column of both the data tables by parsing the words by spaces and for each block if 3 or more letters are common sequentially, the club's name in updated_data will be replaced by the club name in club_df it matches with.
common_letters_count <- function(word1, word2) {
  word1_letters <- str_split(tolower(word1), "")[[1]]
  word2_letters <- str_split(tolower(word2), "")[[1]]
  
  common_letters <- intersect(word1_letters, word2_letters)
  return(length(common_letters))
}



for (i in 1:nrow(updated_data)) {
  for (j in 1:nrow(club_df)) {
    if (updated_data$League[i] == club_df$League[j]) {
      updated_data_words <- str_split(updated_data$Club[i], " ")[[1]]
      club_df_words <- str_split(club_df$Club[j], " ")[[1]]
      
      if (length(updated_data_words) > 1 && length(club_df_words) > 1) {
        first_word_common_count <- common_letters_count(updated_data_words[1], club_df_words[1])
        second_word_common_count <- common_letters_count(updated_data_words[2], club_df_words[2])
        
        if (first_word_common_count >= 3 && second_word_common_count >= 3) {
          updated_data$Club[i] <- club_df$Club[j]
          break
        }
      }
    }
  }
}

longest_word <- function(name) {
  words <- str_split(name, " ")[[1]]
  longest <- words[[1]]
  
  for (word in words) {
    if (nchar(word) > nchar(longest)) {
      longest <- word
    }
  }
  
  return(longest)
}

#For the club names in updated data that are still not matched with club names in club_df, we will sparce the club names by spaces. If the block with a greater length matches with a block in clubs' name in club_df, it will be replaced.
given_club_names <- c("ACF Fiorentina", "AFC Bournemouth", "Ajax Amsterdam",
                      "América Futebol Clube (MG)", "Atlético de Madrid", "Atlético Paranaense",
                      "Basaksehir FK", "Bayer 04 Leverkusen", "Besiktas JK",
                      "Bologna 1909", "Botafogo de Futebol e Regatas", "Brighton & Hove Albion",
                      "Büyüksehir Belediye Erzurumspor", "Cardiff City", "Caykur Rizespor",
                      "CD Feirense", "CD Nacional", "CD Santa Clara",
                      "CD Tondela", "Ceará Sporting Club", "Clube Atlético Mineiro",
                      "Clube de Regatas Vasco da Gama", "CR Flamengo", "Cruzeiro Esporte Clube",
                      "CS Marítimo", "De Graafschap Doetinchem", "Deportivo Alavés",
                      "Eintracht Frankfurt", "Esporte Clube Bahia", "Esporte Clube Vitória",
                      "FC Barcelona", "Fluminense Football Club", "Fortuna Düsseldorf",
                      "Fortuna Sittard", "GD Chaves", "Genoa CFC",
                      "Getafe CF", "Grêmio Foot-Ball Porto Alegrense", "Heracles Almelo",
                      "Huddersfield Town", "Inter Milan", "Leicester City",
                      "Levante UD", "MKE Ankaragücü", "Newcastle United",
                      "Paraná Clube", "Parma Calcio 1913", "Portimonense SC",
                      "RCD Espanyol Barcelona", "Real Sociedad", "Real Valladolid CF",
                      "Rio Ave", "São Paulo Futebol Clube", "SC Heerenveen",
                      "Sevilla", "SL Benfica", "Sociedade Esportiva Palmeiras",
                      "Sport Club Corinthians Paulista", "Sport Club do Recife", "Sport Club Internacional",
                      "SS Lazio", "SV Werder Bremen", "Tottenham Hotspur",
                      "TSG 1899 Hoffenheim", "UC Sampdoria", "Udinese Calcio",
                      "US Sassuolo", "Valencia CF", "Villarreal CF",
                      "Vitesse Arnhem", "Vitória Guimarães SC", "Vitória Setúbal",
                      "Willem II Tilburg", "Wolverhampton Wanderers", "Yeni Malatyaspor")

for (i in 1:nrow(updated_data)) {
  all_data_longest_word <- longest_word(updated_data$Club[i])
  
  for (given_name in given_club_names) {
    given_name_longest_word <- longest_word(given_name)
    
    if (all_data_longest_word == given_name_longest_word) {
      updated_data$Club[i] <- given_name
      break
    }
  }
}

View(updated_data)

#Last attempt on matching the CLub names by manually creating  a mapping List
#checking what clubs that exist in club_df are missing in updated_data
missing_clubs1 <- setdiff(club_df$Club, updated_data$Club)

#checking what clubs that exist in updated_data are missing in club_df
missing_clubs2 <- setdiff(updated_data$Club, club_df$Club)

#Creating a mapping list: 
new_club_names <- c("Wolves" = "Wolverhampton Wanderers",
                    "Parma" = "Parma Calcio 1913",
                    "Frosinone" = "Frosinone Calcio",
                    "Espanyol" = "RCD Espanyol Barcelona",
                    "Athletic" = "Athletic Bilbao",
                    "Alavés" = "Deportivo Alavés",
                    "E. Frankfurt" = "Eintracht Frankfurt",
                    "Ajax" = "Ajax Amsterdam",
                    "Feyenoord" = "Willem II Tilburg",
                    "Willem II" = "Willem II Tilburg",
                    "Excelsior" = "Excelsior Rotterdam",
                    "Palmeiras" = "Sociedade Esportiva Palmeiras",
                    "Grêmio" = "Grêmio Foot-Ball Porto Alegrense",
                    "Atlético-MG" = "Clube Atlético Mineiro",
                    "Atlético-PR" = "Atlético Paranaense",
                    "EC Bahia" = "Esporte Clube Bahia",
                    "Chapecoense" = "Associação Chapecoense de Futebol",
                    "Ceará SC" = "Ceará Sporting Club",
                    "Vasco da Gama" = "Clube de Regatas Vasco da Gama",
                    "América-MG" = "América Futebol Clube (MG)",
                    "Godoy Cruz" = "CD Godoy Cruz Antonio Tomba",
                    "Defensa" = "Defensa y Justicia",
                    "Huracán" = "CA Huracán",
                    "Boca Juniors" = "CA Boca Juniors",
                    "River Plate" = "CA River Plate",
                    "Vélez Sarsfield" = "CA Vélez Sarsfield",
                    "Atl. Tucumán" = "Club Atlético Tucumán",
                    "Independiente" = "CA Independiente",
                    "CA Talleres" = "Club Atlético Talleres",
                    "Banfield" = "CA Banfield",
                    "CA Unión" = "Club Atlético Unión",
                    "Estudiantes" = "Club Estudiantes de La Plata",
                    "Rosario Central" = "CA Rosario Central",
                    "San Lorenzo" = "CA San Lorenzo de Almagro",
                    "Newell's" = "CA Newell's Old Boys",
                    "Argentinos Jrs." = "AA Argentinos Juniors",
                    "Tigre" = "Club Atlético Tigre",
                    "Belgrano" = "Club Atlético Belgrano",
                    "Lanús" = "Club Atlético Lanús",
                    "Gimnasia" = "Club de Gimnasia y Esgrima La Plata",
                    "Patronato" = "Club Atlético Patronato",
                    "San Martín (SJ)" = "CA San Martín (San Juan)",
                    "Aldosivi" = "Club Atlético Aldosivi",
                    "San Martín (T)" = "Club Atlético San Martín (Tucumán)",
                    "Arsenal Sarandí" = "Arsenal de Sarandí",
                    "CA Temperley" = "Club Atlético Temperley",
                    "Chacarita Jrs." = "Club Atlético Chacarita Juniors",
                    "Olimpo" = "Club Olimpo",
                    "Saint-Étienne"=" AS Saint-Étienne","Paris SG" = "Paris Saint-Germain", "Monaco"="AS Monaco","Marseille"="Olympic Marseille","Montpellier"="Montpellier HSC","Real Betis "="Real Betis Balompié")

# Use str_replace_all() to replace the club names in club_df with the new names
updated_data$Club <- str_replace_all(updated_data$Club, new_club_names)

merged_data <- merge(club_df, updated_data, by = "Club")
merged_data$League.y<-NULL

missing_clubs3 <- setdiff(updated_data$Club, club_df$Club)
missing_clubs4 <- setdiff( club_df$Club,updated_data$Club)

write.csv(merged_data, file = "club_data1.csv", row.names = FALSE)

club_data <- read_csv("club_data.csv")


#For the Team & Contract column, seperate Team and Contract in 2 different columns. Use the contract column and subtract it from 2019 to find the remaining duration of the contract.
player_data<- read_csv("player_data.csv")


player_data <- player_data %>%
  mutate(`Years Left` = as.numeric(str_extract(`Team & Contract`, "(?<=~\\s)\\d{4}"))-2019)

player_data$`Team & Contract` <- gsub(" ~ ", "", player_data$`Team & Contract`)
player_data$`Team & Contract` <- gsub("\\b\\d{8}\\b", "", player_data$`Team & Contract`)
player_data$Club<-player_data$`Team & Contract` 
player_data$`Team & Contract`<-NULL

player_data <- player_data %>%
  select(1:2, Club, 3:ncol(player_data)-1)

player_data$Club <- str_trim(player_data$Club, side = "right")

merged_data <- merge(player_data, club_data, by = "Club")

player_data$Weight_new<-as.numeric(str_extract(player_data$Weight, "\\d+"))

nrow(distinct(player_data, Club))
nrow(distinct(club_data, Club))

#transfer fee from 2019/2020
TM_link<-"https://www.transfermarkt.us/transfers/transferrekorde/statistik/top/plus/0/galerie/0?saison_id=2019&land_id=&ausrichtung=Sturm&spielerposition_id=&altersklasse=&jahrgang=0&leihe=&w_s="

TMatt<-read.csv("/Users/anweshanadhikari/Documents/Market-Value-Predictor/transferfee/Forwards.csv")
View(TM_att)
TMatt$Position<-"Forward"
colnames(TM_att) <- trimws(colnames(TM_att))
TMatt <- TM_att%>%select(hauptlink, Position, `inline.table`, hauptlink.2, `inline.table.2`, rechts)
TMatt$name<-TM_att$hauptlink
TMatt$transfer_fee<-TMatt$rechts
TMatt$detailed_position<-TMatt$inline.table
TMatt$league<-TMatt$inline.table.2
TMatt$club<-TMatt$hauptlink.2
TMatt<-TMatt%>%select(name,transfer_fee,Position,club,league,detailed_position)

TMdef<-read.csv("/Users/anweshanadhikari/Documents/Market-Value-Predictor/transferfee/defenders.csv")
TMdef$Position<-"Defence"
colnames(TMdef) <- trimws(colnames(TMdef))
TMdef <- TMdef%>%select(hauptlink, Position, `inline.table`, hauptlink.2, `inline.table.2`, rechts)
TMdef$name<-TMdef$hauptlink
TMdef$transfer_fee<-TMdef$rechts
TMdef$detailed_position<-TMdef$inline.table
TMdef$league<-TMdef$inline.table.2
TMdef$club<-TMdef$hauptlink.2
TMdef<-TMdef%>%select(name,transfer_fee,Position,club,league,detailed_position)


TMmid<-read.csv("/Users/anweshanadhikari/Documents/Market-Value-Predictor/transferfee/Midfielders.csv")
TMmid$Position<-"Midfield"
colnames(TMmid) <- trimws(colnames(TMmid))
TMmid <- TMmid%>%select(hauptlink, Position, `inline.table`, hauptlink.2, `inline.table.2`, rechts)
TMmid$name<-TMmid$hauptlink
TMmid$transfer_fee<-TMmid$rechts
TMmid$detailed_position<-TMmid$inline.table
TMmid$league<-TMmid$inline.table.2
TMmid$club<-TMmid$hauptlink.2
TMmid<-TMmid%>%select(name,transfer_fee,Position,club,league,detailed_position)

TMgk<-read.csv("/Users/anweshanadhikari/Documents/Market-Value-Predictor/transferfee/GKs.csv")
TMgk$Position<-"GK"
colnames(TMgk) <- trimws(colnames(TMgk))
TMgk <- TMgk%>%select(hauptlink, Position, `inline.table`, hauptlink.2, `inline.table.2`, rechts)
TMgk$name<-TMgk$hauptlink
TMgk$transfer_fee<-TMgk$rechts
TMgk$detailed_position<-TMgk$inline.table
TMgk$league<-TMgk$inline.table.2
TMgk$club<-TMgk$hauptlink.2
TMgk<-TMgk%>%select(name,transfer_fee,Position,club,league,detailed_position)

colnames(TMatt)



