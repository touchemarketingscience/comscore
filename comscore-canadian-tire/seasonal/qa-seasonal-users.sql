WITH
date_lower_bound AS (SELECT '2022-11-16' AS value),
date_upper_bound AS (SELECT '2023-10-31' AS value),
main AS (
    select
        (CASE 
        WHEN date_part(month, calendar_date) = 1 THEN 'Winter'
        WHEN date_part(month, calendar_date) = 2 THEN 'Winter'
        WHEN date_part(month, calendar_date) = 3 THEN 'Spring'
        WHEN date_part(month, calendar_date) = 4 THEN 'Spring'
        WHEN date_part(month, calendar_date) = 5 THEN 'Spring'
        WHEN date_part(month, calendar_date) = 6 THEN 'Summer'
        WHEN date_part(month, calendar_date) = 7 THEN 'Summer'
        WHEN date_part(month, calendar_date) = 8 THEN 'Summer'
        WHEN date_part(month, calendar_date) = 9 THEN 'Fall'
        WHEN date_part(month, calendar_date) = 10 THEN 'Fall'
        WHEN date_part(month, calendar_date) = 11 AND date_part(day, calendar_date) <= 15 THEN 'Fall'
        WHEN date_part(month, calendar_date) = 11 AND date_part(day, calendar_date) > 15 THEN 'Winter'
        WHEN date_part(month, calendar_date) = 12 THEN 'Winter'
        END) as date_season,
        COUNT(DISTINCT guid) AS unique_users
    FROM spectrum_comscore.clickstream_ca
    WHERE ((calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound))
    GROUP BY 1
)
SELECT *
FROM main
LIMIT 1000;
