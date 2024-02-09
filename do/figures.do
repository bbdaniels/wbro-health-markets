// Fact #1: Kenya

// Fact 1 -- "most health care is in competitive markets"

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

    graph export "${box}/outputs/kenya-facilities-markets.png" , replace

  use "${git}/constructed/kenya-locations-markets.dta" , clear

    tw ///
      (histogram market_n [fweight=TOTALPOP] ///
        , discrete lw(none) fc(black%80) barwidth(0.6) ) /// size of markets
      (histogram market_n  ///
        , discrete lw(none) fc(black%30) barwidth(0.9)) /// size of markets
    , legend(on region(lp(blank) fc(none)) ring(0) pos(1) order(2 "Share of Locations" 1 "Share of Population") symxsize(small)) ///
      xlab(0 1 2 3 4 5 6 7 8 9 10 "10+" , notick) xtit("...A Largest Available Market with X Total Health Facilities") ///
      ytit("Percentage of Locations/Population Facing...") yscale(noline) ylab(0 "0%" .25 "25%" .5 "50%" , notick) yline(.25 .5 , lc(black))

    graph export "${box}/outputs/kenya-locations-markets.png" , replace

  use  "${git}/data/kenya-facilities-comparison.dta", clear

    tw ///
      (histogram market_kepsie  [fweight=TOTALPOP] ///
        , discrete lw(none) fc(black%80) barwidth(0.6) ) /// size of markets
      (histogram market_n [fweight=TOTALPOP]  ///
        , discrete lw(none) fc(black%30) barwidth(0.9)) /// size of markets
    , legend(on region(lp(blank) fc(none)) ring(0) pos(1) order(2 "Administrative Data" 1 "Facility Survey") symxsize(small)) ///
      xlab(0 1 2 3 4 5 6 7 8 9 10 "10+" , notick) xtit("...A Largest Available Market with X Total Health Facilities") ///
      ytit("Percentage of Population Facing...") yscale(noline) ylab(0 "0%" .25 "25%" .5 "50%" , notick) yline(.25 .5 , lc(black))

    graph export "${box}/outputs/kenya-locations-markets-kepsie.png" , replace


// Fact 3: Qualifications and Quality

  use "${git}/constructed/sdi-irt.dta" , clear

  replace t_hat = 0 if t_hat < 0

  graph hbox t_hat [pweight = weight], over(c , sort(1) descending) noout ///
    box(1 , lc(gray) fc(none)) note(" ") ytit("Expected Correct Treatment Frequency") ///
    ylab(0 "0%" 25 "25%" 50 "50%" 75 "75%" 100 "100%") medline(lc(black) lw(thick)) medtype(cline)

  graph export "${box}/outputs/sdi-qualifications.png" , replace

// Fact 3

  use "${git}/constructed/irving.dta" , clear
  append using "${git}/constructed/sps.dta"

  graph hbar duration ///
  , over(country, sort(1))  over(method) nofill scale(0.7) ///
    note("INRUD = International Network for the Rational Use of Drugs") ///
    ytit("") ylab(0 "Consultation Duration {&rarr}" 5 "Five Minutes" 10 "Ten Minutes") ///
    xoverhang blab(bar) bar(1,fc(black))


  local nb=`.Graph.plotregion1.barlabels.arrnels'
      forval i=1/`nb' {
      .Graph.plotregion1.barlabels[`i'].text[1] = "`: di %2.1f `.Graph.plotregion1.barlabels[`i'].text[1]''"
      .Graph.plotregion1.barlabels[`i'].text[1]="`.Graph.plotregion1.barlabels[`i'].text[1]' min"
      }
      .Graph.drawgraph

      graph export "${box}/outputs/duration.png" , replace


// Fact 5

  use "${git}/constructed/antibiotics.dta" , clear

    replace Prevalence = Prevalence * 100
    graph hbar Prevalence ///
    , over(Country , sort(1)) over(Denominator) nofill ///
      ylab(0 "0%" 25 "25%" 50 "50%" 75 "75%" 100 "100%") ///
      bar(1, fc(black)) ytit("Share of Antibiotics") ///
      blab(bar) ysize(6) scale(0.7)

      local nb=`.Graph.plotregion1.barlabels.arrnels'
      forval i=1/`nb' {
      .Graph.plotregion1.barlabels[`i'].text[1] = "`: di %2.0f `.Graph.plotregion1.barlabels[`i'].text[1]''"
      .Graph.plotregion1.barlabels[`i'].text[1]="`.Graph.plotregion1.barlabels[`i'].text[1]'%"
      }
      .Graph.drawgraph

      graph export "${box}/outputs/antibiotics.png" , replace


  use "${git}/constructed/sp-med.dta" , clear

  replace med_antibiotic = med_antibiotic * 100
  replace med_unlabelled = med_unlabelled * 100

    graph hbar med_antibiotic med_unlabelled ///
      , over(f) nofill ///
        legend(on order(1 "Antibiotics" 2 "Unlabelled")) ///
        ylab(0 "0%" 25 "25%" 50 "50%" 75 "75%" 100 "100%") ///
        bargap(10) bar(1, fc(black)) bar(2, fc(maroon)) ///
        blab(bar) ysize(6) scale(0.6)

      local nb=`.Graph.plotregion1.barlabels.arrnels'
      forval i=1/`nb' {
      .Graph.plotregion1.barlabels[`i'].text[1] = "`: di %2.0f `.Graph.plotregion1.barlabels[`i'].text[1]''"
      .Graph.plotregion1.barlabels[`i'].text[1]="`.Graph.plotregion1.barlabels[`i'].text[1]'%"
      }
      .Graph.drawgraph

    graph export "${box}/outputs/sps-meds.png" , replace

// Fact 7: Caseloads

  use "${git}/constructed/po-vietnam.dta" , clear

    tw (scatter po_timeperpatient n , m(Oh) mlc(black) mfc(none) mlw(thin)) ///
       (function 60/x , range(2.5 100) lc(gs14)) ///
       (function 120/x , range(5 100) lc(gs10)) ///
       (function 240/x , range(10 100) lc(gs6)) ///
       (function 480/x , range(20 100) lc(gs2)) ///
     , yscale(log) xscale(log) title("Working Days in Vietnam") ///
      ylab(5 "5 Minutes" 15 "15 Minutes" 45 `""45 Minutes" "Per Patient""') ///
      xlab(1 "One Patient Per Day" 10 "Ten Patients" 100 "100 Patients") ///
      legend(on order(0 "Total:" 2 "One Hour" 3 "Two Hours" 4 "Four Hours" 5 "Eight Hours") ///
            symxsize(small) size(small) r(1) ring(0) pos(11))

      graph export "${box}/outputs/vietnam-times.png" , replace

  use "${git}/constructed/sp-all.dta" , clear

    replace patients_arrive = 5 if patients_arrive > 5 & patients_arrive != .
    replace study = "Urban India" if strpos(study,"Qutub")
    replace study = "Rural India" if strpos(study,"Maqari")

    lab def p 0 "No Queue" 5 "Queue 5+"
    lab val patients_arrive p

    bys study: gen w = 100/_N
    graph hbar (sum) w ///
    , over(patients_arrive) over(study) ///
      ylab(0 "0%" 25 "25%" 50 "50%" 75 "75%" 100 "100%") ///
      xoverhang blab(bar) bar(1,fc(black)) ytit("") title("Patients in Queue when SP Arrives")


    local nb=`.Graph.plotregion1.barlabels.arrnels'
    forval i=1/`nb' {
    .Graph.plotregion1.barlabels[`i'].text[1] = "`: di %2.0f `.Graph.plotregion1.barlabels[`i'].text[1]''"
    .Graph.plotregion1.barlabels[`i'].text[1]="`.Graph.plotregion1.barlabels[`i'].text[1]'%"
    }
    .Graph.drawgraph

    graph export "${box}/outputs/sp-queue.png" , replace


  use "${git}/constructed/sdi-cap.dta" , clear
    gen pro = hf_outpatient / (60 * hf_staff_op)
    gen fac = hf_outpatient / 60
    gen op = hf_staff_op
    replace op = 6 if op > 5
      drop if op == 0

      lab def op  6 "6+"
      lab val op op

    bys country : gen weight = 1/_N

    graph box pro [pweight=weight], ///
      over(public) over(op)  noout asy ///
      legend(on pos(12) ring(0)) medline(lc(black) lw(thick)) medtype(cline)   ///
      box(1, fc(none) lc(gray)) box(2, fc(none) lc(gs12)) ///
      ytit("Patients per Provider Day") note("Providers at Clinic {&rarr}")

      graph export "${box}/outputs/sdi-caseloads.png" , replace

// Facct 8: public sector

use "${git}/constructed/sdi-irt.dta" , clear

  replace t_hat = 0 if t_hat < 0

  drop if country == "Guinea Bissau"

  graph hbox t_hat ///
    , over(public) over(facility_level) over(country , sort(2) descending) ///
      box(1, fc(none) lc(gray)) box(2, fc(none) lc(gs12)) ///
      note(" ") ytit("Expected Correct Treatment Frequency") ///
      noout scale(0.5) ylab(0 "0%" 25 "25%" 50 "50%" 75 "75%" 100 "100%") ///
      legend(on pos(11) ring(0) c(1)) medline(lc(black) lw(thick)) medtype(cline)

      graph export "${box}/outputs/sdi-pubpri.png" , replace

// End
