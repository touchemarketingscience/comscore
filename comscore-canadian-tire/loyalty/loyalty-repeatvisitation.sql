-- Step 1: Calculate the total visits per domain for each user
WITH non_unique_intender_data AS (
    SELECT 
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
        END) AS domain_group,
        calendar_date
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

total_visits AS (
  SELECT guid,
         domain_group,
         COUNT(*) AS visit_count
  FROM non_unique_intender_data
  GROUP BY guid, domain_group
),

-- Step 2: Calculate the total unique visits per domain for each user
unique_visits AS (
  SELECT guid,
         domain_group,
         COUNT(DISTINCT calendar_date) AS unique_visit_count
  FROM non_unique_intender_data
  GROUP BY guid, domain_group
),

-- Step 3: Subtract the unique visits from the total visits to get repeat visits per domain for each user
repeat_visits AS (
    SELECT 
        tv.guid,
        tv.domain_group,
        tv.visit_count AS total_visit_count,
        uv.unique_visit_count AS unique_visit_count,
        tv.visit_count - uv.unique_visit_count AS repeat_visit_count
    FROM total_visits tv
    JOIN unique_visits uv
    ON tv.guid = uv.guid AND tv.domain_group = uv.domain_group
),

-- Step 4: Sum up the repeat visits for each domain across all users
-- Step 5: Divide the sum of repeat visits by the count of unique users who visited the domain to get the average repeat visits per domain
total_output AS (
SELECT 
    domain_group,
    COUNT(DISTINCT guid) AS unique_users,
    SUM(total_visit_count) AS total_visits,
    SUM(unique_visit_count) AS unique_visits,
    SUM(repeat_visit_count) AS repeat_visits,
    SUM(repeat_visit_count) / COUNT(DISTINCT guid) AS avg_repeat_visits
FROM repeat_visits
GROUP BY domain_group
ORDER BY avg_repeat_visits DESC
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
a.unique_users,
a.total_visits,
a.unique_visits,
a.repeat_visits,
a.avg_repeat_visits,
b.unique_users AS ref_intenders,
c.unique_users AS ref_genpop
FROM total_output AS a
CROSS JOIN ref_intenders AS b
CROSS JOIN ref_genpop AS c

LIMIT 10000;