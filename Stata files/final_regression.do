************************************************************************
* ECOM5002 Group Project - Regression Analysis
* Author: Tsz Fung Wong
************************************************************************
***************************************************************
*** 1. Preliminary commands to initiate do file ***
***************************************************************
clear all
set more off
** cd "Downloads"
*****************************************************************
*** 2. Load the company data ***
*****************************************************************
use "C:\Users\22830043\Downloads\regression.dta", clear

list gvkey conml at revt nicon ceq capx xrd emp
keep if curcd == "AUD"

***************************************************************
*** 3. Variable transformations ***
***************************************************************
gen roa = nicon / at
label variable roa "Return on Asset (Net Income / Asset)"

gen log_at = log(at)
label variable log_at "Log(at)"

gen log_revt = log(revt)
label variable log_revt "Log(revt)"

gen leverage = lt / at
label variable leverage "Leverage Ratio (Liabilities /Assets)"

gen capx_at_ratio = capx / at
label variable capx_at_ratio "Capital Expenditure Intensity"

gen turnover = revt / at
label variable turnover "Asset Turnover Ratio"

gen rnd_intensity = xrd / at
label variable rnd_intensity "R&D Intensity (rnd/at)"

gen labour_intensity = xlr / at
label variable labour_intensity "Labour Cost Intensity"

***************************************************************
*** 4. Descriptive Statistics ***
***************************************************************
summarize roa log_at log_revt leverage capx_at_ratio rnd_intensity turnover labour_intensity emp

***************************************************************
*** 5. Handle Missing Data ***
***************************************************************
misstable summarize roa log_at log_revt leverage capx_at_ratio rnd_intensity turnover labour_intensity emp

*** We drop labour_intensity and emp because missing values more than 50%
*** We drop rnd_intensity as well as missing rate is 45%

***************************************************************
*** 6. Regression ***
***************************************************************
regress roa log_at log_revt leverage
regress roa log_at log_revt leverage turnover capx_at_ratio

***************************************************************
*** 7. Handle Multicollinearity ***
***************************************************************
** We drop log_revt,
** becaz turnover is calculated from revt/at
regress roa log_at leverage turnover

***************************************************************
*** 9. REMOVE OUTLIERS ***
***************************************************************
summarize roa, detail
local p5 = r(p5)
local p99 = r(p95)

drop if roa < `p5' | roa > `p99'
regress roa log_at leverage capx_at_ratio, robust

***************************************************************
*** 8. Plot residuals and predicted values ***
***************************************************************
predict yhat, xb
predict resid, residuals

twoway (scatter resid yhat), ///
    title("Residuals vs Predicted Values") ///
    yline(0)

***************************************************************
*** 9. Export to MS Word ***
***************************************************************
ssc install estout

* Estimate the models
eststo clear
eststo model1: regress roa log_at leverage
eststo model2: regress roa log_at
eststo model3: regress roa log_at leverage capx_at_ratio
eststo model4: regress roa log_at capx_at_ratio

esttab model1 model2 model3 model4 using "final_regression_table.rtf", ///
    se label replace ///
    title("Regression of ROA on Firm Characteristics") ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    stats(r2_a N, fmt(3 0) labels("Adjusted R-squared" "Observations")) ///
    alignment(c) ///
    compress
