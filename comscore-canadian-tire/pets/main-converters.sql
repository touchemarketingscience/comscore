-- COMSCORE - CONVERTER DEFINITION


-- **************************************************************************
-- COMSCORE - INTENDERS ONLY
--      @GUID
--      @DOMAIN GROUP (CLEANED DOMAIN)
-- **************************************************************************

WITH 
year_lower_bound AS (SELECT 2022 AS value),
year_upper_bound AS (SELECT 2022 AS value),

comscore_cleaned_intenders_only AS (SELECT 

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

WHERE (date_part(year, calendar_date) >= (SELECT value FROM year_lower_bound) AND date_part(year, calendar_date) <= (SELECT value FROM year_upper_bound)) AND

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
    SELECT guid, COUNT(*) AS frequency FROM spectrum_comscore.clickstream_ca
    WHERE (date_part(year, calendar_date) >= (SELECT value FROM year_lower_bound) AND date_part(year, calendar_date) <= (SELECT value FROM year_upper_bound)) AND (domain LIKE '%petsmart.c%') AND (
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
    GROUP BY 1
    ORDER BY 2 DESC
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

converter_group AS (
    SELECT
    domain_group,
    COUNT(DISTINCT guid) AS converters
    FROM comscore_cleaned_intenders_only
    WHERE guid IN (SELECT guid FROM converter_list_petsmart)
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
    FROM intender_group AS a LEFT JOIN converter_group AS b ON a.domain_group = b.domain_group
)

SELECT * FROM converter_list_petsmart

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