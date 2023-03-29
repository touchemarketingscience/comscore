-- @WbResult clickstream_ca

WITH audience_canadiantire AS (
      SELECT DISTINCT guid FROM spectrum_comscore.clickstream_ca 
      WHERE (date_part(year, calendar_date) >= 2022 and date_part(year, calendar_date) <= 2022) AND (
            (domain LIKE '%canadiantire.ca%' OR event_detail LIKE '%canadiantire.ca%') AND 
            (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%')
      )
),

audience_petsmart AS (
      SELECT DISTINCT guid FROM spectrum_comscore.clickstream_ca 
      WHERE (date_part(year, calendar_date) >= 2022 and date_part(year, calendar_date) <= 2022) AND (
            (domain LIKE '%petsmart.ca%' OR event_detail LIKE '%petsmart.ca%') AND 
            (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%')
      )
),

audience_walmart AS (
      SELECT DISTINCT guid FROM spectrum_comscore.clickstream_ca 
      WHERE (date_part(year, calendar_date) >= 2022 and date_part(year, calendar_date) <= 2022) AND (
            (domain LIKE '%walmart.ca%' OR event_detail LIKE '%walmart.ca%') AND 
            (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%')
      )
),

audience_amazon AS (
      SELECT DISTINCT guid FROM spectrum_comscore.clickstream_ca 
      WHERE (date_part(year, calendar_date) >= 2022 and date_part(year, calendar_date) <= 2022) AND (
            (domain LIKE '%amazon.ca%' OR event_detail LIKE '%amazon.ca%') AND 
            (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%')
      )
),

audience_costco AS (
      SELECT DISTINCT guid FROM spectrum_comscore.clickstream_ca 
      WHERE (date_part(year, calendar_date) >= 2022 and date_part(year, calendar_date) <= 2022) AND (
            (domain LIKE '%costco.ca%' OR event_detail LIKE '%costco.ca%') AND 
            (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%')
      )
),

audience_sobeys AS (
      SELECT DISTINCT guid FROM spectrum_comscore.clickstream_ca 
      WHERE (date_part(year, calendar_date) >= 2022 and date_part(year, calendar_date) <= 2022) AND (
            (domain LIKE '%sobeys.com%' OR event_detail LIKE '%sobeys.com%') AND 
            (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%')
      )
),

audience_petland AS (
      SELECT DISTINCT guid FROM spectrum_comscore.clickstream_ca 
      WHERE (date_part(year, calendar_date) >= 2022 and date_part(year, calendar_date) <= 2022) AND (
            (domain LIKE '%petland.ca%' OR event_detail LIKE '%petland.ca%') AND 
            (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%')
      )
),

audience_petvalu AS (
      SELECT DISTINCT guid FROM spectrum_comscore.clickstream_ca 
      WHERE (date_part(year, calendar_date) >= 2022 and date_part(year, calendar_date) <= 2022) AND (
            (domain LIKE '%petvalu.ca%' OR event_detail LIKE '%petvalu.ca%') AND 
            (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%')
      )
)


SELECT 
       'Canadian Tire' AS competitor_origin,
      (CASE 
            WHEN (domain LIKE '%canadiantire.ca%' OR event_detail LIKE '%canadiantire.ca%') AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Canadian Tire' 
            WHEN (domain LIKE '%walmart.ca%'      OR event_detail LIKE '%walmart.ca%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Walmart'
            WHEN (domain LIKE '%amazon.ca%'       OR event_detail LIKE '%amazon.ca%'      ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Amazon'
            WHEN (domain LIKE '%costco.ca%'       OR event_detail LIKE '%costco.ca%'      ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Costco'
            WHEN (domain LIKE '%sobeys.com%'      OR event_detail LIKE '%sobeys.com%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Sobeys'
            WHEN (domain LIKE '%petland.ca%'      OR event_detail LIKE '%petland.ca%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetLand'
            WHEN (domain LIKE '%petvalu.ca%'      OR event_detail LIKE '%petvalu.ca%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetValu'
            WHEN (domain LIKE '%petsmart.ca%'     OR event_detail LIKE '%petsmart.ca%'    ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetSmart'
      END) as competitor,
      COUNT(DISTINCT guid) AS unique_users
FROM spectrum_comscore.clickstream_ca 
WHERE (date_part(year, calendar_date) >= 2022 and date_part(year, calendar_date) <= 2022) AND guid IN (
      SELECT guid FROM audience_canadiantire
)
GROUP BY competitor_origin, competitor

UNION ALL

SELECT 
       'PetSmart' AS competitor_origin,
      (CASE 
            WHEN (domain LIKE '%canadiantire.ca%' OR event_detail LIKE '%canadiantire.ca%') AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Canadian Tire' 
            WHEN (domain LIKE '%walmart.ca%'      OR event_detail LIKE '%walmart.ca%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Walmart'
            WHEN (domain LIKE '%amazon.ca%'       OR event_detail LIKE '%amazon.ca%'      ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Amazon'
            WHEN (domain LIKE '%costco.ca%'       OR event_detail LIKE '%costco.ca%'      ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Costco'
            WHEN (domain LIKE '%sobeys.com%'      OR event_detail LIKE '%sobeys.com%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Sobeys'
            WHEN (domain LIKE '%petland.ca%'      OR event_detail LIKE '%petland.ca%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetLand'
            WHEN (domain LIKE '%petvalu.ca%'      OR event_detail LIKE '%petvalu.ca%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetValu'
            WHEN (domain LIKE '%petsmart.ca%'     OR event_detail LIKE '%petsmart.ca%'    ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetSmart'
      END) as competitor,
      COUNT(DISTINCT guid) AS unique_users
FROM spectrum_comscore.clickstream_ca 
WHERE (date_part(year, calendar_date) >= 2022 and date_part(year, calendar_date) <= 2022) AND guid IN (
      SELECT guid FROM audience_petsmart
)
GROUP BY competitor_origin, competitor

UNION ALL

SELECT 
       'Walmart' AS competitor_origin,
      (CASE 
            WHEN (domain LIKE '%canadiantire.ca%' OR event_detail LIKE '%canadiantire.ca%') AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Canadian Tire' 
            WHEN (domain LIKE '%walmart.ca%'      OR event_detail LIKE '%walmart.ca%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Walmart'
            WHEN (domain LIKE '%amazon.ca%'       OR event_detail LIKE '%amazon.ca%'      ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Amazon'
            WHEN (domain LIKE '%costco.ca%'       OR event_detail LIKE '%costco.ca%'      ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Costco'
            WHEN (domain LIKE '%sobeys.com%'      OR event_detail LIKE '%sobeys.com%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Sobeys'
            WHEN (domain LIKE '%petland.ca%'      OR event_detail LIKE '%petland.ca%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetLand'
            WHEN (domain LIKE '%petvalu.ca%'      OR event_detail LIKE '%petvalu.ca%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetValu'
            WHEN (domain LIKE '%petsmart.ca%'     OR event_detail LIKE '%petsmart.ca%'    ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetSmart'
      END) as competitor,
      COUNT(DISTINCT guid) AS unique_users
FROM spectrum_comscore.clickstream_ca 
WHERE (date_part(year, calendar_date) >= 2022 and date_part(year, calendar_date) <= 2022) AND guid IN (
      SELECT guid FROM audience_walmart
)
GROUP BY competitor_origin, competitor

UNION ALL 

SELECT 
       'Amazon' AS competitor_origin,
      (CASE 
            WHEN (domain LIKE '%canadiantire.ca%' OR event_detail LIKE '%canadiantire.ca%') AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Canadian Tire' 
            WHEN (domain LIKE '%walmart.ca%'      OR event_detail LIKE '%walmart.ca%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Walmart'
            WHEN (domain LIKE '%amazon.ca%'       OR event_detail LIKE '%amazon.ca%'      ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Amazon'
            WHEN (domain LIKE '%costco.ca%'       OR event_detail LIKE '%costco.ca%'      ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Costco'
            WHEN (domain LIKE '%sobeys.com%'      OR event_detail LIKE '%sobeys.com%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Sobeys'
            WHEN (domain LIKE '%petland.ca%'      OR event_detail LIKE '%petland.ca%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetLand'
            WHEN (domain LIKE '%petvalu.ca%'      OR event_detail LIKE '%petvalu.ca%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetValu'
            WHEN (domain LIKE '%petsmart.ca%'     OR event_detail LIKE '%petsmart.ca%'    ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetSmart'
      END) as competitor,
      COUNT(DISTINCT guid) AS unique_users
FROM spectrum_comscore.clickstream_ca 
WHERE (date_part(year, calendar_date) >= 2022 and date_part(year, calendar_date) <= 2022) AND guid IN (
      SELECT guid FROM audience_amazon
)
GROUP BY competitor_origin, competitor

UNION ALL 

SELECT 
       'Costco' AS competitor_origin,
      (CASE 
            WHEN (domain LIKE '%canadiantire.ca%' OR event_detail LIKE '%canadiantire.ca%') AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Canadian Tire' 
            WHEN (domain LIKE '%walmart.ca%'      OR event_detail LIKE '%walmart.ca%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Walmart'
            WHEN (domain LIKE '%amazon.ca%'       OR event_detail LIKE '%amazon.ca%'      ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Amazon'
            WHEN (domain LIKE '%costco.ca%'       OR event_detail LIKE '%costco.ca%'      ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Costco'
            WHEN (domain LIKE '%sobeys.com%'      OR event_detail LIKE '%sobeys.com%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Sobeys'
            WHEN (domain LIKE '%petland.ca%'      OR event_detail LIKE '%petland.ca%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetLand'
            WHEN (domain LIKE '%petvalu.ca%'      OR event_detail LIKE '%petvalu.ca%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetValu'
            WHEN (domain LIKE '%petsmart.ca%'     OR event_detail LIKE '%petsmart.ca%'    ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetSmart'
      END) as competitor,
      COUNT(DISTINCT guid) AS unique_users
FROM spectrum_comscore.clickstream_ca 
WHERE (date_part(year, calendar_date) >= 2022 and date_part(year, calendar_date) <= 2022) AND guid IN (
      SELECT guid FROM audience_costco
)
GROUP BY competitor_origin, competitor

UNION ALL 

SELECT 
       'PetValu' AS competitor_origin,
      (CASE 
            WHEN (domain LIKE '%canadiantire.ca%' OR event_detail LIKE '%canadiantire.ca%') AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Canadian Tire' 
            WHEN (domain LIKE '%walmart.ca%'      OR event_detail LIKE '%walmart.ca%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Walmart'
            WHEN (domain LIKE '%amazon.ca%'       OR event_detail LIKE '%amazon.ca%'      ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Amazon'
            WHEN (domain LIKE '%costco.ca%'       OR event_detail LIKE '%costco.ca%'      ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Costco'
            WHEN (domain LIKE '%sobeys.com%'      OR event_detail LIKE '%sobeys.com%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Sobeys'
            WHEN (domain LIKE '%petland.ca%'      OR event_detail LIKE '%petland.ca%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetLand'
            WHEN (domain LIKE '%petvalu.ca%'      OR event_detail LIKE '%petvalu.ca%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetValu'
            WHEN (domain LIKE '%petsmart.ca%'     OR event_detail LIKE '%petsmart.ca%'    ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetSmart'
      END) as competitor,
      COUNT(DISTINCT guid) AS unique_users
FROM spectrum_comscore.clickstream_ca 
WHERE (date_part(year, calendar_date) >= 2022 and date_part(year, calendar_date) <= 2022) AND guid IN (
      SELECT guid FROM audience_petvalu
)
GROUP BY competitor_origin, competitor

UNION ALL 

SELECT 
       'PetLand' AS competitor_origin,
      (CASE 
            WHEN (domain LIKE '%canadiantire.ca%' OR event_detail LIKE '%canadiantire.ca%') AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Canadian Tire' 
            WHEN (domain LIKE '%walmart.ca%'      OR event_detail LIKE '%walmart.ca%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Walmart'
            WHEN (domain LIKE '%amazon.ca%'       OR event_detail LIKE '%amazon.ca%'      ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Amazon'
            WHEN (domain LIKE '%costco.ca%'       OR event_detail LIKE '%costco.ca%'      ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Costco'
            WHEN (domain LIKE '%sobeys.com%'      OR event_detail LIKE '%sobeys.com%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Sobeys'
            WHEN (domain LIKE '%petland.ca%'      OR event_detail LIKE '%petland.ca%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetLand'
            WHEN (domain LIKE '%petvalu.ca%'      OR event_detail LIKE '%petvalu.ca%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetValu'
            WHEN (domain LIKE '%petsmart.ca%'     OR event_detail LIKE '%petsmart.ca%'    ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetSmart'
      END) as competitor,
      COUNT(DISTINCT guid) AS unique_users
FROM spectrum_comscore.clickstream_ca 
WHERE (date_part(year, calendar_date) >= 2022 and date_part(year, calendar_date) <= 2022) AND guid IN (
      SELECT guid FROM audience_petland
)
GROUP BY competitor_origin, competitor

UNION ALL 

SELECT 
       'Sobeys' AS competitor_origin,
      (CASE 
            WHEN (domain LIKE '%canadiantire.ca%' OR event_detail LIKE '%canadiantire.ca%') AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Canadian Tire' 
            WHEN (domain LIKE '%walmart.ca%'      OR event_detail LIKE '%walmart.ca%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Walmart'
            WHEN (domain LIKE '%amazon.ca%'       OR event_detail LIKE '%amazon.ca%'      ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Amazon'
            WHEN (domain LIKE '%costco.ca%'       OR event_detail LIKE '%costco.ca%'      ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Costco'
            WHEN (domain LIKE '%sobeys.com%'      OR event_detail LIKE '%sobeys.com%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'Sobeys'
            WHEN (domain LIKE '%petland.ca%'      OR event_detail LIKE '%petland.ca%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetLand'
            WHEN (domain LIKE '%petvalu.ca%'      OR event_detail LIKE '%petvalu.ca%'     ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetValu'
            WHEN (domain LIKE '%petsmart.ca%'     OR event_detail LIKE '%petsmart.ca%'    ) AND (event_detail LIKE '%pet%' OR event_detail LIKE '%animalerie%' OR event_detail LIKE '%animaux%') THEN 'PetSmart'
      END) as competitor,
      COUNT(DISTINCT guid) AS unique_users
FROM spectrum_comscore.clickstream_ca 
WHERE (date_part(year, calendar_date) >= 2022 and date_part(year, calendar_date) <= 2022) AND guid IN (
      SELECT guid FROM audience_sobeys
)
GROUP BY competitor_origin, competitor

ORDER BY competitor_origin, unique_users DESC
LIMIT 10000;