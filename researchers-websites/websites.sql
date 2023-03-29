WITH total_filtered_competitive_set_users AS (
    SELECT 
          domain,
          guid
    FROM spectrum_comscore.clickstream_ca
    WHERE date_part(year, calendar_date) >= 2021 OR date_part(year, calendar_date) <= 2022 AND (
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

domain_visits AS (
    SELECT domain, COUNT(DISTINCT guid) AS unique_users
    FROM total_filtered_competitive_set_users
    GROUP BY domain
),
total_target_users AS (
    SELECT COUNT(DISTINCT guid) AS total_users
    FROM total_filtered_competitive_set_users
),

total_comscore_users AS (
    SELECT COUNT(DISTINCT guid) AS total_users
    FROM spectrum_comscore.clickstream_ca
    WHERE date_part(year, calendar_date) >= 2021 OR date_part(year, calendar_date) <= 2022
),

audience_percentage AS (
  SELECT  dv.domain AS domain,
          dv.unique_users AS user_audience_unique,
          ttu.total_users AS user_audience_total,
          (dv.unique_users * 100.0 / ttu.total_users)  AS user_audience_reach
  FROM domain_visits AS dv
  CROSS JOIN total_target_users AS ttu
  ORDER BY user_audience_reach DESC
),

comscore_domain_users AS (
SELECT 
       domain,
       COUNT(DISTINCT guid) AS total_comscore_audience
FROM spectrum_comscore.clickstream_ca WHERE date_part(year, calendar_date) >= 2021 OR date_part(year, calendar_date) <= 2022
GROUP BY domain
),

totaleverything AS (SELECT  av.domain,
        av.user_audience_unique,
        av.user_audience_total,
        av.user_audience_reach,
        tcu.total_users AS user_comscore_total
FROM audience_percentage AS av
CROSS JOIN total_comscore_users AS tcu
ORDER BY user_audience_reach DESC
)

SELECT 
totaleverything.domain,
totaleverything.user_audience_unique,
totaleverything.user_audience_total,
totaleverything.user_audience_reach,
totaleverything.user_comscore_total,
comscore_domain_users.total_comscore_audience

FROM totaleverything LEFT JOIN comscore_domain_users
ON totaleverything.domain = comscore_domain_users.domain;



LIMIT 100
;