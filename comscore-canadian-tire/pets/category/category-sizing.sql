WITH 

year_lower_bound AS (SELECT 2021 AS value),
year_upper_bound AS (SELECT 2022 AS value),

non_unique_shopper_data AS (
    SELECT 

    COUNT(DISTINCT guid) as unique_users

    FROM spectrum_comscore.clickstream_ca
    WHERE (date_part(year, calendar_date) >= (SELECT value FROM year_lower_bound) AND date_part(year, calendar_date) <= (SELECT value FROM year_upper_bound)) AND
    (
        (domain LIKE '%walmart.c%') OR
        (domain LIKE '%canadiantire.c%') OR
        (domain LIKE '%loblaw.c%') OR
        (domain LIKE '%dollarama.c%') OR
        (domain LIKE '%metro.c%') OR      
        (domain LIKE '%sobeys.c%') OR    
        (domain LIKE '%shoppersdrugmart.c%') OR
        (domain LIKE '%bestbuy.c%') OR    
        (domain LIKE '%homedepot.c%') OR  
        (domain LIKE '%costco.c%') OR    
        (domain LIKE '%thebay.c%') OR    
        (domain LIKE '%indigo.c%') OR
        (domain LIKE '%jeancoutu.c%') OR 
        (domain LIKE '%londondrugs.c%') OR
        (domain LIKE '%sportchek.c%') OR  
        (domain LIKE '%ikea.c%') OR   
        (domain LIKE '%rona.c%') OR       
        (domain LIKE '%marks.c%') OR     
        (domain LIKE '%gianttiger.c%')
    )
)

SELECT * FROM non_unique_shopper_data
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