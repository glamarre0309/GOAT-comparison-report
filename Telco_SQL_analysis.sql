-- Overall Churn KPI
SELECT 
  COUNT(*) AS total_customers,
  SUM(CASE WHEN Churn = TRUE THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(SUM(CASE WHEN Churn = TRUE THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate
FROM `churn-analysis-492117.Telco.telco_churn`;
-- 🔍 Insight:
-- Overall churn rate gives a baseline for the company.
-- Example interpretation: If churn_rate = 26%, roughly 1 in 4 customers is leaving.
-- Benchmark: Monthly churn > 5% is usually high in telecom.

-- Churn by Contract Type 
SELECT 
  Contract,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN Churn = TRUE THEN 1 ELSE 0 END) AS churned,
  ROUND(SUM(CASE WHEN Churn = TRUE THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate
FROM `churn-analysis-492117.Telco.telco_churn`
GROUP BY Contract
ORDER BY churn_rate DESC;
-- 🔍 Insight:
-- Month-to-month contracts usually show the highest churn.
-- Annual or two-year contracts tend to retain customers longer.
-- Actionable: Offer incentives to month-to-month customers to switch to longer contracts.

-- Churn by Payment Method
SELECT 
  PaymentMethod,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN Churn = TRUE THEN 1 ELSE 0 END) AS churned,
  ROUND(SUM(CASE WHEN Churn = TRUE THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate
FROM `churn-analysis-492117.Telco.telco_churn`
GROUP BY PaymentMethod
ORDER BY churn_rate DESC;
-- 🔍 Insight:
-- Some payment methods (like manual check) may have higher churn than automated methods (like credit card or bank transfer).
-- Actionable: Encourage auto-pay to reduce churn risk.

--Monthly Charges vs Churn
SELECT 
  Churn,
  ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges
FROM `churn-analysis-492117.Telco.telco_churn`
GROUP BY Churn;
-- 🔍 Insight
-- What it shows: The query calculates the average monthly charges for customers who churned vs those who did not churn.
-- Typical finding: In telecom datasets, churned customers often have higher average monthly charges than retained customers.
-- Interpretation: High-cost customers on month-to-month or flexible plans may feel the service is not worth the cost, increasing their likelihood to leave.

-- Tenure Buckets (Feature Engineering)
SELECT 
  CASE 
    WHEN tenure <= 12 THEN '0-12 months'
    WHEN tenure <= 24 THEN '13-24 months'
    WHEN tenure <= 48 THEN '25-48 months'
    ELSE '49+ months'
  END AS tenure_group,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN Churn = TRUE THEN 1 ELSE 0 END) AS churned,
  ROUND(SUM(CASE WHEN Churn = TRUE THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate
FROM `churn-analysis-492117.Telco.telco_churn`
GROUP BY tenure_group
ORDER BY churn_rate DESC;
-- 🔍 Insight:
-- New customers (0-12 months) usually churn the most.
-- Mid-tenure customers (25–48 months) are more stable.
-- Actionable: Focus retention campaigns on recent customers.

-- Churn by Internet Service
SELECT 
  InternetService,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN Churn = TRUE THEN 1 ELSE 0 END) AS churned,
  ROUND(SUM(CASE WHEN Churn = TRUE THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate
FROM `churn-analysis-492117.Telco.telco_churn`
GROUP BY InternetService
ORDER BY churn_rate DESC;
-- 🔍 Insight:
-- Customers with Fiber optic often churn more than DSL or no internet.
-- Actionable: Improve service quality or offer bundles to Fiber optic users to reduce churn.

-- High Risk Customers
SELECT 
  customerID,
  tenure,
  MonthlyCharges,
  Contract,
  PaymentMethod,
  Churn
FROM `churn-analysis-492117.Telco.telco_churn`
WHERE Churn = TRUE
  AND MonthlyCharges > 80
  AND Contract = 'Month-to-month'
ORDER BY MonthlyCharges DESC;
-- 🔍 Insight:
-- Customers paying high monthly fees on short-term contracts are at the highest churn risk.
-- Actionable: Target these customers with discounts, loyalty programs, or contract upgrades.