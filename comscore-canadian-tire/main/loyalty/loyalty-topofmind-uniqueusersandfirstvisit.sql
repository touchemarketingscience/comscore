WITH non_unique_intender_data AS (
    SELECT 
    calendar_date,
    event_time,
    guid,
    (CASE
    WHEN (domain LIKE '%canadiantire.ca%') THEN 'Canadian Tire'
    WHEN (domain LIKE '%walmart.ca%') THEN 'Walmart'
    WHEN (domain LIKE '%amazon%') THEN 'Amazon'
    WHEN (domain LIKE '%costco.ca%') THEN 'Costco'
    WHEN (domain LIKE '%sobeys.com%') THEN 'Sobeys'
    WHEN (domain LIKE '%petland.ca%') THEN 'Pet Land'
    WHEN (domain LIKE '%petvalu.ca%') THEN 'Pet Valu'
    WHEN (domain LIKE '%petsmart.ca%') THEN 'Pet Smart'
    WHEN (domain LIKE '%baileyblu.com%') THEN 'Bailey Blu'
    WHEN (domain LIKE '%chico.ca%') THEN 'Chico'
    WHEN (domain LIKE '%mondou.com%') THEN 'Mondou'
    WHEN (domain LIKE '%pattesgriffes.com%') THEN 'Pattes Griffes'
    WHEN (domain LIKE '%tailblazerspets.com%') THEN 'Tail Blazers'
    WHEN (domain LIKE '%wbu.com%') THEN 'Wild Birds Unlimited'
    ELSE domain
    END
    ) AS domain_group
    FROM spectrum_comscore.clickstream_ca
    WHERE (date_part(year, calendar_date) >= 2021 AND date_part(year, calendar_date) <= 2022) AND
    ((domain LIKE '%petland.ca%'
    OR domain LIKE '%petvalu.ca%'
    OR domain LIKE '%petsmart.ca%'
    OR domain LIKE '%baileyblu.com%'
    OR domain LIKE '%chico.ca%'
    OR domain LIKE '%mondou.com%'
    OR domain LIKE '%pattesgriffes.com%'
    OR domain LIKE '%tailblazerspets.com%'
    OR domain LIKE '%wbu.com%') OR
    (domain LIKE '%canadiantire.ca%' AND (event_detail LIKE '%animalerie%' OR event_detail LIKE '%pet-care%')) OR
    (domain LIKE '%walmart.ca%' AND (event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%' OR event_detail LIKE '%pets%' OR event_detail LIKE '%pet-%' OR event_detail LIKE '%pet/%' OR event_detail LIKE '%pet\.%')) OR
    ((domain LIKE '%amazon%' OR domain LIKE '%amzn%') AND (event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%' OR event_detail LIKE '%pets%' OR event_detail LIKE '%pet-%' OR event_detail LIKE '%pet/%' OR event_detail LIKE '%pet\.%')) OR
    (domain LIKE '%costco.ca%' AND (event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%' OR event_detail LIKE '%pets%' OR event_detail LIKE '%pet-%' OR event_detail LIKE '%pet/%' OR event_detail LIKE '%pet\.%')) OR
    (domain LIKE '%sobeys.com%' AND (event_detail LIKE '%animalerie%' OR event_detail LIKE '%pet%')))
),

-- *********************************************************************************************
--  MAIN TABLES
-- *********************************************************************************************
first_visits AS (
    SELECT guid,
        domain_group,
        ROW_NUMBER() OVER (PARTITION BY guid ORDER BY event_time) AS visit_rank
    FROM non_unique_intender_data
),

total_output_col_fv AS (
   SELECT 
        domain_group,
        COUNT(guid) AS first_visit_users
    FROM first_visits
    WHERE visit_rank = 1
    GROUP BY 1
    ORDER BY 2 DESC
),

total_output_col_uu AS (
    SELECT
    domain_group,
    COUNT(DISTINCT guid) AS unique_users
    FROM non_unique_intender_data
    GROUP BY 1
    ORDER BY 2 DESC
),

total_output AS (
    SELECT
    a.domain_group,
    a.unique_users, 
    b.first_visit_users
    FROM total_output_col_uu AS a LEFT JOIN total_output_col_fv AS b ON a.domain_group = b.domain_group
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
a.first_visit_users,
b.unique_users AS ref_intenders,
c.unique_users AS ref_genpop
FROM total_output AS a
CROSS JOIN ref_intenders AS b
CROSS JOIN ref_genpop AS c

LIMIT 10000;