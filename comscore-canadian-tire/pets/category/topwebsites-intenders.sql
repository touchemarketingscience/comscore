WITH unique_intender_data AS (
    SELECT 
    calendar_date,
    zvelo_category,
    guid,
    domain
    FROM spectrum_comscore.clickstream_ca
    WHERE (date_part(year, calendar_date) >= 2021 AND date_part(year, calendar_date) <= 2022) AND
    ((domain LIKE 'petland.c%')
    OR (domain LIKE '%petvalu.c%')
    OR (domain LIKE '%petsmart.c%')
    OR (domain LIKE '%baileyblu.com%')
    OR (domain LIKE 'chico.c%' OR domain LIKE '%boutiquedanimauxchico.com%')
    OR (domain LIKE 'mondou.c%')
    OR (domain LIKE '%pattesgriffes.com%')
    OR (domain LIKE '%tailblazerspets.com%')
    OR (domain LIKE 'wbu.c%') OR
    (domain LIKE '%canadiantire.ca%' AND (event_detail LIKE '%animalerie%' OR event_detail LIKE '%pet-care%')) OR
    (domain LIKE '%walmart.ca%' AND (event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%' OR event_detail LIKE '%pets%' OR event_detail LIKE '%pet-%' OR event_detail LIKE '%pet/%' OR event_detail LIKE '%pet\.%')) OR
    ((domain LIKE '%amazon%' OR domain LIKE '%amzn%') AND (event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%' OR event_detail LIKE '%pets%' OR event_detail LIKE '%pet-%' OR event_detail LIKE '%pet/%' OR event_detail LIKE '%pet\.%')) OR
    (domain LIKE '%costco.ca%' AND (event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%' OR event_detail LIKE '%pets%' OR event_detail LIKE '%pet-%' OR event_detail LIKE '%pet/%' OR event_detail LIKE '%pet\.%')) OR
    (domain LIKE '%sobeys.com%' AND (event_detail LIKE '%animalerie%' OR event_detail LIKE '%pet%')))
),

-- *********************************************************************************************
--  MAIN TABLES
-- *********************************************************************************************

intender_list AS (
    SELECT DISTINCT guid FROM unique_intender_data
),

total_intenders AS (
    SELECT
        domain AS join_field_a,
        COUNT(DISTINCT guid) AS unique_users
    FROM spectrum_comscore.clickstream_ca
    WHERE (date_part(year, calendar_date) >= 2021 AND date_part(year, calendar_date) <= 2022) AND guid IN (
        SELECT guid FROM intender_list
    )
    GROUP BY 1
),

total_genpop AS (
     SELECT
        domain AS join_field_a,
        COUNT(DISTINCT guid) AS unique_users
    FROM spectrum_comscore.clickstream_ca WHERE (date_part(year, calendar_date) >= 2021 AND date_part(year, calendar_date) <= 2022)
    GROUP BY 1
),

total_output AS (
    SELECT 
        a.join_field_a,
        a.unique_users AS total_intenders,
        b.unique_users AS total_genpop
    FROM total_intenders AS a RIGHT JOIN total_genpop AS b ON a.join_field_a = b.join_field_a
),


-- *********************************************************************************************
--  INDEX REFERENCE COLUMNS
-- *********************************************************************************************

ref_genpop AS (
    SELECT COUNT(DISTINCT guid) AS unique_users
    FROM spectrum_comscore.clickstream_ca
    WHERE date_part(year, calendar_date) >= 2021 AND date_part(year, calendar_date) <= 2022
),

ref_intenders AS (
    SELECT COUNT(DISTINCT guid) AS unique_users
    FROM unique_intender_data
    WHERE date_part(year, calendar_date) >= 2021 AND date_part(year, calendar_date) <= 2022
)

-- *********************************************************************************************
--  OUTPUT
-- *********************************************************************************************

SELECT

    a.join_field_a          AS domain_group,
    a.total_intenders       AS total_intenders,
    a.total_genpop          AS total_genpop,
    b.unique_users          AS ref_intenders,
    c.unique_users          AS ref_genpop

FROM        total_output    AS a
CROSS JOIN  ref_intenders   AS b
CROSS JOIN  ref_genpop      AS c

ORDER BY 3 DESC, 1 ASC
LIMIT 10000;


    /*
     -- *** CONVERTER *** --
     AND
     (
     -- (event_detail LIKE '%shopping-cart%')                                   OR
     -- (event_detail LIKE '%/cart%')                                           OR
     -- (event_detail LIKE '%checkout%')                                        OR
     -- (event_detail LIKE '%shop%' AND event_detail LIKE '%cart%')             OR
     -- (event_detail LIKE '%cart%' AND event_detail LIKE '%shop%')             OR
     
     (event_detail LIKE '%history%' AND event_detail LIKE '%order%')         OR
     (event_detail LIKE '%order%' AND event_detail LIKE '%history%')         OR
     (event_detail LIKE '%recent%' AND event_detail LIKE '%order%')          OR
     (event_detail LIKE '%order%' AND event_detail LIKE '%recent%')          OR
     (event_detail LIKE '%account%' AND event_detail LIKE '%order%')         OR 
     (event_detail LIKE '%order%' AND event_detail LIKE '%account%')         
     )
     */