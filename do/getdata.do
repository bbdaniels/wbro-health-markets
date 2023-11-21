// Get primary data for this project
clear all

// Fact 1: Kenya

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
// End


// Fact 2: Standardized Patient lit review 
clear all 
import excel using "${box}/data/SP_Summary.xlsx", firstrow sheet("For plotting")
save "${git}/data/SP_summary.dta", replace


