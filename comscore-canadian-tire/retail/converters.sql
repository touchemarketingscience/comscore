WITH 

year_lower_bound AS (SELECT 2021 AS value),
year_upper_bound AS (SELECT 2022 AS value),

comscore_filtered AS (
    SELECT 
        (CASE
        WHEN domain LIKE '%canadiantire.ca%' OR event_detail LIKE '%canadiantire.ca%' THEN 'Canadian Tire'
        ELSE domain
        END) AS competitor,
        event_detail,
        event_detail2,
        count (DISTINCT guid)
    FROM spectrum_comscore.clickstream_ca
    WHERE (date_part(year, calendar_date) >= (SELECT value FROM year_lower_bound) AND date_part(year, calendar_date) <= (SELECT value FROM year_upper_bound)) AND
        (domain LIKE '%canadiantire.ca%' OR event_detail LIKE '%canadiantire.ca%') AND (
        (event_detail2 LIKE '%convert%')                                        OR
        (event_detail2 LIKE '%checkout%')                                       OR
        (event_detail LIKE '%/commande%')                                       OR
        (event_detail LIKE '%shopping-cart%')                                   OR
        (event_detail LIKE '%/cart%')                                           OR
        (event_detail LIKE '%checkout%')                                        OR
        (event_detail LIKE '%shop%' AND event_detail LIKE '%cart%')             OR
        (event_detail LIKE '%cart%' AND event_detail LIKE '%shop%')             OR
        (event_detail LIKE '%history%' AND event_detail LIKE '%order%')         OR
        (event_detail LIKE '%order%' AND event_detail LIKE '%history%')         OR
        (event_detail LIKE '%recent%' AND event_detail LIKE '%order%')          OR
        (event_detail LIKE '%order%' AND event_detail LIKE '%recent%')          OR
        (event_detail LIKE '%account%' AND event_detail LIKE '%order%')         OR 
        (event_detail LIKE '%order%' AND event_detail LIKE '%account%')         
    )
    GROUP BY 1, 2, 3
    ORDER BY 4 DESC
)

SELECT * FROM comscore_filtered
LIMIT 10000;
