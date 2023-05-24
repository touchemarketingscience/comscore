WITH converters AS (
    SELECT
        DISTINCT guid
    FROM spectrum_comscore.clickstream_ca

    -- ********************************************************************
    -- DATE RANGE
    -- ********************************************************************
    WHERE 
    (
        date_part(year, calendar_date) = 2021 OR date_part(year, calendar_date) = 2022
    ) 
    AND 
    (   
        -- ********************************************************************
        -- ONLY INCLUDE USERS WHO HAVE VISITED A COMPETITOR SITE (INTENDER GROUP)
        -- ********************************************************************
        guid IN 
        (
            SELECT DISTINCT guid FROM spectrum_comscore.clickstream_ca
            WHERE 
            (
                (
                    (domain LIKE '%canadiantire.ca%'     OR event_detail LIKE '%canadiantire.ca%')     OR
                    (domain LIKE '%walmart.ca%'          OR event_detail LIKE '%walmart.ca%')          OR
                    (domain LIKE '%amazon%'              OR event_detail LIKE '%amazon.ca%')           OR
                    (domain LIKE '%amzn%'                OR event_detail LIKE '%amazon.ca%')           OR
                    (domain LIKE '%costco.ca%'           OR event_detail LIKE '%costco.ca%')           OR
                    (domain LIKE '%sobeys.com%'          OR event_detail LIKE '%sobeys.com%')          OR
                    (domain LIKE '%petland.ca%'          OR event_detail LIKE '%petland.ca%')          OR
                    (domain LIKE '%petvalu.ca%'          OR event_detail LIKE '%petvalu.ca%')          OR
                    (domain LIKE '%petsmart.ca%'         OR event_detail LIKE '%petsmart.ca%')         OR
                    (domain LIKE '%baileyblu.com%'       OR event_detail LIKE '%baileyblu.com%')       OR
                    (domain LIKE '%chico.ca%'            OR event_detail LIKE '%chico.ca%')            OR
                    (domain LIKE '%mondou.com%'          OR event_detail LIKE '%mondou.com%')          OR
                    (domain LIKE '%pattesgriffes.com%'   OR event_detail LIKE '%pattesgriffes.com%')   OR
                    (domain LIKE '%tailblazerspets.com%' OR event_detail LIKE '%tailblazerspets.com%') OR
                    (domain LIKE '%wbu.com%'             OR event_detail LIKE '%wbu.com%')                         
                ) 
                AND 
                (
                    (
                        zvelo LIKE '%Pets%' OR zvelo_category LIKE '%Pets%' OR zvelo_subcategory LIKE '%Pets%'
                    ) 
                    OR
                    (
                        domain NOT LIKE '%estjet%' 
                        AND 
                        (
                        event_detail LIKE '%animalerie%'    OR 
                        event_detail LIKE '%animaux%'       OR 
                        event_detail LIKE '%pets%'          OR 
                        event_detail LIKE '%pet-%'          OR 
                        event_detail LIKE '%pet/%'          OR 
                        event_detail LIKE '%pet\.%' 
                        ) 
                        AND 
                        ( 
                        event_detail NOT LIKE '%peti%'      OR
                        event_detail NOT LIKE '%peta%'      OR 
                        event_detail NOT LIKE '%petr%'      OR 
                        event_detail NOT LIKE '%ppet%'
                        )
                    )
                )
            )
        )
    )

    -- ********************************************************************
    -- DOMAIN CONVERTER GROUP (COMMENT OUT IF NOT NEEDED)
    -- ********************************************************************
    AND 
    (   
        (
            (domain LIKE '%canadiantire.ca%'     OR event_detail LIKE '%canadiantire.ca%')     OR
            (domain LIKE '%walmart.ca%'          OR event_detail LIKE '%walmart.ca%')          OR
            (domain LIKE '%amazon%'              OR event_detail LIKE '%amazon.ca%')           OR
            (domain LIKE '%amzn%'                OR event_detail LIKE '%amazon.ca%')           OR
            (domain LIKE '%costco.ca%'           OR event_detail LIKE '%costco.ca%')           OR
            (domain LIKE '%sobeys.com%'          OR event_detail LIKE '%sobeys.com%')          OR
            (domain LIKE '%petland.ca%'          OR event_detail LIKE '%petland.ca%')          OR
            (domain LIKE '%petvalu.ca%'          OR event_detail LIKE '%petvalu.ca%')          OR
            (domain LIKE '%petsmart.ca%'         OR event_detail LIKE '%petsmart.ca%')         OR
            (domain LIKE '%baileyblu.com%'       OR event_detail LIKE '%baileyblu.com%')       OR
            (domain LIKE '%chico.ca%'            OR event_detail LIKE '%chico.ca%')            OR
            (domain LIKE '%mondou.com%'          OR event_detail LIKE '%mondou.com%')          OR
            (domain LIKE '%pattesgriffes.com%'   OR event_detail LIKE '%pattesgriffes.com%')   OR
            (domain LIKE '%tailblazerspets.com%' OR event_detail LIKE '%tailblazerspets.com%') OR
            (domain LIKE '%wbu.com%'             OR event_detail LIKE '%wbu.com%')                         
        ) 
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
    )
    GROUP BY 1
),

audience AS (
    SELECT
    UPPER(REPLACE(REPLACE(zvelo_category, ' and ', '&'),' ','')) AS zvelo_category,
    COUNT(DISTINCT guid) as unique_users
    FROM spectrum_comscore.clickstream_ca
    WHERE 
    (
        date_part(year, calendar_date) = 2021 OR date_part(year, calendar_date) = 2022
    )
    AND 
    (
        guid IN 
        (
            SELECT guid FROM converters
        )
    )
    GROUP BY 1
),

genpop AS (
    SELECT
    UPPER(REPLACE(REPLACE(zvelo_category, ' and ', '&'),' ','')) AS zvelo_category,
    COUNT(DISTINCT guid) as unique_users
    FROM spectrum_comscore.clickstream_ca
    WHERE 
    (
        date_part(year, calendar_date) = 2021 OR date_part(year, calendar_date) = 2022
    )
    GROUP BY 1
)

SELECT
    a.zvelo_category AS zvelo_category,
    a.unique_users AS unique_users_converter,
    b.unique_users     AS unique_users_genpop
FROM audience AS a INNER JOIN genpop AS b ON a.zvelo_category = b.zvelo_category
ORDER BY 2 DESC


LIMIT 50000;