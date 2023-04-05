SELECT
    domain,
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
                OR (domain LIKE '%amazon%')
                OR (domain LIKE '%amzn%')
                OR (domain LIKE '%costco.ca%')
                OR (domain LIKE '%sobeys.com%')
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