WITH 
-- TOTAL USERS IN AUDIENCE AND THE DOMAINS THEY VISITED
total_filtered_competitive_users AS (
    SELECT 
          domain,
          guid
    FROM spectrum_comscore.clickstream_ca
    WHERE date_part(year, calendar_date) >= 2022 OR date_part(year, calendar_date) <= 2022 AND (
         ((domain LIKE '%canadiantire.ca%' OR event_detail  LIKE '%canadiantire.ca%' ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
      OR ((domain LIKE '%walmart.ca%'      OR event_detail  LIKE '%walmart.ca%'      ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
      OR ((domain LIKE '%amazon.ca%'       OR event_detail  LIKE '%amazon.ca%'       ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
      OR ((domain LIKE '%costco.ca%'       OR event_detail  LIKE '%costco.ca%'       ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
      OR ((domain LIKE '%sobeys.com%'      OR event_detail  LIKE '%sobeys.com%'      ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
      OR ((domain LIKE '%petland.ca%'      OR event_detail  LIKE '%petland.ca%'      ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
      OR ((domain LIKE '%petvalu.ca%'      OR event_detail  LIKE '%petvalu.ca%'      ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
      OR ((domain LIKE '%petsmart.ca%'     OR event_detail  LIKE '%petsmart.ca%'     ) AND (event_detail  LIKE '%pet%' OR event_detail  LIKE '%animalerie%' OR event_detail  LIKE '%animaux%'))
    )
),
-- TOTAL USERS IN COMSCORE AND THE DOMAINS THEY VISITED
total_filtered_comscore_users AS (
    SELECT 
          domain,
          guid
    FROM spectrum_comscore.clickstream_ca
    WHERE date_part(year, calendar_date) >= 2022 OR date_part(year, calendar_date) <= 2022
),

domain_visits_audience AS (
    SELECT  domain, 
            COUNT(DISTINCT guid) AS unique_users
    FROM    total_filtered_competitive_users
    GROUP BY domain
),

domain_visits_comscore AS (
    SELECT  domain,
            COUNT(DISTINCT guid) AS total_comscore_unique
            FROM total_filtered_comscore_users
    GROUP BY domain
),

-- TOTALS FOR CROSS JOINS
total_users_audience AS (
    SELECT COUNT(DISTINCT guid) AS total_users
    FROM total_filtered_competitive_users
),

total_users_comscore AS (
    SELECT COUNT(DISTINCT guid) AS total_users
    FROM total_filtered_comscore_users
),

percentage_audience AS (
  SELECT  dv.domain                             AS domain,
          dv.unique_users                       AS user_audience_unique,
          ttu.total_users                       AS user_audience_total
  FROM          domain_visits_audience          AS dv
  CROSS JOIN    total_users_audience            AS ttu
  ORDER BY      user_audience_unique DESC
),

totaleverything AS (
    SELECT  av.domain,
            av.user_audience_unique,
            av.user_audience_total,
            tcu.total_users                     AS user_comscore_total
    FROM    percentage_audience                 AS av 
    CROSS JOIN total_users_comscore             AS tcu
)

SELECT 
totaleverything.domain                          AS domain,
totaleverything.user_audience_unique            AS audience_unique,
totaleverything.user_audience_total             AS audience_total,
domain_visits_comscore.total_comscore_unique    AS comscore_unique,
totaleverything.user_comscore_total             AS comscore_total

FROM totaleverything LEFT JOIN domain_visits_comscore
ON totaleverything.domain = domain_visits_comscore.domain
ORDER BY audience_unique DESC
LIMIT 100000
;
