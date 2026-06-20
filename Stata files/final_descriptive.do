***Key Metric Trends
** Fundamental quarterly
use "C:\Users\22830043\Downloads\10yearQuarerly.dta", clear
gen year_quarter = yq(fyearq, fqtr)
format year_quarter %tq

* Average Revenue
preserve
collapse (mean) revtq, by(year_quarter)
tsset year_quarter
tsline revtq, title("Average Quarterly Revenue") ytitle("Revenue (revtq) (AUD Millions)") xtitle("Year and Quarter")
graph export "C:\Users\22830043\Downloads\tsline_avg_total_Revenue.png", replace
restore

generate roa = ibq / atq
* Average Assets
preserve
collapse (mean) roa, by(year_quarter)
tsset year_quarter
tsline roa, title("Average Quarterly ROA") ytitle("Return on Assets (roa) (AUD Millions)") xtitle("Year and Quarter")
graph export "C:\Users\22830043\Downloads\tsline_avg_total_roa.png", replace
restore

* Average Long term debt
preserve
generate dlltqOnAtq = dlttq / atq
collapse (mean) dlltqOnAtq, by(year_quarter)
tsset year_quarter
tsline dlltqOnAtq, title("Average Quarterly Long-term-Debt/Assets Ratio") ytitle("Long-Term Debt (dlltqOnAtq) (AUD Millions)") xtitle("Year and Quarter")
graph export "C:\Users\22830043\Downloads\tsline_avg_total_dlltqOnAtq.png", replace
restore

** Security Monthly
use "C:\Users\22830043\Downloads\securityMonthly.dta", clear
gen year_month = ym(year(datadate), month(datadate))
format year_month %tm

* Price Volatility
preserve
gen volatility = prchm - prclm
collapse (mean) volatility, by(year_month)
tsset year_month
tsline volatility, title("Average Monthly Price Volatility") ///
    ytitle("Price Range") xtitle("Year Month") ///
    graphregion(color(white))
graph export "C:\Users\22830043\Downloads\tsline_avg_total_volatility.png", replace
restore

* Trading Volume
preserve
collapse (mean) prccm, by(year_month)
tsset year_month
tsline prccm, title("Average Monthly Trading Volume") ///
    ytitle("Volume (AUD Millions)") xtitle("Year Month") ///
    graphregion(color(white))
graph export "C:\Users\22830043\Downloads\tsline_avg_total_prccm.png", replace
restore


** Comparative Analysis (NEXTDC / Telstra to the industy)
* Fundamental Quarterly
use "C:\Users\22830043\Downloads\10yearQuarerly.dta", clear
gen year_quarter = yq(fyearq, fqtr)
format year_quarter %tq

* Identify NEXTDC and Telstra
gen isFocusCompany = "Industry"
replace isFocusCompany = "NEXTDC" if strpos(conml, "NEXTDC") > 0
replace isFocusCompany = "Telstra" if strpos(conml, "Telstra") > 0

* simple bar chart on assets and revenue
preserve
collapse (mean) atq revtq, by(conml year_quarter)
gen isFocusCompany = "Other"
replace isFocusCompany = "NEXTDC" if strpos(conml, "NEXTDC") > 0
replace isFocusCompany = "Telstra" if strpos(conml, "Telstra") > 0
collapse (sum) atq revtq, by (isFocusCompany)
graph pie atq, over(isFocusCompany) ///
    plabel(_all percent, size(medsmall)) ///
    title("Average Total Assets NEXTDC/Telstra vs Industry")
graph export "C:\Users\22830043\Downloads\pie_nextdc_telstra_atq_atq.png", replace
graph pie revtq, over(isFocusCompany) ///
    plabel(_all percent, size(medsmall)) ///
    title("Average Revenue NEXTDC/Telstra vs Industry")
graph export "C:\Users\22830043\Downloads\pie_nextdc_telstra_atq_revtq.png", replace
restore

* Compare ROA
preserve
generate roa = ibq / atq
keep if isFocusCompany != ""
collapse (mean) roa, by(isFocusCompany year_quarter)
// list isFocusCompany year_quarter atq ceqq dlttq ibq oiadpq revtq oancfy, sepby(isFocusCompany)
twoway ///
    (line roa year_quarter if isFocusCompany=="NEXTDC", lcolor(blue) lwidth(medium) lpattern(solid)) ///
    (line roa year_quarter if isFocusCompany=="Telstra", lcolor(green) lwidth(medium) lpattern(dot)) ///
    (line roa year_quarter if isFocusCompany=="Industry", lcolor(red) lwidth(medium) lpattern(dash)) ///
    , ///
    title("Quarterly Return on Assets: NEXTDC / Telstra vs Industry") ///
    ylabel(, grid) xlabel(, grid) ///
    legend(order(1 "NEXTDC" 2 "Telstra" 3 "Industry") pos(12) ring(0) cols(1))
graph export "C:\Users\22830043\Downloads\twoway_nextdc_telstra_roa.png", replace
restore

* Compare DebtOnAssets
preserve
keep if isFocusCompany != ""
generate dlltqOnAtq = dlttq / atq
collapse (mean) dlltqOnAtq, by(isFocusCompany year_quarter)
twoway ///
    (line dlltqOnAtq year_quarter if isFocusCompany=="NEXTDC", lcolor(blue) lwidth(medium) lpattern(solid)) ///
    (line dlltqOnAtq year_quarter if isFocusCompany=="Telstra", lcolor(green) lwidth(medium) lpattern(dot)) ///
    (line dlltqOnAtq year_quarter if isFocusCompany=="Industry", lcolor(red) lwidth(medium) lpattern(dash)) ///
    , ///
    title("Quarterly Long-term-Debt/Assets Ratio: NEXTDC / Telstra vs Industry") ///
    ylabel(, grid) xlabel(, grid) ///
    legend(order(1 "NEXTDC" 2 "Telstra" 3 "Industry") pos(12) ring(0) cols(1))
graph export "C:\Users\22830043\Downloads\twoway_nextdc_telstra_dlltqOnAtq.png", replace
restore


* Security Monthly
use "C:\Users\22830043\Downloads\securityMonthly.dta", clear
gen year_month = ym(year(datadate), month(datadate))
format year_month %tm

* Identify NEXTDC and Telstra
gen isFocusCompany = "Industry"
replace isFocusCompany = "NEXTDC" if strpos(conm, "NEXTDC") > 0
replace isFocusCompany = "Telstra" if strpos(conm, "TELSTRA") > 0

* Compare volatility
preserve
gen volatility = prchm - prclm
collapse (mean) volatility, by(isFocusCompany year_month)
twoway ///
    (line volatility year_month if isFocusCompany=="NEXTDC", lcolor(blue) lwidth(medium) lpattern(solid)) ///
    (line volatility year_month if isFocusCompany=="Telstra", lcolor(green) lwidth(medium) lpattern(dot)) ///
    (line volatility year_month if isFocusCompany=="Industry", lcolor(red) lwidth(medium) lpattern(dash)) ///
    , ///
    title("Monthly Volatility: NEXTDC / Telstra vs Industry") ///
    ylabel(, grid) xlabel(, grid) ///
    legend(order(1 "NEXTDC" 2 "Telstra" 3 "Industry") pos(12) ring(0) cols(1))
graph export "C:\Users\22830043\Downloads\twoway_nextdc_telstra_Volatility.png", replace
restore

* Compare Trading Volume
preserve
collapse (mean) prccm, by(isFocusCompany year_month)
twoway ///
    (line prccm year_month if isFocusCompany=="NEXTDC", lcolor(blue) lwidth(medium) lpattern(solid)) ///
    (line prccm year_month if isFocusCompany=="Telstra", lcolor(green) lwidth(medium) lpattern(dot)) ///
    (line prccm year_month if isFocusCompany=="Industry", lcolor(red) lwidth(medium) lpattern(dash)) ///
    , ///
    title("Monthly Trading Volume: NEXTDC / Telstra vs Industry") ///
    ylabel(, grid) xlabel(, grid) ///
    legend(order(1 "NEXTDC" 2 "Telstra" 3 "Industry") pos(12) ring(0) cols(1))
graph export "C:\Users\22830043\Downloads\twoway_nextdc_telstra_TradingVolume.png", replace
restore

*** Industry Aggregates 
** Fundamental quarterly
use "C:\Users\22830043\Downloads\10yearQuarerly.dta", clear
gen year_quarter = yq(fyearq, fqtr)
format year_quarter %tq

* Total Revenue
preserve
collapse (sum) revtq, by(year_quarter)
tsset year_quarter
tsline revtq, title("Total Revenue (Quarterly)") ytitle("Revenue (revtq) (AUD Millions)") xtitle("Year and Quarter")
graph export "C:\Users\22830043\Downloads\tsline_sum_total_Revenue.png", replace
restore

* Average Assets
preserve
collapse (sum) ibq, by(year_quarter)
tsset year_quarter
tsline ibq, title("Total Assets (Quarterly)") ytitle("Income (ibq) (AUD Millions)") xtitle("Year and Quarter")
graph export "C:\Users\22830043\Downloads\tsline_sum_total_ibq.png", replace
restore

* Average Long term debt
preserve
collapse (sum) dlttq, by(year_quarter)
tsset year_quarter
tsline dlttq, title("Total Long-term-Debt (Quarterly)") ytitle("Long-Term Debt (dlttq) (AUD Millions)") xtitle("Year and Quarter")
graph export "C:\Users\22830043\Downloads\tsline_sum_total_debt.png", replace
restore


** Security Monthly
use "C:\Users\22830043\Downloads\securityMonthly.dta", clear
gen year_month = ym(year(datadate), month(datadate))
format year_month %tm

* Trading Volume
preserve
collapse (sum) prccm, by(year_month)
tsset year_month
tsline prccm, title("Total Trading Volume (Monthly)") ///
    ytitle("Volume (AUD Millions)") xtitle("Year Month") ///
    graphregion(color(white))
graph export "C:\Users\22830043\Downloads\tsline_total_prccm.png", replace
restore