##### NUTNET TAXONOMIC ADJUSTMENTS
## JD Bakker
## 250801

## Separate taxonomic adjustments for each site to increase temporal consistency in naming

## Based on data in 'full-cover-2025-08-01.csv'
## Includes all sites with >= 4 years of data

## Most changes are summarized in a CSV file (adjustments.needed)
## Species characteristics (Taxon in site) updated separately from taxonomic changes (Taxon in plot)
## Individual changes can be dropped by setting 'Apply' == "No" 

Taxonomic.Adjustments <- function(datafile = datafile,
                                  adjustments.needed = adjustments.needed) {
  
  data1 <- datafile
  print(paste(nrow(data1), "records initially"))
  
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
               "check species characteristic changes in adjustments"))
  
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
  print(ifelse(nrow(data2.check) == 0, "all taxon adjustments made", "check Taxon names in adjustments"))
  
    #check for conflicting life history information
  duplicate_records <- data2 %>%
    count(site_code, Taxon, block, plot, subplot, year, year_trt) %>%
    filter(n > 1)
  
    print(ifelse(nrow(duplicate_records) == 0, "no duplicate records", "check for duplicate records"))

  print(paste(counter, "taxon name adjustments made"))
  print(paste(nrow(data2), "records after adjustments"))
  
  data2
  
}
