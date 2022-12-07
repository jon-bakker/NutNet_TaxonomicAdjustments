# NutNet_TaxonomicAdjustments
Taxonomic adjustments for NutNet compositional data to ensure consistent naming within a site over time.  Note that this script does **not** consider taxonomic consistency among sites.

Taxonomic adjustments have been considered for all sites with at least 4 years of data.  In the current data release (**November 15, 2022**), this is **78 sites**.

Taxonomic adjustments can be necessary for many reasons - see the below description of the 'Reason' column in the CSV file.

Adjustments were identified by comparing species lists over time, both for a site as a whole and for individual plots within it.  The spplist() function provides a simple way to create a species list for a site.  

The CSV file contains a table of all recommended changes along with other notes about composition on a site-by-site basis.  This  file is specific to a data release and therefore needs to be updated each time a new file of cover data is released.  The release date is indicated at the end of the file name (YYYY-MM-DD).

The columns in the CSV file are as follows:
- site_code - NutNet site to which this adjustment applies
- Taxon - current name of Taxon
- NewTaxon - recommended new name of Taxon (usually another taxon present at that site)
- Notes - explanation of why adjustment is recommended.  Incomplete.  Also includes questions about idiosyncracies of site and documentation if no changes are recommended at site ('no changes').
- Reason - simplified explanation of why adjustment is recommended.  Starting to use consistent reasons, but this is incomplete.  Reasons include:
  - **Aggregate at genus level** - two or more taxon codes that appear to be used inconsistently. For example, two species within a genus are distinguished in one year, but in another year there is only a single record for the genus.
  - **Aggregate at species level** - a taxon that is a subspecies or variety of a species is assigned to the species.  For example, 'Poa pratensis ssp. latifolia' is assigned to 'Poa pratensis'.
  - **Assign to dominant taxon in Family** - unknown taxon from family is assigned to the dominant taxon in that Family.  The rationale for this adjustment is that this permits correct calculations of total abundance yet the addition of these unknowns to already-dominant taxa has relatively small effects of dissimilarity among plots.  This adjustment was introduced as of the January 31, 2022 data release.
  - **Assign to dominant taxon in Genus** - a generic taxon (e.g., Poa sp.) is assigned to the dominant taxon within that genus. Used when there are several potential taxa within genus.
  - **Common misidentification** - two or more taxa that are commonly or easily confused.
  - **Global taxon name** - unknowns and identifications to genus level sometimes include site code in taxon name.  This simply removes the site code so that the adjusted taxon name is globally comparable.
  - **Inconsistent identication across years** - two or more taxon names that are used in the same plot in different years.
  - **No changes** - no recommended changes for site
  - **No congeners recorded** - identification of a species and a genus are combined as a single taxon. The retained name for this taxon is usually the code that was most frequently used at this site.
  - **Spelling** - one taxon code is a misspelling of the other. For example, 'Poa pratensis' and 'Poa pratensi'.
  - **Synonyms** - two taxon codes are synonyms for the same taxon.
- NewFamily - recommended new Family to which observation should be assigned
- Omit - binary; whether to apply this adjustment (No) or to omit it (Yes). It is counter-intuitive to have to flag the entries that you want to omit, so this field has been replaced by the 'Apply' field and will be eliminated in the future.
- Apply - binary; whether to apply this adjustment (Yes) or to omit it (No).

The data import script (Data.Import.Taxonomic.Adjustments.script.YYMMDD.R) loads the data (not included here; available to authorized users through the NutNet dropbox folder), creates a species list for each site based on the raw cover data, applies the taxonomic adjustments function, and creates a species list based on the adjusted cover data for each site with at least 4 years of data.  The species lists can be easily ignored if desired.  If run, they require two destination folders, 'output/raw' and 'output/adjusted', within your working directory.  The 'output/raw' folder will receive a summary of the raw data for each site (currently, n = 143). The 'output/adjusted' folder will receive a summary of the data after taxonomic adjustments for each site with at least 4 years of data (currently, n = 78).

The workflow of the taxonomic adjustments function (Taxonomic.Adjustments.function.YYMMDD.R) is as follows:
- Drop non-vascular plants (mosses, lichens, fungi), but retain Selaginella and lycopods as vascular plants.
- Merge original data file with set of adjustments.
- If a given taxon at a given site has a recommended adjustment replace the name in the 'Taxon' field with that in the 'NewTaxon' field.  In a few cases the recommended 'NewTaxon' is from a different plant family, or a family was not provided originally; in these cases, the entry in the 'Family' field is also replaced with that in the 'NewFamily' field.  Taxa without recommended adjustments are unchanged.
- Drop records in which the Taxon has not been assigned to a plant family.  This includes all substrates (non-living).
- Recalculate the cover of each taxon in each plot-year so that multiple entires of a taxon are replaced by a single entry consisting of the summed cover of all entries assigned to it.

**Please reach out to Jon Bakker (jbakker@uw.edu) if you have issues with this code or feel other/different taxonomic adjustments are warranted.**
