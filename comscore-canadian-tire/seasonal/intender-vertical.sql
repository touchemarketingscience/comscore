WITH 
year_lower_bound AS (SELECT 2022 AS value),
year_upper_bound AS (SELECT 2023 AS value),
comscore_filtered_intenders AS (
    SELECT 
        date_part(year, calendar_date) as date_year, 
        (CASE 
        WHEN date_part(month, calendar_date) = 1 THEN 'Winter'
        WHEN date_part(month, calendar_date) = 2 THEN 'Winter'
        WHEN date_part(month, calendar_date) = 3 THEN 'Spring'
        WHEN date_part(month, calendar_date) = 4 THEN 'Spring'
        WHEN date_part(month, calendar_date) = 5 THEN 'Spring'
        WHEN date_part(month, calendar_date) = 6 THEN 'Summer'
        WHEN date_part(month, calendar_date) = 7 THEN 'Summer'
        WHEN date_part(month, calendar_date) = 8 THEN 'Summer'
        WHEN date_part(month, calendar_date) = 9 THEN 'Fall'
        WHEN date_part(month, calendar_date) = 10 THEN 'Fall'
        WHEN date_part(month, calendar_date) = 11 AND date_part(day, calendar_date) <= 15 THEN 'Fall'
        WHEN date_part(month, calendar_date) = 11 AND date_part(day, calendar_date) > 15 THEN 'Winter'
        WHEN date_part(month, calendar_date) = 12 THEN 'Winter'
        END) as date_season,
        (CASE
        WHEN domain = 'canadiantire.ca' THEN 'Canadian Tire'
        WHEN domain = 'amazon.ca' 		THEN 'Amazon'
        WHEN domain = 'walmart.ca' 		THEN 'Walmart'
        WHEN domain = 'bestbuy.ca' 		THEN 'Best Buy'
        WHEN domain = 'wayfair.ca' 		THEN 'Wayfair'
        WHEN domain = 'ikea.com' 		THEN 'IKEA'
        WHEN domain = 'thebay.com' 		THEN 'Hudsons Bay'
        WHEN domain = 'labaie.com' 		THEN 'Hudsons Bay'
        WHEN domain = 'homehardware.ca' THEN 'Home Hardware'
        WHEN domain = 'homedepot.ca' 	THEN 'Home Depot'
        WHEN domain = 'rona.ca' 		THEN 'Rona'
        WHEN domain = 'lowes.ca' 		THEN 'Lowes'
        WHEN domain = 'renodepot.com' 	THEN 'Reno Depot'
        WHEN domain = 'costco.ca' 		THEN 'Costco'
        WHEN domain = 'dollarama.com' 	THEN 'Dollarama'
        ELSE 'Not Included'
        END) AS competitor,
        COUNT (DISTINCT guid) as unique_users
    FROM spectrum_comscore.clickstream_ca
    WHERE (date_part(year, calendar_date) >= (SELECT value FROM year_lower_bound) AND date_part(year, calendar_date) <= (SELECT value FROM year_upper_bound)) 
        AND 
        ( -- INTENDER LOGIC
               (domain = 'canadiantire.ca')
            OR (domain = 'amazon.ca')
            OR (domain = 'walmart.ca')
            OR (domain = 'bestbuy.ca' )
            OR (domain = 'wayfair.ca')
            OR (domain = 'ikea.com')
            OR (domain = 'thebay.com')
            OR (domain = 'labaie.com')
            OR (domain = 'homehardware.ca')
            OR (domain = 'homedepot.ca')
            OR (domain = 'rona.ca')
            OR (domain = 'lowes.ca')
            OR (domain = 'renodepot.com')
            OR (domain = 'costco.ca')
            OR (domain = 'dollarama.com')
        )    GROUP BY 1, 2, 3
    ORDER BY 1 ASC
)
SELECT * FROM comscore_filtered_intenders
LIMIT 10000;