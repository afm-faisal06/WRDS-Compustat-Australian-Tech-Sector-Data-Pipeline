**********************************************************************
***            STOCK PERFORMANCE ANALYSIS: NXT vs TLS              ***
***             Montly Price & Trading Volume Trends               ***
**********************************************************************


*** =============================================================== ***
*** 1. Preliminary Commands to Initiate Do File
*** =============================================================== ***

* Clear memory and close any open files to avoid conflicts
clear all
set more off 

* Set working directory
cd "Downloads"

* Load company stock dataset
use data_for_firm_analysis1, clear


*** =============================================================== ***
*** 2. Data Filtering: Selecting Relevant Companies
*** =============================================================== ***

* Keep only NEXTDC LTD and TELSTRA GROUP LIMITED
keep if conm == "NEXTDC LTD" | conm == "TELSTRA GROUP LIMITED"


*** =============================================================== ***
*** 3. Create Year Variable
*** =============================================================== ***

* Extract numeric year from datadate
generate year = year(datadate)


*** =============================================================== ***
*** 4. Format and Compute Yearly Average Stock Prices
*** =============================================================== ***

* (Optional) Format numeric display for clarity
format prccm %9.3f

* Collapse to yearly average price per company
collapse (mean) prccm, by(conm year)


*** =============================================================== ***
*** 5. Visualization: Yearly Average Stock Price Trend
*** =============================================================== ***

* Plot yearly closing prices for NEXTDC LTD and TELSTRA GROUP LIMITED
twoway (line prccm year if conm == "NEXTDC LTD", lcolor(blue) lwidth(medthick)) ///
       (line prccm year if conm == "TELSTRA GROUP LIMITED", lcolor(red) lwidth(medthick)), ///
       title("Yearly Closing Prices: NXT vs TLS") ///
       ytitle("Average Price") ///
       xtitle("Year") ///
       xlabel(2014(1)2026, format(%ty)) ///
       legend(order(1 "NXT" 2 "TLS")) ///
       scheme(s1color)



**********************************************************************
***                ANALYSIS OF TRADING VOLUME DATA                 ***
**********************************************************************


*** =============================================================== ***
*** 1. Preliminary Commands to Initiate Do File
*** =============================================================== ***

* Clear memory and close any open files to avoid conflicts
clear all
set more off 

* Set working directory
cd "Downloads"

* Load company stock dataset
use data_for_firm_analysis1, clear


*** =============================================================== ***
*** 2. Data Filtering: Selecting Relevant Companies
*** =============================================================== ***

* Keep only NEXTDC LTD and TELSTRA GROUP LIMITED
keep if conm == "NEXTDC LTD" | conm == "TELSTRA GROUP LIMITED"


*** =============================================================== ***
*** 3. Create Year Variable
*** =============================================================== ***

* Extract numeric year from datadate
generate year = year(datadate)


*** =============================================================== ***
*** 3. Collapse Data to Compute Yearly Average Trading Volume
*** =============================================================== ***

* Collapse to yearly mean of trading volume per company
collapse (mean) cshtrm, by(conm year)

* Convert trading volume into thousands for better readability
gen cshtrm_k = cshtrm / 1000


*** =============================================================== ***
*** 4. Visualization: Yearly Trading Volume by Company
*** =============================================================== ***

* Plot trading volume for NEXTDC LTD
twoway (line cshtrm_k year if conm == "NEXTDC LTD", lcolor(blue) lwidth(medthick)) ///
    , title("Yearly Trading Volume: NEXTDC LTD") ///
    ytitle("Average Trading Volume (in Thousands)") ///
    xtitle("Year") ///
    xlabel(2014(1)2026, format(%ty)) ///
    ylabel(0(10)100, format(%9.0f)) ///
    legend(off) ///
    scheme(s1color)

* Plot trading volume for TELSTRA GROUP LIMITED
twoway (line cshtrm_k year if conm == "TELSTRA GROUP LIMITED", lcolor(red) lwidth(medthick)) ///
    , title("Yearly Trading Volume: TELSTRA GROUP LIMITED") ///
    ytitle("Average Trading Volume (in Thousands)") ///
    xtitle("Year") ///
    xlabel(2014(1)2026, format(%ty)) ///
    ylabel(200(50)600, format(%9.0f)) ///
    legend(off) ///
    scheme(s1color)



**********************************************************************
***                 END OF STOCK ANALYSIS DO-FILE                  ***
**********************************************************************
