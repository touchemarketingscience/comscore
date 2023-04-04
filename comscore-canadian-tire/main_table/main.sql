WITH user_data_comscore AS (
    SELECT
        -- date_part(year, calendar_date) AS year,
        -- calendar_date,
        domain,
        event_detail,
        machine_id,
        guid,
        (CASE
        WHEN (domain LIKE '%canadiantire.ca%' OR event_detail LIKE '%canadiantire.ca%') THEN 'Canadian Tire'
        WHEN (domain LIKE '%walmart.ca%' OR event_detail LIKE '%walmart.ca%') THEN 'Walmart'
        WHEN (domain LIKE '%amazon.ca%' OR event_detail LIKE '%amazon.ca%') THEN 'Amazon'
        WHEN (domain LIKE '%costco.ca%' OR event_detail LIKE '%costco.ca%') THEN 'Costco'
        WHEN (domain LIKE '%sobeys.com%' OR event_detail LIKE '%sobeys.com%') THEN 'Sobeys'
        WHEN (domain LIKE '%petland.ca%' OR event_detail LIKE '%petland.ca%') THEN 'Pet Land'
        WHEN (domain LIKE '%petvalu.ca%' OR event_detail LIKE '%petvalu.ca%') THEN 'Pet Valu'
        WHEN (domain LIKE '%petsmart.ca%' OR event_detail LIKE '%petsmart.ca%') THEN 'Pet Smart'
        WHEN (domain LIKE '%baileyblu.com%') THEN 'Bailey Blu'
        WHEN (domain LIKE '%chico.ca%') THEN 'Chico'
        WHEN (domain LIKE '%mondou.com%') THEN 'Mondou'
        WHEN (domain LIKE '%pattesgriffes.com%') THEN 'Pattes Griffes'
        WHEN (domain LIKE '%tailblazerspets.com%') THEN 'Tail Blazers'

        WHEN domain LIKE '%snapcha%'        THEN 'Snapchat'
        WHEN domain LIKE '%tiktok%'         THEN 'Tiktok'
        WHEN domain LIKE '%linkedin%'       THEN 'Linkedin'
        WHEN domain LIKE '%twitter%'        THEN 'Twitter'
        WHEN domain LIKE '%pinterest%'      THEN 'Pinterest'
        WHEN domain LIKE '%reddit%'         THEN 'Reddit'
        WHEN domain LIKE '%facebook.com%'   THEN 'Facebook'
        WHEN domain LIKE '%fb.%'            THEN 'Facebook'
        WHEN domain LIKE '%instagram%'      THEN 'Instagram'
        WHEN domain LIKE '%messenger.%'     THEN 'Facebook'
        WHEN domain LIKE '%wechat%'         THEN 'Wechat'
        WHEN domain LIKE '%whatsapp%'       THEN 'Whatsapp'
        WHEN domain LIKE '%tumblr%'         THEN 'Tumblr'
        WHEN domain LIKE '%quora%'          THEN 'Quora'

        WHEN domain LIKE '%youtube%'        THEN 'Video Streaming'
        WHEN domain LIKE '%vimeo%'          THEN 'Video Streaming'
        WHEN domain LIKE '%twitch%'         THEN 'Video Streaming'
        WHEN domain LIKE '%dailymotion%'    THEN 'Video Streaming'
        WHEN domain LIKE '%netflix%'        THEN 'Video Streaming'

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
        END) AS domain_group,
        (CASE 
        WHEN UPPER(zvelo) LIKE '%PET%'OR UPPER(zvelo_category) LIKE '%PET%'OR UPPER(zvelo_subcategory) LIKE '%PET%' THEN 'PETS'
        WHEN domain NOT LIKE '%estjet%' AND (event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%' OR event_detail LIKE '%pets%' OR event_detail LIKE '%pet-%' OR event_detail LIKE '%pet/%' OR event_detail LIKE '%pet\.%' )
        AND ( event_detail NOT LIKE '%peti%' OR event_detail NOT LIKE '%peta%' OR event_detail NOT LIKE '%petr%' OR event_detail NOT LIKE '%ppet%') THEN 'PETS'
        
        ELSE UPPER(zvelo)

        END) AS domain_category,
        (CASE
    WHEN (domain LIKE '%canadiantire.ca%'OR event_detail LIKE '%canadiantire.ca%') THEN 'Retail E-Commerce'
    WHEN (domain LIKE '%walmart.ca%'OR event_detail LIKE '%walmart.ca%') THEN 'Retail E-Commerce'
    WHEN (domain LIKE '%amazon.ca%'OR event_detail LIKE '%amazon.ca%') THEN 'Retail E-Commerce'
    WHEN (domain LIKE '%costco.ca%'OR event_detail LIKE '%costco.ca%') THEN 'Retail E-Commerce'
    WHEN (domain LIKE '%sobeys.com%'OR event_detail LIKE '%sobeys.com%') THEN 'Retail E-Commerce'
    WHEN (domain LIKE '%petland.ca%'OR event_detail LIKE '%petland.ca%') THEN 'Retail E-Commerce'
    WHEN (domain LIKE '%petvalu.ca%'OR event_detail LIKE '%petvalu.ca%') THEN 'Retail E-Commerce'
    WHEN (domain LIKE '%petsmart.ca%'OR event_detail LIKE '%petsmart.ca%') THEN 'Retail E-Commerce'
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
    END) as domain_sector,


    (CASE 

    WHEN domain LIKE '%snapcha%'        THEN 'Social Media'
    WHEN domain LIKE '%tiktok%'         THEN 'Social Media'
    WHEN domain LIKE '%linkedin%'       THEN 'Social Media'
    WHEN domain LIKE '%twitter%'        THEN 'Social Media'
    WHEN domain LIKE '%pinterest%'      THEN 'Social Media'
    WHEN domain LIKE '%reddit%'         THEN 'Social Media'
    WHEN domain LIKE '%facebook.com%'   THEN 'Social Media'
    WHEN domain LIKE '%fb.%'            THEN 'Social Media'
    WHEN domain LIKE '%instagram%'      THEN 'Social Media'
    WHEN domain LIKE '%messenger.%'     THEN 'Social Media'
    WHEN domain LIKE '%wechat%'         THEN 'Social Media'
    WHEN domain LIKE '%whatsapp%'       THEN 'Social Media'
    WHEN domain LIKE '%tumblr%'         THEN 'Social Media'
    WHEN domain LIKE '%quora%'          THEN 'Social Media'

    WHEN domain LIKE '%youtube%'        THEN 'Video Streaming'
    WHEN domain LIKE '%vimeo%'          THEN 'Video Streaming'
    WHEN domain LIKE '%twitch%'         THEN 'Video Streaming'
    WHEN domain LIKE '%dailymotion%'    THEN 'Video Streaming'
    WHEN domain LIKE '%netflix%'        THEN 'Video Streaming'

    WHEN domain LIKE '%amazon%'         THEN 'E-commerce & Shopping'
    WHEN domain LIKE '%ebay%'           THEN 'E-commerce & Shopping'
    WHEN domain LIKE '%etsy%'           THEN 'E-commerce & Shopping'
    WHEN domain LIKE '%walmart%'        THEN 'E-commerce & Shopping'
    WHEN domain LIKE '%wayfair%'        THEN 'E-Commerce & Shopping'
    WHEN domain LIKE '%aliexpress%'     THEN 'E-Commerce & Shopping'
    WHEN domain LIKE '%canadiantire%'   THEN 'E-commerce & Shopping'

    WHEN domain LIKE '%google.com%'     THEN 'Search Engine'
    WHEN domain LIKE '%bing.com%'       THEN 'Search Engine'

    WHEN domain = 'live.com'            THEN 'Web Portal / Email'
    WHEN domain = 'microsoft.com'       THEN 'Web Portal / Email'
    WHEN domain = 'yahoo.com'           THEN 'Web Portal / Email'
    WHEN domain = 'msn.com'             THEN 'Web Portal / Email'

    WHEN domain = 'cbc.ca'              THEN 'News & Weather'
    
    WHEN domain = 'ctvnews.ca'          THEN 'News & Weather'
    WHEN domain = 'wikipedia.org'       THEN 'Reference'

    WHEN domain = 'canada.ca'           THEN 'Government'
    WHEN domain = 'gc.ca'               THEN 'Government'

    WHEN domain = 'unpkg.com'           THEN 'Technology / CDN'
    
    WHEN domain = 'microsoftonline.com' THEN 'Web Portal / Email'
    WHEN domain = 'apple.com'           THEN 'Technology / Electronics'
    WHEN domain = 'adobe.com'           THEN 'Technology / Software'
    WHEN domain = 'kijiji.ca'           THEN 'Marketplace'
    WHEN domain = 'samba.tv'            THEN 'Technology / Networking'
    WHEN domain = 'paypal.com'          THEN 'Online Payments'
    WHEN domain = 'bestbuy.ca'          THEN 'E-commerce & Shopping'
    WHEN domain = '360yield.com'        THEN 'Advertising / Technology'
    WHEN domain = 'office.com'          THEN 'Technology / Productivity'
    WHEN domain = 'blogspot.com'        THEN 'Blogging / Website Platform'
    WHEN domain = 'zoom.us'             THEN 'Video Conferencing'
    WHEN domain = 'ebay.ca'             THEN 'Marketplace'
    WHEN domain = 'imdb.com'            THEN 'Movies & Theatre'
    WHEN domain = 'indeed.com'          THEN 'Job Search'
    WHEN domain = 'etsy.com'            THEN 'Marketplace'
    WHEN domain = 'fandom.com'          THEN 'Fan Communities'
    WHEN domain = 'homedepot.ca'        THEN 'Home Improvement'
    WHEN domain = 'spotify.com'         THEN 'Music Streaming'
    WHEN domain = 'globalnews.ca'       THEN 'News & Weather'
    WHEN domain = 'ebay.com'            THEN 'Marketplace'
    WHEN domain = 'admantx.com'         THEN 'Advertising / Semantic Analysis'
    WHEN domain = 'td.com'              THEN 'Banking'
    WHEN domain = 'canadapost-postescanada.ca'  THEN 'Postal Service'
    WHEN domain = 'wordpress.com'               THEN 'Blogging / Website Platform'
    WHEN domain = 'sonobi.com'                  THEN 'Advertising / Technology'
    WHEN domain = 'healthline.com'              THEN 'Health Information'
    WHEN domain = 'stackadapt.com'              THEN 'Advertising / Technology'
    WHEN domain = 'costco.ca'                   THEN 'E-Commerce & Shopping'
    WHEN domain = 'theweathernetwork.com'       THEN 'News & Weather'
    WHEN domain = 'zendesk.com'                 THEN 'Customer Support'
    WHEN domain = 'cloudflare.com'              THEN 'CDN / Security'
    WHEN domain = 'stripe.com'                  THEN 'Online Payments'
    WHEN domain = 'on.ca'                       THEN 'Government'
    WHEN domain = 'easydmp.net'                 THEN 'Data Management Platform'
    WHEN domain = 'ontario.ca'                  THEN 'Government'
    WHEN domain = 'tripadvisor.ca'              THEN 'Travel'
    WHEN domain = 'primevideo.com'              THEN 'Video Streaming'
    WHEN domain = 'discord.com'                 THEN 'Gaming'
    WHEN domain = 'vidazoo.com'                 THEN 'Advertising / Video'
    WHEN domain = 'vimeo.com'                   THEN 'Video Streaming'
    WHEN domain = 'wikihow.com'                 THEN 'How-to Guides'
    WHEN domain = 'mktoresp.com'                THEN 'Marketing Automation'
    WHEN domain = 'qc.ca'                       THEN 'Government'
    WHEN domain = 'dropbox.com'                 THEN 'Cloud Storage / Collaboration'
    WHEN domain = 'cnn.com'                     THEN 'News & Weather'
    WHEN domain = 'rbcroyalbank.com'            THEN 'Banking'
    WHEN domain = 'fout.jp'                     THEN 'Other'
    WHEN domain = 'bell.ca'                     THEN 'Telecommunications'
    WHEN domain = 'yellowpages.ca'              THEN 'Business Directory'
    WHEN domain = 'shopify.com' THEN 'Blogging / Website Platform'
    WHEN domain = 'github.com' THEN 'Technology / Software Development'
    WHEN domain = 'myshopify.com' THEN 'Blogging / Website Platform'
    WHEN domain = 'example.com' THEN '(Unclear, please specify)'
    WHEN domain = 'yelp.ca' THEN 'Business Directory'
    WHEN domain = 'nytimes.com' THEN 'News & Weather'
    WHEN domain = 'outlook.com' THEN 'Web Portal / Email'
    WHEN domain = 'medallia.ca' THEN 'Customer Support'
    WHEN domain = 'samsung.com' THEN 'Technology / Electronics'
    WHEN domain = 'webmd.com' THEN 'Health Information'
    WHEN domain = 'ikea.com' THEN 'Home Improvement'
    WHEN domain = 'rogers.com' THEN 'Telecommunications'
    WHEN domain = 'arcgis.com' THEN 'Mapping / GIS'
    WHEN domain = 'connextra.com' THEN 'Advertising / Technology'
    WHEN domain = 'tumblr.com' THEN 'Blogging / Website Platform'
    WHEN domain = 'bbc.com' THEN 'News & Weather'
    WHEN domain = 'realtor.ca' THEN 'Real Estate'
    WHEN domain = 'forbes.com' THEN 'News & Weather'
    WHEN domain = 'github.io' THEN 'Technology / Software Development'
    WHEN domain = 'dailymotion.com' THEN 'Video Streaming'
    WHEN domain = 'securekeyconcierge.com' THEN 'Identity Verification'
    WHEN domain = 'steampowered.com' THEN 'Gaming'
    WHEN domain = 'twitch.tv' THEN 'Video Streaming'
    WHEN domain = 'rona.ca' THEN 'Home Improvement'
    WHEN domain = 'medium.com' THEN 'Blogging / Website Platform'
    WHEN domain = 'nih.gov' THEN 'Government'
    WHEN domain = 'sharepoint.com' THEN 'Collaboration / Document Management'
    WHEN domain = 'anyclip.com' THEN 'Advertising / Video'
    WHEN domain = 'businessinsider.com' THEN 'News & Weather'
    WHEN domain = 'amzn.to' THEN 'E-commerce & Shopping'
    WHEN domain = 'royalbank.com' THEN 'Banking'
    WHEN domain = 'theguardian.com' THEN 'News & Weather'
    WHEN domain = 'scotiabank.com' THEN 'Banking'
    WHEN domain = 'skype.com' THEN 'Communication / Video Calling'
    WHEN domain = 'expedia.ca' THEN 'Travel'
    WHEN domain = 'narcity.com' THEN 'News & Weather'
    WHEN domain = 'hp.com' THEN 'Technology / Electronics'
    WHEN domain = 'alibaba.com' THEN 'E-Commerce & Shopping'
    WHEN domain = 'staples.ca' THEN 'E-Commerce & Shopping'
    WHEN domain = 'cibc.com' THEN 'Banking'
    WHEN domain = 'shoppersdrugmart.ca' THEN 'Pharmacy'
    WHEN domain = 'gmail.com' THEN 'Web Portal / Email'
    WHEN domain = 'pelmorex.com' THEN 'Weather Information'
    WHEN domain = 'rbc.com' THEN 'Banking'
    WHEN domain = 'cardinalcommerce.com' THEN 'Blogging / Website Platform'
    WHEN domain = 'moneris.com' THEN 'Payment Processing'
    WHEN domain = 'booking.com' THEN 'Travel'
    WHEN domain = 'azurewebsites.net' THEN 'Web Hosting'
    WHEN domain = 'adobe.io' THEN 'Technology / Software'
    WHEN domain = 'intuit.com' THEN 'Financial Software'
    WHEN domain = 'thestar.com' THEN 'News & Weather'
    WHEN domain = 'mayoclinic.org' THEN 'Health Information'
    WHEN domain = 'telus.com' THEN 'Telecommunications'
    WHEN domain = 'weebly.com' THEN 'Blogging / Website Platform'
    WHEN domain = 'ctxtfl.com' THEN 'Other'
    WHEN domain = 'autotrader.ca' THEN 'Automotive'
    WHEN domain = 'drift.com' THEN 'Customer Support'
    WHEN domain = 'narvar.com' THEN 'Postal Service'
    WHEN domain = 'theglobeandmail.com' THEN 'News & Weather'
    WHEN domain = 'stackexchange.com' THEN 'Reference'
    WHEN domain = 'canadapost.ca' THEN 'Postal Service'
    WHEN domain = 'clickcease.com' THEN 'Ad Fraud Prevention'
    WHEN domain = 'bmo.com' THEN 'Banking'
    WHEN domain = 'office365.com' THEN 'Technology / Productivity'
    ELSE 'Other'
    END) AS domain_subcategory,

    (CASE
    
    WHEN (

      (event_detail LIKE '%purchase%' AND event_detail LIKE '%complete%')       OR
      (event_detail LIKE '%payment%' AND event_detail LIKE '%complete%')        OR
      (event_detail LIKE '%transaction%' AND event_detail LIKE '%complete%')    OR
      (event_detail LIKE '%checkout%' AND event_detail LIKE '%complete%')       OR
  
      (event_detail LIKE '%purchase%' AND event_detail LIKE '%success%')        OR
      (event_detail LIKE '%payment%' AND event_detail LIKE '%success%')         OR
      (event_detail LIKE '%transaction%' AND event_detail LIKE '%success%')     OR
      (event_detail LIKE '%checkout%' AND event_detail LIKE '%success%')        OR
  
      (event_detail LIKE '%purchase%' AND event_detail LIKE '%confirm%')        OR
      (event_detail LIKE '%payment%' AND event_detail LIKE '%confirm%')         OR
      (event_detail LIKE '%transaction%' AND event_detail LIKE '%confirm%')     OR
      (event_detail LIKE '%checkout%' AND event_detail LIKE '%confirm%')        OR
  
      (event_detail LIKE '%purchase%' AND event_detail LIKE '%finish%')         OR
      (event_detail LIKE '%payment%' AND event_detail LIKE '%finish%')          OR
      (event_detail LIKE '%transaction%' AND event_detail LIKE '%finish%')      OR
      (event_detail LIKE '%checkout%' AND event_detail LIKE '%finish%')         OR

      (event_detail LIKE '%purchase%' AND event_detail LIKE '%final%')          OR
      (event_detail LIKE '%payment%' AND event_detail LIKE '%final%')           OR
      (event_detail LIKE '%transaction%' AND event_detail LIKE '%final%')       OR
      (event_detail LIKE '%checkout%' AND event_detail LIKE '%final%')          OR

      (event_detail LIKE '%purchase%' AND event_detail LIKE '%done%')           OR
      (event_detail LIKE '%payment%' AND event_detail LIKE '%done%')            OR
      (event_detail LIKE '%transaction%' AND event_detail LIKE '%done%')        OR
      (event_detail LIKE '%checkout%' AND event_detail LIKE '%done%')           OR

      (event_detail LIKE '%purchase%' AND event_detail LIKE '%processed%')      OR
      (event_detail LIKE '%payment%' AND event_detail LIKE '%processed%')       OR
      (event_detail LIKE '%transaction%' AND event_detail LIKE '%processed%')   OR
      (event_detail LIKE '%checkout%' AND event_detail LIKE '%processed%')      OR

      (event_detail LIKE '%purchase%' AND event_detail LIKE '%validated%')      OR
      (event_detail LIKE '%payment%' AND event_detail LIKE '%validated%')       OR
      (event_detail LIKE '%transaction%' AND event_detail LIKE '%validated%')   OR
      (event_detail LIKE '%checkout%' AND event_detail LIKE '%validated%')    
    ) THEN 'CONVERTER'
    ELSE ''
    END) AS is_converter
    
    FROM spectrum_comscore.clickstream_ca
    WHERE date_part(year, calendar_date) >= 2021 AND date_part(year, calendar_date) <= 2022    
),

audience_pets AS (SELECT 
    COUNT(DISTINCT guid) as unique_users
    FROM user_data_comscore WHERE guid IN (
        SELECT DISTINCT guid
        FROM user_data_comscore
        WHERE domain_category = 'PETS' AND is_coverter = 'CONVERTER'
    )
),

audience_comscore AS (SELECT 
    COUNT(DISTINCT guid) as unique_users
FROM user_data_comscore
)

SELECT * FROM audience_pets
UNION ALL
SELECT * FROM audience_comscore

/*
SELECT
    a.domain_group,
    a.unique_users as unique_users_pets,
    b.unique_users as unique_users_comscore
FROM audience_pets AS a LEFT JOIN audience_comscore AS b 
ON a.domain_group = b.domain_group
ORDER BY a.unique_users DESC
*/
/*
SELECT 
    total_joined.domain,
    total_joined.domain_group,
    total_joined.unique_users_comscore,
    total_joined.unique_users_pets,
    total_comscore.total_users_comscore,
    total_audience.total_users_audience
FROM total_joined
CROSS JOIN total_comscore
CROSS JOIN total_audience
*/
LIMIT 50000;