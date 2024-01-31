// Get primary data for this project
clear all

// Fact 1: Facilities and markets competition

  // Facilities in markets
  use "${box}/data/Kenya/Constructed/Facilities.dta" , clear

  keep lat lon county market market_tag

    save "${git}/data/kenya-facilities-markets.dta" , replace

  // Locations shapefiles
  use "${box}/data/Kenya/Data/GIS/Locations_shp.dta" , clear
    save "${git}/data/kenya-locations-shp.dta" , replace

  use "${box}/data/Kenya/Data/GIS/Locations_dbf.dta" , clear
    save "${git}/data/kenya-locations-dbf.dta" , replace

  use "${box}/data/Kenya/Data/GIS/Kenya_County_shp.dta" , clear
	save "${git}/data/kenya-county-shp.dta", replace

  /* Facilities in markets (Kepsie)
  use "${box}/data/Kenya/data/raw/kepsie-facilities.dta" , clear
  isid hfid_m , sort
  set seed 12345
  zcenter , id(hfid_m) x(longitude) y(latitude) maxdistance(4) gen(market) latlon
  geoinpoly latitude longitude using "${git}/constructed/kenya-locations-shp.dta" // Map geographic locations (facilities) to shapefile polygons (locations
    lab var _ID "SHP ID for Location" // No missing values for ID; i.e. all facilities were matched with a location polygen from the shp

  save "${git}/data/kenya-facilities-kepsie.dta" , replace
  */

// Fact 2: Standardized Patient lit review
clear all
import excel using "${box}/data/SP_Summary.xlsx", firstrow sheet("For plotting")
save "${git}/data/SP_summary.dta", replace

// Fact 3: Qualifications and quality

  use "${box}/data/SDI/knowledge.dta" , clear

  save "${git}/data/sdi-irt.dta", replace

// Fact 5: Antibiotics

  use "${box}/data/SPs/SP Interactions.dta"
    keep facility_type study case uniqueid
  save "${git}/data/sp-all.dta", replace

  use "${box}/data/SPs/SP Medications.dta"
  save "${git}/data/sp-med.dta", replace

// Fact 7: Caseloads

  use "${box}/data/SDI/capacity.dta" , clear

  save "${git}/data/sdi-cap.dta", replace

// End
