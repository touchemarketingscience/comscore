WITH non_unique_intender_data AS (
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

total_website_visit_count_per_intender_1ONLY AS (
    SELECT
        guid,
        COUNT(DISTINCT domain_group) AS domain_group_count
    FROM non_unique_intender_data
    GROUP BY 1
    HAVING COUNT(DISTINCT domain_group) = 1
),

total_website_visit_count_per_intender_2PLUS AS (
    SELECT
        guid,
        COUNT(DISTINCT domain_group) AS domain_group_count
    FROM non_unique_intender_data
    GROUP BY 1
    HAVING COUNT(DISTINCT domain_group) >= 2
),

total_output_1ONLY AS (
    SELECT 
    domain_group,
    COUNT(DISTINCT guid) AS unique_users
    FROM non_unique_intender_data WHERE guid IN (
        SELECT guid FROM total_website_visit_count_per_intender_1ONLY
    )
    GROUP BY 1
),

total_output_2ONLY AS (
    SELECT 
    domain_group,
    COUNT(DISTINCT guid) AS unique_users
    FROM non_unique_intender_data WHERE guid IN (
        SELECT guid FROM total_website_visit_count_per_intender_2PLUS
    )
    GROUP BY 1
),

total_output AS (
    SELECT
    a.domain_group,
    a.unique_users AS unique_users_1ONLY,
    b.unique_users AS unique_users_2PLUS
    FROM total_output_1ONLY AS a FULL OUTER JOIN total_output_2ONLY AS b ON a.domain_group = b.domain_group
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
    FROM non_unique_intender_data
    WHERE date_part(year, calendar_date) >= 2021 AND date_part(year, calendar_date) <= 2022
)

-- *********************************************************************************************
--  OUTPUT
-- *********************************************************************************************

SELECT
a.domain_group,
a.unique_users_1ONLY,
a.unique_users_2PLUS,
b.unique_users AS ref_intenders,
c.unique_users AS ref_genpop
FROM total_output AS a
CROSS JOIN ref_intenders AS b
CROSS JOIN ref_genpop AS c

LIMIT 10000;