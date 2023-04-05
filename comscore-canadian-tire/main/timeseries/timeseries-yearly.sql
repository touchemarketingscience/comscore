WITH unique_intender_data AS (
    SELECT
        date_part(year, calendar_date) AS year,
        guid
    FROM
        spectrum_comscore.clickstream_ca
    WHERE (date_part(year, calendar_date) = 2021 OR date_part(year, calendar_date) = 2022) AND (
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
        year AS join_field,
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
)

SELECT 
    a.join_field,
    a.unique_users AS total_intenders,
    b.unique_users AS total_genpop
FROM total_intenders AS a INNER JOIN total_genpop AS b ON a.join_field = b.join_field

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