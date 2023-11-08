//

// Figure 1 -- "most health facilities are in competitive markets"

  use "${git}/constructed/kenya-facilities-markets.dta" , clear

    replace market_n = 10 if market_n > 10

    tw ///
      (histogram market_n ///
        , discrete lw(none) fc(red%80) barwidth(0.8) ) /// size of markets
      (histogram market_n if market_tag==1 ///
        , discrete lw(none) fc(black%20) barwidth(0.9)) /// size of markets
    , legend(on pos(12) order(2 "Share of Markets with..." 1 "Share of Facilities in Markets with...") symxsize(small)) ///
      xlab(1 2 3 4 5 6 7 8 9 10 "10+" , notick) xtit("...X total health facilities") ///
      ytit("") yscale(noline) ylab(0 "0%" .25 "25%" .5 "50%" , notick) yline(.25 .5 , lc(black))

    graph export "${git}/outputs/kenya-facilities-markets.png" , replace

// Figure 2 -- "most people are served by competitive markets"

  use "${git}/constructed/kenya-locations-markets.dta" , clear

    gsort _ID -market_n
      bys _ID : gen temp = _n
      keep if temp == 1
      drop temp
    replace market_n = 0 if missing(market_n)

      replace market_n = 10 if market_n > 10

      tw ///
        (histogram market_n [fweight=TOTALPOP] ///
          , discrete lw(none) fc(red%80) barwidth(0.8) ) /// size of markets
        (histogram market_n  ///
          , discrete lw(none) fc(black%20) barwidth(0.9)) /// size of markets
      , legend(on pos(12) order(2 "Share of Locations with..." 1 "Share of Population in Locations with...") symxsize(small)) ///
        xlab(0 1 2 3 4 5 6 7 8 9 10 "10+" , notick) xtit("...A largest available market of X size") ///
        ytit("") yscale(noline) ylab(0 "0%" .25 "25%" .5 "50%" , notick) yline(.25 .5 , lc(black))

    graph export "${git}/outputs/kenya-locations-markets.png" , replace


//
