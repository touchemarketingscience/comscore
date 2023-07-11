WITH 

date_lower_bound AS (SELECT '2019-01-01' AS value),
date_upper_bound AS (SELECT '2023-03-31' AS value),

unique_intender_data AS (
    SELECT 
    calendar_date,
    guid
    FROM spectrum_comscore.clickstream_ca
    WHERE ( (calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound)) AND ( -- INTENDER LOGIC
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
        date_part(month, calendar_date) AS join_field_b,
        COUNT(DISTINCT guid) AS unique_users
    FROM unique_intender_data
    GROUP BY 1, 2
),

total_genpop AS (
     SELECT
        date_part(year, calendar_date) AS join_field_a,
        date_part(month, calendar_date) AS join_field_b,
        COUNT(DISTINCT guid) AS unique_users
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
    total_output.join_field_a AS year,
    total_output.join_field_b AS month,
    total_output.total_intenders AS total_intenders,
    total_output.total_genpop AS total_genpop,
    ref_genpop.unique_users AS ref_genpop,
    ref_intenders.unique_users AS ref_intenders
FROM total_output
CROSS JOIN ref_genpop
CROSS JOIN ref_intenders

LIMIT 10000;