-- =============================================================
-- Average spend by education level
-- Identifies which customer segments generate the most revenue.
-- Helps the marketing team prioritise messaging and offers
-- towards the highest value demographic groups.
SELECT
	education,
	COUNT(*) AS total_customers,
	ROUND((SUM(mnt_wines) + SUM(mnt_fruits) + SUM(mnt_meat_products) + SUM(mnt_fish_products) 
	+ SUM(mnt_sweet_products) + SUM(mnt_gold_prods)) / COUNT(1)::numeric, 2)  AS avg_amount
FROM marketing_campaign
GROUP BY education
ORDER BY 3 DESC;
-- FINDING: Spend increases broadly with education level, with one exception.
-- PhD: $672.41 (486) | Graduation: $619.90 (1,127) | Master: $611.78 (370)
-- 2n Cycle: $496.53 (203) | Basic: $81.80 (54)
-- INSIGHT: Graduation is the largest and second highest spending segment —
-- the most strategically valuable group by volume and total revenue.
-- Master spends slightly less than Graduation despite higher education level,
-- likely due to sample composition rather than a true spending pattern.
-- Basic education customers spend 88% less than PhD customers.

-- =============================================================
-- Age distribution overview
-- Establishes the age range and average age of the customer base.
-- Used to define meaningful age brackets for segmentation.
SELECT
    MIN(DATE_PART('year', CURRENT_DATE) - year_birth) AS min_age,
    MAX(DATE_PART('year', CURRENT_DATE) - year_birth) AS max_age,
     ROUND(AVG(DATE_PART('year', CURRENT_DATE) - year_birth)::numeric, 1) AS avg_age
FROM marketing_campaign
WHERE year_birth >= 1926;
-- FINDING: Age range: 30–86 | Average age: 57
-- Customer base skews older — majority above 50.
-- 3 records excluded (year_birth before 1926) as likely erroneous entries.

-- =============================================================
-- Average spend and number of customers by age group
-- Segments customers into standard marketing age brackets.
-- Reveals which life stage generates the most revenue.
SELECT
	CASE 
		WHEN DATE_PART('year', CURRENT_DATE) - year_birth >= 30 AND DATE_PART('year', CURRENT_DATE) - year_birth < 40
		THEN 'Young Adults'
		WHEN DATE_PART('year', CURRENT_DATE) - year_birth >= 40 AND DATE_PART('year', CURRENT_DATE) - year_birth < 50
		THEN 'Middle Age'
		WHEN DATE_PART('year', CURRENT_DATE) - year_birth >= 50 AND DATE_PART('year', CURRENT_DATE) - year_birth < 60
		THEN 'Mature'
		WHEN DATE_PART('year', CURRENT_DATE) - year_birth >= 60 AND DATE_PART('year', CURRENT_DATE) - year_birth < 70
		THEN 'Senior'
		ELSE 'Elder'
	END AS age_group,
	COUNT(id) AS total_customers,
	ROUND((SUM(mnt_wines) + SUM(mnt_fruits) + SUM(mnt_meat_products) + SUM(mnt_fish_products) 
	+ SUM(mnt_sweet_products) + SUM(mnt_gold_prods)) / COUNT(id)::numeric, 2)  AS avg_amount
FROM marketing_campaign
WHERE year_birth >= 1926
GROUP BY 1
ORDER BY 3 DESC;
-- FINDING: Elder (70–86): $735.55 (420) | Young Adults (30–39): $686.91 (147)
-- Senior (60–69): $657.38 (487) | Mature (50–59): $545.77 (724) | Middle Age (40–49): $500.79 (459)
-- INSIGHT: Elder customers are the highest spenders despite not being the largest group —
-- likely due to higher disposable income post-retirement.
-- Middle Age customers spend the least, consistent with peak family financial obligations.
-- Mature is the largest segment (724) and represents the core customer base.

-- =============================================================
-- Income distribution and segmentation
-- Establishes income range and segments customers into quartile-based
-- brackets to reveal which financial group generates the most revenue.
-- Brackets defined using Q1, median and Q3 for statistical fairness.
-- NOTE: 1 record with income $666,666 excluded from income-based analysis.
-- Value is 4x the second highest income ($162,397) and would skew averages.
-- Data point is retained in the dataset but excluded here as a statistical outlier.
SELECT
    MIN(income) AS min_income,
    MAX(income) AS max_income,
    ROUND(AVG(income), 2) AS avg_income
FROM marketing_campaign
WHERE income IS NOT NULL AND income < 200000;


SELECT
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY income) AS q1,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY income) AS median,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY income) AS q3
FROM marketing_campaign
WHERE income IS NOT NULL AND income < 200000;


SELECT
	CASE
		WHEN income <= 35284
		THEN 'Low income'
		WHEN income > 35284 AND income <= 51373
		THEN 'Lower middle'
		WHEN income > 51373 AND income <= 68487
		THEN 'Upper middle'
		ELSE 'High income'
	END AS income_group,
	COUNT(*) AS total_customers,
	ROUND(AVG(income), 2) AS avg_income,
	ROUND((SUM(mnt_wines) + SUM(mnt_fruits) + SUM(mnt_meat_products) + SUM(mnt_fish_products) 
	+ SUM(mnt_sweet_products) + SUM(mnt_gold_prods)) / COUNT(*)::numeric, 2)  AS avg_amount
FROM marketing_campaign
WHERE income IS NOT NULL AND income < 200000
GROUP BY 1
ORDER BY 3 DESC;
-- FINDING: Average spend increases directly with income across all brackets.
-- Low income (< $35,284): $81.59 | Lower middle: $231.32 
-- Upper middle: $757.74 | High income (> $68,487): $1,359.99
-- INSIGHT: High income customers spend 16x more than low income customers.
-- Prioritising campaigns toward higher income segments will likely
-- yield significantly better ROI.

-- =============================================================
-- Spend segmentation by marital status
-- Investigates whether marital status influences spending behaviour.
-- Analysed at two levels: individual status and partner vs no partner.
-- Invalid marital status values excluded (Absurd, Alone, YOLO).
SELECT
	marital_status,
	COUNT(*) AS total_customers,
	ROUND((SUM(mnt_wines) + SUM(mnt_fruits) + SUM(mnt_meat_products) + SUM(mnt_fish_products) 
	+ SUM(mnt_sweet_products) + SUM(mnt_gold_prods)) / COUNT(*)::numeric, 2)  AS avg_amount
FROM marketing_campaign
WHERE marital_status NOT IN ('Absurd', 'Alone', 'YOLO')
GROUP BY 1
ORDER BY 3 DESC;

SELECT
	CASE
		WHEN marital_status IN ('Divorced', 'Single', 'Widow')
		THEN 'no_partner'
		ELSE 'has_partner'
	END AS marital_status,
	COUNT(*) AS total_customers,
	ROUND((SUM(mnt_wines) + SUM(mnt_fruits) + SUM(mnt_meat_products) + SUM(mnt_fish_products) 
	+ SUM(mnt_sweet_products) + SUM(mnt_gold_prods)) / COUNT(*)::numeric, 2)  AS avg_amount
FROM marketing_campaign
WHERE marital_status NOT IN ('Absurd', 'Alone', 'YOLO')
GROUP BY 1
ORDER BY 3 DESC;
-- FINDING: No strong overall relationship between marital status and average spend.
-- EXCEPTION: Widow customers show notably higher average spend ($738.82)
-- compared to Married ($590.80) and other groups.
-- Grouped analysis (has_partner vs no_partner) showed no significant difference.
-- Marital status alone is not a reliable segmentation criterion,
-- but Widow segment may be worth investigating further.


-- =============================================================
-- Profile of top buyers (75th percentile — 18+ purchases)
-- Aggregates demographic characteristics of the most purchase-active
-- customers to give the marketing team a targetable profile.
WITH top_customers AS (
SELECT
	*,
	DATE_PART('year', CURRENT_DATE) - year_birth AS age
FROM marketing_campaign
WHERE num_web_purchases + num_catalog_purchases + num_store_purchases > 
	(SELECT
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY num_web_purchases + num_catalog_purchases + num_store_purchases) AS q3
FROM marketing_campaign
WHERE year_birth > 1926)
AND year_birth >= 1926
)

SELECT
	ROUND(AVG(age)::numeric, 2) AS avg_age,
	ROUND(AVG(income)::numeric, 2) AS avg_income,
	MODE() WITHIN GROUP (ORDER BY education) AS most_common_education,
	MODE() WITHIN GROUP (ORDER BY marital_status) AS most_common_marital_status,
	ROUND(AVG((kidhome + teenhome))::numeric, 2) AS avg_dependents_number,
	ROUND(AVG(num_web_purchases + num_catalog_purchases + num_store_purchases)::numeric, 2) AS avg_purchase_number,
	ROUND(AVG(mnt_wines + mnt_fruits + mnt_meat_products + mnt_fish_products 
    + mnt_sweet_products + mnt_gold_prods)::numeric, 2) AS avg_spend
FROM top_customers;
-- FINDING: 556 customers average 22.27 purchases.
-- Average age: 59 | Average income: $71,117 | Average amount spend: $1,249.31
-- Most common education: Graduation | Most common marital status: Married
-- Average dependents: 0.58
-- INSIGHT: Top buyers are older, married, higher income customers with
-- few dependents — very similar profile to high value spenders.
-- A single targeted campaign could effectively reach both segments.


-- =============================================================
-- Profile of top spenders (75th percentile)
-- Aggregates demographic characteristics of the highest spending
-- customers to give the marketing team a targetable profile.
WITH top_customers AS (
SELECT
	*,
	DATE_PART('year', CURRENT_DATE) - year_birth AS age
FROM marketing_campaign
WHERE mnt_wines + mnt_fruits + mnt_meat_products + mnt_fish_products + mnt_sweet_products + mnt_gold_prods > 
	(SELECT
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY mnt_wines + mnt_fruits + mnt_meat_products + mnt_fish_products + mnt_sweet_products + mnt_gold_prods) AS q3
FROM marketing_campaign
WHERE year_birth > 1926)
AND year_birth > 1926
)

SELECT
	ROUND(AVG(age)::numeric, 2) AS avg_age,
	ROUND(AVG(income)::numeric, 2) AS avg_income,
	MODE() WITHIN GROUP (ORDER BY education) AS most_common_education,
	MODE() WITHIN GROUP (ORDER BY marital_status) AS most_common_marital_status,
	ROUND(AVG((kidhome + teenhome))::numeric, 2) AS avg_dependents_number,
	ROUND(AVG(num_web_purchases + num_catalog_purchases + num_store_purchases)::numeric, 2) AS avg_purchase_number,
	ROUND(AVG(mnt_wines + mnt_fruits + mnt_meat_products + mnt_fish_products 
    + mnt_sweet_products + mnt_gold_prods)::numeric, 2) AS avg_spend
FROM top_customers;
-- FINDING: Top spenders average 20 purchases and $75,223 income.
-- Average age: 58 | Most common education: Graduation | Most common marital status: Married
-- Average dependents: 0.38
-- INSIGHT: Top spenders and top buyers share nearly identical profiles —
-- older, married, Graduation-educated, higher income, few dependents.
-- This consistency strongly suggests a single high-value segment exists
-- that is both purchase-active and high spending.
-- Marketing efforts concentrated on this profile are likely to maximise ROI.


-- =============================================================
-- Profile of most responsive customers (2+ campaigns accepted)
-- Aggregates demographic characteristics of customers who responded
-- to multiple campaigns — the most marketing-receptive segment.
WITH campaign_answers AS (
SELECT
	*,
	DATE_PART('year', CURRENT_DATE) - year_birth AS age
FROM marketing_campaign
WHERE accepted_cmp1 + accepted_cmp2 + accepted_cmp3 + accepted_cmp4
+ accepted_cmp5 + response >= 2
AND year_birth > 1926
)

SELECT
	ROUND(AVG(age)::numeric, 2) AS avg_age,
	ROUND(AVG(income)::numeric, 2) AS avg_income,
	MODE() WITHIN GROUP (ORDER BY education) AS most_common_education,
	MODE() WITHIN GROUP (ORDER BY marital_status) AS most_common_marital_status,
	ROUND(AVG((kidhome + teenhome))::numeric, 2) AS avg_dependents_number,
	ROUND(AVG(num_web_purchases + num_catalog_purchases + num_store_purchases)::numeric, 2) AS avg_purchase_number,
	ROUND(AVG(mnt_wines + mnt_fruits + mnt_meat_products + mnt_fish_products 
    + mnt_sweet_products + mnt_gold_prods)::numeric, 2) AS avg_spend
FROM campaign_answers;
-- FINDING: Average age: 56 | Average income: $69,465
-- Most common education: Graduation | Most common marital status: Married
-- Average dependents: 0.49 | Average purchases: 17.46 | Average spend: $1,266.43
-- INSIGHT: Campaign-responsive customers share the same core profile
-- as top buyers and top spenders — older, married, Graduation-educated,
-- higher income, few dependents.
-- This segment is already engaged and spending well.
-- Re-engaging them with personalised campaigns is likely the highest ROI action
-- available to the marketing team.