WITH 

date_lower_bound AS (SELECT '2021-01-01' AS value),
date_upper_bound AS (SELECT '2022-12-31' AS value),

unique_intender_data AS (
    SELECT 
    calendar_date,
    event_time,
    event_detail,
    time_spent,
    domain,
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
    WHERE ((calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound))
    AND ( -- INTENDER LOGIC
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
    event_time,
    event_detail,
    time_spent,
    domain,
    guid,
    domain_group
    FROM unique_intender_data
    WHERE ((calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound))
    AND
        (  -- CONVERTER LOGIC
               event_detail LIKE '%checkout%' 
            OR event_detail LIKE '%commande%'
            OR event_detail LIKE '%payment%'
            OR event_detail LIKE '%caisse%'
        )
),

unique_locator_data AS (
    SELECT 
    calendar_date,
    event_time,
    event_detail,
    time_spent,
    domain,
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
    WHERE ((calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound))
    AND ( -- LOCATOR LOGIC
            ((domain LIKE '%canadiantire.ca%' OR event_detail LIKE '%canadiantire.ca%') AND (event_detail LIKE '%store-locator%' OR event_detail LIKE '%localisateur-de-magasin%'))
            OR ((domain LIKE '%amazon.ca%'  OR event_detail LIKE '%amazon.ca%') AND (event_detail LIKE '%store-locator%' OR event_detail LIKE '%localisateur-de-magasin%'))
            OR ((domain LIKE '%walmart.ca%' OR event_detail LIKE '%walmart.ca%') AND (event_detail LIKE '%stores-near-me%' OR event_detail LIKE  '%magasin%'))
            OR ((domain LIKE '%bestbuy.ca%' OR event_detail LIKE '%bestbuy.ca%') AND (event_detail LIKE '%stores.bestbuy.ca/en-ca/search%' OR event_detail LIKE '%stores.bestbuy.ca/fr-ca/chercher%'))
            OR ((domain LIKE '%wayfair.ca%' OR event_detail LIKE '%wayfair.ca%') AND (event_detail LIKE '%wayfair-locations%'))
            OR ((domain LIKE '%ikea.com%' OR event_detail LIKE '%ikea.com%') AND (event_detail LIKE '%ikea.com/ca/en/stores%' OR event_detail LIKE '%ikea.com/ca/fr/stores%'))
            OR ((domain LIKE '%homesense.ca%' OR event_detail LIKE '%homesense.ca%') AND (event_detail LIKE '%en/storelocator%' OR event_detail LIKE '%fr/storelocator%'))
            OR ((domain LIKE '%winners.ca%' OR event_detail LIKE '%winners.ca%') AND (event_detail LIKE '%en/storelocator%' OR event_detail LIKE '%fr/storelocator%'))
            OR ((domain LIKE '%thebay.com%' OR event_detail LIKE '%thebay.com%') AND (event_detail LIKE '%locations.thebay.com/en-ca%'))
            OR ((domain LIKE '%labaie.com%' OR event_detail LIKE '%labaie.com%') AND (event_detail LIKE '%locations.labaie.com/fr-ca%'))
            OR ((domain LIKE '%marshalls.ca%' OR event_detail LIKE '%marshalls.ca%') AND (event_detail LIKE '%storelocator%'))
            OR ((domain LIKE '%homehardware.ca%' OR event_detail LIKE '%homehardware.ca%') AND (event_detail LIKE '%store-locator%' OR event_detail LIKE '%localisateur-de-magasin%'))
            OR ((domain LIKE '%homedepot.ca%' OR event_detail LIKE '%homedepot.ca%') AND (event_detail LIKE '%stores.homedepot.ca%' OR event_detail LIKE '%magasins%'))
            OR ((domain LIKE '%rona.ca%' OR event_detail LIKE '%rona.ca%') AND (event_detail LIKE '%StoreListDisplay%'))
            OR ((domain LIKE '%lowes.ca%' OR event_detail LIKE '%lowes.ca%') AND (event_detail LIKE '%lowes.ca/stores%'))
            OR ((domain LIKE '%renodepot.com%' OR event_detail LIKE '%renodepot.com%') AND (event_detail LIKE '%find-a-warehouse%' OR event_detail LIKE '%trouver-magasin-entrepot%'))
            OR ((domain LIKE '%costco.ca%' OR event_detail LIKE '%costco.ca%') AND (event_detail LIKE '%warehouse-locations%'))
            OR ((domain LIKE '%dollarama.com%' OR event_detail LIKE '%dollarama.com%') AND (event_detail LIKE '%en-CA/locations%' OR event_detail LIKE '%fr-CA/localisateur%'))
        )
),

-- *********************************************************************************************
--  GUID LIST
-- *********************************************************************************************
intender_list AS (
    SELECT DISTINCT guid FROM unique_intender_data
),

converter_list AS (
    SELECT DISTINCT guid FROM unique_converter_data
),

locator_list AS (
    SELECT DISTINCT guid FROM unique_locator_data
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
    FROM intender_list
),

ref_converters AS (
    SELECT COUNT(DISTINCT guid) AS unique_users
    FROM converter_list
),

ref_locators AS (
    SELECT COUNT(DISTINCT guid) AS unique_users
    FROM locator_list
),

timespent_per_user_per_domain AS (
SELECT 
    unique_intender_data.domain_group AS competitor,
    unique_intender_data.guid AS guid,
    AVG(COALESCE(unique_intender_data.time_spent, 0)) AS avg_time_spent
FROM unique_intender_data
GROUP BY competitor, guid
)

SELECT
    competitor,
    AVG(avg_time_spent) AS avg_time_spent_per_user
FROM timespent_per_user_per_domain
GROUP BY competitor


LIMIT 500000;