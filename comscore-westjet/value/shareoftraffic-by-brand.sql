WITH 

date_lower_bound AS (SELECT '2019-01-01' AS value),
date_upper_bound AS (SELECT '2023-03-31' AS value),

unique_intender_data AS (
    SELECT 
    calendar_date,
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
    WHERE ( (calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound))  AND ( -- INTENDER LOGIC
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

-- *********************************************************************************************
--  MAIN TABLES
-- *********************************************************************************************

total_intenders AS (
    SELECT
        date_part(year, calendar_date) AS join_field_a,
        domain_group AS join_field_b,
        COUNT(guid) AS unique_users
    FROM unique_intender_data
    GROUP BY 1, 2
),

total_genpop AS (
     SELECT
        date_part(year, calendar_date) AS join_field_a,
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
    END) AS join_field_b,
        COUNT(guid) AS unique_users
    FROM spectrum_comscore.clickstream_ca
    GROUP BY 1, 2
),

total_output AS (
    SELECT 
        a.join_field_a,
        a.join_field_b,
        a.unique_users AS total_intenders,
        b.unique_users AS total_genpop
    FROM total_intenders AS a INNER JOIN total_genpop AS b ON a.join_field_a = b.join_field_a AND a.join_field_b = b.join_field_b
),


-- *********************************************************************************************
--  INDEX REFERENCE COLUMNS
-- *********************************************************************************************

ref_genpop AS (
    SELECT COUNT(DISTINCT guid) AS unique_users
    FROM spectrum_comscore.clickstream_ca
   WHERE ( (calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound)) 
),

ref_intenders AS (
    SELECT COUNT(DISTINCT guid) AS unique_users
    FROM unique_intender_data
    WHERE ( (calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound)) 
)

-- *********************************************************************************************
--  OUTPUT
-- *********************************************************************************************

SELECT

    a.join_field_a          AS year,
    a.join_field_b          AS domain_group,
    a.total_intenders       AS total_intenders,
    a.total_genpop          AS total_genpop,
    b.unique_users          AS ref_intenders,
    c.unique_users          AS ref_genpop

FROM        total_output    AS a
CROSS JOIN  ref_intenders   AS b
CROSS JOIN  ref_genpop      AS c

ORDER BY 3 DESC, 1 ASC
LIMIT 10000;
