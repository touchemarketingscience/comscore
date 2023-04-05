SELECT
    (
        CASE
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
    ) AS domain_group,
    count (DISTINCT guid)
FROM
    spectrum_comscore.clickstream_ca
WHERE
    
(
    date_part(year, calendar_date) = 2021OR date_part(year, calendar_date) = 2022
)

AND 
(
    (
        (domain LIKE '%petland.ca%')
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
        (
            domain LIKE '%canadiantire.ca%' AND (
                (event_detail LIKE '%animalerie%' OR event_detail LIKE '%pet-care%')AND (
                    event_detail NOT LIKE '%peti%'
                    OR event_detail NOT LIKE '%peta%'
                    OR event_detail NOT LIKE '%petr%'
                    OR event_detail NOT LIKE '%ppet%'
                )
            )
        )

        OR
        -- *************************************************
        -- WALMART
        -- *************************************************
        (
            domain LIKE '%walmart.ca%' AND ((
                event_detail LIKE '%animalerie%' 
                OR event_detail LIKE '%animaux%' 
                OR event_detail LIKE '%pets%' 
                OR event_detail LIKE '%pet-%' 
                OR event_detail LIKE '%pet/%' 
                OR event_detail LIKE '%pet\.%') AND (
                    event_detail NOT LIKE '%peti%'
                    OR event_detail NOT LIKE '%peta%'
                    OR event_detail NOT LIKE '%petr%'
                    OR event_detail NOT LIKE '%ppet%'
                )
            )
        )

         OR
        -- *************************************************
        -- AMAZON
        -- *************************************************
        (
            domain LIKE '%amazon%' AND 
            (
                (
                    event_detail LIKE '%animalerie%'
                    OR event_detail LIKE '%animaux%'
                    OR event_detail LIKE '%pets%'
                    OR event_detail LIKE '%pet-%'
                    OR event_detail LIKE '%pet/%'
                    OR event_detail LIKE '%pet\.%'
                )
                AND 
                (
                    event_detail NOT LIKE '%peti%'
                    OR event_detail NOT LIKE '%peta%'
                    OR event_detail NOT LIKE '%petr%'
                    OR event_detail NOT LIKE '%ppet%'
                )
            )
        )

        OR
        -- *************************************************
        -- COSTCO
        -- *************************************************
        (
            (domain LIKE '%costco.ca%') AND
            (
                (
                    event_detail LIKE '%animalerie%'
                    OR event_detail LIKE '%animaux%'
                    OR event_detail LIKE '%pets%'
                    OR event_detail LIKE '%pet-%'
                    OR event_detail LIKE '%pet/%'
                    OR event_detail LIKE '%pet\.%'
                )
                AND 
                (
                    event_detail NOT LIKE '%peti%'
                    OR event_detail NOT LIKE '%peta%'
                    OR event_detail NOT LIKE '%petr%'
                    OR event_detail NOT LIKE '%ppet%'
                )
            )
        )
         OR
        -- *************************************************
        -- SOBEYS
        -- *************************************************
        (
            domain LIKE '%sobeys.com%' AND
            (
                (
                    event_detail LIKE '%animalerie%'
                    OR event_detail LIKE '%pet%'
                )
                AND 
                (
                    event_detail NOT LIKE '%peti%'
                    OR event_detail NOT LIKE '%peta%'
                    OR event_detail NOT LIKE '%petr%'
                    OR event_detail NOT LIKE '%ppet%'
                )
            )
        )




    )
)

    
GROUP BY
    1
ORDER BY
    2 desc
LIMIT
    10000;


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