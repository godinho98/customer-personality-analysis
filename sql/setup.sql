-- =============================================================
-- Customer Personality Analysis — Project Setup
-- =============================================================

-- Date format in the CSV is DD-MM-YYYY.
-- PostgreSQL defaults to ISO (YYYY-MM-DD), so we set DMY
-- at the database level to avoid import errors.
ALTER DATABASE customer_analysis SET datestyle = 'ISO, DMY';

-- Creating the table to match the dataset structure exactly.
-- income uses NUMERIC(12,2) to preserve decimal values.
-- Campaign flags (0/1) use SMALLINT — correct type for binary indicators.
CREATE TABLE marketing_campaign (
    id                    INTEGER PRIMARY KEY,
    year_birth            INTEGER,
    education             VARCHAR(50),
    marital_status        VARCHAR(50),
    income                NUMERIC(12, 2),
    kidhome               INTEGER,
    teenhome              INTEGER,
    dt_customer           DATE,
    recency               INTEGER,
    mnt_wines             INTEGER,
    mnt_fruits            INTEGER,
    mnt_meat_products     INTEGER,
    mnt_fish_products     INTEGER,
    mnt_sweet_products    INTEGER,
    mnt_gold_prods        INTEGER,
    num_deals_purchases   INTEGER,
    num_web_purchases     INTEGER,
    num_catalog_purchases INTEGER,
    num_store_purchases   INTEGER,
    num_web_visits_month  INTEGER,
    accepted_cmp3         SMALLINT,
    accepted_cmp4         SMALLINT,
    accepted_cmp5         SMALLINT,
    accepted_cmp1         SMALLINT,
    accepted_cmp2         SMALLINT,
    complain              SMALLINT,
    z_cost_contact        INTEGER,
    z_revenue             INTEGER,
    response              SMALLINT
);

-- Verifying row count after import — expected: 2240
SELECT COUNT(*) FROM marketing_campaign;

-- Quick visual check of the first 10 rows
SELECT * FROM marketing_campaign LIMIT 10;