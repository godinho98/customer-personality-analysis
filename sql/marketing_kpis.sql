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