WITH 

date_lower_bound AS (SELECT '2021-01-01' AS value),
date_upper_bound AS (SELECT '2022-12-31' AS value),

unique_intender_data AS (
    SELECT 
    calendar_date,
    event_detail,
    zvelo_subcategory,
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
    WHERE ((calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound))  AND
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

unique_converter_data AS (
    SELECT 
    calendar_date,
    event_detail,
    zvelo_subcategory,
    guid,
    domain_group
    FROM unique_intender_data
    WHERE 
    (  -- CONVERTER LOGIC
           event_detail LIKE '%checkout%' 
        OR event_detail LIKE '%commande%'
        OR event_detail LIKE '%payment%'
        OR event_detail LIKE '%caisse%'
    )
),

-- *********************************************************************************************
--  MAIN TABLES
-- *********************************************************************************************

intender_list AS (
    SELECT DISTINCT guid FROM unique_intender_data
),

converter_list AS (
    SELECT DISTINCT guid FROM unique_converter_data
),

total_intenders AS (
    SELECT
        UPPER(REPLACE(REPLACE(zvelo_subcategory, ' and ', '&'),' ','')) AS join_field_a,
        COUNT(DISTINCT guid) AS unique_users
    FROM spectrum_comscore.clickstream_ca
    WHERE ((calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound))  AND guid IN (
        SELECT guid FROM intender_list
    )
    GROUP BY 1
),

total_converters AS (
    SELECT
        UPPER(REPLACE(REPLACE(zvelo_subcategory, ' and ', '&'),' ','')) AS join_field_a,
        COUNT(DISTINCT guid) AS unique_users
    FROM spectrum_comscore.clickstream_ca
    WHERE ((calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound))  AND guid IN (
        SELECT guid FROM converter_list
    )
    GROUP BY 1
),

total_genpop AS (
     SELECT
        UPPER(REPLACE(REPLACE(zvelo_subcategory, ' and ', '&'),' ','')) AS join_field_a,
        COUNT(DISTINCT guid) AS unique_users
    FROM spectrum_comscore.clickstream_ca 
    WHERE ((calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound)) 
    GROUP BY 1
),

total_output AS (
    SELECT 
        total_intenders.join_field_a,
        total_intenders.unique_users AS total_intenders,
        total_converters.unique_users AS total_converters,
        total_genpop.unique_users AS total_genpop
    FROM total_intenders
    RIGHT JOIN total_converters ON total_intenders.join_field_a = total_converters.join_field_a 
    RIGHT JOIN total_genpop ON total_intenders.join_field_a = total_genpop.join_field_a
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
    FROM unique_intender_data
    WHERE ((calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound)) 
),

ref_converters AS (
    SELECT COUNT(DISTINCT guid) AS unique_users
    FROM unique_converter_data
    WHERE ((calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound)) 
)

-- *********************************************************************************************
--  OUTPUT
-- *********************************************************************************************

SELECT
    total_output.join_field_a           AS zvelo_subcategory,
    total_output.total_intenders        AS total_intenders,
    total_output.total_converters       AS total_converters,
    total_output.total_genpop           AS total_genpop,
    ref_genpop.unique_users             AS ref_genpop,
    ref_intenders.unique_users          AS ref_intenders,
    ref_converters.unique_users         AS ref_converters
FROM        total_output
CROSS JOIN  ref_genpop
CROSS JOIN  ref_intenders
CROSS JOIN  ref_converters
WHERE total_intenders > 100
ORDER BY 2 DESC

LIMIT 10000;