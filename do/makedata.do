// Build the analytical datasets

// Kenya locations shapefiles
use "${git}/data/kenya-locations-shp.dta" , clear
  save "${git}/constructed/kenya-locations-shp.dta" , replace

use "${git}/data/kenya-locations-dbf.dta" , clear
  ren id _ID
  save "${git}/constructed/kenya-locations-dbf.dta" , replace

// Kenya markets and facilities
use "${git}/data/kenya-facilities-markets.dta" , clear

  bys county market : gen market_n = _N
    lab var market_n "Facilities in Market"

  save "${git}/constructed/kenya-facilities-markets.dta" , replace

// Kenya location market exposures
use "${git}/data/kenya-facilities-markets.dta" , clear

  bys county market : gen market_n = _N
    lab var market_n "Facilities in Market"

  geoinpoly lat lon using "${git}/constructed/kenya-locations-shp.dta"
    lab var _ID "SHP ID for Location"

  egen loc_ex_tag = tag(_ID market)
    keep if loc_ex_tag == 1

  merge m:1 _ID using "${git}/constructed/kenya-locations-dbf.dta" ///
    , keepusing(TOTALPOP)

  save "${git}/constructed/kenya-locations-markets.dta" , replace

//
