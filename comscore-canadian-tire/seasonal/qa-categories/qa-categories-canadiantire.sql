WITH 
year_lower_bound AS (SELECT 2022 AS value),
year_upper_bound AS (SELECT 2023 AS value),
comscore_filtered_intenders AS (
    SELECT 
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
        END) AS competitor,
        event_detail,
        event_detail2,
        COUNT (DISTINCT guid) as unique_users
    FROM spectrum_comscore.clickstream_ca
    WHERE (date_part(year, calendar_date) >= (SELECT value FROM year_lower_bound) AND date_part(year, calendar_date) <= (SELECT value FROM year_upper_bound)) 
        AND (domain = 'canadiantire.ca' OR domain = 'canadiantire.com')
        GROUP BY 1, 2, 3
    ORDER BY 4 DESC
)
SELECT * FROM comscore_filtered_intenders
LIMIT 10000000;