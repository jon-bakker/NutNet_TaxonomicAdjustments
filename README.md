# NutNet_TaxonomicAdjustments
Taxonomic adjustments for NutNet compositional data to ensure consistent naming within a site over time.  Note that this script does **not** consider taxonomic consistency among sites.

Taxonomic adjustments have been considered for all sites with at least 4 years of data.  In the current data release (**January 31, 2025**), this is **86 sites**.

Taxonomic adjustments can be necessary for many reasons - see the below description of the 'Reason' column in the CSV file.

Adjustments were identified by comparing species lists over time, both for a site as a whole and for individual plots within it.  The spplist() function provides a simple way to create a species list for a site.  The data import script (Data.Import.Taxonomic.Adjustments.script.YYMMDD.R) includes code to export species lists for every site - see details below.

The CSV file contains a table of all recommended changes along with other notes about composition on a site-by-site basis.  This  file is specific to a data release and therefore needs to be updated each time a new file of cover data is released.  The release date is indicated at the end of the file name (YYYY-MM-DD).

The columns in the CSV file are as follows:
- site_code - NutNet site to which this adjustment applies
- Taxon - current name of Taxon
- NewTaxon - recommended new name of Taxon (usually another taxon present at that site)
- Notes - explanation of why adjustment is recommended.  Incomplete.  Also includes questions about idiosyncracies of site.
- Reason - simplified explanation of why adjustment is recommended.  As of the April 26, 2023 data release, a reason is provided for every entry.  Currently 11 reasons are used:
  - **Aggregate at genus level** - level of taxonomic resolution varies among years.  For example, two species within a genus are distinguished in one year, but in another year there is only a single record for the genus.  Species within genus are assigned to the genus.
  - **Aggregate at species level** - level of taxonomic resolution varies among years.  For example, one taxon code is a subspecies or variety of the other.  The more specific taxon is assigned to the species.  For example, '*Poa pratensis* ssp. *latifolia*' is assigned to '*Poa pratensis*'.
  - **Assign to dominant taxon in Family** - Family contains several taxa along with an unknown taxon code (e.g., Unknown Poaceae). The unknown taxon is assigned to the dominant taxon in that Family.  The rationale for this adjustment is that this permits correct calculations of total abundance yet the addition of these unknowns to already-dominant taxa has relatively small effects of dissimilarity among plots.  This adjustment was first introduced in the January 31, 2022 data release.
  - **Assign to dominant taxon in Genus** - A genus a generic taxon (e.g., *Poa* sp.) is assigned to the dominant taxon within that genus. Used when several species have been recorded within the genus. Assumption is that the generic taxon is more likely to be one of these existing taxa than to be a new species.  This permits correct the calculations of total abundance yet the addition of these unknowns to already-dominant taxa has relatively small effects of dissimilarity among plots.
  - **Common misidentification** - two taxa are commonly or easily confused.  Assigned to the taxon code that was used most recently or as indicated by site lead.
  - **Global taxon name** - unknowns and identifications to genus level sometimes include the site code in taxon name.  This removes the site code so that the adjusted taxon name is globally comparable.
  - **Inconsistent identication across years** - two or more taxon codes that are present in the same plot in different years.  Usually assigned to the taxon that code that was used most recently or as indicated by site lead.
  - **No changes** - no recommended changes.  Either no changes are recommended for the entire site or a particular adjustment was considered but not adopted and is recorded here for clarity.  For example, if two taxon codes appear to meet another reason but were both present in the same plot-year then the assumption is that they should be kept distinct. 
  - **No congeners recorded** - some observations within a genus are to species (*Poa pratensis*) and some are to the genus level (*Poa* sp.).  These two taxon codes are combined as a single taxon under the assumption that records at the genus level are more likely to be a shorthand for the species rather than a new taxon. The retained name for this taxon is usually the code that was most frequently used at this site.  Used where only these two taxon codes are present.
  - **Spelling** - one taxon code is a misspelling of the other. For example, '*Poa pratensis*' and '*Poa pratensi*' should both refer to the same taxon.  Assigned to the correct spelling.
  - **Synonyms** - two taxon codes are synonyms. Assigned to the taxon code used most recently at the site.
- NewFamily - recommended new Family to which observation should be assigned.  Used rarely - only when the taxonomic adjustment requires changing the plant family.
- Omit - binary; whether to apply this adjustment (No) or to omit it (Yes). It is counter-intuitive to have to flag the entries that you want to omit, so this field has been replaced by the 'Apply' field and will be eliminated in the future.
- Apply - binary; whether to apply this adjustment (Yes) or to omit it (No).  For example, all entries where the reason is 'no changes' are set to Apply == No.

The data import script (Data.Import.Taxonomic.Adjustments.script.YYMMDD.R) loads the data (not included here; available to authorized users through the NutNet dropbox folder), creates a species list for each site based on the raw cover data, applies the taxonomic adjustments function, and creates a species list based on the adjusted cover data for each site with at least 4 years of data.  The species lists can be easily ignored if desired.  If run, they require two destination folders, 'output/raw' and 'output/adjusted', within your working directory.  The 'output/raw' folder will receive a summary of the raw data for each site (currently, n = 162). The 'output/adjusted' folder will receive a summary of the data after taxonomic adjustments for each site with at least 4 years of data (currently, n = 86).

The workflow of the taxonomic adjustments function (Taxonomic.Adjustments.function.YYMMDD.R) is as follows:
- Print to screen the number of number of records present in datafile.
- Drop non-vascular plants (mosses, lichens, fungi), but retain Selaginella as vascular plants.
- Adjust some life history information and drop taxa not assigned to a plant family.
- Merge original data file with set of adjustments.
- A few taxa in a few sites do not have consistent life history information (e.g., lifespan reported for some entries but not for others); these unknowns are omitted so that there is a single record for each site-taxon combination. 
- If a given taxon at a given site has a recommended adjustment, replace the name in the 'Taxon' field with that in the 'NewTaxon' field.  If the recommended 'NewTaxon' is from a different plant family, or a family was not provided originally, the entry in the 'Family' field is also replaced with that in the 'NewFamily' field.  Taxa without recommended adjustments are unchanged.
- Check whether any of the recommended adjustments were not made (e.g., if they were incorrectly spelled) and print to screen whether "all adjustments made" or to "check Taxon names in adjustments".
- Recalculate the cover of each taxon in each plot-year so that multiple entires of a taxon are replaced by a single entry consisting of the summed cover of all entries assigned to it.
- Set the maximum possible cover of a species to 100%.
- Check for conflicting life history information, such as two entries with different provenances for the same site-taxon combination.  Print to screen either "no duplicate records" or "check for duplicate records".
- Print to screen the number of adjustments made and the number of records present after adjustments.

**Please reach out to Jon Bakker (jbakker@uw.edu) if you have issues with this code or feel other/different taxonomic adjustments are warranted.**
