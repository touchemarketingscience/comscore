WITH
date_lower_bound AS (SELECT '2022-11-16' AS value),
date_upper_bound AS (SELECT '2023-10-31' AS value),
sub AS (
    select
   	 	guid,
        date_part(year, calendar_date) as date_year, 
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
        (CASE
	        WHEN domain = 'canadiantire.ca' OR domain = 'canadiantire.com' 	THEN 'Canadian Tire'
	        WHEN domain = 'amazon.ca' 		OR domain = 'amazon.com' 		THEN 'Amazon'
	        WHEN domain = 'walmart.ca' 		OR domain = 'walmart.com' 		THEN 'Walmart'
	        WHEN domain = 'bestbuy.ca' 		OR domain = 'bestbuy.com' 		THEN 'Best Buy'
	        WHEN domain = 'wayfair.ca' 		OR domain = 'wayfair.com' 		THEN 'Wayfair'
	        WHEN domain = 'ikea.com' 		OR domain = 'ikea.ca' 			THEN 'IKEA'
	        WHEN domain = 'thebay.com' 		OR domain = 'thebay.ca' 		THEN 'Hudsons Bay'
	        WHEN domain = 'labaie.com' 		OR domain = 'labaie.ca' 		THEN 'Hudsons Bay'
	        WHEN domain = 'homehardware.ca' OR domain = 'homehardware.com' 	THEN 'Home Hardware'
	        WHEN domain = 'homedepot.ca' 	OR domain = 'homedepot.com' 	THEN 'Home Depot'
	        WHEN domain = 'rona.ca' 		OR domain = 'rona.com' 			THEN 'Rona'
	        WHEN domain = 'lowes.ca' 		OR domain = 'lowes.com' 		THEN 'Lowes'
	        WHEN domain = 'renodepot.com' 	OR domain = 'renodepot.ca' 		THEN 'Reno Depot'
	        WHEN domain = 'costco.ca' 		OR domain = 'costco.com' 		THEN 'Costco'
	        WHEN domain = 'dollarama.com' 	OR domain = 'dollarama.ca' 		THEN 'Dollarama'
	        ELSE 'Not Included'
	     END) AS competitor,
    LOWER(event_detail) as event_detail
    FROM spectrum_comscore.clickstream_ca
    WHERE ((calendar_date) >= (SELECT value FROM date_lower_bound) AND calendar_date <= (SELECT value FROM date_upper_bound)) AND
        (
               (domain = 'canadiantire.ca' 	OR domain = 'canadiantire.com')
            OR (domain = 'amazon.ca' 		OR domain = 'amazon.com') 
            OR (domain = 'walmart.ca' 		OR domain = 'walmart.com') 
            OR (domain = 'bestbuy.ca' 		OR domain = 'bestbuy.com')
            OR (domain = 'wayfair.ca' 		OR domain = 'wayfair.com')
            OR (domain = 'ikea.com' 		OR domain = 'ikea.ca')
            OR (domain = 'thebay.com' 		OR domain = 'thebay.ca')
            OR (domain = 'labaie.com' 		OR domain = 'labaie.ca')
            OR (domain = 'homehardware.ca' 	OR domain = 'homehardware.com')
            OR (domain = 'homedepot.ca' 	OR domain = 'homedepot.com')
            OR (domain = 'rona.ca' 			OR domain = 'rona.com')
            OR (domain = 'lowes.ca' 		OR domain = 'lowes.com')
            OR (domain = 'renodepot.com' 	OR domain = 'renodepot.ca')
            OR (domain = 'costco.ca' 		OR domain = 'costco.com')
            OR (domain = 'dollarama.com' 	OR domain = 'dollarama.ca')
        )
),
main AS (
    SELECT 
    guid,
    date_year,
    date_season,
        competitor,
        (CASE 
            WHEN 
                (event_detail LIKE '%snow%' AND event_detail LIKE '%shovel%') OR
                (event_detail LIKE '%snow%' AND event_detail LIKE '%remov%') OR
                (event_detail LIKE '%snow%' AND event_detail LIKE '%blow%')
            THEN 'Winter & Snow Removal'
            WHEN 
                event_detail LIKE '%clean%' OR 
                event_detail LIKE '%stain%' OR
                event_detail LIKE '%vacuum%' OR 
                event_detail LIKE '%mop%' OR
                event_detail LIKE '%trash%' OR
                event_detail LIKE '%garbage%' OR
                event_detail LIKE '%bin%' OR
                event_detail LIKE '%bleach%' OR
                event_detail LIKE '%vacs%'
            THEN 'Cleaning'
            WHEN 
                event_detail LIKE '%christmas%' OR 
                event_detail LIKE '%oliday%' OR 
                event_detail LIKE '%joy%' OR
                (event_detail LIKE '%last%' AND event_detail LIKE '%gift%')
            THEN 'Christmas Holidays'
            WHEN 
                event_detail LIKE '%storage%' OR 
                event_detail LIKE '%organiz%' OR 
                event_detail LIKE '%closet%' OR 
                event_detail LIKE '%shelf%' OR
                event_detail LIKE '%shelv%' OR 
                event_detail LIKE '%moving-supplies%' OR
                event_detail LIKE '%cabinet%' OR
                event_detail LIKE '%shelf%' OR
                event_detail LIKE '%drawer%' OR
                event_detail LIKE '%book%'
            THEN 'Storage & Organization'
            WHEN 
                event_detail LIKE '%paint%' OR 
                event_detail LIKE '%fitting%' OR 
                event_detail LIKE '%building-material%' OR 
                event_detail LIKE '%tool-%' OR 
                event_detail LIKE '%dewalt%' OR 
                event_detail LIKE '%generator%' OR 
                event_detail LIKE '%roof%' OR 
                event_detail LIKE '%repair%' OR 
                event_detail LIKE '%socket%' OR 
                event_detail LIKE '%screw%' OR 
                event_detail LIKE '%pipe%' OR 
                event_detail LIKE '%diy%' OR 
                event_detail LIKE '%plywood%' OR
                event_detail LIKE '%repair%' OR 
                event_detail LIKE '%tile%' OR
                event_detail LIKE '%tools-hardware%' OR
                event_detail LIKE '%lighting%' OR
                event_detail LIKE '%window%' OR
                event_detail LIKE '%faucet%' OR
                event_detail LIKE '%mastercraft%' OR
                event_detail LIKE '%rust%' OR
                event_detail LIKE '%tub%' OR 
                event_detail LIKE '%glass%' OR
                event_detail LIKE '%floor%' OR 
                event_detail LIKE '%sideboard%' OR
                event_detail LIKE '%milwaukee%' OR
                event_detail LIKE '%makita%' OR
                event_detail LIKE '%drill%' OR
                event_detail LIKE '%kitchen%' OR
                event_detail LIKE '%led%' OR
                event_detail LIKE '%-door%' OR
                event_detail LIKE '%shower%' OR
                event_detail LIKE '%bathroom%' OR
                event_detail LIKE '%construct%' OR
                event_detail LIKE '%plumbing%' OR
                event_detail LIKE '%light%' OR
                event_detail LIKE '%toilet%' OR
                event_detail LIKE '%hardware%' OR
                event_detail LIKE '%husky%' OR
                event_detail LIKE '%knob%' OR
                event_detail LIKE '%renova%' OR
                event_detail LIKE '%wall%' OR
                event_detail LIKE '%baseboard%' OR
                event_detail LIKE '%shop-vac%' OR
                event_detail LIKE '%saw%' OR
                event_detail LIKE '%-tool%' OR
                event_detail LIKE '%decor%' OR
                event_detail LIKE '%stanley%' OR
                event_detail LIKE '%safety%' OR
                event_detail LIKE '%noma%' OR 
                event_detail LIKE '%theatre%' OR
                event_detail LIKE '%stair%' OR
                event_detail LIKE '%stud%'
            THEN 'Home Improvement & Maintenance'
            WHEN 
                event_detail LIKE '%sport%' OR 
                event_detail LIKE '%basketball%' OR 
                event_detail LIKE '%hockey%' 
            THEN 'Team Sports'
            WHEN 
                event_detail LIKE '%grass%' OR 
                event_detail LIKE '%plant%' OR 
                event_detail LIKE '%grow%' OR 
                event_detail LIKE '%lawn%' OR 
                event_detail LIKE '%leaf%' OR 
                event_detail LIKE '%scotts%' OR
                event_detail LIKE '%garden%' OR
                event_detail LIKE '%jardin%' OR
                event_detail LIKE '%fertilizer%' OR
                event_detail LIKE '%trimmer%' OR
                event_detail LIKE '%flower%'
            THEN 'Lawncare'
            WHEN 
                event_detail LIKE '%bike%' OR 
                event_detail LIKE '%bicycle%' OR
                event_detail LIKE '%biking%' OR 
                event_detail LIKE '%scooter%' 
            THEN 'Transport'
            WHEN 
                event_detail LIKE '%trampoline%' OR 
                event_detail LIKE '%nerf%' OR 
                event_detail LIKE '%water-gun%' OR
                (event_detail LIKE '%swing%' AND event_detail LIKE '%set%') OR
                event_detail LIKE '%play%' AND (event_detail LIKE '%house%' OR event_detail LIKE '%ground%')
            THEN 'Backyard Toys'
            WHEN 
                event_detail LIKE '%camp%' OR 
                event_detail LIKE '%fishing%' OR 
                event_detail LIKE '%tent%' OR 
                event_detail LIKE '%boat%' OR
                event_detail LIKE '%coleman%' OR
                event_detail LIKE '%luggage%' OR
                event_detail LIKE '%travel%' OR
                event_detail LIKE '%hiking%' OR
                event_detail LIKE '%vlog%' OR
                event_detail LIKE '%gps%' OR
                event_detail LIKE '%knife%' or
                event_detail LIKE '%kayak%' or
                event_detail LIKE '%canoe%'
            THEN 'Adventure'
            WHEN 
                event_detail LIKE '%outdoor%' OR 
                event_detail LIKE '%terrasse%' OR
                event_detail LIKE '%bbq%' OR 
                event_detail LIKE '%grill%' OR 
                event_detail LIKE '%gazebo%' OR 
                event_detail LIKE '%deck%' OR 
                event_detail LIKE '%pool%' OR 
                event_detail LIKE '%swim%' OR 
                event_detail LIKE '%spa%' OR 
                event_detail LIKE '%patio%' OR
                event_detail LIKE '%barbecue%' OR
                event_detail LIKE '%barbeque%' OR
                event_detail LIKE '%garage%' OR 
                event_detail LIKE '%outdoor-living%'
            THEN 'Garage & Outdoor'
            ELSE 'Other' 
        END) AS category,
        COUNT(*) as pageviews
    FROM sub
    group by 1, 2, 3, 4, 5
)
SELECT *
FROM main
LIMIT 800000;
