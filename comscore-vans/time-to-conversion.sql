WITH 
date_lower_bound AS (SELECT '2021-01-01' AS value),
date_upper_bound AS (SELECT '2023-03-31' AS value),
-- *********************************************************************************************
--  GUID LIST
-- *********************************************************************************************
unique_intender_data AS (
    SELECT 
    guid,
    calendar_date
    FROM spectrum_comscore.clickstream_ca
    WHERE ((calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound)) 
    AND (event_detail like '%boot%' or event_detail LIKE '%shoe%') and (event_detail like '%winter%' or event_detail like '%snow%')
),
intender_list AS (
    SELECT 
    DISTINCT guid
    FROM unique_intender_data
),
unique_converter_data AS (
   	SELECT 
    guid,
    calendar_date
    FROM spectrum_comscore.clickstream_ca
    WHERE ((calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound)) 
    AND (event_detail2 = 'started_checkout' OR event_detail2 = 'purchase' or event_detail2 = 'converted') 
    AND (domain = 'sportchek.ca' OR domain = 'marks.com' OR domain = 'softmoc.com' OR domain = 'canadiantire.ca' OR domain = 'theshoecompany.ca' OR domain = 'sail.ca' OR domain = 'brownsshoes.com' OR	domain = 'thebay.com' OR	domain = 'mountainwarehouse.com' OR	domain = 'kijiji.ca' OR	domain = 'dsw.ca' OR	domain = 'altitude-sports.com' OR	domain = 'mec.ca' OR	domain = 'yellowshoes.com' OR	domain = 'columbiasportswear.ca' OR	domain = 'sportinglife.ca' OR	domain = 'walmart.ca' OR	domain = 'sorelfootwear.ca' OR	domain = 'merrell.com' OR	domain = 'atmosphere.ca' OR	domain = 'timberland.ca' OR	domain = 'globoshoes.com' OR	domain = 'sportsexperts.ca' OR	domain = 'rubinoshoes.com' OR	domain = 'burton.com' OR	domain = 'bogsfootwear.ca' OR	domain = 'naturalizer.ca' OR	domain = 'littleburgundyshoes.com' OR	domain = 'nationalsports.com' OR	domain = 'thenorthface.com' OR	domain = 'cabelas.ca' OR	domain = 'ladernierechasse.com' OR	domain = 'vans.ca' OR	domain = 'kamik.com' OR	domain = 'costco.ca' OR	domain = 'svpsports.ca' OR	domain = 'snowshoemag.com' OR	domain = 'dcshoes.com' OR	domain = 'rei.com' OR	domain = 'hunterboots.com' OR	domain = 'outdoorgearlab.com' OR	domain = 'evo.com' OR	domain = 'lequipeur.com' OR	domain = 'gearjunkie.com' OR	domain = 'gvsnowshoes.com' OR	domain = 'cypressmountain.com' OR	domain = 'zulily.com' OR	domain = 'salomon.com' OR	domain = 'prfo.com')
	AND guid IN (SELECT guid FROM intender_list)
),
converter_list AS (
 	SELECT 
    DISTINCT guid
    FROM unique_converter_data
),
-- *********************************************************************************************
--  TTC Tables
-- *********************************************************************************************
first_appearance_of_intenders AS (
    SELECT 
        guid,
        MIN(calendar_date) as first_appearance_date
    FROM unique_intender_data
    GROUP BY guid
),
first_appearance_of_converters AS (
    SELECT 
        guid,
        MIN(calendar_date) as first_conversion_date
    FROM unique_converter_data
    GROUP BY guid
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
)
SELECT 
    first_appearance_of_intenders.guid AS guid,
    first_appearance_of_intenders.first_appearance_date AS first_appearance_date,
    first_appearance_of_converters.first_conversion_date AS first_conversion_date,
    ref_intenders.unique_users AS ref_intenders,
    ref_converters.unique_users AS ref_converters
FROM first_appearance_of_intenders
INNER JOIN first_appearance_of_converters ON first_appearance_of_intenders.guid = first_appearance_of_converters.guid
CROSS JOIN ref_intenders
CROSS JOIN ref_converters
LIMIT 500000;
