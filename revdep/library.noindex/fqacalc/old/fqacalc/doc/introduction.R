## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
#attach packages required for this tutorial
library(fqacalc) #for FQA calculations
library(dplyr) #for data manipulation

## -----------------------------------------------------------------------------
#view a list of all available databases
head(db_names()$fqa_db)

#NOTE citations for lists can be viewed using db_names()$citation

#store the Colorado database as an object
colorado <- view_db("colorado_2020")

#view it
head(colorado)

## -----------------------------------------------------------------------------
#view the data
head(crooked_island)

#print the dimensions (35 rows and 3 columns)
dim(crooked_island)

#view the documentation for the data set (bottom right pane of R studio)
?crooked_island

#load the data set into local environment
crooked_island <- crooked_island

## ---- echo = F----------------------------------------------------------------
data <- data.frame(plot_id = c(1, 1, 2, 2),
                   name = c("Plant A", "Plant B", "Plant C", "Plant D"),
                   cover = c(20, 50, 35, 45))

knitr::kable(data)

## -----------------------------------------------------------------------------
#introduce a typo
mistake_island <- crooked_island %>% 
  mutate(name = sub("Abies balsamea", "Abies blahblah", name))

#store accepted entries
accepted_entries <- accepted_entries(#this is the data
                                     mistake_island, 
                                     #'key' to join data to regional database
                                     key = "name", 
                                     #this is the regional database
                                     db = "michigan_2014", 
                                     #include native AND introduced entries
                                     native = FALSE) 

## -----------------------------------------------------------------------------
#To see unassigned_plants in action we're going to Montana! 

#first create a df of plants to input
no_c_plants<- data.frame(name = c("ABRONIA FRAGRANS", 
                                  "ACER GLABRUM", 
                                  "ACER GRANDIDENTATUM", 
                                  "ACER PLATANOIDES"))

#then create a df of unassigned plants
unassigned_plants(no_c_plants, key = "name", db = "montana_2017")


## -----------------------------------------------------------------------------
#write a dataframe with duplicates
transect <- data.frame(acronym  = c("ABEESC", "ABIBAL", "AMMBRE", 
                                    "AMMBRE", "ANTELE", "ABEESC", 
                                    "ABIBAL", "AMMBRE"),
                      cover = c(50, 4, 20, 30, 30, 40, 7, 60),
                      plot_id = c(1, 1, 1, 1, 2, 2, 2, 2))

#set allow_duplicates to FALSE
cover_FQI(transect, key = "acronym", db = "michigan_2014", 
          native = FALSE, allow_duplicates = FALSE)

#set allow_duplicates to TRUE
#but set plot_id so duplicates will not be allowed within the same plot
cover_FQI(transect, key = "acronym", db = "michigan_2014", 
          native = FALSE, allow_duplicates = FALSE, plot_id = "plot_id")


## -----------------------------------------------------------------------------
#df where some entries are listed as accepted name and synonym of other species
synonyms <- data.frame(name = c("CAREX FOENEA", "ABIES BIFOLIA"),
                       cover = c(60, 10))

mean_c(synonyms, key = "name", db = "wyoming_2017", native = F)


## -----------------------------------------------------------------------------
#total mean c
mean_c(crooked_island, key = "acronym", db = "michigan_2014", native = FALSE)

#native mean C
mean_c(crooked_island, key = "acronym", db = "michigan_2014", native = TRUE)

#total FQI
FQI(crooked_island, key = "acronym", db = "michigan_2014", native = FALSE)

#native FQI
FQI(crooked_island, key = "acronym", db = "michigan_2014", native = TRUE)

#adjusted FQI (always includes both native and introduced species)
adjusted_FQI(crooked_island, key = "acronym", db = "michigan_2014")

## -----------------------------------------------------------------------------
#a summary of all metrics (always includes both native and introduced)
#can optionally include species with no C value
#--if TRUE, this species will count in species richness and mean wetness metrics
all_metrics(crooked_island, key = "acronym", db = "michigan_2014", allow_no_c = TRUE)

## -----------------------------------------------------------------------------
#In R studio, this line of code will bring up documentation in bottom right pane
?all_metrics

## -----------------------------------------------------------------------------
#first make a hypothetical plot with cover values
plot <- data.frame(acronym  = c("ABEESC", "ABIBAL", "AMMBRE", "ANTELE"),
                   name = c("Abelmoschus esculentus", 
                            "Abies balsamea", "Ammophila breviligulata", 
                            "Anticlea elegans; zigadenus glaucus"),
                   cover = c(50, 4, 20, 30))

#now make up a transect
transect <- data.frame(acronym  = c("ABEESC", "ABIBAL", "AMMBRE", 
                                    "AMMBRE", "ANTELE", "ABEESC", 
                                    "ABIBAL", "AMMBRE"),
                       cover = c(50, 4, 20, 30, 30, 40, 7, 60),
                       plot_id = c(1, 1, 1, 1, 2, 2, 2, 2))

#plot cover mean c (no duplicates allowed)
cover_mean_c(plot, key = "acronym", db = "michigan_2014", 
             native = FALSE, cover_class = "percent_cover", 
             allow_duplicates = FALSE)

#transect cover mean c (duplicates allowed along unless in the same plot)
cover_mean_c(transect, key = "acronym", db = "michigan_2014", 
             native = FALSE, cover_class = "percent_cover",
             allow_duplicates = TRUE, plot_id = "plot_id")

#cover-weighted FQI 
#you can choose to allow duplicates depending on if species are in a single plot
cover_FQI(transect, key = "acronym", db = "michigan_2014", native = FALSE, 
          cover_class = "percent_cover",
          allow_duplicates = TRUE)

#transect summary function (always allows duplicates)
transect_summary(transect, key = "acronym", db = "michigan_2014")

## -----------------------------------------------------------------------------
#print transect to view structure of data
transect_unveg <- data.frame(acronym = c("GROUND", "ABEESC", "ABIBAL", "AMMBRE",
                                          "ANTELE", "WATER", "GROUND", "ABEESC", 
                                          "ABIBAL", "AMMBRE"),
                             cover = c(60, 50, 4, 20, 30, 20, 20, 40, 7, 60),
                             quad_id = c(1, 1, 1, 1, 1, 2, 2, 2, 2, 2))

#plot summary of a transect 
#duplicates are allowed, unless they are in the same plot
plot_summary(x = transect_unveg, key = "acronym", db = "michigan_2014", 
             cover_class = "percent_cover", 
             plot_id = "quad_id")

## -----------------------------------------------------------------------------
#To calculate the relative value of a tree

#relative frequency
relative_frequency(transect, key = "acronym", db = "michigan_2014", 
              col = "physiog")

#can also include bare ground and water in the data 
#here transect_unveg is data containing ground and water defined previously
relative_frequency(transect_unveg, key = "acronym", db = "michigan_2014", 
              col = "physiog")

#relative cover
relative_cover(transect, key = "acronym", db = "michigan_2014", 
               col = "family", cover_class = "percent_cover")

#relative importance
relative_importance(transect, key = "acronym", db = "michigan_2014", 
                    col = "species", cover_class = "percent_cover")

#species summary (including ground and water)
species_summary(transect_unveg, key = "acronym", db = "michigan_2014", 
                cover_class = "percent_cover")

#physiognomy summary (including ground and water)
physiog_summary(transect_unveg, key = "acronym", db = "michigan_2014", 
                cover_class = "percent_cover")

## -----------------------------------------------------------------------------
#mean wetness
mean_w(crooked_island, key = "acronym", db = "michigan_2014", allow_no_c = FALSE)

