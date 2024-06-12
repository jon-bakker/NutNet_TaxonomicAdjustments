# Function to tally species in a site (taxon x year matrix)
spplist <- function(datafile = datafile, site_code = site_code) {
  require(tidyverse)
  temp <- datafile[datafile$site_code == site_code, ] %>%
    group_by(Taxon, year) %>%
    summarize(N = length(max_cover > 0), .groups = "keep") %>%
    pivot_wider(names_from = year, values_from = N, names_sort = TRUE) %>%
    merge(y = unique(datafile[ , c("Taxon", "Family")]), by.y = "Taxon", all.y = FALSE)
  temp[is.na(temp)] <- "."
  with(temp, temp[ order(Family, Taxon), ])
}
