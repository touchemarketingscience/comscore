WITH 

date_lower_bound AS (SELECT '2021-01-01' AS value),
date_upper_bound AS (SELECT '2022-12-31' AS value),

unique_intender_data AS (
    SELECT 
    calendar_date,
    event_time,
    event_detail,
    domain,
    guid,
    (CASE
    WHEN event_detail LIKE '%vacations.aircanada.c%' THEN 'Air Canada Vacations'
    WHEN event_detail LIKE '%aircanada.c%' THEN 'Air Canada Airlines'
    WHEN event_detail LIKE '%westjet.c%' AND event_detail LIKE '%vacations%' THEN 'WestJet Vacations'
    WHEN event_detail LIKE '%westjet.c%' THEN 'WestJet Airlines'
    WHEN event_detail LIKE '%flyporter.c%' OR domain LIKE '%flyporter.c%' THEN 'Porter Airlines'
    WHEN event_detail LIKE '%airtransat.c%' OR domain LIKE '%airtransat.c%' THEN 'Air Transat'
    WHEN event_detail LIKE '%flyflair.c.c%' OR domain LIKE '%flyflair.c%' THEN 'Flair Airlines'
    WHEN event_detail LIKE '%emirates.c%' OR domain LIKE '%emirates.c%' THEN 'Emirates Airlines'
    WHEN event_detail LIKE '%airfrance.c%' OR domain LIKE '%airfrance.c%' THEN 'Air France'
    WHEN event_detail LIKE '%fijiairways.c%' OR domain LIKE '%fijiairways.c%' THEN 'Fiji Airways'
    WHEN event_detail LIKE '%qatarairways.c%' OR domain LIKE '%qatarairways.c%' THEN 'Qatar Airways'
    WHEN event_detail LIKE '%turkishairlines.c%' OR domain LIKE '%turkishairlines.c%' THEN 'Turkish Airlines'
    WHEN event_detail LIKE '%flylynx.c%' OR domain LIKE '%flylynx.c%' THEN 'Lynx Airlines'
    WHEN event_detail LIKE '%sunwing.c%' OR domain LIKE '%sunwing.c%' THEN 'Sunwing Airlines'
    ELSE domain
    END) AS domain_group
    FROM spectrum_comscore.clickstream_ca
    WHERE ((calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound))
    AND ( -- INTENDER LOGIC
            (event_detail LIKE '%vacations.aircanada.c%') OR
            (event_detail LIKE '%aircanada.c%') OR
            (event_detail LIKE '%westjet.c%' AND event_detail LIKE '%vacations%') OR
            (event_detail LIKE '%westjet.c%') OR
            (event_detail LIKE '%flyporter.c%' OR domain LIKE '%flyporter.c%') OR
            (event_detail LIKE '%airtransat.c%' OR domain LIKE '%airtransat.c%') OR
            (event_detail LIKE '%flyflair.c%' OR domain LIKE '%flyflair.c%') OR
            (event_detail LIKE '%emirates.c%' OR domain LIKE '%emirates.c%') OR
            (event_detail LIKE '%airfrance.c%' OR domain LIKE '%airfrance.c%') OR
            (event_detail LIKE '%fijiairways.c%' OR domain LIKE '%fijiairways.c%') OR
            (event_detail LIKE '%qatarairways.c%' OR domain LIKE '%qatarairways.c%') OR
            (event_detail LIKE '%turkishairlines.c%' OR domain LIKE '%turkishairlines.c%') OR
            (event_detail LIKE '%flylynx.c%' OR domain LIKE '%flylynx.c%') OR
            (event_detail LIKE '%sunwing.c%' OR domain LIKE '%sunwing.c%')
        )
),

unique_converter_data AS (
    SELECT 
    calendar_date,
    event_time,
    event_detail,
    domain,
    guid,
    domain_group
    FROM unique_intender_data
    WHERE ((calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound))
    AND ( -- CONVERTER
            ((event_detail LIKE '%vacations.aircanada.c%') AND (event_detail LIKE '%book%')) OR
            ((event_detail LIKE '%aircanada.c%') AND (event_detail LIKE '%book%')) OR
            ((event_detail LIKE '%westjet.c%' AND event_detail LIKE '%vacations%') AND (event_detail LIKE '%book%')) OR
            ((event_detail LIKE '%westjet.c%') AND (event_detail LIKE '%book%')) OR
            ((event_detail LIKE '%flyporter.c%' OR domain LIKE '%flyporter.c%') AND (event_detail LIKE '%book%')) OR
            ((event_detail LIKE '%airtransat.c%' OR domain LIKE '%airtransat.c%') AND (event_detail LIKE '%book%')) OR
            ((event_detail LIKE '%flyflair.c%' OR domain LIKE '%flyflair.c%') AND (event_detail LIKE '%book%')) OR
            ((event_detail LIKE '%emirates.c%' OR domain LIKE '%emirates.c%') AND (event_detail LIKE '%fly2%')) OR
            ((event_detail LIKE '%airfrance.c%' OR domain LIKE '%airfrance.c%') AND (event_detail LIKE '%exchange%')) OR
            ((event_detail LIKE '%fijiairways.c%' OR domain LIKE '%fijiairways.c%') AND (event_detail LIKE '%book%')) OR
            ((event_detail LIKE '%qatarairways.c%' OR domain LIKE '%qatarairways.c%') AND (event_detail LIKE '%book%')) OR
            ((event_detail LIKE '%turkishairlines.c%' OR domain LIKE '%turkishairlines.c%') AND (event_detail LIKE '%book%')) OR
            ((event_detail LIKE '%flylynx.c%' OR domain LIKE '%flylynx.c%') AND (event_detail LIKE '%payment%')) OR
            ((event_detail LIKE '%sunwing.c%' OR domain LIKE '%sunwing.c%') AND (event_detail LIKE '%book%'))
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
),

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