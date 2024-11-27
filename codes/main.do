


* Aggregate data
use ".../data/euroarea_gdp_8_3.dta", clear
rename qdate dateq
merge m:1 dateq using ".../data/shocks.dta", nogen keep(1 3)

replace mp_pm_mpd = mp_pm_mpd/100
keep if geo == "EA20"

drop if dateq > tq(2019, q4)


gen tot_gdp = real_gdp_services + real_gdp_manu + real_gdp_other

tsset dateq
    forvalues i = 0/20 {
	gen cumF`i'real_gdp_services = (F`i'.real_gdp_services-L.real_gdp_services)/L.real_gdp_services
	gen cumF`i'real_gdp_manu     = (F`i'.real_gdp_manu-L.real_gdp_manu)/L.real_gdp_manu
	gen cumF`i'real_gdp_other    = (F`i'.real_gdp_other-L.real_gdp_other)/L.real_gdp_other
	gen cumF`i'tot_gdp           = (F`i'.tot_gdp-L.tot_gdp)/L.tot_gdp
	gen cumF`i'unemp             = (F`i'.unemp-L.unemp)
}


gen dummy_crises = 0
replace dummy_crises = 1 if dateq > tq(2007, q3)  & dateq < tq(2009, q4)
replace dummy_crises = 1 if dateq >= tq(2001, q1) & dateq <= tq(2001, q4)



gen pos_shock = mp_pm_mpd*(mp_pm_mpd > 0) 
gen neg_shock = mp_pm_mpd*(mp_pm_mpd < 0) 


forvalues i = 1/12 {
	
foreach varr in cumF0tot_gdp unemp inflation cumF0real_gdp_services cumF0real_gdp_manu mp_pm_mpd pos_shock neg_shock { 
gen L`i'`varr' = L`i'.`varr'

}
}


keep if geo == "EA20"
tsset dateq

drop if dateq < tq(1999, q1)
drop if dateq > tq(2019, q1)

	 forvalues lead = 0/12 {
newey cumF`lead'tot_gdp i.quarter i.dummy_crises L1cumF0tot_gdp L2cumF0tot_gdp L1mp_pm_mpd L2mp_pm_mpd L3mp_pm_mpd L4mp_pm_mpd L5mp_pm_mpd L6mp_pm_mpd L7mp_pm_mpd L8mp_pm_mpd mp_pm_mpd, lag(2) force
quietly est sto m`lead'
	 }

	esttab m0 m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 ///
using ".../estimation/figure2_all.csv", replace plain ///
cells(b(label("beta_h")) se) ///
keep(mp_pm_mpd) ///
se noobs nomtitles compress collabels(, none)





 forvalues lead = 0/20 {
newey cumF`lead'real_gdp_services i.quarter i.dummy_crises L1unemp L1inflation L1mp_pm_mpd L2mp_pm_mpd L3mp_pm_mpd L4mp_pm_mpd L5mp_pm_mpd L6mp_pm_mpd L7mp_pm_mpd L8mp_pm_mpd mp_pm_mpd L1cumF0real_gdp_services L2cumF0real_gdp_services, lag(2) force
quietly est sto m`lead'
	 }
	 
			esttab m0 m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 ///
using ".../estimation/figure2_serv.csv", replace plain ///
cells(b(label("beta_h")) se) ///
keep(mp_pm_mpd) ///
se noobs nomtitles compress collabels(, none)




	 forvalues lead = 0/20 {
newey cumF`lead'real_gdp_manu i.quarter i.dummy_crises L1unemp L1inflation L1mp_pm_mpd L2mp_pm_mpd L3mp_pm_mpd L4mp_pm_mpd L5mp_pm_mpd L6mp_pm_mpd L7mp_pm_mpd L8mp_pm_mpd mp_pm_mpd L1cumF0real_gdp_manu L2cumF0real_gdp_manu, lag(2) force
quietly est sto m`lead'
	 }
	 
			esttab m0 m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 ///
using ".../estimation/figure2_manuf.csv", replace plain ///
cells(b(label("beta_h")) se) ///
keep(mp_pm_mpd) ///
se noobs nomtitles compress collabels(, none)





* Import data
use "/Users/ruslanadatsenko/Documents/GitHub/industry_mp_europe/empirical_results/data/euroarea_gdp_8_3.dta", clear
rename qdate dateq
merge m:1 dateq using "/Users/ruslanadatsenko/Documents/GitHub/industry_mp_europe/empirical_results/data/shocks2.dta", nogen keep(1 3)


drop if geo == "EA"
drop if geo == "EA20"
drop if geo == "EA10"
drop if geo == "EA11"
drop if dateq < tq(1999, q1)
drop if dateq > tq(2019, q4)

replace mp_pm_mpd = mp_pm_mpd/100


gen tot_gdp = real_gdp_services + real_gdp_manu + real_gdp_other

xtset geo1 dateq
    forvalues i = 0/20 {
	gen cumF`i'real_gdp_services = (F`i'.real_gdp_services-L.real_gdp_services)/L.real_gdp_services
	gen cumF`i'real_gdp_manu     = (F`i'.real_gdp_manu-L.real_gdp_manu)/L.real_gdp_manu
	gen cumF`i'real_gdp_other    = (F`i'.real_gdp_other-L.real_gdp_other)/L.real_gdp_other
	gen cumF`i'tot_gdp           = (F`i'.tot_gdp-L.tot_gdp)/L.tot_gdp
	gen cumF`i'unemp             = (F`i'.unemp-L.unemp)
}


gen pos_shock = mp_pm_mpd*(mp_pm_mpd > 0) 
gen neg_shock = mp_pm_mpd*(mp_pm_mpd < 0) 

su pos_shock if mp_pm_mpd > 0
su pos_shock if mp_pm_mpd < 0



forvalues i = 1/8 {
	
foreach varr in cumF0tot_gdp unemp inflation cumF0real_gdp_services cumF0real_gdp_manu mp_pm_mpd mean_inc pos_shock neg_shock { 
gen L`i'`varr' = L`i'.`varr'

}
}



gen dummy_crises = 0
replace dummy_crises = 1 if dateq > tq(2007, q3) & dateq < tq(2009, q4)
replace dummy_crises = 1 if dateq >= tq(2001, q1) & dateq <= tq(2001, q4)


egen  newid3 = group(geo1)
su    newid3

egen time = group(dateq)
bys newid3: egen min_time = min(time)

gen coeff = .
gen coeff2 = .



xtset newid3 dateq
forvalues country = 1/20{ 
	 forvalues lead = 0/10 {	
newey cumF`lead'tot_gdp i.quarter i.dummy_crises L1unemp L1inflation L1mean_inc L1mp_pm_mpd L2mp_pm_mpd L3mp_pm_mpd L4mp_pm_mpd L5mp_pm_mpd L6mp_pm_mpd L7mp_pm_mpd L8mp_pm_mpd mp_pm_mpd L1cumF0tot_gdp L2cumF0tot_gdp if newid3 == `country', lag(2) force
	replace coeff = _b[mp_pm_mpd] if (newid3 == `country' & time == 1 + `lead')
	disp(`country')
	}
}


xtset newid3 dateq
forvalues country = 1/20{ 
	 forvalues lead = 0/10 {	
newey cumF`lead'tot_gdp i.quarter i.dummy_crises L1unemp L1inflation L1mean_inc L1mp_pm_mpd L2mp_pm_mpd L3mp_pm_mpd L4mp_pm_mpd L5mp_pm_mpd L6mp_pm_mpd L7mp_pm_mpd L8mp_pm_mpd neg_shock L1cumF0tot_gdp L2cumF0tot_gdp if newid3 == `country', lag(2) force
	replace coeff2 = _b[neg_shock] if (newid3 == `country' & time == 1 + `lead')
	disp(`country')
	}
}



replace geo = "AU"  if geo == "AT"
replace geo = "CW"  if geo == "HR"
replace geo = "CP"  if geo == "CY"
replace geo = "EO"  if geo == "EE"
replace geo = "FN"  if geo == "FI"
replace geo = "GE"  if geo == "DE"
replace geo = "GR"  if geo == "EL" 
replace geo = "IR"  if geo == "IE" 
replace geo = "LN"  if geo == "LT"
replace geo = "MLT" if geo == "MT"
replace geo = "NE"  if geo == "NL"
replace geo = "PO"  if geo == "PT"
replace geo = "VS"  if geo == "SI"
replace geo = "SP"  if geo == "ES"


gen sign_neg_shock = -coeff2


egen sum_gdp                      = sum(tot_gdp)
bys geo: egen sum_gdp2            = sum(tot_gdp)
bys geo: egen mean_manuf          = mean(share_real_gdp_manu)
bys geo: egen mean_service_privat = mean(share_real_gdp_services)
bys geo: egen mean_coef           = mean(coeff)
bys geo: egen mean_coef2          = mean(sign_neg_shock)


keep dateq year geo mean_coef mean_manuf mean_service_privat mean_coef2 share_real_gdp_manu share_real_gdp_services time

keep if year == 2019


bys geo: egen mean_manuf_2019          = mean(share_real_gdp_manu)
bys geo: egen mean_service_privat_2019 = mean(share_real_gdp_services)

generate pos = 9
replace pos  = 6  if geo == "NE"
replace pos  = 12 if geo == "BE"


save ".../data_fed_note.dta", replace

use ".../data_fed_note.dta", clear



graph twoway scatter mean_service_privat_2019 mean_manuf_2019, mlabel(geo) mlabv(pos) ytitle("Average service industry value added share") xtitle("Average manufacturing industry value added share") legend(off) graphregion(color(white)) bgcolor(white) ylab(, nogrid) ysize(3.5) xsize(5) 



graph twoway scatter mean_coef mean_manuf, mlabel(geo) ytitle("Average of estimated coefficient") xtitle("Average manufacturing industry value added share") || lfit mean_coef mean_manuf, legend(off) graphregion(color(white)) bgcolor(white) ylab(, nogrid) ysize(3.5) xsize(5) 



graph twoway scatter mean_coef mean_service_privat, mlabel(geo) ytitle("Average of estimated coefficient") xtitle("Average service industry value added share") || lfit mean_coef mean_service_privat, legend(off) graphregion(color(white)) bgcolor(white) ylab(, nogrid) ysize(3.5) xsize(5)



graph twoway scatter mean_coef2 mean_manuf, mlabel(geo) ytitle("Average of estimated coefficient") xtitle("Average manufacturing industry value added share") || lfit mean_coef2 mean_manuf, legend(off) graphregion(color(white)) bgcolor(white) ylab(, nogrid) ysize(3.5) xsize(5)



graph twoway scatter mean_coef2 mean_service_privat, mlabel(geo) ytitle("Average of estimated coefficient") xtitle("Average service industry value added share") || lfit mean_coef2 mean_service_privat, legend(off) graphregion(color(white)) bgcolor(white) ylab(, nogrid) ysize(3.5) xsize(5)








