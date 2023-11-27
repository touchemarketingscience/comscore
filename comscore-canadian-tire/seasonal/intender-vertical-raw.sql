-- Define constants for year boundaries to avoid repeated subqueries
--set YearLowerBound=2022
--set YearUpperBound=2023
WITH main_competitor AS (
    SELECT 
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
        event_detail,
        COUNT(DISTINCT guid) AS unique_users
    FROM spectrum_comscore.clickstream_ca
    WHERE date_part(year, calendar_date) >= ${YearLowerBound} AND date_part(year, calendar_date) <= ${YearUpperBound}
        AND 
        ( -- INTENDER LOGIC
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
    GROUP BY 1, 2
),
main_category AS (
    SELECT 
        competitor,
        (CASE 
            WHEN 
                (LOWER(event_detail) LIKE '%snow%' AND LOWER(event_detail) LIKE '%shovel%') OR
                (LOWER(event_detail) LIKE '%snow%' AND LOWER(event_detail) LIKE '%remov%') OR
                (LOWER(event_detail) LIKE '%snow%' AND LOWER(event_detail) LIKE '%blow%')
            THEN 'Winter & Snow Removal'
            WHEN 
                LOWER(event_detail) LIKE '%clean%' OR 
                LOWER(event_detail) LIKE '%stain%' OR
                LOWER(event_detail) LIKE '%vacuum%' OR 
                LOWER(event_detail) LIKE '%mop%' OR
                LOWER(event_detail) LIKE '%trash%' OR
                LOWER(event_detail) LIKE '%garbage%' OR
                LOWER(event_detail) LIKE '%bin%' OR
                LOWER(event_detail) LIKE '%bleach%'
            THEN 'Cleaning'
            WHEN 
                LOWER(event_detail) LIKE '%christmas%' OR 
                LOWER(event_detail) LIKE '%holiday%' OR 
                LOWER(event_detail) LIKE '%joy%' OR
                (LOWER(event_detail) LIKE '%last%' AND LOWER(event_detail) LIKE '%gift%')
            THEN 'Christmas Holidays'
            WHEN 
                LOWER(event_detail) LIKE '%storage%' OR 
                LOWER(event_detail) LIKE '%organiz%' OR 
                LOWER(event_detail) LIKE '%closet%' OR 
                LOWER(event_detail) LIKE '%shelf%' OR
                LOWER(event_detail) LIKE '%shelv%' OR 
                LOWER(event_detail) LIKE '%moving-supplies%' OR
                LOWER(event_detail) LIKE '%cabinet%' OR
                LOWER(event_detail) LIKE '%shelf%' OR
                LOWER(event_detail) LIKE '%drawer%' OR
                LOWER(event_detail) LIKE '%book%'
            THEN 'Storage & Organization'
            WHEN 
                LOWER(event_detail) LIKE '%paint%' OR 
                LOWER(event_detail) LIKE '%fitting%' OR 
                LOWER(event_detail) LIKE '%building-material%' OR 
                LOWER(event_detail) LIKE '%tool-%' OR 
                LOWER(event_detail) LIKE '%dewalt%' OR 
                LOWER(event_detail) LIKE '%generator%' OR 
                LOWER(event_detail) LIKE '%roof%' OR 
                LOWER(event_detail) LIKE '%repair%' OR 
                LOWER(event_detail) LIKE '%socket%' OR 
                LOWER(event_detail) LIKE '%screw%' OR 
                LOWER(event_detail) LIKE '%pipe%' OR 
                LOWER(event_detail) LIKE '%diy%' OR 
                LOWER(event_detail) LIKE '%plywood%' OR
                LOWER(event_detail) LIKE '%repair%' OR 
                LOWER(event_detail) LIKE '%tile%' OR
                LOWER(event_detail) LIKE '%tools-hardware%' OR
                LOWER(event_detail) LIKE '%lighting%' OR
                LOWER(event_detail) LIKE '%window%' OR
                LOWER(event_detail) LIKE '%faucet%' OR
                LOWER(event_detail) LIKE '%mastercraft%' OR
                LOWER(event_detail) LIKE '%rust%' OR
                LOWER(event_detail) LIKE '%tub%' OR 
                LOWER(event_detail) LIKE '%glass%' OR
                LOWER(event_detail) LIKE '%floor%' OR 
                LOWER(event_detail) LIKE '%sideboard%' OR
                LOWER(event_detail) LIKE '%milwaukee%' OR
                LOWER(event_detail) LIKE '%makita%' OR
                LOWER(event_detail) LIKE '%drill%' OR
                LOWER(event_detail) LIKE '%kitchen%' OR
                LOWER(event_detail) LIKE '%led%' OR
                LOWER(event_detail) LIKE '%-door%' OR
                LOWER(event_detail) LIKE '%shower%' OR
                LOWER(event_detail) LIKE '%bathroom%' OR
                LOWER(event_detail) LIKE '%construct%' OR
                LOWER(event_detail) LIKE '%plumbing%' OR
                LOWER(event_detail) LIKE '%light%' OR
                LOWER(event_detail) LIKE '%toilet%' OR
                LOWER(event_detail) LIKE '%hardware%' OR
                LOWER(event_detail) LIKE '%husky%' OR
                LOWER(event_detail) LIKE '%knob%' OR
                LOWER(event_detail) LIKE '%renova%' OR
                LOWER(event_detail) LIKE '%wall%' OR
                LOWER(event_detail) LIKE '%baseboard%' OR
                LOWER(event_detail) LIKE '%shop-vac%' OR
                LOWER(event_detail) LIKE '%saw%' OR
                LOWER(event_detail) LIKE '%-tool%' OR
                LOWER(event_detail) LIKE '%decor%' OR
                LOWER(event_detail) LIKE '%stanley%' OR
                LOWER(event_detail) LIKE '%safety%' OR
                LOWER(event_detail) LIKE '%noma%'
            THEN 'Home Improvement & Maintenance'
            WHEN 
                LOWER(event_detail) LIKE '%sport%' OR 
                LOWER(event_detail) LIKE '%basketball%' OR 
                LOWER(event_detail) LIKE '%hockey%' 
            THEN 'Team Sports'
            WHEN 
                LOWER(event_detail) LIKE '%grass%' OR 
                LOWER(event_detail) LIKE '%plant%' OR 
                LOWER(event_detail) LIKE '%grow%' OR 
                LOWER(event_detail) LIKE '%lawn%' OR 
                LOWER(event_detail) LIKE '%leaf%' OR 
                LOWER(event_detail) LIKE '%scotts%' OR
                LOWER(event_detail) LIKE '%garden%' OR
                LOWER(event_detail) LIKE '%jardin%' OR
                LOWER(event_detail) LIKE '%fertilizer%' OR
                LOWER(event_detail) LIKE '%trimmer%' 
            THEN 'Lawncare'
            WHEN 
                LOWER(event_detail) LIKE '%bike%' OR 
                LOWER(event_detail) LIKE '%bicycle%' OR
                LOWER(event_detail) LIKE '%biking%' OR 
                LOWER(event_detail) LIKE '%scooter%' 
            THEN 'Transport'
            WHEN 
                LOWER(event_detail) LIKE '%trampoline%' OR 
                LOWER(event_detail) LIKE '%nerf%' OR 
                LOWER(event_detail) LIKE '%water-gun%' 
            THEN 'Backyard Toys'
            WHEN 
                LOWER(event_detail) LIKE '%camp%' OR 
                LOWER(event_detail) LIKE '%fishing%' OR 
                LOWER(event_detail) LIKE '%tent%' OR 
                LOWER(event_detail) LIKE '%boat%' OR
                LOWER(event_detail) LIKE '%coleman%' OR
                LOWER(event_detail) LIKE '%luggage%' OR
                LOWER(event_detail) LIKE '%travel%' OR
                LOWER(event_detail) LIKE '%hiking%' OR
                LOWER(event_detail) LIKE '%vlog%' OR
                LOWER(event_detail) LIKE '%gps%' OR
                LOWER(event_detail) LIKE '%knife%'
            THEN 'Adventure'
            WHEN 
                LOWER(event_detail) LIKE '%outdoor%' OR 
                LOWER(event_detail) LIKE '%terrasse%' OR
                LOWER(event_detail) LIKE '%bbq%' OR 
                LOWER(event_detail) LIKE '%grill%' OR 
                LOWER(event_detail) LIKE '%gazebo%' OR 
                LOWER(event_detail) LIKE '%deck%' OR 
                LOWER(event_detail) LIKE '%pool%' OR 
                LOWER(event_detail) LIKE '%swim%' OR 
                LOWER(event_detail) LIKE '%spa%' OR 
                LOWER(event_detail) LIKE '%patio%' OR
                LOWER(event_detail) LIKE '%barbecue%' OR
                LOWER(event_detail) LIKE '%barbeque%' OR
                LOWER(event_detail) LIKE '%garage%' OR 
                LOWER(event_detail) LIKE '%outdoor-living%'
            THEN 'Garage & Outdoor'
            ELSE 'Other' 
        END) AS category,
        event_detail,
        COUNT(DISTINCT guid) AS unique_users
    FROM main_competitor
    GROUP BY 1, 2, 3
)

SELECT *
FROM main_category
WHERE category = 'Other'
ORDER BY unique_users DESC
LIMIT 1000000;
