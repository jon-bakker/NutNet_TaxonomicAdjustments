##### NUTNET TAXONOMIC ADJUSTMENTS
## JD Bakker
## 260604

## Separate taxonomic adjustments for each site to increase temporal consistency in naming

## Based on data in 'full-cover-2026-06-04.csv'
## Includes all sites with >= 4 years of data

## Most changes are summarized in a CSV file (adjustments.needed)
## Species characteristics (Taxon in site) updated separately from taxonomic changes (Taxon in plot)
## Individual changes can be dropped by setting 'Apply' == "No" 
## Set of changes appropriate for ISA available in 'Apply.ISA' column


Taxonomic.Adjustments <- function(datafile = datafile,
                                  adjustments.needed = adjustments.needed,
                                  Apply = Apply) {
  
  data1 <- datafile
  Apply <- Apply
  print(paste(nrow(data1), "records initially"))
  
  # Check for records with different species characteristics 
  duplicates <- data1 %>%
    dplyr::select(site_code, Taxon, Family, local_lifespan, local_provenance, functional_group) %>%
    unique() %>%
    count(site_code, Taxon, ) %>% 
    filter(n > 1)
  
  print(paste(nrow(duplicates), "Taxon with different species characteristics in same site:"))
  print(duplicates)
  
  data1 <- data1 %>%
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
  
  duplicates <- data1 %>%
    dplyr::select(site_code, Taxon, Family, local_lifespan, local_provenance, functional_group) %>%
    unique() %>%
    count(site_code, Taxon, ) %>% 
    filter(n > 1)
  print(ifelse(nrow(duplicates) == 0,
               "No more duplicate records",
               paste(nrow(duplicates), "duplicate records")))
  
  counter <- 0
  
  characteristic.adjustments <- adjustments.needed %>%
    filter(Apply == "Yes" &
             Reason == "Update species characteristics")
  
  taxon.adjustments <- adjustments.needed %>%
    filter(Apply == "Yes" &
             Reason != "Update species characteristics") %>%
    dplyr::select(site_code, Taxon, NewTaxon, New_Family)

  # Update species characteristics
  species.info <- data1 %>%
    dplyr::select(site_code, Taxon, Family, local_lifespan, local_provenance, local_lifeform, functional_group, ps_path) %>%
    unique() %>%
    merge(y = characteristic.adjustments,
          by = c("site_code", "Taxon"), all.x = TRUE, all.y = FALSE) %>%
    mutate(local_provenance = ifelse(is.na(New_local_provenance) | New_local_provenance == "", local_provenance, New_local_provenance),
           local_lifeform = ifelse(is.na(New_local_lifeform) | New_local_lifeform == "", local_lifeform, New_local_lifeform),
           local_lifespan = ifelse(is.na(New_local_lifespan) | New_local_lifespan == "", local_lifespan, New_local_lifespan),
           functional_group = ifelse(is.na(New_functional_group) | New_functional_group == "", functional_group, New_functional_group) ) %>%
    dplyr::select(-c(NewTaxon:New_functional_group))
  
  species.check <- species.info %>% count(site_code, Taxon) %>% filter(n > 1)
  
  print(ifelse(nrow(species.check) == 0,
               paste("all", nrow(characteristic.adjustments), "species characteristic changes made"), 
               paste("CHECK:", nrow(characteristic.adjustments), "species characteristic changes in adjustments")))
  
  # Adjust Taxon name and family where needed
  data2 <- data1 %>%
    merge(by = c("site_code", "Taxon"), all.x = TRUE,
          y = taxon.adjustments, all.y = FALSE)
  
  taxon.counter <- nrow(data2[ ! is.na(data2$NewTaxon) , ])
  
  print(paste(taxon.counter, "adjustments to taxon names made"))
  
  counter <- counter + taxon.counter
  
  data2 <- data2 %>% 
    mutate(Taxon = ifelse(is.na(NewTaxon) | NewTaxon == "", Taxon, NewTaxon),
           Family = ifelse(is.na(New_Family) | New_Family == "", Family, New_Family) ) %>%
    dplyr::select(-c(NewTaxon:New_Family) )
  
  # Sum cover for each taxon in each plot
  data2 <- data2 %>%
    group_by(site_code, site_name, block, plot, subplot, year, year_trt, trt, Taxon, Family) %>%
    summarize(max_cover = sum(max_cover),
              .groups = "keep")
  
  cover.counter <- nrow(data2[ data2$max_cover > 100, ])
  
  print(paste(cover.counter, "cover values set to maximum (100%)"))

  data2 <- data2 %>%
    mutate(max_cover = ifelse(max_cover > 100, 100, max_cover)) # ensure maximum cover is 100%
  
  # Drop records not assigned to family
  data2 <- data2 %>%
    filter(Family != "NULL")
  
  # Link species characteristics back to data
  data2 <- data2 %>%
    merge(y = species.info, all.x = TRUE, all.y = FALSE)

  # Drop mosses, lichens, fungi, non-living
  data2 <- data2 %>% filter( ! functional_group %in% c("BRYOPHYTE", "LICHEN", "LIVERWORT", "NON-LIVE"))
  
  #some families not consistently identified to functional group
  data2 <- data2[ ! data2$Family %in% c("Cladoniaceae",
                                        "Lycopodiaceae",
                                        "Parmeliaceae", 
                                        "Peltigeraceae",
                                        "Phallales",
                                        "Selaginellaceae",
                                        "Sphagnaceae",
                                        "Stereocaulaceae") , ]

  # #confirm that all taxon adjustments made
  data2.check <- merge(x = data1, by = c("site_code", "Taxon"), all.x = FALSE,
                       y = taxon.adjustments, all.y = FALSE) %>%
    filter(is.na(max_cover))
  print(ifelse(nrow(data2.check) == 0,
               "all taxon adjustments made", 
               paste("CHECK:", nrow(data2.check), "Taxon names in adjustments")))
  
    #check for duplicate records
  duplicate_records <- data2 %>%
    count(site_code, Taxon, block, plot, subplot, year, year_trt) %>%
    filter(n > 1)
  
    print(ifelse(nrow(duplicate_records) == 0, 
                 "no duplicate records", 
                 paste("CHECK:", nrow(duplicate_records), "duplicate records present")))

  print(paste(counter, "taxon name adjustments made"))
  print(paste(nrow(data2), "records after adjustments"))
  
  data2
  
}
