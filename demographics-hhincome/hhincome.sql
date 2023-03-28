-- @WbResult person_demographics_ca
SELECT hh_income,
       COUNT(DISTINCT machine_id) AS unique_machine_id_counts,
       'Total Competitive Set (Pet-Category)' AS unique_machine_id_group
FROM spectrum_comscore.person_demographics_ca WHERE (date_part(year, date) >= 2019 and date_part(year, date) <= 2022) AND hh_income LIKE '%HH%'

AND machine_id IN (
  SELECT 
  DISTINCT machine_id
  FROM spectrum_comscore.clickstream_ca 
  WHERE date_part(year, calendar_date) >= 2019 and date_part(year, calendar_date) <= 2022 
    AND (
       ((domain LIKE '%canadiantire.ca%'   OR event_detail  LIKE '%canadiantire.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
    OR ((domain LIKE '%walmart.ca%'   OR event_detail  LIKE '%walmart.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
    OR ((domain LIKE '%amazon.ca%'   OR event_detail  LIKE '%amazon.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
    OR ((domain LIKE '%costco.ca%'   OR event_detail  LIKE '%costco.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
    OR ((domain LIKE '%sobeys.com%'   OR event_detail  LIKE '%sobeys.com%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
    OR ((domain LIKE '%petland.ca%'   OR event_detail  LIKE '%petland.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
    OR ((domain LIKE '%petvalu.ca%'   OR event_detail  LIKE '%petvalu.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
    OR ((domain LIKE '%petsmart.ca%'   OR event_detail  LIKE '%petsmart.ca%' ) AND  (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
  )
)

GROUP BY 1

UNION ALL

SELECT hh_income,
       COUNT(DISTINCT machine_id) AS unique_machine_id_counts,
       'Total Comscore' AS unique_machine_id_group
FROM spectrum_comscore.person_demographics_ca WHERE (date_part(year, date) >= 2019 and date_part(year, date) <= 2022) AND hh_income LIKE '%HH%'

GROUP BY 1

LIMIT 10000;

