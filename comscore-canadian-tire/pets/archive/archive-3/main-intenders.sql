SELECT 
(CASE
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
END) AS domain_group,
count (DISTINCT guid)
FROM spectrum_comscore.clickstream_ca
WHERE (date_part(year, calendar_date) = 2021 OR date_part(year, calendar_date) = 2022) AND
((domain LIKE '%petland.ca%'
OR domain LIKE '%petvalu.ca%'
OR domain LIKE '%petsmart.ca%'
OR domain LIKE '%baileyblu.com%'
OR domain LIKE '%chico.ca%'
OR domain LIKE '%mondou.com%'
OR domain LIKE '%pattesgriffes.com%'
OR domain LIKE '%tailblazerspets.com%'
OR domain LIKE '%wbu.com%') OR
(domain LIKE '%canadiantire.ca%' AND (event_detail LIKE '%animalerie%' OR event_detail LIKE '%pet-care%')) OR
(domain LIKE '%walmart.ca%' AND (event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%' OR event_detail LIKE '%pets%' OR event_detail LIKE '%pet-%' OR event_detail LIKE '%pet/%' OR event_detail LIKE '%pet\.%')) OR
((domain LIKE '%amazon%' OR domain LIKE '%amzn%') AND (event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%' OR event_detail LIKE '%pets%' OR event_detail LIKE '%pet-%' OR event_detail LIKE '%pet/%' OR event_detail LIKE '%pet\.%')) OR
(domain LIKE '%costco.ca%' AND (event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%' OR event_detail LIKE '%pets%' OR event_detail LIKE '%pet-%' OR event_detail LIKE '%pet/%' OR event_detail LIKE '%pet\.%')) OR
(domain LIKE '%sobeys.com%' AND (event_detail LIKE '%animalerie%' OR event_detail LIKE '%pet%')))
GROUP BY 1
ORDER BY 2 DESC

/*

Pet Smart	            3130
Mondou	                1429
Walmart	                1262
Amazon	                1067
Costco	                356
Canadian Tire	        323
Pet Land	            181
Pet Valu	            140
Wild Birds Unlimited	91
Chico	                77
Sobeys	                20
Pattes Griffes	        14
Tail Blazers	        8
Bailey Blu	            1

*/