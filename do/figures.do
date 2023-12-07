// Fact #1: Kenya

// Figure 1 -- "most health facilities are in competitive markets"

  use "${git}/constructed/kenya-facilities-markets.dta" , clear

    replace market_n = 10 if market_n > 10 //Set 10 as ceiling

    tw ///
      (histogram market_n ///
        , discrete lw(none) fc(black%80) barwidth(0.6) ) /// size of markets
      (histogram market_n if market_tag==1 ///
        , discrete lw(none) fc(black%30) barwidth(0.9)) /// size of markets
    , legend(on region(lp(blank) fc(none)) ring(0) pos(1) order(2 "Share of Markets" 1 "Share of Facilities") symxsize(small)) ///
      xlab(1 2 3 4 5 6 7 8 9 10 "10+" , notick) xtit("...X Total Health Facilities") ///
      ytit("Percentage of Markets/Facilities Facing...") yscale(noline) ylab(0 "0%" .25 "25%" .5 "50%" , notick) yline(.25 .5 , lc(black))

    graph export "${git}/outputs/kenya-facilities-markets.png" , replace


// Figure 2 -- "most people are served by competitive markets"

  use "${git}/constructed/kenya-locations-markets.dta" , clear

    tw ///
      (histogram market_n [fweight=TOTALPOP] ///
        , discrete lw(none) fc(black%80) barwidth(0.6) ) /// size of markets
      (histogram market_n  ///
        , discrete lw(none) fc(black%30) barwidth(0.9)) /// size of markets
    , legend(on region(lp(blank) fc(none)) ring(0) pos(1) order(2 "Share of Locations" 1 "Share of Population") symxsize(small)) ///
      xlab(0 1 2 3 4 5 6 7 8 9 10 "10+" , notick) xtit("...A Largest Available Market with X Total Health Facilities") ///
      ytit("Percentage of Locations/Population Facing...") yscale(noline) ylab(0 "0%" .25 "25%" .5 "50%" , notick) yline(.25 .5 , lc(black))

    graph export "${git}/outputs/kenya-locations-markets.png" , replace

  use  "${git}/data/kenya-facilities-comparison.dta", clear

    tw ///
      (histogram market_kepsie  [fweight=TOTALPOP] ///
        , discrete lw(none) fc(black%80) barwidth(0.6) ) /// size of markets
      (histogram market_n [fweight=TOTALPOP]  ///
        , discrete lw(none) fc(black%30) barwidth(0.9)) /// size of markets
    , legend(on region(lp(blank) fc(none)) ring(0) pos(1) order(2 "Administrative Data" 1 "Facility Survey") symxsize(small)) ///
      xlab(0 1 2 3 4 5 6 7 8 9 10 "10+" , notick) xtit("...A Largest Available Market with X Total Health Facilities") ///
      ytit("Percentage of Population Facing...") yscale(noline) ylab(0 "0%" .25 "25%" .5 "50%" , notick) yline(.25 .5 , lc(black))

    graph export "${git}/outputs/kenya-locations-markets-kepsie.png" , replace


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
