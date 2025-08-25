##### NUTNET TAXONOMIC ADJUSTMENTS 
## JD Bakker
## 250801

## Notes:
## All sites with >= 4 years of data
## Data release from August 1, 2025 (and interim releases since January 31, 2025)

# 1.0 LOAD ITEMS -----------------------------------------------------------
# 1.1 Load packages ----
library(plyr)
library(tidyverse)

# 1.2 Load functions ---------------------------------------------------------------
# Function to tally species in a site (taxon x year matrix)
source("scripts/spplist.function.250801.R")
#code updated to also track species characteristics

# Function to tally plots in a site (block x year matrix)
source("scripts/plotlist.function.R")

# Function to conduct site-specific taxonomic adjustments
source("scripts/Taxonomic.Adjustments.function.250801.R")

# 1.3 Load data ----
original.triplet <- read.csv("data/full-cover_2025-08-01.csv", header = T) # 382592 x 17
triplet <- original.triplet %>% # backup
  mutate(year = as.numeric(year))

original.site.covars <- read.csv("data/comb-by-plot-clim-soil_2025-08-01.csv",
                                 na.strings = c("NULL", "NA")) # 31425 x 87
site.covars.orig <- original.site.covars

adjustments.needed <- read.csv("data/taxonomic-adjustments-2025-08-01.csv") # 644 x 11

# 2.0 PRE-PROCESSING OF COVER DATA ------------------------------------------------------------

# 2.1 Check for records with different species characteristics ----
triplet %>%
  dplyr::select(site_code, Taxon, Family, local_lifespan, local_provenance, functional_group) %>%
  unique() %>%
  count(site_code, Taxon, ) %>% 
  filter(n > 1)

# site_code                              Taxon n
# 1    bttr.us           RANUNCULUS SP. (bttr.us) 2
# 2    cbgb.us              UNKNOWN SP. (cbgb.us) 2
# 3    cdcr.us              UNKNOWN SP. (cdcr.us) 3
# 4     kbs.us               UNKNOWN SP. (kbs.us) 3
# 5    kiny.au         RYTIDOSPERMA SP. (kiny.au) 2
# 6    kiny.au            TRIFOLIUM SP. (kiny.au) 2
# 7    kiny.au   UNKNOWN ASTERACEAE SP. (kiny.au) 2
# 8    kiny.au      UNKNOWN POACEAE SP. (kiny.au) 3
# 9    kiny.au              UNKNOWN SP. (kiny.au) 6
# 10 saline.us            UNKNOWN SP. (saline.us) 2
# 11    sgs.us               UNKNOWN SP. (sgs.us) 2
# 12   shps.us UNKNOWN BRASSICACEAE SP. (shps.us) 3
# 13   shps.us              UNKNOWN SP. (shps.us) 5
# 14   sier.us              UNKNOWN SP. (sier.us) 2

## temporary adjustments to create separate Taxon codes for species with different characteristics documented
triplet <- triplet %>%
  mutate(Taxon = case_when(site_code == "bttr.us" &
                             Taxon == "RANUNCULUS SP. (bttr.us)" &
                             local_provenance == "NAT" ~ "RANUNCULUS SP.2 (bttr.us)",
                           site_code == "cbgb.us" &
                             Taxon == "UNKNOWN SP. (cbgb.us)" &
                             functional_group == "FORB" ~ "UNKNOWN FORB SP. (cbgb.us)",
                           site_code == "cdcr.us" &
                             Taxon == "UNKNOWN SP. (cdcr.us)" &
                             functional_group == "FORB" ~ "UNKNOWN FORB SP.2 (cdcr.us)",
                           site_code == "cdcr.us" &
                             Taxon == "UNKNOWN SP. (cdcr.us)" &
                             functional_group == "WOODY" ~ "UNKNOWN WOODY SP. (cdcr.us)",
                           site_code == "kbs.us" &
                             Taxon == "UNKNOWN SP. (kbs.us)" &
                             local_lifespan == "INDETERMINATE" &
                             functional_group == "NULL" ~ "UNKNOWN SP.2 (kbs.us)",
                           site_code == "kbs.us" &
                             Taxon == "UNKNOWN SP. (kbs.us)" &
                             functional_group == "WOODY" ~ "UNKNOWN WOODY SP. (kbs.us)",
                           site_code == "kiny.au" &
                             Taxon == "RYTIDOSPERMA SP. (kiny.au)" &
                             local_lifespan == "PERENNIAL" ~ "RYTIDOSPERMA SP.2 (kiny.au)",
                           site_code == "kiny.au" &
                             Taxon == "TRIFOLIUM SP. (kiny.au)" &
                             functional_group == "FORB" ~ "TRIFOLIUM SP.2 (kiny.au)",
                           site_code == "kiny.au" &
                             Taxon == "UNKNOWN ASTERACEAE SP. (kiny.au)" &
                             local_lifespan == "ANNUAL" ~ "UNKNOWN ASTERACEAE SP.2 (kiny.au)",
                           site_code == "kiny.au" &
                             Taxon == "UNKNOWN POACEAE SP. (kiny.au)" &
                             local_provenance == "NAT" &
                             local_lifespan == "PERENNIAL" ~ "UNKNOWN POACEAE SP.2 (kiny.au)",
                           site_code == "kiny.au" &
                             Taxon == "UNKNOWN POACEAE SP. (kiny.au)" &
                             local_provenance == "UNK" ~ "UNKNOWN POACEAE SP.3 (kiny.au)",
                           site_code == "kiny.au" &
                             Taxon == "UNKNOWN SP. (kiny.au)" &
                             local_provenance == "NAT" &
                             functional_group == "FORB" ~ "UNKNOWN FORB SP. (kiny.au)",
                           site_code == "kiny.au" &
                             Taxon == "UNKNOWN SP. (kiny.au)" &
                             local_provenance == "NAT" ~ "UNKNOWN SP.2 (kiny.au)",
                           site_code == "kiny.au" &
                             Taxon == "UNKNOWN SP. (kiny.au)" &
                             functional_group == "GRAMINOID" ~ "UNKNOWN GRAMINOID SP. (kiny.au)",
                           site_code == "kiny.au" &
                             Taxon == "UNKNOWN SP. (kiny.au)" &
                             local_provenance == "UNK" &
                             local_lifespan == "ANNUAL" ~ "UNKNOWN ANNUAL SP. (kiny.au)",
                           site_code == "kiny.au" &
                             Taxon == "UNKNOWN SP. (kiny.au)" &
                             local_provenance == "UNK" &
                             local_lifespan == "NULL" ~ "UNKNOWN SP.3 (kiny.au)",
                           site_code == "saline.us" &
                             Taxon == "UNKNOWN SP. (saline.us)" &
                             local_provenance == "UNK" ~ "UNKNOWN SP.2 (saline.us)",
                           site_code == "sgs.us" &
                             Taxon == "UNKNOWN SP. (sgs.us)" &
                             local_provenance == "UNK" ~ "UNKNOWN SP.2 (sgs.us)",
                           site_code == "shps.us" &
                             Taxon == "UNKNOWN BRASSICACEAE SP. (shps.us)" &
                             local_lifespan == "ANNUAL" ~ "UNKNOWN BRASSICACEAE SP.2 (shps.us)",
                           site_code == "shps.us" &
                             Taxon == "UNKNOWN BRASSICACEAE SP. (shps.us)" &
                             local_provenance == "UNK" ~ "UNKNOWN BRASSICACEAE SP.3 (shps.us)",
                           site_code == "shps.us" &
                             Taxon == "UNKNOWN SP. (shps.us)" &
                             local_lifespan == "ANNUAL" &
                             local_provenance == "NULL" ~ "UNKNOWN SP.2 (shps.us)",
                           site_code == "shps.us" &
                             Taxon == "UNKNOWN SP. (shps.us)" &
                             local_lifespan == "ANNUAL" &
                             local_provenance == "UNK" ~ "UNKNOWN SP.3 (shps.us)",
                           site_code == "shps.us" &
                             Taxon == "UNKNOWN SP. (shps.us)" &
                             local_lifespan == "NULL" &
                             local_provenance == "UNK" ~ "UNKNOWN SP.4 (shps.us)",
                           site_code == "shps.us" &
                             Taxon == "UNKNOWN SP. (shps.us)" &
                             local_lifespan == "PERENNIAL" &
                             local_provenance == "UNK" ~ "UNKNOWN SP.5 (shps.us)",
                           site_code == "sier.us" &
                             Taxon == "UNKNOWN SP. (sier.us)" &
                             local_lifespan == "ANNUAL" &
                             functional_group == "FORB" ~ "UNKNOWN SP.2 (sier.us)",
                           TRUE ~ Taxon) )

triplet %>%
  dplyr::select(site_code, Taxon, Family, local_lifespan, local_provenance, functional_group) %>%
  unique() %>%
  count(site_code, Taxon, ) %>% 
  filter(n > 1)
#no more duplicate recrods

## create summary table for each site showing composition BEFORE taxonomic adjustments
## (this operates on all sites)
sites.data <- unique(triplet$site_code) #162 sites
for(i in 1:length(sites.data)) {
  write.csv(spplist(datafile = triplet,
                    site_code = sites.data[i]),
            file = paste("output/raw/", as.character(sites.data[i]), "_raw.csv", sep = ""))
}
rm(sites.data)


# 2.1 Choose sites to which to apply taxonomic adjustments ----

## tally number of years of data per site
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
## focus on sites with < 4 years of data
exptsites.all <- siteyear %>% filter(years >= 4) # (n = 90)
#siteyear %>% filter(years == 3) # 7 sites have 3 years of data


# 2.2 Taxonomic QC ----
data1.all <- Taxonomic.Adjustments(datafile = triplet,
                                   adjustments.needed = adjustments.needed) # 328461 x 16

## create summary table for each site showing composition after taxonomic adjustments
## (non-living taxa omitted from all sites
## (adjustments to species characteristics and taxon names only for sites with >= 4 years of data)
sites.data <- unique(triplet$site_code) #162 sites
for(i in 1:length(sites.data)) {
  write.csv(spplist(datafile = data1.all,
                    site_code = sites.data[i]),
            file = paste("output/adjusted/", as.character(sites.data[i]), "_adjusted.csv", sep = ""))
}
rm(sites.data)
