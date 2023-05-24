WITH 

year_lower_bound AS (SELECT '2022-01-01' AS value),
year_upper_bound AS (SELECT '2022-01-31' AS value),
user_guid AS (SELECT 342580090 AS value),

event_time_journey AS (
    SELECT 
    calendar_date,
    date_part(year, calendar_date) AS year,
    date_part(month, calendar_date) AS month,
    to_char(calendar_date, 'Day') as day,
    (CASE 
    WHEN ((domain LIKE 'petland.c%') OR (domain LIKE '%petvalu.c%') OR (domain LIKE '%petsmart.c%') OR (domain LIKE '%baileyblu.com%') OR (domain LIKE 'chico.c%' OR domain LIKE '%boutiquedanimauxchico.com%') OR (domain LIKE 'mondou.c%') OR (domain LIKE '%pattesgriffes.com%') OR (domain LIKE '%tailblazerspets.com%') OR (domain LIKE 'wbu.c%') OR (domain LIKE '%canadiantire.ca%' AND (event_detail LIKE '%animalerie%' OR event_detail LIKE '%pet-care%')) OR (domain LIKE '%walmart.ca%' AND (event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%' OR event_detail LIKE '%pets%' OR event_detail LIKE '%pet-%' OR event_detail LIKE '%pet/%' OR event_detail LIKE '%pet\.%')) OR ((domain LIKE '%amazon%' OR domain LIKE '%amzn%') AND (event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%' OR event_detail LIKE '%pets%' OR event_detail LIKE '%pet-%' OR event_detail LIKE '%pet/%' OR event_detail LIKE '%pet\.%')) OR (domain LIKE '%costco.ca%' AND (event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%' OR event_detail LIKE '%pets%' OR event_detail LIKE '%pet-%' OR event_detail LIKE '%pet/%' OR event_detail LIKE '%pet\.%')) OR (domain LIKE '%sobeys.com%' AND (event_detail LIKE '%animalerie%' OR event_detail LIKE '%pet%'))) 
    THEN 'Pet Event' ELSE ''
    END) AS event_of_interest,
    domain,
    event_detail,
    event_detail2,
    event_time,
    time_spent
    FROM spectrum_comscore.clickstream_ca 
    WHERE guid = (SELECT value FROM user_guid) AND (calendar_date >= (SELECT value FROM year_lower_bound) AND calendar_date <= (SELECT value FROM year_upper_bound)) 
    ORDER BY calendar_date ASC, event_time ASC
)

SELECT * FROM event_time_journey;