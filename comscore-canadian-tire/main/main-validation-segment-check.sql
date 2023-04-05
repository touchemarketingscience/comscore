
WITH converters AS (
    SELECT
    DISTINCT guid as user_id
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
),

intenders AS (
    SELECT
    DISTINCT guid as user_id
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
),

clickstream_domains AS (
    SELECT 
    guid AS user_id,
    (CASE
        -- --------------------------------------------------------------------
        -- COMPETITIVE SET 
        -- --------------------------------------------------------------------
        WHEN (domain LIKE '%canadiantire.ca%' OR event_detail LIKE '%canadiantire.ca%')         THEN 'Canadian Tire'
        WHEN (domain LIKE '%walmart.ca%' OR event_detail LIKE '%walmart.ca%')                   THEN 'Walmart'
        WHEN (domain LIKE '%amazon.ca%' OR event_detail LIKE '%amazon.ca%')                     THEN 'Amazon'
        WHEN (domain LIKE '%amzn%')                                                             THEN 'Amazon'
        WHEN (domain LIKE '%costco.ca%' OR event_detail LIKE '%costco.ca%')                     THEN 'Costco'
        WHEN (domain LIKE '%sobeys.com%' OR event_detail LIKE '%sobeys.com%')                   THEN 'Sobeys'
        WHEN (domain LIKE '%petland.ca%' OR event_detail LIKE '%petland.ca%')                   THEN 'Pet Land'
        WHEN (domain LIKE '%petvalu.ca%' OR event_detail LIKE '%petvalu.ca%')                   THEN 'Pet Valu'
        WHEN (domain LIKE '%petsmart.ca%' OR event_detail LIKE '%petsmart.ca%')                 THEN 'Pet Smart'
        WHEN (domain LIKE '%baileyblu.com%'  OR event_detail LIKE '%baileyblu.com%')            THEN 'Bailey Blu'
        WHEN (domain LIKE '%chico.ca%' OR event_detail LIKE '%chico.ca%')                       THEN 'Chico'
        WHEN (domain LIKE '%mondou.com%' OR event_detail LIKE '%mondou.com%')                   THEN 'Mondou'
        WHEN (domain LIKE '%pattesgriffes.com%' OR event_detail LIKE '%pattesgriffes.com%')     THEN 'Pattes Griffes'
        WHEN (domain LIKE '%tailblazerspets.com%' OR event_detail LIKE '%tailblazerspets.com%') THEN 'Tail Blazers'
        WHEN (domain LIKE '%wbu.com%' OR event_detail LIKE '%wbu.com%')                         THEN 'Wild Birds Unlimited'
        -- --------------------------------------------------------------------
        -- SOCIAL MEDIA
        -- --------------------------------------------------------------------
        WHEN domain LIKE '%snapchat%'               THEN 'Snapchat'
        WHEN domain LIKE '%tiktok%'                 THEN 'Tiktok'
        WHEN domain LIKE '%linkedin%'               THEN 'Linkedin'
        WHEN domain LIKE '%twitter%'                THEN 'Twitter'
        WHEN domain LIKE '%pinterest%'              THEN 'Pinterest'
        WHEN domain LIKE '%reddit%'                 THEN 'Reddit'
        WHEN domain LIKE '%facebook.com%'           THEN 'Facebook'
        WHEN domain LIKE '%fb.%'                    THEN 'Facebook'
        WHEN domain LIKE '%instagram%'              THEN 'Instagram'
        WHEN domain LIKE '%tumblr%'                 THEN 'Tumblr'
        WHEN domain LIKE '%quora%'                  THEN 'Quora'
        WHEN (domain LIKE '%sina%')                 THEN 'Sina Weibo'
        -- --------------------------------------------------------------------
        -- MESSAGING APPS
        -- --------------------------------------------------------------------
        WHEN domain LIKE '%messenger.%'             THEN 'Messenger'
        WHEN domain LIKE '%wechat%'                 THEN 'Wechat'
        WHEN domain LIKE '%whatsapp%'               THEN 'Whatsapp'
        WHEN (domain LIKE '%line.m%')               THEN 'LINE'
        WHEN (domain LIKE '%viber%')                THEN 'Viber'
        WHEN (domain LIKE '%telegram%')             THEN 'Telegram'
        WHEN (domain LIKE '%kakaotalk%')            THEN 'KakaoTalk'
        WHEN (domain LIKE '%discord%')              THEN 'Discord'
        -- --------------------------------------------------------------------
        -- VIDEO STREAMING
        -- --------------------------------------------------------------------
        WHEN domain LIKE '%youtube%'                THEN 'Youtube'
        WHEN domain LIKE '%vimeo%'                  THEN 'Vimeo'
        WHEN domain LIKE '%twitch%'                 THEN 'Twitch'
        WHEN domain LIKE '%dailymotion%'            THEN 'Dailymotion'
        WHEN domain LIKE '%netflix%'                THEN 'Netflix'
        -- --------------------------------------------------------------------
        -- E-COMMERCE
        -- --------------------------------------------------------------------
        WHEN (domain LIKE '%bestbuy%')              THEN 'Best Buy'
        WHEN (domain LIKE '%costco%')               THEN 'Costco'
        WHEN (domain LIKE '%staples%')              THEN 'Staples'
        WHEN (domain LIKE '%thesource%')            THEN 'The Source'
        WHEN (domain LIKE '%homedepot%')            THEN 'The Home Depot'
        WHEN (domain LIKE '%wayfair%')              THEN 'Wayfair'
        WHEN (domain LIKE '%ikea%')                 THEN 'IKEA'
        WHEN (domain LIKE '%thebay%')               THEN 'Hudsons Bay'
        WHEN (domain LIKE '%shoppers%')             THEN 'Shoppers Drugmart'
        WHEN (domain LIKE '%indigo.ca%')            THEN 'Indigo Books & Music'
        WHEN (domain LIKE '%sportchek%')            THEN 'Sport Chek'
        WHEN (domain LIKE '%lululemon%')            THEN 'Lululemon'
        WHEN (domain LIKE '%dollarama%')            THEN 'Dollarama'
        WHEN (domain LIKE '%well.ca%')              THEN 'Well.ca'
        WHEN (domain LIKE '%canadianprotein%')      THEN 'Canadian Protein'
        WHEN (domain LIKE '%mec.ca%')               THEN 'MEC'
        WHEN (domain LIKE '%nike.com%')             THEN 'Nike'
        WHEN (domain LIKE '%sephora.com%')          THEN 'Sephora'
        WHEN (domain LIKE '%roots.com%')            THEN 'Roots'
        WHEN (domain LIKE '%gapcanada%')            THEN 'Gap'
        WHEN (domain LIKE '%hudsonsbay.com%')       THEN 'Hudsons Bay'
        WHEN (domain LIKE '%bedbathandbeyond.ca%')  THEN 'Bed Bath & Beyond'
        WHEN (domain LIKE '%wellwise.ca%')          THEN 'Wellwise'
        WHEN (domain LIKE '%adidas.ca%')            THEN 'Adidas'
        WHEN (domain LIKE '%alibaba%')              THEN 'Alibaba'
        WHEN (domain LIKE '%aliexpress%')           THEN 'AliExpress'
        WHEN (domain LIKE '%sephora%')              THEN 'Sephora'
        ELSE domain
        END) AS domain_group

    FROM spectrum_comscore.clickstream_ca
)

SELECT 
'Intenders' AS segment,
domain_group, 
COUNT(DISTINCT user_id)
FROM clickstream_domains WHERE user_id IN (
    SELECT user_id FROM intenders
)
GROUP BY 1, 2

UNION ALL

SELECT 
'Converters' AS segment,
domain_group, COUNT(DISTINCT user_id)
FROM clickstream_domains WHERE user_id IN (
    SELECT user_id FROM converters
)
GROUP BY 1, 2

LIMIT 50000;