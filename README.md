# Customer Personality Analysis
### SQL · PostgreSQL · Power BI · Data Quality · Marketing KPIs 

---
# About This Project

Understanding who your customers are is the foundation of any effective marketing strategy. This project analyses a real-world CRM dataset to uncover customer behaviour patterns, segment the customer base, and evaluate campaign performance — giving the marketing team actionable intelligence to improve targeting, reduce wasted spend, and increase revenue.

The entire analysis is performed in SQL against a PostgreSQL database, covering data quality assessment, exploratory analysis, and strategic marketing KPIs across three structured query files.

## 1. Business Context

Customer Personality Analysis is a detailed analysis of the customer profile aimed at increasing revenue by targeting the right people in marketing campaigns and developing products optimised for the existing customer base. It also helps identify weaknesses and opportunities to attract new potential customers.

The objective of this project is to help a business better understand its customer base, segment it meaningfully, and evaluate which campaigns and behaviours drive the most results — avoiding wasted spend on inefficient actions.

---

## 2. Dataset

- **Source:** Provided by Dr. Omar Romero-Hernandez on [Kaggle](https://www.kaggle.com/datasets/imakash3011/customer-personality-analysis/data)
- **Rows:** 2,240 (no duplicates)
- **Columns:** 29, grouped into four attribute categories:

| Group | Description |
|---|---|
| Personal Information | Age, income, education, marital status, dependents, enrolment date |
| Products Purchased | Amount spent on wines, fruits, meat, fish, sweets, and gold |
| Campaign Acceptance | Response to 5 individual campaigns and the last campaign |
| Purchase Channels | Number of purchases via web, store, catalogue, and deals |

---

## 3. Data Quality Assessment

The dataset is in good overall condition, requiring minimal effort to prepare for analysis.

| Check | Finding |
|---|---|
| Missing values | Only `income` had NULLs — 24 rows (1.07%). Excluded from income-based analysis. |
| Duplicates | No duplicate IDs found. Dataset is clean. |
| Data types | All columns matched expected types after correct date format configuration. |
| Standardisation | `marital_status` contains 3 invalid values (`YOLO`, `Absurd`, `Alone`) across 7 rows. Excluded from segmentation. |
| Outliers | 3 records with birth years suggesting ages above 130 — flagged as likely erroneous and excluded from age-based analysis. 1 record with income of $666,666 — excluded from income analysis as a statistical outlier (next highest: $162,397). |

---

## 4. Metrics and KPIs Defined

| Metric | Level |
|---|---|
| Total customers, total spend, total purchases | Basic |
| Purchases by channel | Basic |
| Average spend per customer, average purchases per customer | Indicator |
| Average recency, deal purchase volume | Indicator |
| Overall campaign engagement rate | Strategic KPI |
| Active vs inactive customers | Strategic KPI |
| High value customer profile | Strategic KPI |
| High spend segments (income, age, education, marital status) | Strategic KPI |
| Per-campaign response rate | Strategic KPI |
| Deal buyer profile | Strategic KPI |

---

## 5. Analyses Performed

The project is structured across three SQL files:

**Part 1 — Data Quality** (`data_quality_checks.sql`)
Missing values, duplicates, data type validation, value standardisation, and outlier detection across all 29 columns.

**Part 2 — Exploratory Analysis** (`exploratory_analysis.sql`)
Core business metrics including total customers (2,240), total spend ($1,356,988), total purchases (28,083), purchases by channel, customer averages, recency, campaign engagement rate, and deal purchase volume. Demographic overviews for age and income distribution.

**Part 3 — Marketing KPIs** (`marketing_kpis.sql`)
Demographic segmentation by income (quartile-based), age group, education level, and marital status. Behavioural profiles for top buyers, top spenders, and most campaign-responsive customers. Per-campaign performance breakdown and comparative analysis between the weakest (CMP2) and strongest (LAST_CMP) campaigns. Deal buyer profile analysis.

---

## 6. Key Insights for the Marketing Team

**High-value customer profile is consistent across segments.**
Top buyers, top spenders, and the most campaign-responsive customers all share a near-identical profile: older (avg. ~58), married or together, Graduation-educated, higher income (~$70,000+), and few dependents. A single well-targeted campaign can effectively reach all three groups simultaneously.

**Store is the dominant purchase channel. Catalogue is the weakest.**
Store accounts for 12,970 purchases vs 5,963 for catalogue. Shifting investment from catalogue toward store or web could improve channel ROI without reaching new audiences.

**The last campaign significantly outperformed all others.**
LAST_CMP achieved a 14.91% response rate — more than double any individual campaign (CMP1–CMP5 range: 1.34%–7.46%). The approach used in this campaign warrants further investigation to understand what drove higher engagement.

**CMP2 significantly underperformed and requires review.**
With only 30 responders (1.34%), CMP2 is a clear outlier. Its responder profile is not meaningfully different from other campaigns, suggesting a targeting, messaging, or timing issue rather than an audience mismatch.

**Deal buyers have lower income and more dependents.**
Customers who most frequently purchase using discounts share the same age, education, and marital status as high-value customers, but have lower income ($50,820 vs $71,117) and significantly more dependents (1.49 vs 0.58). This suggests an opportunity to develop more accessible price-point products for this segment rather than relying solely on discounts.

**Income is the strongest predictor of spend.**
High income customers spend $1,359 on average vs $81 for low income — a 16x difference. Education shows a similar but weaker pattern. Prioritising higher income segments in campaign targeting is likely to yield better ROI.

---

## 7. Dataset Limitations

- **Web conversion rate cannot be calculated.** `num_web_visits_month` covers only the last month, while `num_web_purchases` covers the full customer lifetime. The time windows are incomparable.
- **Channel efficiency is limited to purchase volume.** The dataset does not include revenue per channel or marketing cost per channel, making true ROI calculation impossible.
- **Purchase frequency cannot be accurately measured.** Without individual transaction dates, purchases per time period cannot be calculated. Average total purchases per customer (12.54) is used as a proxy.
- **Campaign context is unavailable.** The dataset does not include campaign messaging, timing, target audience, or budget — limiting the ability to explain performance differences between campaigns.

---

## 8. Next Steps

- **RFM Segmentation:** Combine Recency, Frequency, and Monetary dimensions to build a more robust customer value model beyond spend alone.
- **Investigate LAST_CMP:** Analyse what differentiated the last campaign from previous ones and apply those learnings to future campaigns.
- **Review CMP2:** Conduct a root cause analysis with the marketing team to understand the low response rate and avoid repeating the same approach.
- **Develop accessible product lines:** The deal buyer segment represents a significant portion of the base with lower purchasing power. Tailored lower price-point products could convert deal dependency into sustainable revenue.
- **Power BI Dashboard:** An interactive dashboard visualising the key findings from this analysis is available in the `dashboard/` folder.

---

## Project Structure

```
customer-personality-analysis/
│
├── dataset/
│   └── marketing_campaign.csv
│
├── sql/
│   ├── setup.sql
│   ├── data_quality_checks.sql
│   ├── exploratory_analysis.sql
│   └── marketing_kpis.sql
│
├── dashboard/
│   └── (Power BI screenshots)
│
└── README.md
```

---

*Tools used: PostgreSQL 18 · pgAdmin 4 · Power BI · Git*
