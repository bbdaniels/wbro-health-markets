// Build the analytical datasets

// Kenya locations shapefiles
use "${git}/data/kenya-locations-shp.dta" , clear
  save "${git}/constructed/kenya-locations-shp.dta" , replace

use "${git}/data/kenya-locations-dbf.dta" , clear
  rename id _ID
  save "${git}/constructed/kenya-locations-dbf.dta" , replace

// Kenya markets and facilities
use "${git}/data/kenya-facilities-markets.dta" , clear

  bys county market : gen market_n = _N
    lab var market_n "Facilities in Market"

  save "${git}/constructed/kenya-facilities-markets.dta" , replace

// Kenya location market exposures (admin)
use "${git}/data/kenya-facilities-markets.dta" , clear

  bys county market : gen market_n = _N
    lab var market_n "Facilities in Market"

  geoinpoly lat lon using "${git}/constructed/kenya-locations-shp.dta" // Map geographic locations (facilities) to shapefile polygons (locations
    lab var _ID "SHP ID for Location" // No missing values for ID; i.e. all facilities were matched with a location polygen from the shp

  egen loc_ex_tag = tag(_ID market)
    keep if loc_ex_tag == 1 // 4177 location-market observations at end of this line

  merge m:1 _ID using "${git}/constructed/kenya-locations-dbf.dta" /// Match to get population by location: 100% of master observations matched; 355 observations not matched from dbf (i.e. counties with 0 markets)
    , keepusing(TOTALPOP) // 4532 observations at end of this line;


  // Keep only the largest market within each location
  gsort _ID -market_n
    bys _ID : gen temp = _n
    keep if temp == 1
    drop temp
  replace market_n = 0 if missing(market_n) // Locations with 0 markets in them; 2433 locations remaining

    replace market_n = 10 if market_n > 10 // Cap markets with more than 10 facilities to 10 for subsequent visualization
    drop _merge
  save "${git}/constructed/kenya-locations-markets.dta" , replace

  // Kenya location market exposures (Kepsie)
  use "${git}/data/kenya-facilities-kepsie.dta", clear

    ren _ID temp

    geoinpoly latitude longitude using "${git}/data/kenya-county-shp.dta" // Map geographic locations (facilities) to shapefile polygons (locations

      drop if _ID == .
      ren _ID county
      ren temp _ID

      bys market : gen market_n = _N
        lab var market_n "Facilities in Market"

        lab var _ID "SHP ID for Location" // No missing values for ID; i.e. all facilities were matched with a location polygen from the shp

      egen loc_ex_tag = tag(_ID market)
        keep if loc_ex_tag == 1 // 4177 location-market observations at end of this line

      merge m:1 _ID using "${git}/constructed/kenya-locations-dbf.dta" /// Match to get population by location: 100% of master observations matched; 355 observations not matched from dbf (i.e. counties with 0 markets)
        , keepusing(TOTALPOP) keep(3) // 4532 observations at end of this line;

      // Keep only the largest market within each location
      gsort _ID -market_n
        bys _ID : gen temp = _n
        keep if temp == 1
        drop temp
      replace market_n = 0 if missing(market_n) // Locations with 0 markets in them; 2433 locations remaining

    ren market_n market_kepsie
    keep market_kepsie _ID

    merge 1:1 _ID using "${git}/constructed/kenya-locations-markets.dta" , keep(3)
    replace market_kepsie = 10 if market_kepsie > 10 // Cap markets with more than 10 facilities to 10 for subsequent visualization

    save "${git}/data/kenya-facilities-comparison.dta", replace

// Fact #2
use "${git}/data/SP_summary.dta" , clear
  save "${git}/constructed/SP_summary.dta" , replace

// End
