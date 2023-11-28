WITH 
date_lower_bound AS (SELECT '2022-11-16' AS value),
date_upper_bound AS (SELECT '2023-10-31' AS value),
unique_intender_data AS (
    SELECT 
    calendar_date,
    guid
    FROM spectrum_comscore.clickstream_ca
    WHERE ( (calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound)) AND
    (
               (domain = 'canadiantire.ca' 	OR domain = 'canadiantire.com')
            OR (domain = 'amazon.ca' 		OR domain = 'amazon.com') 
            OR (domain = 'walmart.ca' 		OR domain = 'walmart.com') 
            OR (domain = 'bestbuy.ca' 		OR domain = 'bestbuy.com')
            OR (domain = 'wayfair.ca' 		OR domain = 'wayfair.com')
            OR (domain = 'ikea.com' 		OR domain = 'ikea.ca')
            OR (domain = 'thebay.com' 		OR domain = 'thebay.ca')
            OR (domain = 'labaie.com' 		OR domain = 'labaie.ca')
            OR (domain = 'homehardware.ca' 	OR domain = 'homehardware.com')
            OR (domain = 'homedepot.ca' 	OR domain = 'homedepot.com')
            OR (domain = 'rona.ca' 			OR domain = 'rona.com')
            OR (domain = 'lowes.ca' 		OR domain = 'lowes.com')
            OR (domain = 'renodepot.com' 	OR domain = 'renodepot.ca')
            OR (domain = 'costco.ca' 		OR domain = 'costco.com')
            OR (domain = 'dollarama.com' 	OR domain = 'dollarama.ca')
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
    total_output.join_field_a AS year,
    total_output.join_field_b AS month,
    total_output.total_intenders AS total_intenders,
    total_output.total_genpop AS total_genpop,
    ref_genpop.unique_users AS ref_genpop,
    ref_intenders.unique_users AS ref_intenders
FROM total_output
CROSS JOIN ref_genpop
CROSS JOIN ref_intenders
LIMIT 10000;