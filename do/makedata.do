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

    // Find exact corresponding numbers from graph 
	tab market_n // 1st row (freq): 17.58% ~= 17.6% of facilities are located in markets with only 1 facility 
				 // 9th row (cumulative): 69.92% ~= 69.9% of facilities are located in markets with <=9 facilities; thus by corollary, 100-69.9 = 30.1% of facilities are located in markets with >=10 facilities. 
	tab market_n if market_tag==1 // 1st row (freq): At market level, 50.75% ~= 50.8% of markets only have 1 facility in them (singletons markets) 

  
  
// Kenya location market exposures
use "${git}/data/kenya-facilities-markets.dta" , clear

  bys county market : gen market_n = _N
    lab var market_n "Facilities in Market"

  geoinpoly lat lon using "${git}/constructed/kenya-locations-shp.dta" // Map geographic locations (facilities) to shapefile polygons (locations
    lab var _ID "SHP ID for Location" // No missing values for ID; i.e. all facilities were matched with a location polygen from the shp

  egen loc_ex_tag = tag(_ID market)
    keep if loc_ex_tag == 1 // 4177 location-market observations at end of this line

  merge m:1 _ID using "${git}/constructed/kenya-locations-dbf.dta" /// Match to get population by location: 100% of master observations matched; 355 observations not matched from dbf (i.e. counties with 0 markets)
    , keepusing(TOTALPOP) // 4532 observations at end of this line; 


  save "${git}/constructed/kenya-locations-markets.dta" , replace

//
