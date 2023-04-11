WITH 

year_lower_bound AS (SELECT 2022 AS value),
year_upper_bound AS (SELECT 2022 AS value),

unique_intender_data AS (
    SELECT 
    calendar_date,
    guid,
    (CASE
    WHEN (domain LIKE '%canadiantire.ca%') THEN 'Canadian Tire'
    WHEN (domain LIKE '%walmart.ca%') THEN 'Walmart'
    WHEN (domain LIKE '%amazon%' OR domain LIKE '%amzn%') THEN 'Amazon'
    WHEN (domain LIKE '%costco.ca%') THEN 'Costco'
    WHEN (domain LIKE '%sobeys.com%') THEN 'Sobeys'
    WHEN (domain LIKE 'petland.c%') THEN 'Pet Land'
    WHEN (domain LIKE '%petvalu.c%') THEN 'Pet Valu'
    WHEN (domain LIKE '%petsmart.c%') THEN 'Pet Smart'
    WHEN (domain LIKE '%baileyblu.com%') THEN 'Bailey Blu'
    WHEN (domain LIKE 'chico.c%') OR domain LIKE '%boutiquedanimauxchico.com%' THEN 'Chico'
    WHEN (domain LIKE 'mondou.c%') THEN 'Mondou'
    WHEN (domain LIKE '%pattesgriffes.com%') THEN 'Pattes Griffes'
    WHEN (domain LIKE '%tailblazerspets.com%') THEN 'Tail Blazers'
    WHEN (domain LIKE 'wbu.c%') THEN 'Wild Birds Unlimited'
    ELSE domain
    END) AS domain_group
    FROM spectrum_comscore.clickstream_ca
    WHERE (date_part(year, calendar_date) >= (SELECT value FROM year_lower_bound) AND date_part(year, calendar_date) <= (SELECT value FROM year_upper_bound)) AND
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

total_intenders AS (
    SELECT
        date_part(year, calendar_date) AS join_field_a,
        domain_group AS join_field_b,
        COUNT(DISTINCT guid) AS unique_users
    FROM unique_intender_data
    GROUP BY 1, 2
),

total_genpop AS (
     SELECT
        date_part(year, calendar_date) AS join_field_a,
        (CASE
        WHEN (domain LIKE '%canadiantire.ca%') THEN 'Canadian Tire'
        WHEN (domain LIKE '%walmart.ca%') THEN 'Walmart'
        WHEN (domain LIKE '%amazon%' OR domain LIKE '%amzn%') THEN 'Amazon'
        WHEN (domain LIKE '%costco.ca%') THEN 'Costco'
        WHEN (domain LIKE '%sobeys.com%') THEN 'Sobeys'
        WHEN (domain LIKE 'petland.c%') THEN 'Pet Land'
        WHEN (domain LIKE '%petvalu.c%') THEN 'Pet Valu'
        WHEN (domain LIKE '%petsmart.c%') THEN 'Pet Smart'
        WHEN (domain LIKE '%baileyblu.com%') THEN 'Bailey Blu'
        WHEN (domain LIKE 'chico.c%') OR domain LIKE '%boutiquedanimauxchico.com%' THEN 'Chico'
        WHEN (domain LIKE 'mondou.c%') THEN 'Mondou'
        WHEN (domain LIKE '%pattesgriffes.com%') THEN 'Pattes Griffes'
        WHEN (domain LIKE '%tailblazerspets.com%') THEN 'Tail Blazers'
        WHEN (domain LIKE 'wbu.c%') THEN 'Wild Birds Unlimited'
        ELSE domain
        END
        ) AS join_field_b,
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
    WHERE (date_part(year, calendar_date) >= (SELECT value FROM year_lower_bound) AND date_part(year, calendar_date) <= (SELECT value FROM year_upper_bound))
),

ref_intenders AS (
    SELECT COUNT(DISTINCT guid) AS unique_users
    FROM unique_intender_data
    WHERE (date_part(year, calendar_date) >= (SELECT value FROM year_lower_bound) AND date_part(year, calendar_date) <= (SELECT value FROM year_upper_bound))
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