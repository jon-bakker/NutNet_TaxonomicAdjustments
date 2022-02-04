# NutNet_TaxonomicAdjustments
Taxonomic adjustments for NutNet compositional data to ensure consistent naming over time.  Note that this script does **not** consider taxonomic consistency among sites.

Taxonomic adjustments have been considered for all sites with at least 4 years of data.  In the current data release (**January 31, 2022**), this is **74 sites**.

Taxonomic adjustments can be necessary for many reasons, including:
- Taxonomic imprecision. Examples:
  -  Taxa that are distinguished in some years but lumped as a single genus in other years
  -  A taxon that is reported as a species in some years but as a subspecies or variety in other years
- Taxonomic errors. Taxonomic names change over time, and sometimes the same taxa is recorded by different names in different years. 
- Identification issues. A species that is regularly widespread but is missing in a single year may reflect its misidentification as another taxon.
- Spelling errors. For example, 'Poa pratensis' and 'Poa pratensi' will be treated as separate taxa.

Adjustments were identified by comparing species lists over time, both for a site as a whole and for individual plots within it.  The spplist() function provides a simple way to create a species list for a site.  

The CSV file (taxonomic-adjustments-2022-01-31.csv) contains a table of all recommended changes along with other notes about composition on a site-by-site basis.  The CSV file of taxonomic adjustments is specific to a data release and therefore needs to be updated each time a new file of cover data is released.  The release date is indicated at the end of the file name (YYMMDD).  For example, the file 'taxonomic-adjustments-2022-01-31.csv' is for the current file released on **January 31, 2022**.  The columns in the CSV file are as follows:
- site_code - NutNet site to which this adjustment applies
- Taxon - current name of Taxon
- NewTaxon - recommended new name of Taxon (usually another taxon present at that site)
- NewFamily - recommended new Family to which observation should be assigned
- Notes - explanation of why adjustment is recommended.  Incomplete.  Also includes questions about idiosyncracies of site and documentation if no changes are commended at site ('no changes').
- Omit - binary; whether to apply this adjustment (No) or to omit it (Yes). It is counter-intuitive to have to flag the entries that you want to omit, so this field has been replaced by the 'Apply' field and will be eliminated in the future.
- Apply - binary; whether to apply this adjustment (Yes) or to omit it (No).

Note: in previous versions of this script, unknown codes that were not clearly similar to other taxa were omitted.  However, this eliminates the cover associated with those taxa which in a few cases is sizable.  As of the January 31, 2022 data release, I now assign the cover from these unnknown codes to the taxon within that plant family that was most abundant at that site in the year(s) when the unknown was recorded - the rationale being that this will still permit correct calculations of total abundance but that the addition of these unknowns to already-dominant taxa will have relatively small effects of dissimilarity among plots.  These changes are explained in the 'Notes' field ('assign to dominant taxon in Family').

The script named 'Data.Import.Taxonomic.Adjustments.script.221031.R' loads the data (not included here; available to authorized users through the NutNet dropbox folder), creates a species list for each site based on the raw cover data, applies the taxonomic adjustments function, and creates a species list based on the adjusted cover data for each site with at least 4 years of data.  The species lists require two destination folders, 'output/raw' and 'output/adjusted', within your working directory.  The 'output/raw' folder will receive a summary of the raw data for each site (n = 129). The 'output/adjusted' folder will receive a summary of the data after taxonomic adjustments for each site with at least 4 years of data (n = 74).

The workflow of the taxonomic adjustments function (Taxonomic.Adjustments.function.220131.R) is as follows:
- Drop non-vascular plants (mosses, lichens, fungi).
- Merge original data file with set of adjustments.
- If a given taxon at a given site has a recommended adjustment replace the name in the 'Taxon' field with that in the 'NewTaxon' field.  In a few cases the recommended 'NewTaxon' is from a different plant family (or one was not provided originally); in this case, the entry in the 'Family' field is also replaced with that in the 'NewFamily' field.  Taxa without recommended adjustments are unchanged.
- Drop records in which the Taxon has not been assigned to a plant family.  This includes all substrates (non-living).
- Recalculate the cover of each taxon in each plot-year so that multiple entires of a taxon are replaced by a single entry consisting of the summed cover of all entries assigned to it.

**Please reach out to Jon Bakker (jbakker@uw.edu) if you have issues with this code or feel other/different taxonomic adjustments are warranted.**
