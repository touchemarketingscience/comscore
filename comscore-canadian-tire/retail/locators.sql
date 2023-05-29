WITH 

year_lower_bound AS (SELECT 2021 AS value),
year_upper_bound AS (SELECT 2022 AS value),

comscore_filtered_locators AS (
    SELECT 
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
        END) AS competitor,
        event_detail,
        COUNT (DISTINCT guid) as unique_users
    FROM spectrum_comscore.clickstream_ca
    WHERE (date_part(year, calendar_date) >= (SELECT value FROM year_lower_bound) AND date_part(year, calendar_date) <= (SELECT value FROM year_upper_bound)) 
        AND 
        ( -- LOCATOR LOGIC
            -- ((domain LIKE '%canadiantire.ca%' OR event_detail LIKE '%canadiantire.ca%') AND (event_detail LIKE '%store-locator%' OR event_detail LIKE '%localisateur-de-magasin%'))
            -- ((domain LIKE '%amazon.ca%'  OR event_detail LIKE '%amazon.ca%') AND (event_detail LIKE '%store-locator%' OR event_detail LIKE '%localisateur-de-magasin%'))
            -- ((domain LIKE '%walmart.ca%' OR event_detail LIKE '%walmart.ca%') AND (event_detail LIKE '%stores-near-me%' OR event_detail LIKE  %magasin%'))
            -- ((domain LIKE '%bestbuy.ca%' OR event_detail LIKE '%bestbuy.ca%') AND (event_detail LIKE '%stores.bestbuy.ca/en-ca/search%' OR event_detail LIKE '%stores.bestbuy.ca/fr-ca/chercher%'))
            -- ((domain LIKE '%wayfair.ca%' OR event_detail LIKE '%wayfair.ca%') AND (event_detail LIKE '%wayfair-locations%'))
            -- ((domain LIKE '%ikea.com%' OR event_detail LIKE '%ikea.com%') AND (event_detail LIKE '%ikea.com/ca/en/stores%' OR event_detail LIKE '%ikea.com/ca/fr/stores%'))
            -- ((domain LIKE '%homesense.ca%' OR event_detail LIKE '%homesense.ca%') AND (event_detail LIKE '%en/storelocator%' OR event_detail LIKE '%fr/storelocator%'))
            -- ((domain LIKE '%winners.ca%' OR event_detail LIKE '%winners.ca%') AND (event_detail LIKE '%en/storelocator%' OR event_detail LIKE '%fr/storelocator%'))
            -- ((domain LIKE '%thebay.com%' OR event_detail LIKE '%thebay.com%') AND (event_detail LIKE '%locations.thebay.com/en-ca%'))
            -- ((domain LIKE '%labaie.com%' OR event_detail LIKE '%labaie.com%') AND (event_detail LIKE '%locations.labaie.com/fr-ca%'))
            -- ((domain LIKE '%marshalls.ca%' OR event_detail LIKE '%marshalls.ca%') AND (event_detail LIKE '%%' OR event_detail LIKE '%%'))
            ((domain LIKE '%homehardware.ca%' OR event_detail LIKE '%homehardware.ca%') AND (event_detail LIKE '%%' OR event_detail LIKE '%%'))
            -- OR ((domain LIKE '%homedepot.ca%' OR event_detail LIKE '%homedepot.ca%') AND (event_detail LIKE '%%' OR event_detail LIKE '%%'))
            -- OR ((domain LIKE '%rona.ca%' OR event_detail LIKE '%rona.ca%') AND (event_detail LIKE '%%' OR event_detail LIKE '%%'))
            -- OR ((domain LIKE '%lowes.ca%' OR event_detail LIKE '%lowes.ca%') AND (event_detail LIKE '%%' OR event_detail LIKE '%%'))
            -- OR ((domain LIKE '%renodepot.com%' OR event_detail LIKE '%renodepot.com%') AND (event_detail LIKE '%%' OR event_detail LIKE '%%'))
            -- OR ((domain LIKE '%costco.ca%' OR event_detail LIKE '%costco.ca%') AND (event_detail LIKE '%%' OR event_detail LIKE '%%'))
            -- OR ((domain LIKE '%dollarama.com%' OR event_detail LIKE '%dollarama.com%') AND (event_detail LIKE '%%' OR event_detail LIKE '%%'))
        )
    GROUP BY 1, 2
    ORDER BY 3 DESC
)

SELECT * FROM comscore_filtered_locators
LIMIT 10000;
