WITH 

date_lower_bound AS (SELECT '2021-01-01' AS value),
date_upper_bound AS (SELECT '2022-12-31' AS value),

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
   WHERE ( (calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound)) AND
   ( -- INTENDER LOGIC
            (domain LIKE '%canadiantire.ca%' OR event_detail LIKE '%canadiantire.ca%')
        OR (domain LIKE '%amazon.ca%' OR event_detail LIKE '%amazon.ca%')
        OR (domain LIKE '%walmart.ca%' OR event_detail LIKE '%walmart.ca%')
        OR (domain LIKE '%bestbuy.ca%' OR event_detail LIKE '%bestbuy.ca%')
        OR (domain LIKE '%wayfair.ca%' OR event_detail LIKE '%wayfair.ca%')
        OR (domain LIKE '%ikea.com%' OR event_detail LIKE '%ikea.com%')
        OR (domain LIKE '%homesense.ca%' OR event_detail LIKE '%homesense.ca%')
        OR (domain LIKE '%winners.ca%' OR event_detail LIKE '%winners.ca%')
        OR (domain LIKE '%thebay.com%' OR event_detail LIKE '%thebay.com%')
        OR (domain LIKE '%labaie.com%' OR event_detail LIKE '%labaie.com%')
        OR (domain LIKE '%marshalls.ca%' OR event_detail LIKE '%marshalls.ca%')
        OR (domain LIKE '%homehardware.ca%' OR event_detail LIKE '%homehardware.ca%')
        OR (domain LIKE '%homedepot.ca%' OR event_detail LIKE '%homedepot.ca%')
        OR (domain LIKE '%rona.ca%' OR event_detail LIKE '%rona.ca%')
        OR (domain LIKE '%lowes.ca%' OR event_detail LIKE '%lowes.ca%')
        OR (domain LIKE '%renodepot.com%' OR event_detail LIKE '%renodepot.com%')
        OR (domain LIKE '%costco.ca%' OR event_detail LIKE '%costco.ca%')
        OR (domain LIKE '%dollarama.com%' OR event_detail LIKE '%dollarama.com%')
    )
),

-- *********************************************************************************************
--  MAIN TABLES
-- *********************************************************************************************

total_website_visit_count_per_intender AS (
    SELECT
        guid,
        COUNT(DISTINCT domain_group) AS domain_group_count
    FROM unique_intender_data
    GROUP BY 1
),

total_output AS (
    SELECT
        CASE
        WHEN domain_group_count = 0 THEN '0 websites'
        WHEN domain_group_count = 1 THEN '1 websites'
        WHEN domain_group_count = 2 THEN '2 websites'
        WHEN domain_group_count = 3 THEN '3 websites'
        WHEN domain_group_count = 4 THEN '4 websites'
        WHEN domain_group_count = 5 THEN '5 websites'
        WHEN domain_group_count = 6 THEN '6 websites'
        WHEN domain_group_count = 7 THEN '7 websites'
        ELSE '8 or more websites'
        END AS website_count,
        COUNT(guid) AS unique_users
    FROM total_website_visit_count_per_intender
    GROUP BY 1
    ORDER BY MIN(domain_group_count)
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
a.website_count,
a.unique_users,
b.unique_users AS ref_intenders,
c.unique_users AS ref_genpop
FROM total_output AS a
CROSS JOIN ref_intenders AS b
CROSS JOIN ref_genpop AS c

LIMIT 10000;