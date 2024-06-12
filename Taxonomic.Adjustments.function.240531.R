##### NUTNET TAXONOMIC ADJUSTMENTS
## JD Bakker
## 231109

## Separate taxonomic adjustments for each site to increase temporal consistency in naming

## Based on data in 'full-cover-2023-11-07.csv'
## Includes all sites with >= 4 years of data

## Most changes are summarized in a CSV file (adjustments.needed)
## Individual changes can be dropped by setting 'Apply' == "No" 

Taxonomic.Adjustments <- function(datafile = datafile, adjustments.needed = adjustments.needed) {
  
  data1 <- datafile
  print(paste(nrow(data1), "records initially"))
  
  counter <- 0
  
  # Recode Selaginellaceae as Forb
  data1$functional_group[data1$Family == "Selaginellaceae"] <- "FORB"
  
  # Drop mosses, lichens, fungi, non-living
  data1 <- data1[! data1$functional_group %in% c("BRYOPHYTE", "LICHEN", "LIVERWORT", "NON-LIVE") , ]
  #some families not consistently identified to functional group
  data1 <- data1[! data1$Family %in% c("Phallales") , ]
  
  # Clean up life history information
  data1 <- data1 %>%
    mutate(local_provenance = case_when(local_provenance == "NULL" ~ "UNK",
                                        local_provenance == "" ~ "UNK",
                                        TRUE ~ local_provenance),
           local_lifespan = case_when(local_lifespan == "NULL" ~ "UNK",
                                      local_lifespan == "UNKNOWN" ~ "UNK",
                                      TRUE ~ local_lifespan))
  
  # Adjust family where needed and drop records not assigned to family 
  data2 <- data1 %>%
    #dplyr::select(-c(site_name, local_lifespan, local_provenance, functional_group)) %>%
    merge(by = c("site_code", "Taxon"), all.x = TRUE,
          y = adjustments.needed %>% filter(NewFamily != "" & Apply == "Yes"), all.y = FALSE)
  counter <- counter + nrow(data2[ ! is.na(data2$NewTaxon), ])
  data2 <- data2 %>% 
    mutate(Family = ifelse(is.na(NewFamily) | NewFamily == "", Family, NewFamily)) %>%
    dplyr::select(-c(NewTaxon:Apply)) %>%
    filter(Family != "NULL")
  
  # Summarize life history information
  species.info <- data2 %>%
    dplyr::select(site_code, Taxon, Family, local_lifespan, local_provenance, functional_group) %>%
    unique()
  #species.info %>% count(site_code, Taxon) %>% filter(n > 1)
  
  #drop duplicate records for site-taxon
  species.info <- species.info %>% 
    filter( ! (site_code == "bttr.us" & Taxon == "RANUNCULUS SP." & local_provenance == "UNK")) %>% 
    filter( ! (site_code == "hopl.us" & Taxon == "TRIFOLIUM SP." & local_provenance == "UNK")) %>% 
    filter( ! (site_code == "kiny.au" & Taxon == "UNKNOWN ASTERACEAE " & local_provenance == "NAT")) %>% 
    filter( ! (site_code == "kiny.au" & Taxon == "UNKNOWN GRASS" & local_provenance == "INT")) %>%
    filter( ! (site_code == "kiny.au" & Taxon == "UNKNOWN GRASS" & local_provenance == "NAT")) %>%
    filter( ! (site_code == "sier.us" & Taxon == "LOTUS SP." & local_lifespan == "UNK"))
  #species.info %>% count(site_code, Taxon) %>% filter(n > 1)
  
  # Adjust Taxon where needed
  data2 <- data2 %>%
    #dplyr::select(-c(site_name, local_lifespan, local_provenance, functional_group)) %>%
    merge(by = c("site_code", "Taxon"), all.x = TRUE,
          y = adjustments.needed %>% filter(Apply == "Yes") %>% dplyr::select(site_code, Taxon, NewTaxon),
          all.y = FALSE)
  counter <- counter + nrow(data2[ ! is.na(data2$NewTaxon), ])
  data2 <- data2 %>%
    mutate(Taxon = ifelse(is.na(NewTaxon), Taxon, NewTaxon),
           NewTaxon = NULL)
  
  data2.check <- merge(x = data1, by = c("site_code", "Taxon"), all.x = FALSE,
                 y = adjustments.needed %>% filter(Apply == "Yes"), all.y = FALSE) %>%
    filter(is.na(max_cover))
  print(ifelse(nrow(data2.check) == 0, "all adjustments made", "check Taxon names in adjustments"))

  # update life history information
  data2 <- data2 %>%
    group_by(site_code, block, plot, subplot, year, year_trt, trt, Family, Taxon) %>%
    summarize(max_cover = sum(max_cover), .groups = "keep")
  
  counter <- counter + nrow(data2[ data2$max_cover > 100, ])
  
  data2 <- data2 %>%
    mutate(max_cover = ifelse(max_cover > 100, 100, max_cover)) %>% # ensure maximum cover is 100%
    merge(y = species.info, all.x = TRUE, all.y = FALSE)
  
  #check for conflicting life history information
  duplicate_records <- data2 %>%
    group_by(site_code, Taxon, block, plot, subplot, year, year_trt) %>%
    mutate(obs = row_number()) %>%
    filter(obs > 1)
  print(ifelse(nrow(duplicate_records) == 0, "no duplicate records", "check for duplicate records"))

  print(paste(counter, "adjustments made"))
  print(paste(nrow(data2), "records after adjustments"))
  
  data2
  
}
