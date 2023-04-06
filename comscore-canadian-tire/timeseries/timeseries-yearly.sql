WITH unique_intender_data AS (
    SELECT
        calendar_date,
        guid
    FROM
        spectrum_comscore.clickstream_ca
    WHERE (date_part(year, calendar_date) >= 2019 AND date_part(year, calendar_date) <= 2022) AND (
        (  (domain LIKE '%petland.ca%')
            OR (domain LIKE '%petvalu.ca%')
            OR (domain LIKE '%petsmart.ca%')
            OR (domain LIKE '%baileyblu.com%')
            OR (domain LIKE '%chico.ca%')
            OR (domain LIKE '%mondou.com%')
            OR (domain LIKE '%pattesgriffes.com%')
            OR (domain LIKE '%tailblazerspets.com%')
            OR (domain LIKE '%wbu.com%')
        )
        OR
        (
            -- *************************************************
            -- CANADIAN TIRE
            -- *************************************************
            (domain LIKE '%canadiantire.ca%' AND (
                    event_detail LIKE '%animalerie%'  
                    OR event_detail LIKE '%pet-care%'
                )
            )
            -- *************************************************
            -- WALMART
            -- *************************************************
            OR (
                domain LIKE '%walmart.ca%' AND (
                    event_detail LIKE '%animalerie%' 
                    OR event_detail LIKE '%animaux%' 
                    OR event_detail LIKE '%pets%' 
                    OR event_detail LIKE '%pet-%' 
                    OR event_detail LIKE '%pet/%' 
                    OR event_detail LIKE '%pet\.%'
                )
            )
            -- *************************************************
            -- AMAZON
            -- *************************************************
            OR ((domain LIKE '%amazon%' OR domain LIKE '%amzn%') AND (
                    event_detail LIKE '%animalerie%'
                    OR event_detail LIKE '%animaux%'
                    OR event_detail LIKE '%pets%'
                    OR event_detail LIKE '%pet-%'
                    OR event_detail LIKE '%pet/%'
                    OR event_detail LIKE '%pet\.%'
                )
            )
            -- *************************************************
            -- COSTCO
            -- *************************************************
            OR (domain LIKE '%costco.ca%' AND (
                    event_detail LIKE '%animalerie%'
                    OR event_detail LIKE '%animaux%'
                    OR event_detail LIKE '%pets%'
                    OR event_detail LIKE '%pet-%'
                    OR event_detail LIKE '%pet/%'
                    OR event_detail LIKE '%pet\.%'
                )
            )
            -- *************************************************
            -- SOBEYS
            -- *************************************************
            OR (domain LIKE '%sobeys.com%' AND (
                    (event_detail LIKE '%animalerie%' OR event_detail LIKE '%pet%')
                )
            )
        )
    )
),

total_intenders AS (
    SELECT
        date_part(year, calendar_date) AS join_field,
        COUNT(DISTINCT guid) AS unique_users
    FROM unique_intender_data
    GROUP BY 1
),

total_genpop AS (
     SELECT
        date_part(year, calendar_date) AS join_field,
        COUNT(DISTINCT guid) AS unique_users
    FROM spectrum_comscore.clickstream_ca
    GROUP BY 1
),

total_output AS (
    SELECT 
        a.join_field,
        a.unique_users AS total_intenders,
        b.unique_users AS total_genpop
    FROM total_intenders AS a INNER JOIN total_genpop AS b ON a.join_field = b.join_field
),


-- *********************************************************************************************
--  FINALIZATION
-- *********************************************************************************************

ref_genpop AS (
    SELECT COUNT(DISTINCT guid) AS unique_users
    FROM spectrum_comscore.clickstream_ca
    WHERE date_part(year, calendar_date) >= 2019 AND date_part(year, calendar_date) <= 2022
),

ref_intenders AS (
    SELECT COUNT(DISTINCT guid) AS unique_users
    FROM unique_intender_data
    WHERE date_part(year, calendar_date) >= 2019 AND date_part(year, calendar_date) <= 2022
)

SELECT
    a.join_field AS year,
    a.total_intenders AS total_intenders,
    a.total_genpop AS total_genpop,
    b.unique_users AS ref_genpop,
    c.unique_users AS ref_intenders
FROM total_output AS a
CROSS JOIN ref_genpop AS b
CROSS JOIN ref_intenders AS c

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