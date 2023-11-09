
// Get primary data for this project
clear all
// Kenya

  // Facilities in markets
  use "${box}/data/Kenya/Constructed/Facilities.dta" , clear

  keep lat lon county market market_tag

    save "${git}/data/kenya-facilities-markets.dta" , replace

  // Locations shapefiles
  use "${box}/data/Kenya/Data/GIS/Locations_shp.dta" , clear
    save "${git}/data/kenya-locations-shp.dta" , replace

  use "${box}/data/Kenya/Data/GIS/Locations_dbf.dta" , clear
    save "${git}/data/kenya-locations-dbf.dta" , replace

// End
