library(tidyverse)
setwd("/Users/liubeixi/Desktop/Data Science/Project/Shinny/H1B/")
h1b_shiny1 <- readRDS("/Users/liubeixi/Desktop/Data Science/Project/h1b.rds")
names(h1b_shiny)

if(!file.exists("./data")) {dir.create("./data")}

h1b_shiny <- h1b_shiny1 %>%
  select(WORKSITE, EMPLOYER_NAME, lon, lat, 
         apply_city, applyrank_city_us, applyrank_city_state, apply_state, applyrank_state,
         wage_city, wagerank_city_us, wagerank_city_state, wage_state, wagerank_state,
         apply_employer_city, applyrank_employer_city, wage_employer_city, wagerank_employer_city) %>%
  unique() %>%
  mutate( Percent = apply_city/sum(apply_city)) %>%
  filter(!is.na(lat))

saveRDS(h1b_shiny, "./data/h1b_shiny.rds")
#detect city with no geocode
h1b_shiny1 %>%
   select(WORKSITE, lon, lat, apply_city, applyrank_city_us, applyrank_city_state, apply_state, applyrank_state,
                              wage_city, wagerank_city_us, wagerank_city_state, wage_state, wagerank_state) %>%
  unique() %>%
  filter(is.na(lat)) %>%
  arrange(desc(apply_city)) %>%
  slice(-1) %>%
  nrow()
rm(list = ls())