WITH unique_intender_data AS (
    SELECT 
    calendar_date,
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
    WHERE (date_part(year, calendar_date) >= 2019 AND date_part(year, calendar_date) <= 2022) AND
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

total_website_visit_count_per_intender AS (
    SELECT
        guid,
        COUNT(DISTINCT domain_group) AS domain_group_count
    FROM unique_intender_data
    GROUP BY 1
)

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