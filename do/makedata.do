// Build the analytical datasets

// Kenya locations shapefiles
use "${git}/data/kenya-locations-shp.dta" , clear
  save "${git}/constructed/kenya-locations-shp.dta" , replace

use "${git}/data/kenya-locations-dbf.dta" , clear
  save "${git}/constructed/kenya-locations-dbf.dta" , replace

// Kenya markets and facilities

  use "${git}/data/kenya-facilities-markets.dta" , clear

    geo

  save "${git}/constructed/kenya-facilities-markets.dta" , replace



//
