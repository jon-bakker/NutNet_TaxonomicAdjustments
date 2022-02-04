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

Adjustments were identified by comparing species lists over time, both for a site as a whole and for individual plots within it.  The spplist() function provides a simple way to create a species list for a site.  These lists are also included in the 'output' folder here.  The 'output/raw' folder contains a summary of the raw data for each site (n = 129). The 'output/adjusted' folder contains a summary of the data after taxonomic adjustments for each site with at least 4 years of data (n = 74).  All lists were generated using the current data release (January 31, 2022).

The CSV file contains a table of all recommended changes along with other notes about composition on a site-by-site basis.  For a given site, the recommended change is to replace names in the 'Taxon' field with those in the 'NewTaxon' field.  Reasons for these changes are (sometimes) provided in the 'Notes' field.  The 'Apply' field is a flag indicating whether each adjustment should be applied (Yes) or ignored (No).  Sites that do not have any adjustments are also included in this file and the fact that no changes are recommended is explained in the 'Notes' field. (Note: this flag used to be coded as 'Omit' but it's counter-intuitive to have to flag the entries that you want to to omit; this field will be eliminated in the future).

Note: in previous versions of this script, unknown codes that were not clearly similar to other taxa were omitted.  However, this eliminates the cover associated with those taxa which in a few cases is sizable.  As of the January 31, 2022 data release, I now assign these unnknown codes to the taxon within that plant family that was most abundant at that site in the year(s) when the unknown was recorded - the rationale being that this will still permit correct calculations of total abundance but that the addition of these unknowns to already-dominant taxa will have relatively small effects of dissimilarity among plots.  These changes are explained in the 'Notes' field.

The script workflow is as follows:
- Drop non-vascular plants (mosses, lichens, fungi).
- Merge original data file with set of adjustments.
- If a given taxon at a given site has a recommended adjustment, the name in the 'Taxon' field is replaced with that in the 'NewTaxon' field.  In a few cases the recommended 'NewTaxon' is in a different plant family; in this case, the entry in the 'Family' field is also replaced with that in the 'NewFamily' field.  Taxa without recommended adjustments are unchanged.
- Drop records in which the Taxon has not been assigned to a plant family.  This includes all substrates (non-living).
- Recalculate the cover of each taxon in each plot-year so that multiple entires of a taxon are replaced by a single entry consisting of the summed cover of all entries assigned to it.

The CSV file of taxonomic adjustments is specific to a data release and therefore needs to be updated each time a new file of cover data is released.  The release date is indicated at the end of the file name (YYMMDD).  For example, the file 'taxonomic-adjustments-2022-01-31.csv' is for the current file released on **January 31, 2022**.

**Please reach out to Jon Bakker (jbakker@uw.edu) if you have issues with this code or feel other/different taxonomic adjustments are warranted.**
