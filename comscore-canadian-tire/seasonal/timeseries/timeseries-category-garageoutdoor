WITH
date_lower_bound AS (SELECT '2022-11-16' AS value),
date_upper_bound AS (SELECT '2023-10-31' AS value)
SELECT
calendar_date,
date_part(quarter, calendar_date) as quarter,
date_part(year, calendar_date) as year,
COUNT(distinct guid) as unique_users
FROM spectrum_comscore.clickstream_ca
WHERE
    ((calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound))
AND ((domain = 'canadiantire.ca' 	OR domain = 'canadiantire.com')
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
    OR (domain = 'dollarama.com' 	OR domain = 'dollarama.ca'))
AND (LOWER(event_detail) LIKE '%outdoor%' OR 
    LOWER(event_detail) LIKE '%terrasse%' OR
    LOWER(event_detail) LIKE '%bbq%' OR 
    LOWER(event_detail) LIKE '%grill%' OR 
    LOWER(event_detail) LIKE '%gazebo%' OR 
    LOWER(event_detail) LIKE '%deck%' OR 
    LOWER(event_detail) LIKE '%pool%' OR 
    LOWER(event_detail) LIKE '%swim%' OR 
    LOWER(event_detail) LIKE '%spa%' OR 
    LOWER(event_detail) LIKE '%patio%' OR
    LOWER(event_detail) LIKE '%barbecue%' OR
    LOWER(event_detail) LIKE '%barbeque%' OR
    LOWER(event_detail) LIKE '%garage%' OR 
    LOWER(event_detail) LIKE '%outdoor-living%')
group by 1, 2, 3
LIMIT 10000;