WITH 
date_lower_bound AS (SELECT '2022-11-16' AS value),
date_upper_bound AS (SELECT '2023-02-28' AS value),
non_unique_intender_data AS (
    SELECT 
    calendar_date,
    guid,
    (CASE
    WHEN domain = 'canadiantire.ca' OR domain = 'canadiantire.com' 	THEN 'Canadian Tire'
    WHEN domain = 'amazon.ca' 		OR domain = 'amazon.com' 		THEN 'Amazon'
    WHEN domain = 'walmart.ca' 		OR domain = 'walmart.com' 		THEN 'Walmart'
    WHEN domain = 'bestbuy.ca' 		OR domain = 'bestbuy.com' 		THEN 'Best Buy'
    WHEN domain = 'wayfair.ca' 		OR domain = 'wayfair.com' 		THEN 'Wayfair'
    WHEN domain = 'ikea.com' 		OR domain = 'ikea.ca' 			THEN 'IKEA'
    WHEN domain = 'thebay.com' 		OR domain = 'thebay.ca' 		THEN 'Hudsons Bay'
    WHEN domain = 'labaie.com' 		OR domain = 'labaie.ca' 		THEN 'Hudsons Bay'
    WHEN domain = 'homehardware.ca' OR domain = 'homehardware.com' 	THEN 'Home Hardware'
    WHEN domain = 'homedepot.ca' 	OR domain = 'homedepot.com' 	THEN 'Home Depot'
    WHEN domain = 'rona.ca' 		OR domain = 'rona.com' 			THEN 'Rona'
    WHEN domain = 'lowes.ca' 		OR domain = 'lowes.com' 		THEN 'Lowes'
    WHEN domain = 'renodepot.com' 	OR domain = 'renodepot.ca' 		THEN 'Reno Depot'
    WHEN domain = 'costco.ca' 		OR domain = 'costco.com' 		THEN 'Costco'
    WHEN domain = 'dollarama.com' 	OR domain = 'dollarama.ca' 		THEN 'Dollarama'
    ELSE 'Not Included'
    END) AS domain_group
    FROM spectrum_comscore.clickstream_ca
    WHERE ((calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound))AND
    (          (domain = 'canadiantire.ca' 	OR domain = 'canadiantire.com')
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