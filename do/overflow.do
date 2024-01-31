// Figure 3 (map): Most of the population has access to (i.e. resides in locations with) competitive markets
    // Map population density by location (colors) with

  use "${git}/constructed/kenya-locations-markets.dta" , clear // 4532 observations left

	  *Create map using county shp
    label define market_n 0 "0 facilities" 1 "1 facility" 2 "2 facilities" 3 "3 facilities" 4 "4 facilites" 5 "5 facilities" 6 "6 facilities" 7 "7 facilities" 8 "8 facilities" 9 "9 facilities" 10 "10+ facilities"
    label values market_n market_n

    spmap market_n using "${git}/data/kenya-locations-shp.dta", clmethod(unique) ndlabel("no values") id(_ID) fcolor(Blues2) ///
    polygon(data("${git}/data/kenya-county-shp.dta")) ///
    title("Largest Available Market with X Total Facilities", c(black) span)

		graph export "${git}/outputs/kenya_map_largest-market-size.png", replace width(5000)

// Fact #2: Quality of Care is Poor
use "${git}/constructed/SP_summary.dta" , clear

graph hbar CorrectCaseManagement, over(PaperDisease) ///
    ytitle("Proportion Receiving Correct Case Management (%)") ///
    title("Proportion of SP's Receiving Correct Case Management in SP Studies") ///
    ylabel(0 20 40 60 80 100) ///
    bar(1, color(red))  // You can customize the color if needed

graph export "${git}/outputs/SP_summary.png" , replace width(1800) height(600)
