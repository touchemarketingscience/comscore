SELECT
    (CASE 
        WHEN (domain LIKE '%canadiantire.ca%' OR event_detail LIKE '%canadiantire.ca%')         THEN 'Canadian Tire'
        WHEN (domain LIKE '%walmart.ca%' OR event_detail LIKE '%walmart.ca%')                   THEN 'Walmart'
        WHEN (domain LIKE '%amzn%' OR domain LIKE '%amazon%' OR event_detail LIKE '%amazon%')   THEN 'Amazon'
        WHEN (domain LIKE '%costco.ca%' OR event_detail LIKE '%costco.ca%')                     THEN 'Costco'
        WHEN (domain LIKE '%sobeys.com%' OR event_detail LIKE '%sobeys.com%')                   THEN 'Sobeys'
        WHEN (domain LIKE '%petland.ca%' OR event_detail LIKE '%petland.ca%')                   THEN 'Pet Land'
        WHEN (domain LIKE '%petvalu.ca%' OR event_detail LIKE '%petvalu.ca%')                   THEN 'Pet Valu'
        WHEN (domain LIKE '%petsmart.ca%' OR event_detail LIKE '%petsmart.ca%')                 THEN 'Pet Smart'
        WHEN (domain LIKE '%baileyblu.com%'  OR event_detail LIKE '%baileyblu.com%')            THEN 'Bailey Blu'
        WHEN (domain LIKE '%chico.ca%' OR event_detail LIKE '%chico.ca%')                       THEN 'Chico'
        WHEN (domain LIKE '%mondou.com%' OR event_detail LIKE '%mondou.com%')                   THEN 'Mondou'
        WHEN (domain LIKE '%pattesgriffes.com%' OR event_detail LIKE '%pattesgriffes.com%')     THEN 'Pattes Griffes'
        WHEN (domain LIKE '%tailblazerspets.com%' OR event_detail LIKE '%tailblazerspets.com%') THEN 'Tail Blazers'
        WHEN (domain LIKE '%wbu.com%' OR event_detail LIKE '%wbu.com%')                         THEN 'Wild Birds Unlimited'
        ELSE domain
    END) AS domain_group,
    count (DISTINCT guid)
FROM
    spectrum_comscore.clickstream_ca
WHERE
    (
        (
            date_part(year, calendar_date) = 2021
            OR date_part(year, calendar_date) = 2022
        )
        AND (
            (
                (
                    domain LIKE '%canadiantire.ca%' AND event_detail LIKE '%pet-care%'      OR
                    domain LIKE '%canadiantire.ca%' AND event_detail LIKE '%animalerie%' 
                )
                OR (domain LIKE '%walmart.ca%')
                OR (
                    domain LIKE '%amazon%' OR domain LIKE '%amzn%'
                )
                OR (domain LIKE '%costco.ca%')
                OR (
                    domain LIKE '%sobeys.com%' AND event_detail LIKE '%pet-care%'
                )
            )
            AND (
                event_detail LIKE '%animalerie%'
                OR event_detail LIKE '%animaux%'
                OR event_detail LIKE '%pets%'
                OR event_detail LIKE '%pet-%'
                OR event_detail LIKE '%pet/%'
                OR event_detail LIKE '%pet\.%'
            )
            AND (
                event_detail NOT LIKE '%peti%'
                OR event_detail NOT LIKE '%peta%'
                OR event_detail NOT LIKE '%petr%'
                OR event_detail NOT LIKE '%ppet%'
            )
        )
        OR (domain LIKE '%petland.ca%')
        OR (domain LIKE '%petvalu.ca%')
        OR (domain LIKE '%petsmart.ca%')
        OR (domain LIKE '%baileyblu.com%')
        OR (domain LIKE '%chico.ca%')
        OR (domain LIKE '%mondou.com%')
        OR (domain LIKE '%pattesgriffes.com%')
        OR (domain LIKE '%tailblazerspets.com%')
        OR (domain LIKE '%wbu.com%')
    )
GROUP BY
    1
ORDER BY
    2 desc
LIMIT
    10000;