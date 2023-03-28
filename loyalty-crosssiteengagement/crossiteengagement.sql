WITH user_website_count AS (
    SELECT guid,
           COUNT(DISTINCT
           (CASE 
              WHEN (domain LIKE '%canadiantire.ca%' OR event_detail  LIKE '%canadiantire.ca%') AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Canadian Tire' 
              WHEN (domain LIKE '%walmart.ca%'        OR event_detail  LIKE '%walmart.ca%'   ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Walmart'
              WHEN (domain LIKE '%amazon.ca%'         OR event_detail  LIKE '%amazon.ca%'    ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Amazon'
              WHEN (domain LIKE '%costco.ca%'         OR event_detail  LIKE '%costco.ca%'    ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Costco'
              WHEN (domain LIKE '%sobeys.com%'        OR event_detail  LIKE '%sobeys.com%'   ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Sobeys'
              WHEN (domain LIKE '%petland.ca%'        OR event_detail  LIKE '%petland.ca%'   ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetLand'
              WHEN (domain LIKE '%petvalu.ca%'        OR event_detail  LIKE '%petvalu.ca%'   ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetValu'
              WHEN (domain LIKE '%petsmart.ca%'       OR event_detail  LIKE '%petsmart.ca%'  ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetSmart'
          END)
           ) AS visited_websites
    FROM spectrum_comscore.clickstream_ca WHERE date_part(year, calendar_date) = 2022 AND (
         ((domain LIKE '%canadiantire.ca%' OR event_detail  LIKE '%canadiantire.ca%' ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
      OR ((domain LIKE '%walmart.ca%'      OR event_detail  LIKE '%walmart.ca%'      ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
      OR ((domain LIKE '%amazon.ca%'       OR event_detail  LIKE '%amazon.ca%'       ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
      OR ((domain LIKE '%costco.ca%'       OR event_detail  LIKE '%costco.ca%'       ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
      OR ((domain LIKE '%sobeys.com%'      OR event_detail  LIKE '%sobeys.com%'      ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
      OR ((domain LIKE '%petland.ca%'      OR event_detail  LIKE '%petland.ca%'      ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
      OR ((domain LIKE '%petvalu.ca%'      OR event_detail  LIKE '%petvalu.ca%'      ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
      OR ((domain LIKE '%petsmart.ca%'     OR event_detail  LIKE '%petsmart.ca%'     ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
    )
    GROUP BY guid
)

SELECT CASE
           WHEN visited_websites = 1 THEN '1 website'
           WHEN visited_websites = 2 THEN '2 websites'
           WHEN visited_websites = 3 THEN '3 websites'
           WHEN visited_websites = 4 THEN '4 websites'
           WHEN visited_websites = 5 THEN '5 websites'
           WHEN visited_websites = 6 THEN '6 websites'
           WHEN visited_websites = 7 THEN '7 websites'
           ELSE '8 or more websites'
       END AS website_bucket,
       COUNT(guid) AS number_of_users
FROM user_website_count
GROUP BY website_bucket
ORDER BY MIN(visited_websites)

LIMIT 10000

;

