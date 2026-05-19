-- =============================================================
-- 1. Missing Values
-- Checks how many NULLs exist per column and their percentage.
-- Missing values in critical columns can invalidate financial
-- and segmentation analyses.
-- =============================================================
SELECT 'id'                    AS column_name, COUNT(*) - COUNT(id)                    AS missing_values, ROUND((COUNT(*) - COUNT(id))::NUMERIC                    / COUNT(*) * 100, 2) AS pct_missing FROM marketing_campaign UNION ALL
SELECT 'year_birth',                                COUNT(*) - COUNT(year_birth),                                ROUND((COUNT(*) - COUNT(year_birth))::NUMERIC                    / COUNT(*) * 100, 2) FROM marketing_campaign UNION ALL
SELECT 'education',                                 COUNT(*) - COUNT(education),                                 ROUND((COUNT(*) - COUNT(education))::NUMERIC                     / COUNT(*) * 100, 2) FROM marketing_campaign UNION ALL
SELECT 'marital_status',                            COUNT(*) - COUNT(marital_status),                            ROUND((COUNT(*) - COUNT(marital_status))::NUMERIC                / COUNT(*) * 100, 2) FROM marketing_campaign UNION ALL
SELECT 'income',                                    COUNT(*) - COUNT(income),                                    ROUND((COUNT(*) - COUNT(income))::NUMERIC                        / COUNT(*) * 100, 2) FROM marketing_campaign UNION ALL
SELECT 'kidhome',                                   COUNT(*) - COUNT(kidhome),                                   ROUND((COUNT(*) - COUNT(kidhome))::NUMERIC                       / COUNT(*) * 100, 2) FROM marketing_campaign UNION ALL
SELECT 'teenhome',                                  COUNT(*) - COUNT(teenhome),                                  ROUND((COUNT(*) - COUNT(teenhome))::NUMERIC                      / COUNT(*) * 100, 2) FROM marketing_campaign UNION ALL
SELECT 'dt_customer',                               COUNT(*) - COUNT(dt_customer),                               ROUND((COUNT(*) - COUNT(dt_customer))::NUMERIC                   / COUNT(*) * 100, 2) FROM marketing_campaign UNION ALL
SELECT 'recency',                                   COUNT(*) - COUNT(recency),                                   ROUND((COUNT(*) - COUNT(recency))::NUMERIC                       / COUNT(*) * 100, 2) FROM marketing_campaign UNION ALL
SELECT 'mnt_wines',                                 COUNT(*) - COUNT(mnt_wines),                                 ROUND((COUNT(*) - COUNT(mnt_wines))::NUMERIC                     / COUNT(*) * 100, 2) FROM marketing_campaign UNION ALL
SELECT 'mnt_fruits',                                COUNT(*) - COUNT(mnt_fruits),                                ROUND((COUNT(*) - COUNT(mnt_fruits))::NUMERIC                    / COUNT(*) * 100, 2) FROM marketing_campaign UNION ALL
SELECT 'mnt_meat_products',                         COUNT(*) - COUNT(mnt_meat_products),                         ROUND((COUNT(*) - COUNT(mnt_meat_products))::NUMERIC             / COUNT(*) * 100, 2) FROM marketing_campaign UNION ALL
SELECT 'mnt_fish_products',                         COUNT(*) - COUNT(mnt_fish_products),                         ROUND((COUNT(*) - COUNT(mnt_fish_products))::NUMERIC             / COUNT(*) * 100, 2) FROM marketing_campaign UNION ALL
SELECT 'mnt_sweet_products',                        COUNT(*) - COUNT(mnt_sweet_products),                        ROUND((COUNT(*) - COUNT(mnt_sweet_products))::NUMERIC            / COUNT(*) * 100, 2) FROM marketing_campaign UNION ALL
SELECT 'mnt_gold_prods',                            COUNT(*) - COUNT(mnt_gold_prods),                            ROUND((COUNT(*) - COUNT(mnt_gold_prods))::NUMERIC                / COUNT(*) * 100, 2) FROM marketing_campaign UNION ALL
SELECT 'num_deals_purchases',                       COUNT(*) - COUNT(num_deals_purchases),                       ROUND((COUNT(*) - COUNT(num_deals_purchases))::NUMERIC           / COUNT(*) * 100, 2) FROM marketing_campaign UNION ALL
SELECT 'num_web_purchases',                         COUNT(*) - COUNT(num_web_purchases),                         ROUND((COUNT(*) - COUNT(num_web_purchases))::NUMERIC             / COUNT(*) * 100, 2) FROM marketing_campaign UNION ALL
SELECT 'num_catalog_purchases',                     COUNT(*) - COUNT(num_catalog_purchases),                     ROUND((COUNT(*) - COUNT(num_catalog_purchases))::NUMERIC         / COUNT(*) * 100, 2) FROM marketing_campaign UNION ALL
SELECT 'num_store_purchases',                       COUNT(*) - COUNT(num_store_purchases),                       ROUND((COUNT(*) - COUNT(num_store_purchases))::NUMERIC           / COUNT(*) * 100, 2) FROM marketing_campaign UNION ALL
SELECT 'num_web_visits_month',                      COUNT(*) - COUNT(num_web_visits_month),                      ROUND((COUNT(*) - COUNT(num_web_visits_month))::NUMERIC          / COUNT(*) * 100, 2) FROM marketing_campaign UNION ALL
SELECT 'accepted_cmp1',                             COUNT(*) - COUNT(accepted_cmp1),                             ROUND((COUNT(*) - COUNT(accepted_cmp1))::NUMERIC                 / COUNT(*) * 100, 2) FROM marketing_campaign UNION ALL
SELECT 'accepted_cmp2',                             COUNT(*) - COUNT(accepted_cmp2),                             ROUND((COUNT(*) - COUNT(accepted_cmp2))::NUMERIC                 / COUNT(*) * 100, 2) FROM marketing_campaign UNION ALL
SELECT 'accepted_cmp3',                             COUNT(*) - COUNT(accepted_cmp3),                             ROUND((COUNT(*) - COUNT(accepted_cmp3))::NUMERIC                 / COUNT(*) * 100, 2) FROM marketing_campaign UNION ALL
SELECT 'accepted_cmp4',                             COUNT(*) - COUNT(accepted_cmp4),                             ROUND((COUNT(*) - COUNT(accepted_cmp4))::NUMERIC                 / COUNT(*) * 100, 2) FROM marketing_campaign UNION ALL
SELECT 'accepted_cmp5',                             COUNT(*) - COUNT(accepted_cmp5),                             ROUND((COUNT(*) - COUNT(accepted_cmp5))::NUMERIC                 / COUNT(*) * 100, 2) FROM marketing_campaign UNION ALL
SELECT 'complain',                                  COUNT(*) - COUNT(complain),                                  ROUND((COUNT(*) - COUNT(complain))::NUMERIC                      / COUNT(*) * 100, 2) FROM marketing_campaign UNION ALL
SELECT 'z_cost_contact',                            COUNT(*) - COUNT(z_cost_contact),                            ROUND((COUNT(*) - COUNT(z_cost_contact))::NUMERIC                / COUNT(*) * 100, 2) FROM marketing_campaign UNION ALL
SELECT 'z_revenue',                                 COUNT(*) - COUNT(z_revenue),                                 ROUND((COUNT(*) - COUNT(z_revenue))::NUMERIC                     / COUNT(*) * 100, 2) FROM marketing_campaign UNION ALL
SELECT 'response',                                  COUNT(*) - COUNT(response),                                  ROUND((COUNT(*) - COUNT(response))::NUMERIC                      / COUNT(*) * 100, 2) FROM marketing_campaign;
-- FINDING: Only 'income' has missing values (24 rows, 1.07%).
-- All other columns are complete.
-- These 24 rows must be excluded from any income-based analysis.


-- =============================================================
-- 2. Duplicate Values
-- Checks if 'id' is truly unique across all rows.
-- Duplicate IDs would inflate campaign and spend metrics.
-- =============================================================
SELECT 
	id, 
	COUNT(*) AS occurrences
FROM marketing_campaign
GROUP BY id
HAVING COUNT(*) > 1
-- FINDING: No duplicate IDs found. Dataset is clean.


-- =============================================================
-- 3. Data Types
-- Verifies that PostgreSQL assigned correct types during import.
-- Wrong types would block date calculations, aggregations,
-- and numeric comparisons.
-- =============================================================
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'marketing_campaign';
-- FINDING: All columns have correct data types as defined in setup.sql.


-- =============================================================
-- 4. Value Standardization
-- Checks for inconsistent or invalid category values.
-- Unstandardized values will distort segmentation results in analysis.
-- =============================================================
SELECT
	COUNT(DISTINCT marital_status)
FROM marketing_campaign;

SELECT DISTINCT
	marital_status
FROM marketing_campaign;

SELECT
	marital_status,
	COUNT(*) AS total_customers
FROM marketing_campaign
GROUP BY marital_status
ORDER BY 2 DESC;

-- FINDING: marital_status has 3 invalid values: 'YOLO', 'Absurd', 'Alone' (7 rows total).
-- 'Together' is ambiguous but kept as a valid category.
-- These rows should be excluded from segmentation analysis.

SELECT
	COUNT(DISTINCT education)
FROM marketing_campaign;

SELECT DISTINCT
	education
FROM marketing_campaign;

SELECT
	education,
	COUNT(*) AS total_customers
FROM marketing_campaign
GROUP BY education
ORDER BY 2 DESC;
-- FINDING: education has '2n Cycle' which is a valid European education level
-- but inconsistently labeled. Renaming to 'High School' would improve clarity.

-- =============================================================
-- Outlier check — year_birth
-- Identifies customers with potentially erroneous birth years.
-- Ages above 100 are flagged for verification.
-- =============================================================
SELECT 
    id,
    year_birth,
    DATE_PART('year', CURRENT_DATE) - year_birth AS age
FROM marketing_campaign
WHERE DATE_PART('year', CURRENT_DATE) - year_birth > 100;
-- FINDING: 3 records flagged with birth years suggesting ages above 100
-- (year_birth: 1893, 1899, 1900).
-- Excluded from age-based analysis pending business verification.