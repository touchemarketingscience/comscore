WITH 

date_lower_bound AS (SELECT '2019-01-01' AS value),
date_upper_bound AS (SELECT '2023-03-31' AS value),

unique_intender_data AS (
    SELECT 
    calendar_date,
    event_detail,
    guid
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

unique_converter_data AS (
    SELECT 
    calendar_date,
    event_detail,
    guid
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

total_intenders AS (
    SELECT
        date_part(year, calendar_date) AS join_field_a,
        date_part(month, calendar_date) AS join_field_b,
        COUNT(DISTINCT guid) AS unique_users
    FROM unique_intender_data
    GROUP BY 1, 2
),

total_converters AS (
    SELECT
        date_part(year, calendar_date) AS join_field_a,
        date_part(month, calendar_date) AS join_field_b,
        COUNT(DISTINCT guid) AS unique_users
    FROM unique_converter_data
    GROUP BY 1, 2
),

total_genpop AS (
     SELECT
        date_part(year, calendar_date) AS join_field_a,
        date_part(month, calendar_date) AS join_field_b,
        COUNT(DISTINCT guid) AS unique_users
    FROM spectrum_comscore.clickstream_ca
    GROUP BY 1, 2
),

total_output AS (
    SELECT 
        total_genpop.join_field_a,
        total_genpop.join_field_b,
        total_genpop.unique_users AS total_genpop,
        total_intenders.unique_users AS total_intenders,
        total_converters.unique_users AS total_converters
    FROM 
    total_genpop 
    INNER JOIN total_intenders  ON total_genpop.join_field_a = total_intenders.join_field_a AND total_genpop.join_field_b = total_intenders.join_field_b
    INNER JOIN total_converters ON total_genpop.join_field_a = total_converters.join_field_a AND total_genpop.join_field_b = total_converters.join_field_b
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
),

ref_converters AS (
    SELECT COUNT(DISTINCT guid) AS unique_users
    FROM unique_converter_data
    WHERE ( (calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound)) 
)

-- *********************************************************************************************
--  OUTPUT
-- *********************************************************************************************

SELECT
    total_output.join_field_a AS year,
    total_output.join_field_b AS month,
    total_output.total_genpop AS total_genpop,
    total_output.total_intenders AS total_intenders,
    total_output.total_converters AS total_converters,
    ref_genpop.unique_users AS ref_genpop,
    ref_intenders.unique_users AS ref_intenders,
    ref_converters.unique_users AS ref_converters
FROM total_output
CROSS JOIN ref_genpop
CROSS JOIN ref_intenders
CROSS JOIN ref_converters

LIMIT 10000;