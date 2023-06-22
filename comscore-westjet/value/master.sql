WITH 

date_lower_bound AS (SELECT '2021-01-01' AS value),
date_upper_bound AS (SELECT '2022-12-31' AS value),

unique_intender_data AS (
    SELECT 
    calendar_date,
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
    event_detail,
    domain,
    guid,
    domain_group
    FROM unique_intender_data
    WHERE ((calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound))
    AND ( -- INTENDER LOGIC
            ((event_detail LIKE '%vacations.aircanada.c%') AND (event_detail LIKE '%book%')) OR
            ((event_detail LIKE '%aircanada.c%') AND (event_detail LIKE '%farereview%')) OR
            ((event_detail LIKE '%westjet.c%' AND event_detail LIKE '%vacations%') AND (event_detail LIKE '%book%' AND event_detail LIKE '%verif%')) OR
            ((event_detail LIKE '%westjet.c%') AND (event_detail LIKE '%book%' AND event_detail LIKE '%verif%')) OR
            ((event_detail LIKE '%flyporter.c%' OR domain LIKE '%flyporter.c%') AND (event_detail LIKE '%book%')) OR
            ((event_detail LIKE '%airtransat.c%' OR domain LIKE '%airtransat.c%') AND (event_detail LIKE '%bookings%')) OR
            ((event_detail LIKE '%flyflair.c%' OR domain LIKE '%flyflair.c%') AND (event_detail LIKE '%booking%')) OR
            ((event_detail LIKE '%emirates.c%' OR domain LIKE '%emirates.c%') AND (event_detail LIKE '%fly2%')) OR
            ((event_detail LIKE '%airfrance.c%' OR domain LIKE '%airfrance.c%') AND (event_detail LIKE '%checkout%')) OR
            ((event_detail LIKE '%fijiairways.c%' OR domain LIKE '%fijiairways.c%') AND (event_detail LIKE '%booking%')) OR
            ((event_detail LIKE '%qatarairways.c%' OR domain LIKE '%qatarairways.c%') AND (event_detail LIKE '%booking.q%')) OR
            ((event_detail LIKE '%turkishairlines.c%' OR domain LIKE '%turkishairlines.c%') AND (event_detail LIKE '%booking%')) OR
            ((event_detail LIKE '%flylynx.c%' OR domain LIKE '%flylynx.c%') AND (event_detail LIKE '%passengers%')) OR
            ((event_detail LIKE '%sunwing.c%' OR domain LIKE '%sunwing.c%') AND (event_detail LIKE '%book%' AND event_detail LIKE '%verif%'))
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
--  TOTAL locators, CONVERTERS, LOCATORS, GENPOP
-- *********************************************************************************************
total_intenders AS (
    SELECT
        domain_group AS join_field_a,
        COUNT(DISTINCT guid) AS unique_users
    FROM unique_intender_data
    WHERE ((calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound)) 
    GROUP BY 1
),

total_converters AS (
    SELECT
        domain_group AS join_field_a,
        COUNT(DISTINCT guid) AS unique_users
    FROM unique_converter_data
    WHERE ((calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound))
    GROUP BY 1
),

total_genpop AS (
     SELECT
        (CASE
        WHEN event_detail LIKE '%vacations.aircanada.c%' THEN 'Air Canada Vacations'
        WHEN event_detail LIKE '%aircanada.c%' THEN 'Air Canada Airlines'
        WHEN event_detail LIKE '%westjet.c%' AND event_detail LIKE '%vacations%' THEN 'WestJet Vacations'
        WHEN event_detail LIKE '%westjet.c%' THEN 'WestJet Airlines'
        WHEN event_detail LIKE '%flyporter.c%' OR domain LIKE '%flyporter.c%' THEN 'Porter Airlines'
        WHEN event_detail LIKE '%airtransat.c%' OR domain LIKE '%airtransat.c%' THEN 'Air Transat'
        WHEN event_detail LIKE '%flyflair.c%' OR domain LIKE '%flyflair.c%' THEN 'Flair Airlines'
        WHEN event_detail LIKE '%emirates.c%' OR domain LIKE '%emirates.c%' THEN 'Emirates Airlines'
        WHEN event_detail LIKE '%airfrance.c%' OR domain LIKE '%airfrance.c%' THEN 'Air France'
        WHEN event_detail LIKE '%fijiairways.c%' OR domain LIKE '%fijiairways.c%' THEN 'Fiji Airways'
        WHEN event_detail LIKE '%qatarairways.c%' OR domain LIKE '%qatarairways.c%' THEN 'Qatar Airways'
        WHEN event_detail LIKE '%turkishairlines.c%' OR domain LIKE '%turkishairlines.c%' THEN 'Turkish Airlines'
        WHEN event_detail LIKE '%flylynx.c%' OR domain LIKE '%flylynx.c%' THEN 'Lynx Airlines'
        WHEN event_detail LIKE '%sunwing.c%' OR domain LIKE '%sunwing.c%' THEN 'Sunwing Airlines'
        ELSE domain
        END) AS join_field_a,
        COUNT(DISTINCT guid) AS unique_users
    FROM spectrum_comscore.clickstream_ca 
    WHERE ((calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound)) 
    GROUP BY 1
),

-- *********************************************************************************************
--  MAIN OUTPUT DATA
-- *********************************************************************************************

total_output AS (
    SELECT 
        total_intenders.join_field_a    AS join_field_a,
        total_intenders.unique_users    AS total_intenders,
        total_converters.unique_users   AS total_converters,
        total_genpop.unique_users       AS total_genpop
    FROM total_intenders
    LEFT JOIN total_genpop          ON total_intenders.join_field_a = total_genpop.join_field_a
    LEFT JOIN total_converters      ON total_intenders.join_field_a = total_converters.join_field_a
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
-- *********************************************************************************************
--  OUTPUT
-- *********************************************************************************************

SELECT
    total_output.join_field_a           AS domain_group,

    total_output.total_intenders        AS total_intenders,
    total_output.total_converters       AS total_converters,
    total_output.total_genpop           AS total_genpop,

    ref_intenders.unique_users          AS ref_intenders,
    ref_converters.unique_users         AS ref_converters,
    ref_genpop.unique_users             AS ref_genpop

FROM        total_output
CROSS JOIN  ref_genpop
CROSS JOIN  ref_intenders
CROSS JOIN  ref_converters

ORDER BY 2 DESC
LIMIT 100000;