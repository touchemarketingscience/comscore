WITH 
year_lower_bound AS (SELECT 2022 AS value),
year_upper_bound AS (SELECT 2023 AS value),
comscore_filtered_intenders AS (
    SELECT 
        calendar_date as date,
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
        )    GROUP BY 1
    ORDER BY 1 DESC
)
SELECT * FROM comscore_filtered_intenders
LIMIT 10000;