##### NUTNET TAXONOMIC ADJUSTMENTS 
## JD Bakker
## 231109

## Notes:
## All sites with >= 4 years of data
## Data release from November 7, 2023

# 1.0 LOAD ITEMS -----------------------------------------------------------
# 1.1 Load packages ----
library(plyr)
library(tidyverse)

# 1.2 Load functions ---------------------------------------------------------------
# Function to tally species in a site (taxon x year matrix)
source("scripts/spplist.function.R")

# Function to tally plots in a site (block x year matrix)
source("scripts/plotlist.function.R")

# Function to conduct site-specific taxonomic adjustments
source("scripts/Taxonomic.Adjustments.function.231107 - Copy.R")

# 1.3 Load data ----
original.triplet <- read.csv("data/full-cover_2023-11-07.csv", header = T) # 345245 x 17
triplet <- original.triplet %>% # backup
  mutate(year = as.numeric(year))

original.site.covars <- read.csv("data/comb-by-plot-clim-soil_2023-11-07.csv",
                                 na.strings = c("NULL", "NA")) # 28168 x 87
site.covars.orig <- original.site.covars

adjustments.needed <- read.csv("data/taxonomic-adjustments-2023-11-07.csv")

# 2.0 PRE-PROCESSING OF COVER DATA ------------------------------------------------------------

## create summary table for each site showing composition BEFORE taxonomic adjustments
## (this operates on all sites)
sites.data <- unique(triplet$site_code) #161 sites
for(i in 1:length(sites.data)) {
  write.csv(spplist(datafile = triplet,
                    site_code = sites.data[i]),
            file = paste("output/raw/", as.character(sites.data[i]), "_raw.csv", sep = ""))
}
rm(sites.data)


# 2.1 Choose sites to which to apply taxonomic adjustments ----

## drop sites with < 4 years of data
siteyear <- triplet %>%
  dplyr::select(site_code, year, year_trt, block) %>%
  group_by(site_code) %>%
  summarize(years = length(unique(year)),
            min_year = min(year),
            min_year_trt = min(unique(year_trt)),
            max_year = max(year),
            max_year_trt = max(unique(year_trt)),
            blocks = length(unique(block)),
            .groups = "keep")
exptsites.all <- siteyear[siteyear$years >= 4 , ] # select sites with 4 or more years of data (n = 85)
#also includes varheath.no which used to have 4 years of data but has been reduced to 3 years

# 2.2 Taxonomic QC ----
data1.all <- Taxonomic.Adjustments(datafile = triplet,
                                   adjustments.needed = adjustments.needed) # 297805 x 11

## create summary table for each site showing composition after taxonomic adjustments
## (this only includes sites with 4 or more years of data)
sites.data <- exptsites.all$site_code
for(i in 1:length(sites.data)) {
  write.csv(spplist(datafile = data1.all,
                    site_code = sites.data[i]),
            file = paste("output/adjusted/", as.character(sites.data[i]), "_adjusted.csv", sep = ""))
}
rm(sites.data)
