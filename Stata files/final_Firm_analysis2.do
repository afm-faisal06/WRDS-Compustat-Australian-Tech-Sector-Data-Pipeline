**********************************************************************
***                  Financial Ratio Analysis in Stata             ***
***         Comparison: NEXTDC LTD vs TELSTRA GROUP LIMITED        ***
**********************************************************************

*** =============================================================== ***
*** 1. Preliminary Commands
*** =============================================================== ***

* Clear memory and close open files to avoid conflicts
clear all
set more off 

* Set working directory
cd "Downloads" 

* Load dataset
use data_for_firm_analysis2, clear


*** =============================================================== ***
*** 2. Data Preparation
*** =============================================================== ***

* Keep only relevant companies
keep if conm == "NEXTDC LTD" | conm == "TELSTRA GROUP LIMITED"

* Create and label the 'year' variable
gen year = year(datadate)          // Extract numeric year from date
label variable year "Year"


*** =============================================================== ***
*** 3. Liquidity Ratios
*** =============================================================== ***

* Generate Current Ratio
gen cr = act/lct
label variable cr "Current Ratio"

* Plot Current Ratio comparison over time
twoway (line cr year if conm=="TELSTRA GROUP LIMITED", lcolor(blue) lwidth(medthick)) ///
       (line cr year if conm=="NEXTDC LTD", lcolor(red) lwidth(medthick)), ///
       legend(label(1 "TELSTRA LTD") label(2 "NEXTDC LTD")) ///
       title("Current Ratio Comparison Over Time") ///
       ytitle("Current Ratio") ///
       xtitle("Year") ///
       xlabel(2014(1)2025, format(%ty))


*** =============================================================== ***
*** 4. Operating Cashflow to Current Liabilities
*** =============================================================== ***

* Generate Operating Cashflow to Current Liabilities ratio
generate occ = oancf/lct
label variable occ "Operating Cashflow to Current Liabilities"

* Plot comparison
twoway (line occ year if conm=="TELSTRA GROUP LIMITED", lcolor(blue) lwidth(medthick)) ///
       (line occ year if conm=="NEXTDC LTD", lcolor(red) lwidth(medthick)), ///
       legend(label(1 "TELSTRA LTD") label(2 "NEXTDC LTD")) ///
       title("Cashflow to Current Liabilities Comparison Over Time") ///
       ytitle("Cashflow") ///
       xtitle("Year") ///
       xlabel(2014(1)2025, format(%ty))


*** =============================================================== ***
*** 5. Leverage Ratios
*** =============================================================== ***

* Debt-to-Equity Ratio
gen deq = lt/teq
label variable deq "Debt to Equity Ratio"

* Plot Debt-to-Equity ratio comparison
twoway (line deq year if conm=="TELSTRA GROUP LIMITED", lcolor(blue) lwidth(medthick)) ///
       (line deq year if conm=="NEXTDC LTD", lcolor(red) lwidth(medthick)), ///
       legend(label(1 "TELSTRA LTD") label(2 "NEXTDC LTD")) ///
       title("Debt to Equity Ratio Comparison Over Time") ///
       ytitle("Debt-Equity Ratio") ///
       xtitle("Year") ///
       xlabel(2014(1)2025, format(%ty))

* Debt Ratio
gen dr = lt/at
label variable dr "Debt Ratio"

* Comparative Debt Ratio Bar Chart
graph bar (mean) dr, ///
    over(conm, gap(0) relabel(1 "NEXTDC LTD" 2 "TELSTRA GROUP LIMITED")) ///
    over(year, gap(25) label(labsize(small))) ///
    asyvars ///
    bar(1, fcolor(red)   lcolor(black) lwidth(vthin)) ///
    bar(2, fcolor(blue)  lcolor(black) lwidth(vthin)) ///
    blabel(bar, position(outside) format(%4.2f) size(small)) ///
    legend(on order(1 "NEXTDC LTD" 2 "TELSTRA GROUP LIMITED") ///
           position(1) ring(0) cols(1) size(small) region(lstyle(none))) ///
    title("Debt Ratio by Year: NEXTDC vs TELSTRA") ///
    ytitle("Debt Ratio") ///
    note("Year", size(medium) position(6))


*** =============================================================== ***
*** 6. Efficiency Ratios
*** =============================================================== ***

* Sort data for time series calculations
sort conm year

* Generate previous year's total assets
by conm: gen at_prev1 = at[_n-1]

* Compute Average Total Assets
gen avg_total_asset = (at + at_prev) / 2 if year > 2014
label variable avg_total_asset "Average Total Asset between consecutive years"

* Generate Total Asset Turnover (TAT)
gen tat = sale / avg_total_asset
label variable tat "Total Asset Turnover"

* Plot TAT comparison (2015–2024)
twoway (line tat year if conm == "TELSTRA GROUP LIMITED" & inrange(year, 2015, 2024), ///
            lcolor(blue) lwidth(medthick)) ///
       (line tat year if conm == "NEXTDC LTD" & inrange(year, 2015, 2024), ///
            lcolor(red) lwidth(medthick)), ///
       legend(order(1 "TELSTRA GROUP LIMITED" 2 "NEXTDC LTD") ///
              cols(1) position(1) ring(0) size(small)) ///
       title("Total Asset Turnover (2015–2024)") ///
       ytitle("Total Asset Turnover") ///
       xtitle("Year") ///
       xlabel(2015(1)2024, labsize(small)) ///
       scheme(s1color)


*** =============================================================== ***
*** 7. Profitability Ratios
*** =============================================================== ***

* Net Profit Margin (NPM)
gen npm = nicon/sale
label variable npm "Net Profit Margin"

* Plot NPM trend
twoway (line npm year if conm=="NEXTDC LTD", lcolor(red) lwidth(medthick)) ///
       (line npm year if conm=="TELSTRA GROUP LIMITED", lcolor(blue) lwidth(medthick)), ///
       legend(order(1 "NEXTDC LTD" 2 "TELSTRA GROUP LIMITED") cols(2) position(6) ring(0) region(lstyle(none))) ///
       title("Net Profit Margin Over Time") ///
       ytitle("Net Profit Margin") ///
       xtitle("Year") ///
       xlabel(2014(1)2025, labsize(small)) ///
       yline(0, lcolor(black) lpattern(dash)) ///
       scheme(s1color)

* Return on Assets (ROA)
gen roa = nicon/avg_total_asset *100
label variable roa "Return on Assets"

* Plot ROA (2015–2024)
twoway (line roa year if conm == "TELSTRA GROUP LIMITED" & inrange(year, 2015, 2024), ///
            lcolor(blue) lwidth(medthick)) ///
       (line roa year if conm == "NEXTDC LTD" & inrange(year, 2015, 2024), ///
            lcolor(red) lwidth(medthick)), ///
       legend(order(1 "TELSTRA GROUP LIMITED" 2 "NEXTDC LTD") ///
              cols(1) position(1) ring(0) size(small) region(lstyle(none))) ///
       title("Return on Assets (2015–2024)") ///
       ytitle("Return on Assets (ROA)") ///
       xtitle("Year") ///
       xlabel(2015(1)2024, labsize(small)) ///
       yline(0, lcolor(black) lpattern(dash)) ///
       scheme(s1color)

* Return on Equity (ROE)
by conm: gen at_prev2 = at[_n-1]
gen aseq = (at + at_prev2) / 2 if year > 2014
label variable aseq "Average Shareholder's Equity"

gen roe = nicon/aseq *100
label variable roe "Return on Equity"

* Plot ROE (2015–2024)
twoway (line roe year if conm == "TELSTRA GROUP LIMITED" & inrange(year, 2015, 2024), ///
            lcolor(blue) lwidth(medthick)) ///
       (line roe year if conm == "NEXTDC LTD" & inrange(year, 2015, 2024), ///
            lcolor(red) lwidth(medthick)), ///
       legend(order(1 "TELSTRA GROUP LIMITED" 2 "NEXTDC LTD") ///
              cols(1) position(1) ring(0) size(small) region(lstyle(none))) ///
       title("Return on Equity (2015–2024)") ///
       ytitle("Return on Equity (ROE)") ///
       xtitle("Year") ///
       xlabel(2015(1)2024, labsize(small)) ///
       yline(0, lcolor(black) lpattern(dash)) ///
       scheme(s1color)



**********************************************************************
***                END OF FINANCIAL ANALYSIS DO-FILE               ***
**********************************************************************
