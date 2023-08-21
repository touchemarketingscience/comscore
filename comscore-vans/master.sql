WITH 
date_lower_bound AS (SELECT '2019-01-01' AS value),
date_upper_bound AS (SELECT '2023-03-31' AS value),
comscore_data AS (
	SELECT 
    date_part(year, calendar_date) AS year,
    date_part(month, calendar_date) AS month,
    COUNT(DISTINCT guid) AS unique_users
    FROM spectrum_comscore.clickstream_ca
    WHERE ((calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound)) 
    GROUP BY 1, 2
),
intender_data AS (
    SELECT 
    date_part(year, calendar_date) AS year,
    date_part(month, calendar_date) AS month,
    COUNT(DISTINCT guid) AS unique_users
    FROM spectrum_comscore.clickstream_ca
    WHERE 
    	((calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound)) 
    -- AND (event_detail2 = 'started_checkout' OR event_detail2 = 'purchase' or event_detail2 = 'converted') 
    -- AND (domain = 'sportchek.ca' OR domain = 'marks.com' OR domain = 'softmoc.com' OR domain = 'canadiantire.ca' OR domain = 'theshoecompany.ca' OR domain = 'sail.ca' OR domain = 'brownsshoes.com' OR	domain = 'thebay.com' OR	domain = 'mountainwarehouse.com' OR	domain = 'kijiji.ca' OR	domain = 'dsw.ca' OR	domain = 'altitude-sports.com' OR	domain = 'mec.ca' OR	domain = 'yellowshoes.com' OR	domain = 'columbiasportswear.ca' OR	domain = 'sportinglife.ca' OR	domain = 'walmart.ca' OR	domain = 'sorelfootwear.ca' OR	domain = 'merrell.com' OR	domain = 'atmosphere.ca' OR	domain = 'timberland.ca' OR	domain = 'globoshoes.com' OR	domain = 'sportsexperts.ca' OR	domain = 'rubinoshoes.com' OR	domain = 'burton.com' OR	domain = 'bogsfootwear.ca' OR	domain = 'naturalizer.ca' OR	domain = 'littleburgundyshoes.com' OR	domain = 'nationalsports.com' OR	domain = 'thenorthface.com' OR	domain = 'cabelas.ca' OR	domain = 'ladernierechasse.com' OR	domain = 'vans.ca' OR	domain = 'kamik.com' OR	domain = 'costco.ca' OR	domain = 'svpsports.ca' OR	domain = 'snowshoemag.com' OR	domain = 'dcshoes.com' OR	domain = 'rei.com' OR	domain = 'hunterboots.com' OR	domain = 'outdoorgearlab.com' OR	domain = 'evo.com' OR	domain = 'lequipeur.com' OR	domain = 'gearjunkie.com' OR	domain = 'gvsnowshoes.com' OR	domain = 'cypressmountain.com' OR	domain = 'zulily.com' OR	domain = 'salomon.com' OR	domain = 'prfo.com')
	AND (event_detail like '%boot%' or event_detail LIKE '%shoe%') and (event_detail like '%winter%' or event_detail like '%snow%')
    GROUP BY 1, 2
),
intender_list AS (
    SELECT 
    DISTINCT guid
    FROM spectrum_comscore.clickstream_ca
    WHERE 
    	((calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound)) 
    AND (event_detail like '%boot%' or event_detail LIKE '%shoe%') and (event_detail like '%winter%' or event_detail like '%snow%')
),
converter_data AS (
	SELECT 
    date_part(year, calendar_date) AS year,
    date_part(month, calendar_date) AS month,
    COUNT(DISTINCT guid) AS unique_users
    FROM spectrum_comscore.clickstream_ca
    WHERE 
    	((calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound)) 
    AND (event_detail2 = 'started_checkout' OR event_detail2 = 'purchase' or event_detail2 = 'converted') 
    AND (domain = 'sportchek.ca' OR domain = 'marks.com' OR domain = 'softmoc.com' OR domain = 'canadiantire.ca' OR domain = 'theshoecompany.ca' OR domain = 'sail.ca' OR domain = 'brownsshoes.com' OR	domain = 'thebay.com' OR	domain = 'mountainwarehouse.com' OR	domain = 'kijiji.ca' OR	domain = 'dsw.ca' OR	domain = 'altitude-sports.com' OR	domain = 'mec.ca' OR	domain = 'yellowshoes.com' OR	domain = 'columbiasportswear.ca' OR	domain = 'sportinglife.ca' OR	domain = 'walmart.ca' OR	domain = 'sorelfootwear.ca' OR	domain = 'merrell.com' OR	domain = 'atmosphere.ca' OR	domain = 'timberland.ca' OR	domain = 'globoshoes.com' OR	domain = 'sportsexperts.ca' OR	domain = 'rubinoshoes.com' OR	domain = 'burton.com' OR	domain = 'bogsfootwear.ca' OR	domain = 'naturalizer.ca' OR	domain = 'littleburgundyshoes.com' OR	domain = 'nationalsports.com' OR	domain = 'thenorthface.com' OR	domain = 'cabelas.ca' OR	domain = 'ladernierechasse.com' OR	domain = 'vans.ca' OR	domain = 'kamik.com' OR	domain = 'costco.ca' OR	domain = 'svpsports.ca' OR	domain = 'snowshoemag.com' OR	domain = 'dcshoes.com' OR	domain = 'rei.com' OR	domain = 'hunterboots.com' OR	domain = 'outdoorgearlab.com' OR	domain = 'evo.com' OR	domain = 'lequipeur.com' OR	domain = 'gearjunkie.com' OR	domain = 'gvsnowshoes.com' OR	domain = 'cypressmountain.com' OR	domain = 'zulily.com' OR	domain = 'salomon.com' OR	domain = 'prfo.com')
	AND guid IN (SELECT guid FROM intender_list)
    GROUP BY 1, 2
),
full_data AS (
	SELECT 
	comscore_data.year AS year,
	comscore_data.month AS month,
	comscore_data.unique_users AS audience_genpop,
	intender_data.unique_users AS audience_intender,
	converter_data.unique_users AS audience_converter
	FROM comscore_data
	LEFT JOIN intender_data
	ON  comscore_data.year  = intender_data.year
	AND comscore_data.month = intender_data.month
	LEFT JOIN converter_data
	ON  comscore_data.year  = converter_data.year
	AND comscore_data.month = converter_data.month
)
SELECT * FROM full_data LIMIT 100000;
