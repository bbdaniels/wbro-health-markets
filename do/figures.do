//

// Figure 1 -- "most health facilities are in competitive markets"

  use "${git}/constructed/kenya-facilities-markets.dta" , clear

    replace market_n = 10 if market_n > 10 //Set 10 as ceiling

    tw ///
      (histogram market_n ///
        , discrete lw(none) fc(red%80) barwidth(0.8) ) /// size of markets
      (histogram market_n if market_tag==1 ///
        , discrete lw(none) fc(black%20) barwidth(0.9)) /// size of markets
    , legend(on pos(12) order(2 "Share of Markets with..." 1 "Share of Facilities in Markets with...") symxsize(small)) ///
      xlab(1 2 3 4 5 6 7 8 9 10 "10+" , notick) xtit("...X Total Health Facilities") ///
      ytit("") yscale(noline) ylab(0 "0%" .25 "25%" .5 "50%" , notick) yline(.25 .5 , lc(black))

    graph export "${git}/outputs/kenya-facilities-markets.png" , replace

	
// Figure 2 -- "most people are served by competitive markets"

  use "${git}/constructed/kenya-locations-markets.dta" , clear
 
    // Keep only the largest market within each location 
    gsort _ID -market_n
      bys _ID : gen temp = _n
      keep if temp == 1
      drop temp
    replace market_n = 0 if missing(market_n) // Locations with 0 markets in them; 2433 locations remaining 

      replace market_n = 10 if market_n > 10 // Cap markets with more than 10 facilities to 10 for subsequent visualization 

	  tab market_n // Get location-level proportions (frequencies): 1st row: 14.59~=14.6% of locations have their largest market containing 0 facilities, i.e. don't have markets 

	  tab market_n [fweight = TOTALPOP] // Get population-weighted proportions: 1st row (frequency): 7.08~=7.1% of population live in empty cells 
	  // 2nd row (cumulative): 18.98~=19.0% of population live in locations without competitive markets, while 81.0% of population live in locations with (at least one) competitive market
	  // 10th row (frequency): 23.0% of population live in locations with "very" competitive markets (at least 10 facilities)
	
	  
      tw /// 
        (histogram market_n [fweight=TOTALPOP] ///
          , discrete lw(none) fc(red%80) barwidth(0.8) ) /// size of markets
        (histogram market_n  ///
          , discrete lw(none) fc(black%20) barwidth(0.9)) /// size of markets
      , legend(on pos(12) order(2 "Share of Locations with..." 1 "Share of Population in Locations with...") symxsize(small)) ///
        xlab(0 1 2 3 4 5 6 7 8 9 10 "10+" , notick) xtit("...A Largest Available Market with X Total Health Facilities") ///
        ytit("") yscale(noline) ylab(0 "0%" .25 "25%" .5 "50%" , notick) yline(.25 .5 , lc(black))

    graph export "${git}/outputs/kenya-locations-markets.png" , replace


// Figure 3 (map): Most of the population has access to (i.e. resides in locations with) competitive markets 
    // Map population density by location (colors) with 
	
  use "${git}/constructed/kenya-locations-markets.dta" , clear // 4532 observations left
  
   // Keep only the largest market within each location 
    gsort _ID -market_n
      bys _ID : gen temp = _n
      keep if temp == 1
      drop temp
    replace market_n = 0 if missing(market_n) // Locations with 0 markets in them; 2433 locations remaining 

      replace market_n = 10 if market_n > 10 // Cap markets with more than 10 facilities to 10 for subsequent visualization 
	  
	  *Create map using county shp
label define market_n 0 "0 facilities" 1 "1 facility" 2 "2 facilities" 3 "3 facilities" 4 "4 facilites" 5 "5 facilities" 6 "6 facilities" 7 "7 facilities" 8 "8 facilities" 9 "9 facilities" 10 "10+ facilities" 
label values market_n market_n market_n market_n market_n market_n market_n market_n market_n market_n
	
spmap market_n using "${git}/data/kenya-locations-shp.dta", clmethod(unique) ndlabel("no values") id(_ID) fcolor(Blues2) ///
polygon(data("${git}/data/kenya-county-shp.dta")) ///
title("Largest Available Market with X Total Facilities", c(black) span)
		
		graph export "${git}/outputs/kenya_map_largest-market-size.png", replace width(5000)

