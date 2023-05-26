WITH 


date_lower_bound AS (SELECT '2021-01-01' AS value),
date_upper_bound AS (SELECT '2022-12-31' AS value),

non_unique_intender_data AS (
    SELECT 
    calendar_date,
    guid,
    (CASE
    WHEN domain LIKE '%canadiantire.ca%' OR event_detail LIKE '%canadiantire.ca%' THEN 'Canadian Tire'
    WHEN domain LIKE '%amazon.ca%' OR event_detail LIKE '%amazon.ca%' THEN 'Amazon'
    WHEN domain LIKE '%walmart.ca%' OR event_detail LIKE '%walmart.ca%' THEN 'Walmart'
    WHEN domain LIKE '%bestbuy.ca%' OR event_detail LIKE '%bestbuy.ca%' THEN 'Best Buy'
    WHEN domain LIKE '%wayfair.ca%' OR event_detail LIKE '%wayfair.ca%' THEN 'Wayfair'
    WHEN domain LIKE '%ikea.com%' OR event_detail LIKE '%ikea.com%' THEN 'IKEA'
    WHEN domain LIKE '%homesense.ca%' OR event_detail LIKE '%homesense.ca%' THEN 'Home Sense'
    WHEN domain LIKE '%winners.ca%' OR event_detail LIKE '%winners.ca%' THEN 'Winners'
    WHEN domain LIKE '%thebay.com%' OR event_detail LIKE '%thebay.com%' THEN 'Hudsons Bay'
    WHEN domain LIKE '%labaie.com%' OR event_detail LIKE '%labaie.com%' THEN 'Hudsons Bay'
    WHEN domain LIKE '%marshalls.ca%' OR event_detail LIKE '%marshalls.ca%' THEN 'Marshalls'
    WHEN domain LIKE '%homehardware.ca%' OR event_detail LIKE '%homehardware.ca%' THEN 'Home Hardware'
    WHEN domain LIKE '%homedepot.ca%' OR event_detail LIKE '%homedepot.ca%' THEN 'Home Depot'
    WHEN domain LIKE '%rona.ca%' OR event_detail LIKE '%rona.ca%' THEN 'Rona'
    WHEN domain LIKE '%lowes.ca%' OR event_detail LIKE '%lowes.ca%' THEN 'Lowes'
    WHEN domain LIKE '%renodepot.com%' OR event_detail LIKE '%renodepot.com%' THEN 'Reno Depot'
    WHEN domain LIKE '%costco.ca%' OR event_detail LIKE '%costco.ca%' THEN 'Costco'
    WHEN domain LIKE '%dollarama.com%' OR event_detail LIKE '%dollarama.com%' THEN 'Dollarama'
    ELSE domain
    END) AS domain_group
    FROM spectrum_comscore.clickstream_ca
    WHERE ((calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound))AND
    ( -- INTENDER LOGIC
            (domain LIKE '%canadiantire.ca%' OR event_detail LIKE '%canadiantire.ca%')
        OR (domain LIKE '%amazon.ca%' OR event_detail LIKE '%amazon.ca%')
        OR (domain LIKE '%walmart.ca%' OR event_detail LIKE '%walmart.ca%')
        OR (domain LIKE '%bestbuy.ca%' OR event_detail LIKE '%bestbuy.ca%')
        OR (domain LIKE '%wayfair.ca%' OR event_detail LIKE '%wayfair.ca%')
        OR (domain LIKE '%ikea.com%' OR event_detail LIKE '%ikea.com%')
        OR (domain LIKE '%homesense.ca%' OR event_detail LIKE '%homesense.ca%')
        OR (domain LIKE '%winners.ca%' OR event_detail LIKE '%winners.ca%')
        OR (domain LIKE '%thebay.com%' OR event_detail LIKE '%thebay.com%')
        OR (domain LIKE '%labaie.com%' OR event_detail LIKE '%labaie.com%')
        OR (domain LIKE '%marshalls.ca%' OR event_detail LIKE '%marshalls.ca%')
        OR (domain LIKE '%homehardware.ca%' OR event_detail LIKE '%homehardware.ca%')
        OR (domain LIKE '%homedepot.ca%' OR event_detail LIKE '%homedepot.ca%')
        OR (domain LIKE '%rona.ca%' OR event_detail LIKE '%rona.ca%')
        OR (domain LIKE '%lowes.ca%' OR event_detail LIKE '%lowes.ca%')
        OR (domain LIKE '%renodepot.com%' OR event_detail LIKE '%renodepot.com%')
        OR (domain LIKE '%costco.ca%' OR event_detail LIKE '%costco.ca%')
        OR (domain LIKE '%dollarama.com%' OR event_detail LIKE '%dollarama.com%')
   )
),

-- *********************************************************************************************
--  MAIN TABLES
-- *********************************************************************************************

total_website_visit_count_per_intender_1ONLY AS (
    SELECT
        guid,
        COUNT(DISTINCT domain_group) AS domain_group_count
    FROM non_unique_intender_data
    GROUP BY 1
    HAVING COUNT(DISTINCT domain_group) = 1
),

total_website_visit_count_per_intender_2PLUS AS (
    SELECT
        guid,
        COUNT(DISTINCT domain_group) AS domain_group_count
    FROM non_unique_intender_data
    GROUP BY 1
    HAVING COUNT(DISTINCT domain_group) >= 2
),

total_output_1ONLY AS (
    SELECT 
    domain_group,
    COUNT(DISTINCT guid) AS unique_users
    FROM non_unique_intender_data WHERE guid IN (
        SELECT guid FROM total_website_visit_count_per_intender_1ONLY
    )
    GROUP BY 1
),

total_output_2ONLY AS (
    SELECT 
    domain_group,
    COUNT(DISTINCT guid) AS unique_users
    FROM non_unique_intender_data WHERE guid IN (
        SELECT guid FROM total_website_visit_count_per_intender_2PLUS
    )
    GROUP BY 1
),

total_output AS (
    SELECT
    a.domain_group,
    a.unique_users AS unique_users_1ONLY,
    b.unique_users AS unique_users_2PLUS
    FROM total_output_1ONLY AS a FULL OUTER JOIN total_output_2ONLY AS b ON a.domain_group = b.domain_group
),

-- *********************************************************************************************
--  INDEX REFERENCE COLUMNS
-- *********************************************************************************************

ref_genpop AS (
    SELECT COUNT(DISTINCT guid) AS unique_users
    FROM spectrum_comscore.clickstream_ca
    WHERE ((calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound))
),

ref_intenders AS (
    SELECT COUNT(DISTINCT guid) AS unique_users
    FROM non_unique_intender_data
    WHERE ((calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound))
)

-- *********************************************************************************************
--  OUTPUT
-- *********************************************************************************************

SELECT
a.domain_group,
a.unique_users_1ONLY,
a.unique_users_2PLUS,
b.unique_users AS ref_intenders,
c.unique_users AS ref_genpop
FROM total_output AS a
CROSS JOIN ref_intenders AS b
CROSS JOIN ref_genpop AS c

LIMIT 10000;