download.packages("ggmap")
download.packages("tidyverse")
library(ggmap)
library(tidyverse)
setwd("C:/Users/zl1409a/Desktop")
#geocode
h1b <- readRDS("./h1b.rds")
#rank of city with most application
count_site <- readRDS("./count_site.rds")
#detect missing
h1b_detect <- h1b %>%
  group_by(WORKSITE) %>%
  summarise (miss = sum(is.na(lon) | is.na(lat))) %>%
  full_join(count_site) %>%
  filter(miss != 0) %>%
  filter(!is.na(WORKSITE)) %>%
  arrange(desc(apply_city_us)) 
#provide geocodes(day1)
WORKSITE <- h1b_detect$WORKSITE[1:2500]
site_geo <- cbind(geocode(WORKSITE), WORKSITE)
#join the h1b data
h1b_test <- left_join(h1b, site_geo, by = "WORKSITE") %>% 
  mutate(lon = ifelse(is.na(lon.x), lon.y, lon.x)) %>% 
  select(-lon.y, -lon.x) %>%
  mutate(lat = ifelse(is.na(lat.x), lat.y, lat.x)) %>%
  select(-lat.y, -lat.x)
#test
h1b_test %>%
  filter(WORKSITE %in% h1b_detect$WORKSITE[1:2500]) %>%
  group_by(WORKSITE) %>%
  summarise (miss = sum(is.na(lon) | is.na(lat))) %>%
  filter( miss != 0) %>%
  nrow() %>%
  paste("imputed",.,"NA","cities",sep = " ")
#merge "test data" as "h1b data"
h1b <- h1b_test 
#save h1b
saveRDS(h1b,"h1b.rds")
rm(list=ls())