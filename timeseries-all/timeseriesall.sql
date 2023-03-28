-- QUERY TO GET TOTAL USERS
SELECT calendar_date,
       COUNT(DISTINCT guid) AS unique_users,
       'Unique Users: Total' AS unique_user_group
       
FROM spectrum_comscore.clickstream_ca 
WHERE date_part(year, calendar_date) >= 2019 and date_part(year, calendar_date) <= 2022
GROUP BY 1

UNION ALL

-- QUERY TO GET TOTAL USERS IN PET CATEGORY
SELECT calendar_date,
       COUNT(DISTINCT guid) AS unique_users,
       'Unique Users: Zvelo Pet Category' AS unique_user_group
FROM spectrum_comscore.clickstream_ca 
WHERE date_part(year, calendar_date) >= 2019 and date_part(year, calendar_date) <= 2022
AND zvelo LIKE '%Pet%'
GROUP BY 1

UNION ALL
-- QUERY TO GET TOTAL USERS IN RETAIL SECTOR OVERALL
SELECT calendar_date,
       COUNT(DISTINCT guid) AS unique_users,
       'Unique Users: Competitive Set' AS unique_user_group
FROM spectrum_comscore.clickstream_ca 
WHERE date_part(year, calendar_date) >= 2019 and date_part(year, calendar_date) <= 2022 AND (
  (domain LIKE '%canadiantire.ca%'   OR event_detail  LIKE '%canadiantire.ca%'    ) OR
  (domain LIKE '%petsmart.ca%'       OR event_detail  LIKE '%petsmart.ca%'        ) OR
  (domain LIKE '%walmart.ca%'        OR event_detail  LIKE '%walmart.ca%'         ) OR
  (domain LIKE '%amazon.ca%'         OR event_detail  LIKE '%amazon.ca%'          ) OR
  (domain LIKE '%costco.ca%'         OR event_detail  LIKE '%costco.ca%'          ) OR
  (domain LIKE '%petland.ca%'        OR event_detail  LIKE '%petland.ca%'         ) OR
  (domain LIKE '%petvalu.com%'       OR event_detail  LIKE '%petvalu.com%'        ) OR
  (domain LIKE '%sobeys.com%'        OR event_detail  LIKE '%sobeys.com%'         )
)
GROUP BY 1

UNION ALL

-- QUERY TO GET TOTAL USERS IN RETAIL SECTOR, PET CATEGORY ONLY
SELECT calendar_date,
       COUNT(DISTINCT guid) AS unique_users,
       'Unique Users: Competitive Set - Pet Category' AS unique_user_group
FROM spectrum_comscore.clickstream_ca 
WHERE date_part(year, calendar_date) >= 2019 and date_part(year, calendar_date) <= 2022 AND (
     ((domain LIKE '%canadiantire.ca%'   OR event_detail  LIKE '%canadiantire.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
  OR ((domain LIKE '%walmart.ca%'   OR event_detail  LIKE '%walmart.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
  OR ((domain LIKE '%walmart.ca%'   OR event_detail  LIKE '%walmart.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
  OR ((domain LIKE '%amazon.ca%'   OR event_detail  LIKE '%amazon.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
  OR ((domain LIKE '%costco.ca%'   OR event_detail  LIKE '%costco.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
  OR ((domain LIKE '%sobeys.com%'   OR event_detail  LIKE '%sobeys.com%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
  OR ((domain LIKE '%petland.ca%'   OR event_detail  LIKE '%petland.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
  OR ((domain LIKE '%petvalu.ca%'   OR event_detail  LIKE '%petvalu.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
  OR ((domain LIKE '%petsmart.ca%'   OR event_detail  LIKE '%petsmart.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
)
GROUP BY 1

UNION ALL

-- QUERY TO GET TOTAL USERS IN RETAIL SECTOR, PET CATEGORY ONLY, HIGH-VALUE ACTION
SELECT calendar_date,
       COUNT(DISTINCT guid) AS unique_users,
       'Unique Users: Competitive Set - Pet Category (High-Value Action)' AS unique_user_group
FROM spectrum_comscore.clickstream_ca 
WHERE date_part(year, calendar_date) >= 2019 and date_part(year, calendar_date) <= 2022 AND (
     ((domain LIKE '%canadiantire.ca%'   OR event_detail  LIKE '%canadiantire.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
  OR ((domain LIKE '%walmart.ca%'   OR event_detail  LIKE '%walmart.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
  OR ((domain LIKE '%walmart.ca%'   OR event_detail  LIKE '%walmart.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
  OR ((domain LIKE '%amazon.ca%'   OR event_detail  LIKE '%amazon.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
  OR ((domain LIKE '%costco.ca%'   OR event_detail  LIKE '%costco.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
  OR ((domain LIKE '%sobeys.com%'   OR event_detail  LIKE '%sobeys.com%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
  OR ((domain LIKE '%petland.ca%'   OR event_detail  LIKE '%petland.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
  OR ((domain LIKE '%petvalu.ca%'   OR event_detail  LIKE '%petvalu.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
  OR ((domain LIKE '%petsmart.ca%'   OR event_detail  LIKE '%petsmart.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
) AND (
event_detail  LIKE '%checkout%' 
OR event_detail LIKE '%check-out%' 
OR event_detail LIKE '%thank%' 
OR event_detail LIKE '%buy%' 
OR event_detail LIKE '%payment%' 
OR event_detail LIKE '%purchase%'
OR event_detail LIKE '%billing%'
OR event_detail LIKE '%receipt%'
OR event_detail LIKE '%confirm%'
)
GROUP BY 1

UNION ALL

-- QUERY TO GET TOTAL USERS IN RETAIL SECTOR, PET CATEGORY ONLY, MIDFUNNEL ACTION
SELECT calendar_date,
       COUNT(DISTINCT guid) AS unique_users,
       'Unique Users: Competitive Set - Pet Category (Mid-Funnel Action)' AS unique_user_group
FROM spectrum_comscore.clickstream_ca 
WHERE date_part(year, calendar_date) >= 2019 and date_part(year, calendar_date) <= 2022 AND (
     ((domain LIKE '%canadiantire.ca%'   OR event_detail  LIKE '%canadiantire.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
  OR ((domain LIKE '%walmart.ca%'   OR event_detail  LIKE '%walmart.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
  OR ((domain LIKE '%walmart.ca%'   OR event_detail  LIKE '%walmart.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
  OR ((domain LIKE '%amazon.ca%'   OR event_detail  LIKE '%amazon.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
  OR ((domain LIKE '%costco.ca%'   OR event_detail  LIKE '%costco.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
  OR ((domain LIKE '%sobeys.com%'   OR event_detail  LIKE '%sobeys.com%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
  OR ((domain LIKE '%petland.ca%'   OR event_detail  LIKE '%petland.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
  OR ((domain LIKE '%petvalu.ca%'   OR event_detail  LIKE '%petvalu.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
  OR ((domain LIKE '%petsmart.ca%'   OR event_detail  LIKE '%petsmart.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
) AND (
   event_detail NOT LIKE '%checkout%' 
OR event_detail NOT LIKE '%check-out%' 
OR event_detail NOT LIKE '%thank%' 
OR event_detail NOT LIKE '%buy%' 
OR event_detail NOT LIKE '%payment%' 
OR event_detail NOT LIKE '%purchase%'
OR event_detail NOT LIKE '%billing%'
OR event_detail NOT LIKE '%receipt%'
OR event_detail NOT LIKE '%confirm%'
)
GROUP BY 1
ORDER BY 1 ASC, 2 ASC, 3 ASC;