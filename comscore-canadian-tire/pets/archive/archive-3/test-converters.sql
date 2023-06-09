SELECT 

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
END) AS domain_group,

(CASE 
WHEN 
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
THEN 'Converter-Action'
ELSE 'Intender-Action'
END) AS segment_action,

count (DISTINCT guid)

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

GROUP BY 1, 2
ORDER BY 1 ASC

/*
Domain                  Intenders
Pet Smart	            3434
Mondou	                1417
Walmart	                1262
Pet Valu	            1166
Amazon	                1067
Costco	                356
Canadian Tire	        323
Pet Land	            183
Wild Birds Unlimited	90
Chico	                87
Sobeys	                20
Pattes Griffes	        14
Tail Blazers	        8
Bailey Blu	            1

*/