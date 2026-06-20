# WRDS-Compustat-Australian-Tech-Sector-Data-Pipeline

## Project Overview
This repository houses the empirical data processing pipeline, econometric modeling scripts, and documentation assessing the **Technology & Software Services** industry in Australia. Utilizing firm-level financial data and stock metrics from **Wharton Research Data Services (WRDS)** (Compustat Global Fundamentals and Security Monthly), the codebase tracks market dynamics, asset efficiency, and performance drivers from 2014 through 2025. 

The scripts focus heavily on data normalization, outlier diagnostics, and cross-sectional regression models evaluating industry structures, with specific comparative tracking for **Telstra Group Limited (ASX: TLS)** and **NEXTDC Limited (ASX: NXT)**.

For full contextual details regarding the methodology, please refer to the compiled document: **Group6_IndustryAnalysisReport.pdf**.

## Repository Structure
```text
├── Stata files/                        # Core Stata analytics engine
│   ├── final_descriptive.do            # Calculates key metric trends (revenue, assets, ROA, leverage), aggregates macro industry metrics, and handles focus company comparative trend analysis (NXT vs. TLS vs. Industry)
│   ├── final_Firm_analysis1.do         # Tracks firm-specific stock performance using security monthly data; computes and plots yearly closing stock price trends and average yearly trading volumes for NXT and TLS
│   ├── final_Firm_analysis2.do         # Computes comprehensive firm-level accounting ratios (Liquidity, Operating Cashflow, Debt-to-Equity, Asset Turnover, Net Profit Margin, ROA, and ROE) comparing NXT and TLS
│   ├── final_regression.do             # Executes data cleaning transformations, performs variable definitions/intensity drops, filters outliers via percentile winsorization, and fits robust ordinary least squares (OLS) diagnostic models
├── Group6_IndustryAnalysisReport.pdf   # Comprehensive findings and analysis document
└── README.md                           # Core repository guide
```

## Industry & NAICS Classification Scope

The data filtration matrix isolates the Australian technology ecosystem across these core NAICS codes:

* **513210**: Software Publishers


* **541511, 541512, 541513, 541519**: IT & Computer Systems Design


* **518210**: Data Processing, Hosting, and Digital Infrastructure


* **519130, 519190**: Internet Publishing & Web Portals


* **541690, 541715, 334111**: Technical Consulting & Hardware R&D


* **517112**: Wireless Communication Operations



## Data Pipeline & Cleaning Engine

The automated Stata files execute a multi-stage cleaning routine to prevent estimation bias:

* **Time-Series Standardization:** Transforms raw calendar dates into continuous, indexable quarterly (`yq()`) and monthly (`ym()`) time identifiers.
* **Currency Uniformity:** Enforces strict denomination limits by purging non-AUD financial records (`keep if curcd == "AUD"`).
* **Missing Variable Truncation:** Drops structurally incomplete indicators displaying a missing-value rate above 50% (e.g., `xlr`, `emp`, `xrd`).
* **Outlier Mitigation:** Winsorizes/truncates extreme operational anomalies falling outside the 5th and 99th percentiles of Return on Assets (ROA).

## Econometric Modeling

The core script (`final_regression.do`) fits an ordinary least squares (OLS) cross-sectional specification using FY2024 data to isolate structural impacts on firm returns:

$$\overline{\mathrm{ROA}} = \beta_0 + \beta_1 \log(\text{Assets}) + \beta_2 \text{Leverage} + \beta_3 \text{Capex Ratio} + \varepsilon$$

### Code Execution Insights

* **Scale Efficiencies ($\beta_1 = 0.139, p < 0.01$):** Demonstrates strong systemic returns to asset scale in the Australian tech landscape.
* **Leverage Drag ($\beta_2 = -0.196, p < 0.01$):** Highlights the heavy, immediate margin pressures of debt servicing.
* **Capital Gestation ($\beta_3 = -1.300$):** Reflects the classic infrastructure lag where massive capital expenditures depress current-period accounting returns before peak capacity demand is realized.

## Environment Requirements

* **Software:** Stata (configured for handling `eststo` model storage and `twoway` visual plots).
* **Data Access:** Wharton Research Data Services (WRDS) active login credentials for Compustat Global.



## Authors

Group 6

* Tsz Fung Wong 
* Kam Fung Leung 
* Fazle Elahi Khan
* Abu Fatah Mohammed Faisal
* Cong Tuan Nguyen

ECOM5002 - Business Quantitative Techniques
Curtin University

