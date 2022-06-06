##### NUTNET TAXONOMIC ADJUSTMENTS
## JD Bakker
## 220131

## Separate taxonomic adjustments for each site to increase temporal consistency in naming

## Based on data in 'full-cover-2022-01-31.csv'
## Includes all sites with >= 4 years of data

## Most changes are summarized in a CSV file (adjustments.needed)
## Individual changes can be dropped by setting 'Apply' == "No" 

Taxonomic.Adjustments <- function(datafile = datafile, adjustments.needed = adjustments.needed) {
  
  data1 <- datafile
  
  # Drop mosses, lichens, fungi
  data1 <- data1[! data1$functional_group %in% c("BRYOPHYTE", "LICHEN", "CLUBMOSS", "LIVERWORT", "NON-LIVE") , ]
  #some families not consistently identified to functional group
  data1 <- data1[! data1$Family %in% c("Dicranaceae", "Lycopodiaceae", "Phallales", "Pottiaceae",
                                       "Selaginellaceae", "Thuidiaceae", "MNIACEAE", "Polytrichaceae") , ]
  
  # Site-specific taxonomic adjustments
  data2 <- merge(x = data1, by = c("site_code", "Taxon"), all.x = TRUE,
                 y = adjustments.needed[ adjustments.needed$Apply == "Yes" , ], all.y = FALSE) %>%
    mutate(NewTaxon = ifelse(is.na(NewTaxon), Taxon, NewTaxon),
           NewFamily = ifelse(is.na(NewFamily) | NewFamily == "", Family, NewFamily),
           Taxon = NULL,
           Family = NULL,
           Notes = NULL,
           Omit = NULL,
           Apply = NULL) %>%
    rename(Taxon = NewTaxon,
           Family = NewFamily) %>%
    filter(Family != "NULL") # Drop records not assigned to family
  
  data2.check <- merge(x = data1, by = c("site_code", "Taxon"), all.x = FALSE,
                 y = adjustments.needed[ adjustments.needed$Apply == "Yes" , ], all.y = TRUE) %>%
    filter(is.na(max_cover))

  temp <- data2 %>%
    group_by(site_code, block, plot, subplot, trt, year, year_trt, Taxon, Family, live) %>%
    summarize(max_cover = sum(max_cover), .groups = "keep")
  
  temp <- temp %>%
    mutate(max_cover = ifelse(max_cover > 100, 100, max_cover))
   # ensure maximum cover is 100%

  temp
  
}
