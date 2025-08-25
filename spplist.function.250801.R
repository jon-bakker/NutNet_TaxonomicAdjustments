# Function to tally species in a site (taxon x year matrix)
spplist <- function(datafile = datafile,
                    site_code2 = site_code) {
  require(tidyverse)
  temp <- datafile %>%
    filter(site_code == site_code2) %>%
    mutate(ID = paste(Taxon, Family, local_provenance, local_lifeform, local_lifespan, functional_group))
  temp.species <- temp %>%
    dplyr::select(ID, Taxon, Family, local_provenance, local_lifeform, local_lifespan, functional_group) %>%
    unique()
  temp2 <- temp %>%
    group_by(ID, year) %>%
    summarize(N = length(max_cover > 0),
              .groups = "keep") %>%
    pivot_wider(names_from = year,
                values_from = N,
                names_sort = TRUE)
  temp3 <- temp2 %>%
    merge(y = temp.species,
        by.y = "ID",
        all.y = FALSE) %>%
    mutate(ID = NULL) %>%
    relocate(Taxon) %>%
    arrange(Family, Taxon)
  temp3[is.na(temp3)] <- "."
  temp3
}
