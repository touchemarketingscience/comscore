-- COMSCORE - CONVERTER DEFINITION


-- **************************************************************************
-- COMSCORE - INTENDERS ONLY
--      @GUID
--      @DOMAIN GROUP (CLEANED DOMAIN)
-- **************************************************************************

WITH comscore_cleaned_intenders_only AS (SELECT 

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

WHERE (date_part(year, calendar_date) >= 2021 AND date_part(year, calendar_date) <= 2022) AND

((domain LIKE 'petland.c%')
OR (domain LIKE '%petvalu.c%')
OR (domain LIKE '%petsmart.c%')
OR (domain LIKE '%baileyblu.com%')
OR (domain LIKE 'chico.c%' OR domain LIKE '%boutiquedanimauxchico.com%')
OR (domain LIKE 'mondou.c%')
OR (domain LIKE '%pattesgriffes.com%')
OR (domain LIKE '%tailblazerspets.com%')
OR (domain LIKE 'wbu.c%') OR
(domain LIKE '%canadiantire.ca%' AND (event_detail LIKE '%animalerie%' OR event_detail LIKE '%pet-care%')) OR
(domain LIKE '%walmart.ca%' AND (event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%' OR event_detail LIKE '%pets%' OR event_detail LIKE '%pet-%' OR event_detail LIKE '%pet/%' OR event_detail LIKE '%pet\.%')) OR
((domain LIKE '%amazon%' OR domain LIKE '%amzn%') AND (event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%' OR event_detail LIKE '%pets%' OR event_detail LIKE '%pet-%' OR event_detail LIKE '%pet/%' OR event_detail LIKE '%pet\.%')) OR
(domain LIKE '%costco.ca%' AND (event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%' OR event_detail LIKE '%pets%' OR event_detail LIKE '%pet-%' OR event_detail LIKE '%pet/%' OR event_detail LIKE '%pet\.%')) OR
(domain LIKE '%sobeys.com%' AND (event_detail LIKE '%animalerie%' OR event_detail LIKE '%pet%'))) 

),

-- **************************************************************************
-- PETSMART CONVERTERS 
-- **************************************************************************
converter_list_petsmart AS (
    SELECT DISTINCT guid FROM spectrum_comscore.clickstream_ca
    WHERE (date_part(year, calendar_date) >= 2021 AND date_part(year, calendar_date) <= 2022) AND (domain LIKE '%petsmart.c%') AND (
        (event_detail LIKE '%shopping-cart%')                                   OR
        (event_detail LIKE '%/cart%')                                           OR
        (event_detail LIKE '%checkout%')                                        OR
        (event_detail LIKE '%shop%' AND event_detail LIKE '%cart%')             OR
        (event_detail LIKE '%cart%' AND event_detail LIKE '%shop%')             OR
        (event_detail LIKE '%history%' AND event_detail LIKE '%order%')         OR
        (event_detail LIKE '%order%' AND event_detail LIKE '%history%')         OR
        (event_detail LIKE '%recent%' AND event_detail LIKE '%order%')          OR
        (event_detail LIKE '%order%' AND event_detail LIKE '%recent%')          OR
        (event_detail LIKE '%account%' AND event_detail LIKE '%order%')         OR 
        (event_detail LIKE '%order%' AND event_detail LIKE '%account%')         
    )
),

converter_list_canadiantire AS (
    SELECT DISTINCT guid FROM spectrum_comscore.clickstream_ca
    WHERE (date_part(year, calendar_date) >= 2021 AND date_part(year, calendar_date) <= 2022) AND (domain LIKE '%canadiantire.ca%') AND (
        (event_detail LIKE '%shopping-cart%')                                   OR
        (event_detail LIKE '%/cart%')                                           OR
        (event_detail LIKE '%checkout%')                                        OR
        (event_detail LIKE '%shop%' AND event_detail LIKE '%cart%')             OR
        (event_detail LIKE '%cart%' AND event_detail LIKE '%shop%')             OR
        (event_detail LIKE '%history%' AND event_detail LIKE '%order%')         OR
        (event_detail LIKE '%order%' AND event_detail LIKE '%history%')         OR
        (event_detail LIKE '%recent%' AND event_detail LIKE '%order%')          OR
        (event_detail LIKE '%order%' AND event_detail LIKE '%recent%')          OR
        (event_detail LIKE '%account%' AND event_detail LIKE '%order%')         OR 
        (event_detail LIKE '%order%' AND event_detail LIKE '%account%')         
    )
),

converter_list_amazon AS (
    SELECT DISTINCT guid FROM spectrum_comscore.clickstream_ca
    WHERE (date_part(year, calendar_date) >= 2021 AND date_part(year, calendar_date) <= 2022) AND (domain LIKE '%amazon%' OR domain LIKE '%amzn%') AND (
        (event_detail LIKE '%shopping-cart%')                                   OR
        (event_detail LIKE '%/cart%')                                           OR
        (event_detail LIKE '%checkout%')                                        OR
        (event_detail LIKE '%shop%' AND event_detail LIKE '%cart%')             OR
        (event_detail LIKE '%cart%' AND event_detail LIKE '%shop%')             OR
        (event_detail LIKE '%history%' AND event_detail LIKE '%order%')         OR
        (event_detail LIKE '%order%' AND event_detail LIKE '%history%')         OR
        (event_detail LIKE '%recent%' AND event_detail LIKE '%order%')          OR
        (event_detail LIKE '%order%' AND event_detail LIKE '%recent%')          OR
        (event_detail LIKE '%account%' AND event_detail LIKE '%order%')         OR 
        (event_detail LIKE '%order%' AND event_detail LIKE '%account%')         
    )
),

converter_list_walmart AS (
    SELECT DISTINCT guid FROM spectrum_comscore.clickstream_ca
    WHERE (date_part(year, calendar_date) >= 2021 AND date_part(year, calendar_date) <= 2022) AND (domain LIKE '%walmart.ca%') AND (
        (event_detail LIKE '%shopping-cart%')                                   OR
        (event_detail LIKE '%/cart%')                                           OR
        (event_detail LIKE '%checkout%')                                        OR
        (event_detail LIKE '%shop%' AND event_detail LIKE '%cart%')             OR
        (event_detail LIKE '%cart%' AND event_detail LIKE '%shop%')             OR
        (event_detail LIKE '%history%' AND event_detail LIKE '%order%')         OR
        (event_detail LIKE '%order%' AND event_detail LIKE '%history%')         OR
        (event_detail LIKE '%recent%' AND event_detail LIKE '%order%')          OR
        (event_detail LIKE '%order%' AND event_detail LIKE '%recent%')          OR
        (event_detail LIKE '%account%' AND event_detail LIKE '%order%')         OR 
        (event_detail LIKE '%order%' AND event_detail LIKE '%account%')         
    )
),

converter_list_costco AS (
    SELECT DISTINCT guid FROM spectrum_comscore.clickstream_ca
    WHERE (date_part(year, calendar_date) >= 2021 AND date_part(year, calendar_date) <= 2022) AND (domain LIKE '%costco.ca%') AND (
        (event_detail LIKE '%shopping-cart%')                                   OR
        (event_detail LIKE '%/cart%')                                           OR
        (event_detail LIKE '%checkout%')                                        OR
        (event_detail LIKE '%shop%' AND event_detail LIKE '%cart%')             OR
        (event_detail LIKE '%cart%' AND event_detail LIKE '%shop%')             OR
        (event_detail LIKE '%history%' AND event_detail LIKE '%order%')         OR
        (event_detail LIKE '%order%' AND event_detail LIKE '%history%')         OR
        (event_detail LIKE '%recent%' AND event_detail LIKE '%order%')          OR
        (event_detail LIKE '%order%' AND event_detail LIKE '%recent%')          OR
        (event_detail LIKE '%account%' AND event_detail LIKE '%order%')         OR 
        (event_detail LIKE '%order%' AND event_detail LIKE '%account%')         
    )
),

converter_list_sobeys AS (
    SELECT DISTINCT guid FROM spectrum_comscore.clickstream_ca
    WHERE (date_part(year, calendar_date) >= 2021 AND date_part(year, calendar_date) <= 2022) AND (domain LIKE '%sobeys.com%') AND (
        (event_detail LIKE '%shopping-cart%')                                   OR
        (event_detail LIKE '%/cart%')                                           OR
        (event_detail LIKE '%checkout%')                                        OR
        (event_detail LIKE '%shop%' AND event_detail LIKE '%cart%')             OR
        (event_detail LIKE '%cart%' AND event_detail LIKE '%shop%')             OR
        (event_detail LIKE '%history%' AND event_detail LIKE '%order%')         OR
        (event_detail LIKE '%order%' AND event_detail LIKE '%history%')         OR
        (event_detail LIKE '%recent%' AND event_detail LIKE '%order%')          OR
        (event_detail LIKE '%order%' AND event_detail LIKE '%recent%')          OR
        (event_detail LIKE '%account%' AND event_detail LIKE '%order%')         OR 
        (event_detail LIKE '%order%' AND event_detail LIKE '%account%')         
    )
),


-- **************************************************************************
-- INTENDER AND CONVERTER COLUMNS
-- **************************************************************************

intender_group AS (
    SELECT
    domain_group,
    COUNT(DISTINCT guid) AS intenders
    FROM comscore_cleaned_intenders_only
    GROUP BY 1
),

converter_group_petsmart AS (
    SELECT
    domain_group,
    COUNT(DISTINCT guid) AS converters
    FROM comscore_cleaned_intenders_only
    WHERE guid IN (SELECT guid FROM converter_list_petsmart)
    GROUP BY 1
),

converter_group_canadiantire AS (
    SELECT
    domain_group,
    COUNT(DISTINCT guid) AS converters
    FROM comscore_cleaned_intenders_only
    WHERE guid IN (SELECT guid FROM converter_list_canadiantire)
    GROUP BY 1
),

converter_group_walmart AS (
    SELECT
    domain_group,
    COUNT(DISTINCT guid) AS converters
    FROM comscore_cleaned_intenders_only
    WHERE guid IN (SELECT guid FROM converter_list_walmart)
    GROUP BY 1
),

converter_group_amazon AS (
    SELECT
    domain_group,
    COUNT(DISTINCT guid) AS converters
    FROM comscore_cleaned_intenders_only
    WHERE guid IN (SELECT guid FROM converter_list_amazon)
    GROUP BY 1
),

converter_group_costco AS (
    SELECT
    domain_group,
    COUNT(DISTINCT guid) AS converters
    FROM comscore_cleaned_intenders_only
    WHERE guid IN (SELECT guid FROM converter_list_costco)
    GROUP BY 1
),

converter_group_sobeys AS (
    SELECT
    domain_group,
    COUNT(DISTINCT guid) AS converters
    FROM comscore_cleaned_intenders_only
    WHERE guid IN (SELECT guid FROM converter_list_sobeys)
    GROUP BY 1
),

-- **************************************************************************
-- OUTPUT TABLE
-- **************************************************************************

converters_petsmart AS (SELECT
    'Pet Smart' as converter_brand,
    a.domain_group,
    a.intenders,
    b.converters
    FROM intender_group AS a LEFT JOIN converter_group_petsmart AS b ON a.domain_group = b.domain_group
),

converters_canadiantire AS (SELECT
    'Canadian Tire' as converter_brand,
    a.domain_group,
    a.intenders,
    b.converters
    FROM intender_group AS a LEFT JOIN converter_group_canadiantire AS b ON a.domain_group = b.domain_group
),

converters_walmart AS (SELECT
    'Walmart' as converter_brand,
    a.domain_group,
    a.intenders,
    b.converters
    FROM intender_group AS a LEFT JOIN converter_group_walmart AS b ON a.domain_group = b.domain_group
),

converters_amazon AS (SELECT
    'Amazon' as converter_brand,
    a.domain_group,
    a.intenders,
    b.converters
    FROM intender_group AS a LEFT JOIN converter_group_amazon AS b ON a.domain_group = b.domain_group
),

converters_costco AS (SELECT
    'Costco' as converter_brand,
    a.domain_group,
    a.intenders,
    b.converters
    FROM intender_group AS a LEFT JOIN converter_group_costco AS b ON a.domain_group = b.domain_group
),

converters_sobeys AS (SELECT
    'Sobeys' as converter_brand,
    a.domain_group,
    a.intenders,
    b.converters
    FROM intender_group AS a LEFT JOIN converter_group_sobeys AS b ON a.domain_group = b.domain_group
)


SELECT * FROM converters_petsmart
UNION ALL
SELECT * FROM converters_canadiantire
UNION ALL
SELECT * FROM converters_walmart
UNION ALL
SELECT * FROM converters_amazon
UNION ALL
SELECT * FROM converters_costco
UNION ALL
SELECT * FROM converters_sobeys


/* RESULT:
domain_group            intenders	converters
Pet Smart	            3434	    514
Mondou	                1417	    13
Walmart	                1262	    69
Pet Valu	            1166	    152
Amazon	                1067	    67
Costco	                356	         33
Canadian Tire	        323	        46
Pet Land	            83	        34
Wild Birds Unlimited	90	         5
Chico	                87	
Sobeys	                20	        1
Pattes Griffes	        14	
Tail Blazers	        8	        2
Bailey Blu	            1	

*/