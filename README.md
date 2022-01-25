# NutNet_TaxonomicAdjustments
Taxonomic adjustments for NutNet compositional data to ensure consistent naming over time.  Note that this script does **not** consider taxonomic consistency among sites.

Taxonomic adjustments have been considered for all sites with at least 4 years of data.  In the current data release, this is **74 sites**.

Taxonomic adjustments can be necessary for many reasons, including:
- Taxonomic imprecision. Examples:
  -  Taxa that are distinguished in some years but lumped as a single genus in other years
  -  A taxon that is reported as a species in some years but as a subspecies or variety in other years
- Taxonomic errors. Taxonomic names change over time, and sometimes the same taxa is recorded by different names in different years. 
- Identification issues. A species that is regularly widespread but is missing in a single year may reflect its misidentification as another taxon.

Adjustments were identified by comparing species lists over time, both for a site as  whole and for individual plots within it.  The spplist() function provides one simple way to compare species lists for a site.

The CSV file contains a table of all recommended changes along with other notes about composition on a site-by-site basis.  For a given site, the recommended change is to replace names in the 'Taxon' field with those in the 'NewTaxon' field.  Reasons for these changes are (sometimes) provided in the 'Notes' field.  The 'Omit' field is a flag that can be used to exclude a particular adjustment.  Sites that do not have any adjustments are also identified in the 'Notes' field and excluded from adjustments. 

The CSV file is specific to a data release and needs to be updated each time a new file of cover data is released.  The release date is indicated at the end of the file name (YYMMDD).  For example, the file ending 211018 is for the current file released on **October 18, 2021**.

The script workflow is as follows:
- Drop non-vascular plants (mosses, lichens, fungi).
- Drop records in which the Taxon has not been assigned to a plant family.  This includes all substrates (non-living).
- Work through the datafile one site at a time, making all adjustments as recorded in the CSV file (i.e., all records with 'Omit' == "No").
- Drop unknown taxa that that were not clearly similar to other taxa.
- Recalculate the cover of each taxon in each plot-year so that multiple entires of a taxon are replaced by a single entry with the summed cover of all entries assigned to it.
