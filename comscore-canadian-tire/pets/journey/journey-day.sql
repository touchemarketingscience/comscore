WITH 

year_lower_bound AS (SELECT 2022 AS value),
year_upper_bound AS (SELECT 2022 AS value),
user_guid AS (SELECT 342580090 AS value),
user_date AS (SELECT '2022-01-20' AS value),

daily AS(
SELECT 
       calendar_date,
       date_part(year, calendar_date) AS year,
       date_part(month, calendar_date) AS month,
       to_char(calendar_date, 'Day') as day,
       (CASE 
       WHEN  ((domain LIKE 'petland.c%')
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
        THEN 'Pet Event'
        ELSE ''
       END) AS event_of_interest,
       domain,
       event_detail,
       event_detail2,
       event_time,
       time_spent
FROM spectrum_comscore.clickstream_ca 
WHERE guid = (SELECT value FROM user_guid) AND (
    date_part(year, calendar_date) >= (SELECT value FROM year_lower_bound) AND 
    date_part(year, calendar_date) <= (SELECT value FROM year_upper_bound)
) AND calendar_date = (SELECT value FROM user_date)
ORDER BY event_time ASC
),

daily_time AS (
   SELECT
       domain,
       SUM(time_spent) / 60 / 60 AS total_time_spent_hours
FROM spectrum_comscore.clickstream_ca 
WHERE guid = (SELECT value FROM user_guid) AND (
    date_part(year, calendar_date) >= (SELECT value FROM year_lower_bound) AND 
    date_part(year, calendar_date) <= (SELECT value FROM year_upper_bound)
) AND calendar_date = (SELECT value FROM user_date)
GROUP BY 1
)

SELECT * FROM daily LEFT JOIN daily_time ON daily.domain = daily_time.domain ORDER BY daily_time.total_time_spent_hours DESC