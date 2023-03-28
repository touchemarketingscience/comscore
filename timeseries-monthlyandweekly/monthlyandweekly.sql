WITH total_filter_competitor AS (
    SELECT guid,
           calendar_date,
           (CASE 
                WHEN (domain LIKE '%canadiantire.ca%' OR event_detail LIKE '%canadiantire.ca%') AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Canadian Tire' 
                WHEN (domain LIKE '%walmart.ca%'      OR event_detail LIKE '%walmart.ca%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Walmart'
                WHEN (domain LIKE '%amazon.ca%'       OR event_detail LIKE '%amazon.ca%'      ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Amazon'
                WHEN (domain LIKE '%costco.ca%'       OR event_detail LIKE '%costco.ca%'      ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Costco'
                WHEN (domain LIKE '%sobeys.com%'      OR event_detail LIKE '%sobeys.com%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Sobeys'
                WHEN (domain LIKE '%petland.ca%'      OR event_detail LIKE '%petland.ca%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetLand'
                WHEN (domain LIKE '%petvalu.ca%'      OR event_detail LIKE '%petvalu.ca%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetValu'
                WHEN (domain LIKE '%petsmart.ca%'     OR event_detail LIKE '%petsmart.ca%'    ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetSmart'
            END) as competitor
    FROM spectrum_comscore.clickstream_ca
    WHERE date_part(year, calendar_date) = 2022
),

total_comscore_users AS (
    SELECT
        calendar_date,
        'Comscore' AS competitor,
        COUNT(DISTINCT guid) AS unique_users
    FROM spectrum_comscore.clickstream_ca
    WHERE date_part(year, calendar_date) = 2022
    GROUP BY 1, 2
),

total_competitive_users AS (
    SELECT  calendar_date,
        competitor,
        COUNT(DISTINCT guid) AS unique_users
    FROM total_filter_competitor
    GROUP BY 1, 2
)

SELECT calendar_date, competitor, unique_users FROM total_comscore_users
UNION ALL
SELECT calendar_date, competitor, unique_users FROM total_competitive_users

LIMIT 10000;
