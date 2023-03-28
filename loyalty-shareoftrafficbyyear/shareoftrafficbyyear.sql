
-- @WbResult clickstream_ca
SELECT 
date_part(year, calendar_date),
(CASE WHEN (domain LIKE '%canadiantire.ca%' OR event_detail  LIKE '%canadiantire.ca%') AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Canadian Tire' 
      WHEN (domain LIKE '%walmart.ca%'        OR event_detail  LIKE '%walmart.ca%'   ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Walmart'
      WHEN (domain LIKE '%amazon.ca%'         OR event_detail  LIKE '%amazon.ca%'    ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Amazon'
      WHEN (domain LIKE '%costco.ca%'         OR event_detail  LIKE '%costco.ca%'    ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Costco'
      WHEN (domain LIKE '%sobeys.com%'        OR event_detail  LIKE '%sobeys.com%'   ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Sobeys'
      WHEN (domain LIKE '%petland.ca%'        OR event_detail  LIKE '%petland.ca%'   ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetLand'
      WHEN (domain LIKE '%petvalu.ca%'        OR event_detail  LIKE '%petvalu.ca%'   ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetValu'
      WHEN (domain LIKE '%petsmart.ca%'       OR event_detail  LIKE '%petsmart.ca%'  ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetSmart'
END) AS competitor_name,
COUNT(DISTINCT guid) as unique_users
FROM spectrum_comscore.clickstream_ca WHERE (date_part(year, calendar_date) >= 2019 and date_part(year, calendar_date) <= 2022) AND (
         ((domain LIKE '%canadiantire.ca%'   OR event_detail  LIKE '%canadiantire.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
      OR ((domain LIKE '%walmart.ca%'   OR event_detail  LIKE '%walmart.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
      OR ((domain LIKE '%amazon.ca%'   OR event_detail  LIKE '%amazon.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
      OR ((domain LIKE '%costco.ca%'   OR event_detail  LIKE '%costco.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
      OR ((domain LIKE '%sobeys.com%'   OR event_detail  LIKE '%sobeys.com%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
      OR ((domain LIKE '%petland.ca%'   OR event_detail  LIKE '%petland.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
      OR ((domain LIKE '%petvalu.ca%'   OR event_detail  LIKE '%petvalu.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
      OR ((domain LIKE '%petsmart.ca%'   OR event_detail  LIKE '%petsmart.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
)

GROUP BY 1, 2

UNION ALL

-- @WbResult clickstream_ca
SELECT 

date_part(year, calendar_date),
'Total Comscore' AS competitor_name,
COUNT(DISTINCT guid) as unique_users
FROM spectrum_comscore.clickstream_ca WHERE (date_part(year, calendar_date) >= 2019 and date_part(year, calendar_date) <= 2022)
GROUP BY 1, 2


LIMIT 10000

;

