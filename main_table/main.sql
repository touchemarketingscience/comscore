-- @WbResult clickstream_ca
WITH user_data_comscore AS (
    SELECT
        calendar_date,
        domain,
        event_detail,
        guid,
        (
            CASE
                WHEN (
                    domain LIKE '%canadiantire.ca%'
                    OR event_detail LIKE '%canadiantire.ca%'
                ) THEN 'Canadian Tire'
                WHEN (
                    domain LIKE '%walmart.ca%'
                    OR event_detail LIKE '%walmart.ca%'
                ) THEN 'Walmart'
                WHEN (
                    domain LIKE '%amazon.ca%'
                    OR event_detail LIKE '%amazon.ca%'
                ) THEN 'Amazon'
                WHEN (
                    domain LIKE '%costco.ca%'
                    OR event_detail LIKE '%costco.ca%'
                ) THEN 'Costco'
                WHEN (
                    domain LIKE '%sobeys.com%'
                    OR event_detail LIKE '%sobeys.com%'
                ) THEN 'Sobeys'
                WHEN (
                    domain LIKE '%petland.ca%'
                    OR event_detail LIKE '%petland.ca%'
                ) THEN 'Pet Land'
                WHEN (
                    domain LIKE '%petvalu.ca%'
                    OR event_detail LIKE '%petvalu.ca%'
                ) THEN 'Pet Valu'
                WHEN (
                    domain LIKE '%petsmart.ca%'
                    OR event_detail LIKE '%petsmart.ca%'
                ) THEN 'Pet Smart'
                WHEN (domain LIKE '%baileyblu.com%') THEN 'Bailey Blu'
                WHEN (domain LIKE '%chico.ca%') THEN 'Chico'
                WHEN (domain LIKE '%mondou.com%') THEN 'Mondou'
                WHEN (domain LIKE '%pattesgriffes.com%') THEN 'Pattes Griffes'
                WHEN (domain LIKE '%tailblazerspets.com%') THEN 'Tail Blazers'
                WHEN (domain LIKE '%wbu.com%') THEN 'Wild Birds Unlimited'
                WHEN (domain LIKE '%amzn%') THEN 'Amazon'
                WHEN (domain LIKE '%bestbuy%') THEN 'Best Buy'
                WHEN (domain LIKE '%costco%') THEN 'Costco'
                WHEN (domain LIKE '%staples%') THEN 'Staples'
                WHEN (domain LIKE '%thesource%') THEN 'The Source'
                WHEN (domain LIKE '%homedepot%') THEN 'The Home Depot'
                WHEN (domain LIKE '%wayfair%') THEN 'Wayfair'
                WHEN (domain LIKE '%ikea%') THEN 'IKEA'
                WHEN (domain LIKE '%thebay%') THEN 'Hudsons Bay'
                WHEN (domain LIKE '%shoppers%') THEN 'Shoppers Drugmart'
                WHEN (domain LIKE '%indigo.ca%') THEN 'Indigo Books & Music'
                WHEN (domain LIKE '%sportchek%') THEN 'Sport Chek'
                WHEN (domain LIKE '%lululemon%') THEN 'Lululemon'
                WHEN (domain LIKE '%dollarama%') THEN 'Dollarama'
                WHEN (domain LIKE '%well.ca%') THEN 'Well.ca'
                WHEN (domain LIKE '%canadianprotein%') THEN 'Canadian Protein'
                WHEN (domain LIKE '%mec.ca%') THEN 'MEC'
                WHEN (domain LIKE '%nike.com%') THEN 'Nike'
                WHEN (domain LIKE '%sephora.com%') THEN 'Sephora'
                WHEN (domain LIKE '%roots.com%') THEN 'Roots'
                WHEN (domain LIKE '%gapcanada%') THEN 'Gap'
                WHEN (domain LIKE '%hudsonsbay.com%') THEN 'Hudsons Bay'
                WHEN (domain LIKE '%bedbathandbeyond.ca%') THEN 'Bed Bath & Beyond'
                WHEN (domain LIKE '%wellwise.ca%') THEN 'Wellwise'
                WHEN (domain LIKE '%adidas.ca%') THEN 'Adidas'
                WHEN (domain LIKE '%alibaba%') THEN 'Alibaba'
                WHEN (domain LIKE '%aliexpress%') THEN 'AliExpress'
                WHEN (domain LIKE '%sephora%') THEN 'Sephora'
                WHEN (domain LIKE '%facebook%') THEN 'Facebook'
                WHEN (domain LIKE '%whatsapp%') THEN 'WhatsApp'
                WHEN (domain LIKE '%messenger.com%') THEN 'Facebook Messenger'
                WHEN (domain LIKE '%wechat%') THEN 'WeChat'
                WHEN (domain LIKE '%instagram%') THEN 'Instagram'
                WHEN (domain LIKE '%tiktok') THEN 'TikTok'
                WHEN (domain LIKE '%sina%') THEN 'Sina Weibo'
                WHEN (domain LIKE '%twitter%') THEN 'Twitter'
                WHEN (domain LIKE '%telegram%') THEN 'Telegram'
                WHEN (domain LIKE '%linkedin%') THEN 'LinkedIn'
                WHEN (domain LIKE '%reddit%') THEN 'Reddit'
                WHEN (domain LIKE '%snapchat') THEN 'Snapchat'
                WHEN (domain LIKE '%pinterest%') THEN 'Pinterest'
                WHEN (domain LIKE '%discord%') THEN 'Discord'
                WHEN (domain LIKE '%tumblr') THEN 'Tumblr'
                WHEN (domain LIKE '%line.m%') THEN 'LINE'
                WHEN (domain LIKE '%viber%') THEN 'Viber'
                WHEN (domain LIKE '%telegram%') THEN 'Telegram'
                WHEN (domain LIKE '%twitch%') THEN 'Twitch'
                WHEN (domain LIKE '%kakaotalk%') THEN 'KakaoTalk'
                WHEN (domain LIKE '%fb.c%') THEN 'Facebook'
                ELSE domain
            END
        ) AS domain_group,
        (
            CASE
                WHEN UPPER(zvelo) LIKE '%PET%'
                OR UPPER(zvelo_category) LIKE '%PET%'
                OR UPPER(zvelo_subcategory) LIKE '%PET%' THEN 'PETS'
                WHEN domain NOT LIKE '%estjet%'
                AND (
                    event_detail LIKE '%animalerie%'
                    OR event_detail LIKE '%animaux%'
                    OR event_detail LIKE '%pets%'
                    OR event_detail LIKE '%pet-%'
                    OR event_detail LIKE '%pet/%'
                    OR event_detail LIKE '%pet\.%'
                )
                AND (
                    event_detail NOT LIKE '%peti%'
                    OR event_detail NOT LIKE '%peta%'
                    OR event_detail NOT LIKE '%petr%'
                    OR event_detail NOT LIKE '%ppet%'
                ) THEN 'PETS'
                ELSE UPPER(zvelo)
            END
        ) AS domain_category,
        (
            CASE
                WHEN (
                    domain LIKE '%canadiantire.ca%'
                    OR event_detail LIKE '%canadiantire.ca%'
                ) THEN 'Retail E-Commerce'
                WHEN (
                    domain LIKE '%walmart.ca%'
                    OR event_detail LIKE '%walmart.ca%'
                ) THEN 'Retail E-Commerce'
                WHEN (
                    domain LIKE '%amazon.ca%'
                    OR event_detail LIKE '%amazon.ca%'
                ) THEN 'Retail E-Commerce'
                WHEN (
                    domain LIKE '%costco.ca%'
                    OR event_detail LIKE '%costco.ca%'
                ) THEN 'Retail E-Commerce'
                WHEN (
                    domain LIKE '%sobeys.com%'
                    OR event_detail LIKE '%sobeys.com%'
                ) THEN 'Retail E-Commerce'
                WHEN (
                    domain LIKE '%petland.ca%'
                    OR event_detail LIKE '%petland.ca%'
                ) THEN 'Retail E-Commerce'
                WHEN (
                    domain LIKE '%petvalu.ca%'
                    OR event_detail LIKE '%petvalu.ca%'
                ) THEN 'Retail E-Commerce'
                WHEN (
                    domain LIKE '%petsmart.ca%'
                    OR event_detail LIKE '%petsmart.ca%'
                ) THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%baileyblu.com%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%chico.ca%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%mondou.com%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%pattesgriffes.com%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%tailblazerspets.com%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%wbu.com%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%amzn%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%bestbuy%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%costco%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%staples%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%thesource%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%homedepot%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%wayfair%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%ikea%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%thebay%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%shoppers%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%indigo.ca%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%sportchek%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%lululemon%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%dollarama%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%well.ca%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%canadianprotein%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%mec.ca%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%nike.com%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%sephora.com%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%roots.com%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%gapcanada%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%hudsonsbay.com%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%bedbathandbeyond.ca%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%wellwise.ca%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%adidas.ca%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%alibaba%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%aliexpress%') THEN 'Retail E-Commerce'
                WHEN (domain LIKE '%sephora%') THEN 'Retail E-Commerce'
                ELSE 'Uncategorized'
            END
        ) as domain_sector_type
    FROM
        spectrum_comscore.clickstream_ca
    WHERE
        date_part(year, calendar_date) >= 2021
        AND date_part(year, calendar_date) <= 2022
)
SELECT
    domain_group,
    COUNT(DISTINCT guid) as unique_users
FROM
    user_data_comscore
WHERE
    domain_sector_type = 'Retail E-Commerce'
    AND domain_category = 'PETS'
GROUP BY
    1
    /*
     SELECT 
     domain,
     domain_group,
     domain_category,
     COUNT(DISTINCT guid) as unique_users
     FROM    user_data_comscore
     WHERE   domain_category = 'PETS'
     GROUP BY 1, 2, 3
     ORDER BY unique_users DESC
     
     */
LIMIT
    1000;