WITH 

date_lower_bound AS (SELECT '2019-01-01' AS value),
date_upper_bound AS (SELECT '2022-03-31' AS value),

unique_intender_data AS (
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
    WHERE ( (calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound)) AND
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

unique_genpop_data AS (
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
    WHERE ( (calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound))
),

-- *********************************************************************************************
--  MAIN TABLES
-- *********************************************************************************************

total_intenders AS (
    SELECT
    domain_group AS join_field_a,
    date_part(year, calendar_date) AS join_field_b,
    COUNT(DISTINCT guid) AS unique_users
    FROM unique_intender_data
    GROUP BY 1, 2
),

total_genpop AS (
    SELECT
    domain_group AS join_field_a,
    date_part(year, calendar_date) AS join_field_b,
    COUNT(DISTINCT guid) AS unique_users
    FROM unique_genpop_data
    GROUP BY 1, 2
),

total_output AS (
    SELECT 
    a.join_field_a,
    a.join_field_b,
    a.unique_users AS total_intenders,
    b.unique_users AS total_genpop
    FROM total_intenders AS a INNER JOIN total_genpop AS b ON a.join_field_a = b.join_field_a AND a.join_field_b = b.join_field_b
),

-- *********************************************************************************************
--  INDEX REFERENCE COLUMNS
-- *********************************************************************************************

ref_genpop AS (
    SELECT COUNT(DISTINCT guid) AS unique_users
    FROM spectrum_comscore.clickstream_ca
    WHERE ( (calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound))
),

ref_intenders AS (
    SELECT COUNT(DISTINCT guid) AS unique_users
    FROM unique_intender_data
    WHERE ( (calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound))
)

-- *********************************************************************************************
--  OUTPUT
-- *********************************************************************************************

SELECT
    a.join_field_a AS domain_group,
    a.join_field_b AS year,
    a.total_intenders AS total_intenders,
    a.total_genpop AS total_genpop,
    b.unique_users AS ref_genpop,
    c.unique_users AS ref_intenders
FROM total_output AS a
CROSS JOIN ref_genpop AS b
CROSS JOIN ref_intenders AS c

LIMIT 10000;
