WITH 

segment_filter AS (SELECT 'Purchase of Home' AS value),

year_lower_bound AS (SELECT 2021 AS value),
year_upper_bound AS (SELECT 2022 AS value),


domain_segment_affinities AS (
    SELECT 
    guid,
    (CASE 

    WHEN -- MOVING TO A NEW HOME
    (event_detail LIKE '%apartment%' AND event_detail LIKE '%rent%') OR 
    (event_detail LIKE '%real-estate%' AND event_detail LIKE '%rent%') OR 
    (event_detail LIKE '%house%' AND event_detail LIKE '%rent%') OR 
    (event_detail LIKE '%apartment%' AND event_detail LIKE '%condo%') OR 
    (event_detail LIKE '%condo%' AND event_detail LIKE '%rent%') OR
    (event_detail LIKE '%room%' AND event_detail LIKE '%rent%')
    THEN 'Moving To A New Home'

    WHEN -- Job Change
    (event_detail LIKE '%job%' AND event_detail LIKE '%open%') OR 
    (domain LIKE '%indeed.c%' OR domain LIKE '%monster.c%') OR 
    (event_detail LIKE '%jobs-in%') OR
    (event_detail LIKE '%apply%' AND event_detail LIKE '%career%')
    THEN 'Job Change'

    WHEN -- Retirement
    (event_detail LIKE '%retirement%' AND event_detail LIKE '%living%')  OR 
    (event_detail LIKE '%senior%' AND event_detail LIKE '%residence%') OR 
    (event_detail LIKE '%senior%' AND event_detail LIKE '%living%') OR
    (event_detail LIKE '%senior%' AND event_detail LIKE '%home%') OR
    (event_detail LIKE '%retire%' AND event_detail LIKE '%home%')
    THEN 'Retirement'

    WHEN -- Starting a Family
    (event_detail LIKE '%baby%' AND event_detail LIKE '%food%') OR 
    (event_detail LIKE '%diaper%' AND event_detail LIKE '%baby%') OR 
    (event_detail LIKE '%breast%' AND event_detail LIKE '%feeding%') OR 
    (event_detail LIKE '%marriage%') OR 
    (event_detail LIKE '%marr%' AND event_detail LIKE '%honeymoon%')
    THEN 'Starting a Family'

    WHEN -- Health Issues
    (event_detail LIKE '%symptom%' AND (event_detail LIKE '%clinic%' OR event_detail LIKE '%hospital%' OR event_detail LIKE '%doctor%')) OR 
    (event_detail LIKE '%sick%' AND (event_detail LIKE '%clinic%' OR event_detail LIKE '%hospital%' OR event_detail LIKE '%doctor%')) OR 
    (event_detail LIKE '%health%' AND (event_detail LIKE '%clinic%' OR event_detail LIKE '%hospital%' OR event_detail LIKE '%doctor%')) OR 
    (event_detail LIKE '%call%' AND (event_detail LIKE '%clinic%' OR event_detail LIKE '%hospital%' OR event_detail LIKE '%doctor%')) OR 
    (event_detail LIKE '%schedule%' AND (event_detail LIKE '%clinic%' OR event_detail LIKE '%hospital%' OR event_detail LIKE '%doctor%')) OR 
    (event_detail LIKE '%visit%' AND (event_detail LIKE '%clinic%' OR event_detail LIKE '%hospital%' OR event_detail LIKE '%doctor%')) OR 
    (event_detail LIKE '%appointment%' AND (event_detail LIKE '%clinic%' OR event_detail LIKE '%hospital%' OR event_detail LIKE '%doctor%'))
    THEN 'Health Issues'

    WHEN -- Home Purchase
    (event_detail LIKE '%mortgage%') OR 
    (event_detail LIKE '%real%' AND event_detail LIKE '%estate%') OR 
    (event_detail LIKE '%own%' AND(event_detail LIKE '%home%' OR event_detail LIKE '%condo%' OR event_detail LIKE '%estate%' OR event_detail LIKE '%apartment%' OR event_detail LIKE '%house%')) OR 
    (event_detail LIKE '%finance%' AND(event_detail LIKE '%home%' OR event_detail LIKE '%condo%' OR event_detail LIKE '%estate%' OR event_detail LIKE '%apartment%' OR event_detail LIKE '%house%')) OR 
    (event_detail LIKE '%purchase%' AND(event_detail LIKE '%home%' OR event_detail LIKE '%condo%' OR event_detail LIKE '%estate%' OR event_detail LIKE '%apartment%' OR event_detail LIKE '%house%')) OR 
    (event_detail LIKE '%buy%' AND(event_detail LIKE '%home%' OR event_detail LIKE '%condo%' OR event_detail LIKE '%estate%' OR event_detail LIKE '%apartment%' OR event_detail LIKE '%house%')) OR 
    (event_detail LIKE '%mortgage%' AND(event_detail LIKE '%home%' OR event_detail LIKE '%condo%' OR event_detail LIKE '%estate%' OR event_detail LIKE '%apartment%' OR event_detail LIKE '%house%'))
    THEN 'Purchase of Home'

    ELSE ''
    END) AS segment_trigger
    FROM spectrum_comscore.clickstream_ca
    WHERE (date_part(year, calendar_date) >= (SELECT value FROM year_lower_bound) AND date_part(year, calendar_date) <= (SELECT value FROM year_upper_bound))
),

-- *********************************************************************************************
user_segment AS (
    SELECT DISTINCT guid FROM domain_segment_affinities WHERE segment_trigger = (SELECT value FROM segment_filter)
),

unique_intender_data AS (
    SELECT 
    calendar_date,
    domain,
    event_detail,
    (CASE 

    WHEN -- MOVING TO A NEW HOME
    (event_detail LIKE '%apartment%' AND event_detail LIKE '%rent%') OR 
    (event_detail LIKE '%real-estate%' AND event_detail LIKE '%rent%') OR 
    (event_detail LIKE '%house%' AND event_detail LIKE '%rent%') OR 
    (event_detail LIKE '%apartment%' AND event_detail LIKE '%condo%') OR 
    (event_detail LIKE '%condo%' AND event_detail LIKE '%rent%') OR
    (event_detail LIKE '%room%' AND event_detail LIKE '%rent%')
    THEN 'Moving To A New Home'

    WHEN -- Job Change
    (event_detail LIKE '%job%' AND event_detail LIKE '%open%') OR 
    (domain LIKE '%indeed.c%' OR domain LIKE '%monster.c%') OR 
    (event_detail LIKE '%jobs-in%') OR
    (event_detail LIKE '%apply%' AND event_detail LIKE '%career%')
    THEN 'Job Change'

    WHEN -- Retirement
    (event_detail LIKE '%retirement%' AND event_detail LIKE '%living%')  OR 
    (event_detail LIKE '%senior%' AND event_detail LIKE '%residence%') OR 
    (event_detail LIKE '%senior%' AND event_detail LIKE '%living%') OR
    (event_detail LIKE '%senior%' AND event_detail LIKE '%home%') OR
    (event_detail LIKE '%retire%' AND event_detail LIKE '%home%')
    THEN 'Retirement'

    WHEN -- Starting a Family
    (event_detail LIKE '%baby%' AND event_detail LIKE '%food%') OR 
    (event_detail LIKE '%breast%' AND event_detail LIKE '%feeding%') OR 
    (event_detail LIKE '%marriage%') OR 
    (event_detail LIKE '%marr%' AND event_detail LIKE '%honeymoon%')
    THEN 'Starting a Family'

    WHEN -- Health Issues
    (event_detail LIKE '%symptom%' AND (event_detail LIKE '%clinic%' OR event_detail LIKE '%hospital%' OR event_detail LIKE '%doctor%')) OR 
    (event_detail LIKE '%sick%' AND (event_detail LIKE '%clinic%' OR event_detail LIKE '%hospital%' OR event_detail LIKE '%doctor%')) OR 
    (event_detail LIKE '%health%' AND (event_detail LIKE '%clinic%' OR event_detail LIKE '%hospital%' OR event_detail LIKE '%doctor%')) OR 
    (event_detail LIKE '%call%' AND (event_detail LIKE '%clinic%' OR event_detail LIKE '%hospital%' OR event_detail LIKE '%doctor%')) OR 
    (event_detail LIKE '%schedule%' AND (event_detail LIKE '%clinic%' OR event_detail LIKE '%hospital%' OR event_detail LIKE '%doctor%')) OR 
    (event_detail LIKE '%visit%' AND (event_detail LIKE '%clinic%' OR event_detail LIKE '%hospital%' OR event_detail LIKE '%doctor%')) OR 
    (event_detail LIKE '%appointment%' AND (event_detail LIKE '%clinic%' OR event_detail LIKE '%hospital%' OR event_detail LIKE '%doctor%'))
    THEN 'Health Issues'

    WHEN -- Home Purchase
    (event_detail LIKE '%mortgage%') OR 
    (event_detail LIKE '%real%' AND event_detail LIKE '%estate%') OR 
    (event_detail LIKE '%own%' AND(event_detail LIKE '%home%' OR event_detail LIKE '%condo%' OR event_detail LIKE '%estate%' OR event_detail LIKE '%apartment%' OR event_detail LIKE '%house%')) OR 
    (event_detail LIKE '%finance%' AND(event_detail LIKE '%home%' OR event_detail LIKE '%condo%' OR event_detail LIKE '%estate%' OR event_detail LIKE '%apartment%' OR event_detail LIKE '%house%')) OR 
    (event_detail LIKE '%purchase%' AND(event_detail LIKE '%home%' OR event_detail LIKE '%condo%' OR event_detail LIKE '%estate%' OR event_detail LIKE '%apartment%' OR event_detail LIKE '%house%')) OR 
    (event_detail LIKE '%buy%' AND(event_detail LIKE '%home%' OR event_detail LIKE '%condo%' OR event_detail LIKE '%estate%' OR event_detail LIKE '%apartment%' OR event_detail LIKE '%house%')) OR 
    (event_detail LIKE '%mortgage%' AND(event_detail LIKE '%home%' OR event_detail LIKE '%condo%' OR event_detail LIKE '%estate%' OR event_detail LIKE '%apartment%' OR event_detail LIKE '%house%'))
    THEN 'Purchase of Home'

    ELSE ''
    END) AS segment_trigger,
    guid
    FROM spectrum_comscore.clickstream_ca
    WHERE (date_part(year, calendar_date) >= (SELECT value FROM year_lower_bound) AND date_part(year, calendar_date) <= (SELECT value FROM year_upper_bound)) AND
    ((domain LIKE 'petland.c%')
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
    AND guid IN (SELECT guid FROM user_segment)
),

-- *********************************************************************************************
--  MAIN TABLES
-- *********************************************************************************************

total_intenders AS (
    SELECT
        segment_trigger AS join_field_b,
        COUNT(DISTINCT guid) AS unique_users
    FROM unique_intender_data
    GROUP BY 1
),

total_converters AS (
    SELECT
        segment_trigger AS join_field_b,
        COUNT(DISTINCT guid) AS unique_users
    FROM unique_intender_data WHERE guid IN (
        '512653071',
        '510084996',
        '496683757',
        '251448593',
        '281706106',
        '353983423',
        '504255419',
        '451608518',
        '477202587',
        '356930312',
        '272981917',
        '438509707',
        '510561697',
        '492575975',
        '504724929',
        '505573356',
        '476641683',
        '503186759',
        '478225569',
        '353178038',
        '360762513',
        '237873372',
        '238494112',
        '476535497',
        '504065870',
        '508212092',
        '490691799',
        '347190923',
        '442801957',
        '495142410',
        '481751404',
        '367894146',
        '504572919',
        '480560593',
        '344369748',
        '510518112',
        '354565666',
        '499076357',
        '491114596',
        '287292150',
        '476248336',
        '492698143',
        '505172518',
        '490613488',
        '505701191',
        '482143114',
        '285240415',
        '511235983',
        '499066632',
        '500041439',
        '506569932',
        '359313994',
        '481155521',
        '285095682',
        '248952095',
        '511135364',
        '500546255',
        '499046445',
        '508024506',
        '275487127',
        '499176514',
        '507100741',
        '466245191',
        '268907819',
        '356093063',
        '353706374',
        '484196451',
        '356018976',
        '510148049',
        '516026215',
        '353664673',
        '501187527',
        '478519239',
        '496160687',
        '474591021',
        '238503148',
        '511032078',
        '347045250',
        '356423813',
        '513771134',
        '501510420',
        '137818692',
        '518618691',
        '473194434',
        '434606024',
        '489190312',
        '487650217',
        '500669498',
        '353427267',
        '505150955',
        '504556615',
        '522015788',
        '430853019',
        '138078192',
        '476602120',
        '524596977',
        '501594508',
        '353174904',
        '506687443',
        '136013703',
        '318008952',
        '501802978',
        '502791724',
        '516066210',
        '273994215',
        '501632798',
        '497260325',
        '497138148',
        '523563043',
        '355603700',
        '353232411',
        '356461538',
        '498500950',
        '437142218',
        '263201787',
        '345175644',
        '504613879',
        '507316801',
        '505665055',
        '506235954',
        '282360495',
        '253094051',
        '354006263',
        '499749726',
        '501227072',
        '265370700',
        '522100813',
        '488630432',
        '524061043',
        '488515751',
        '505139951',
        '353212172',
        '492088771',
        '507054402',
        '502733395',
        '511540510',
        '488740686',
        '491065158',
        '450277597',
        '412300437',
        '497647182',
        '355801188',
        '349547298',
        '511086460',
        '502698121',
        '505713789',
        '474052565',
        '501107867',
        '506235955',
        '504094499',
        '501513971',
        '512579088',
        '359227708',
        '499245009',
        '503030951',
        '481638270',
        '511624254',
        '395632377',
        '512559561',
        '280887045',
        '344968460',
        '511244551',
        '499241462',
        '506015872',
        '538580971',
        '501165823',
        '478690859',
        '503136454',
        '529008948',
        '356048479',
        '527079445',
        '509147259',
        '502697845',
        '516591884',
        '454640075',
        '488666322',
        '274960442',
        '500097681',
        '510141171',
        '486621540',
        '501115761',
        '516026214',
        '494003652',
        '494624104',
        '443646469',
        '505209110',
        '506020188',
        '502685827',
        '388160124',
        '261747415',
        '536526814',
        '499078707',
        '490583575',
        '254765612',
        '358387569',
        '497206534',
        '500680807',
        '502634059',
        '494541295',
        '339302326',
        '520020213',
        '319116074',
        '446804798',
        '494504274',
        '506025994',
        '515026961',
        '357045897',
        '494204401',
        '518069821',
        '492192208',
        '512034616',
        '135104211',
        '490691800',
        '478661522',
        '507505452',
        '510067384',
        '474052564',
        '501730737',
        '505568602',
        '501083876',
        '504212368',
        '437520839',
        '349038639',
        '504171828',
        '503133153',
        '502183597',
        '279945409',
        '471819065',
        '502754622',
        '505060160',
        '486713919',
        '498555764',
        '510569844',
        '506062726',
        '496570746',
        '272613254',
        '506696266',
        '460519132',
        '527007224',
        '498053829',
        '512631423',
        '502634061',
        '334378712',
        '353588191',
        '525090977',
        '501729331',
        '527525982',
        '500023497',
        '490122097',
        '480703899',
        '524523055',
        '479112286',
        '517088480',
        '502212501',
        '492779001',
        '512732715',
        '315063045',
        '479732351',
        '511210890',
        '487018020',
        '522562565',
        '500112934',
        '503616956',
        '502237479',
        '499050396',
        '500628206',
        '499011317',
        '504623800',
        '514085496',
        '480018463',
        '513172159',
        '452077536',
        '423685783',
        '515084813',
        '497019114',
        '491134233',
        '501136829',
        '464501756',
        '136960932',
        '499140761',
        '509144326',
        '476528030',
        '339200777',
        '510606489',
        '490241178',
        '486017745',
        '350418140',
        '353234695',
        '251013140',
        '494064024',
        '312757168',
        '463457329',
        '508517662',
        '504163800',
        '289004917',
        '281580341',
        '465260916',
        '500229514',
        '507434517',
        '330453123',
        '501105864',
        '480612241',
        '290908765',
        '488521842',
        '298629713',
        '344866048',
        '488059546',
        '349173732',
        '481254097',
        '347394206',
        '481544696',
        '360860240',
        '336572290',
        '332936455',
        '496744165',
        '250033345',
        '345489962',
        '347764379',
        '349031643',
        '504061507',
        '486017746',
        '518594632',
        '498530749',
        '281368600',
        '362762797',
        '355339677',
        '337969199',
        '258608450',
        '494175724',
        '331586476',
        '346690030',
        '506574739',
        '251625863',
        '333248247',
        '381667196',
        '484768885',
        '508618588',
        '491617812',
        '342580090',
        '503762718',
        '502503470',
        '474672524',
        '303990604',
        '493647722',
        '273662804',
        '494094464',
        '505072324',
        '508615383',
        '295365569',
        '504019381',
        '345021585',
        '136712789',
        '363299646',
        '277123474',
        '508090871',
        '499131695',
        '505550336',
        '296920224',
        '497571761',
        '496718400',
        '494204194',
        '297063504',
        '488038607',
        '512059507',
        '297009170',
        '255561895',
        '321723468',
        '495065152',
        '470032129',
        '316385859',
        '504237780',
        '503730375',
        '504562558',
        '502763470',
        '513107320',
        '502507128',
        '474687475',
        '525533877',
        '507034274',
        '503138677',
        '279373111',
        '500015945',
        '319043144',
        '360190652',
        '355744600',
        '505708446',
        '339277377',
        '504018734',
        '374581297',
        '501806836',
        '524039082',
        '350057140',
        '282817974',
        '347235495',
        '331176382',
        '313095006',
        '353724554',
        '297052459',
        '349936193',
        '500212572',
        '508132511',
        '507468083',
        '511179596',
        '299028639',
        '507197131',
        '324746700',
        '503599020',
        '330973436',
        '506514874',
        '472670229',
        '509026346',
        '536050274',
        '502056898',
        '481681889',
        '496151843',
        '328146630',
        '360762690',
        '407690436',
        '500176590',
        '504130539',
        '497670279',
        '487585572',
        '495007513',
        '137307743',
        '493521645',
        '410161177',
        '530085120',
        '462520543',
        '491557462',
        '333597272',
        '317572788',
        '512648069',
        '438773512',
        '498118501',
        '473162358',
        '482651406',
        '503509815',
        '359539444',
        '555593168',
        '508669478',
        '511756988',
        '361940554',
        '357386406',
        '501114913',
        '502703215',
        '348783762',
        '510526175',
        '345715165',
        '503549062',
        '448620027',
        '528512125',
        '480145643',
        '339632712',
        '399717750',
        '347811415',
        '351024297',
        '496606521',
        '488082405',
        '491003809',
        '277841649',
        '479687858',
        '498181795',
        '498589339',
        '422027274',
        '332967563',
        '490174549',
        '480146198',
        '509061665',
        '341470450',
        '497520150',
        '512036666',
        '505605732',
        '499166217',
        '138358393',
        '275764853',
        '505003911',
        '355557618',
        '486085478',
        '358635999',
        '508132510',
        '355360011',
        '509543958',
        '512645702',
        '490068013',
        '506170125',
        '496135141',
        '348560433',
        '526506245',
        '499541806',
        '351960324',
        '504109287',
        '248593559',
        '314812973',
        '506059142',
        '304075447',
        '511078063',
        '262789295',
        '496616507',
        '507571449',
        '526503760',
        '502736926',
        '481046728',
        '494701943',
        '491224287',
        '501674832',
        '135384708',
        '340745322',
        '501554428',
        '356718634',
        '524500198',
        '450732897',
        '484731960',
        '365107540',
        '506169141',
        '365301427',
        '479504437',
        '137376276',
        '432045953',
        '475672286',
        '501251802',
        '482650539',
        '475015837',
        '482030878',
        '368620464',
        '487195565',
        '381667197',
        '482046569',
        '469125426',
        '497258466',
        '262434795',
        '504675818',
        '350362068',
        '351182149',
        '491552383',
        '365343417',
        '518556635',
        '248927510',
        '491105868',
        '508663682',
        '349730663',
        '499191873',
        '322753604',
        '482253399',
        '309512405',
        '135951516',
        '476077300',
        '261145158',
        '497601275',
        '423692265',
        '501597471',
        '505036919',
        '412070766',
        '499647848',
        '484026018',
        '363472352',
        '352824930',
        '359841720',
        '476158439',
        '341147974',
        '305414191',
        '472019582',
        '262172353',
        '483274717',
        '511540317',
        '503173912',
        '267771206',
        '501251801',
        '494567756',
        '493521644',
        '425630250',
        '136954975',
        '500167401',
        '503509814',
        '492211756',
        '557575179',
        '483681517',
        '501674836',
        '351730364',
        '501777814',
        '508168669',
        '519039037',
        '493319371',
        '484796176',
        '490143317',
        '501160247',
        '317942049',
        '501789641',
        '485017787',
        '501253803',
        '356361697',
        '455316004',
        '491025348',
        '503706295',
        '476578929',
        '478554335',
        '492682610',
        '486536541',
        '328225899',
        '492170542',
        '370457688',
        '470880531',
        '502750411',
        '349547298',
        '349217899',
        '502211032',
        '493679300',
        '340932948',
        '419558515',
        '443646469',
        '356546679',
        '253111246',
        '507536324',
        '502036847',
        '464598574',
        '504668840',
        '446553734',
        '498636424',
        '513022108',
        '448747816',
        '521059558',
        '524588603',
        '494119945',
        '501275449',
        '556526831',
        '425302229',
        '479087909',
        '486680197',
        '368133308',
        '501515773',
        '500657738',
        '490313281',
        '502659442',
        '496121233',
        '136054263',
        '505539969',
        '349632302',
        '474529607',
        '136117785',
        '313631214',
        '305013545',
        '476544742',
        '415165009',
        '505140357',
        '338802431',
        '460026650',
        '517508344',
        '509207594',
        '501101420',
        '359387177',
        '509675846',
        '476505043',
        '136622611',
        '501612066',
        '430586128',
        '528000126',
        '508676012',
        '237335004',
        '344957844',
        '502098595',
        '493623616',
        '489003206',
        '489731736',
        '500559997',
        '501777815',
        '370574488',
        '510039075',
        '502167751',
        '499077152',
        '485208112',
        '492622732',
        '512122993',
        '514167031',
        '497664642',
        '471614734',
        '500134198',
        '528512126',
        '359813210',
        '509196568',
        '507276680',
        '497131416',
        '506164860',
        '426157357',
        '510137816',
        '367190181',
        '479034512',
        '509543959',
        '500674650',
        '136865010',
        '508049410',
        '504181084',
        '474543724',
        '364552403',
        '500517192',
        '481254970',
        '507034275',
        '489056240',
        '283016151',
        '519501369',
        '508548407',
        '423116181',
        '530085121',
        '490031083',
        '510638453',
        '426728887',
        '486610279',
        '544036004',
        '319569318',
        '476527080',
        '496083562',
        '498107880',
        '136868549',
        '493199366',
        '500091995',
        '500596304',
        '477660282',
        '485022316',
        '479708614',
        '134276522',
        '486532320',
        '492660594',
        '504597485',
        '410161178',
        '501674837',
        '481714570',
        '504116178',
        '502022167',
        '494557861',
        '506137225',
        '520581608',
        '481544697',
        '136647038',
        '511652404',
        '512506876',
        '510546659',
        '136748430',
        '501757876',
        '440707545',
        '501830225',
        '524500199',
        '135686587',
        '503623117',
        '501614195',
        '499020247',
        '465000456',
        '506508173',
        '483503255',
        '482710736',
        '518031293',
        '502225018',
        '483019530',
        '499699616',
        '505133410',
        '353067604',
        '502116600',
        '511599420',
        '138044577',
        '492226378',
        '498576064',
        '362211257',
        '504179892',
        '368456714',
        '479706501',
        '367359276',
        '509262524',
        '136264289',
        '134181686',
        '504658904',
        '557511001',
        '505597467',
        '499156347',
        '359007434',
        '494140869',
        '137447841',
        '338106180',
        '504148523',
        '513760295',
        '518618691',
        '511067402',
        '475697475',
        '496218822',
        '502018653',
        '510023590',
        '492081972',
        '502696816',
        '480095609',
        '353211653',
        '515150296',
        '492002390',
        '506224864',
        '341532827',
        '479645867',
        '500547733',
        '501500570',
        '134619005',
        '273662804',
        '299028639',
        '361050751',
        '502750411',
        '136712789',
        '321723468',
        '435112518',
        '536050274',
        '330453123',
        '353107928',
        '355592291',
        '501266450',
        '336254360',
        '342476158',
        '519080190',
        '499567150',
        '282817974',
        '319705011',
        '345331171',
        '346704465',
        '348215579',
        '248593559',
        '449010295',
        '500555215',
        '502719593',
        '509224868',
        '509675846',
        '501585884',
        '321723468',
        '494701943',
        '497571761',
        '531542581',
        '283371437',
        '461046650',
        '503050932',
        '323832798',
        '263201787',
        '492750236',
        '341203511',
        '507536324',
        '327686152',
        '273662804',
        '349363223',
        '249911755',
        '505085769',
        '552555189'
    )
    GROUP BY 1
),

total_genpop AS (
     SELECT
        (CASE 

        WHEN -- MOVING TO A NEW HOME
        (event_detail LIKE '%apartment%' AND event_detail LIKE '%rent%') OR 
        (event_detail LIKE '%real-estate%' AND event_detail LIKE '%rent%') OR 
        (event_detail LIKE '%house%' AND event_detail LIKE '%rent%') OR 
        (event_detail LIKE '%apartment%' AND event_detail LIKE '%condo%') OR 
        (event_detail LIKE '%condo%' AND event_detail LIKE '%rent%') OR
        (event_detail LIKE '%room%' AND event_detail LIKE '%rent%')
        THEN 'Moving To A New Home'

        WHEN -- Job Change
        (event_detail LIKE '%job%' AND event_detail LIKE '%open%') OR 
        (domain LIKE '%indeed.c%' OR domain LIKE '%monster.c%') OR 
        (event_detail LIKE '%jobs-in%') OR
        (event_detail LIKE '%apply%' AND event_detail LIKE '%career%')
        THEN 'Job Change'

        WHEN -- Retirement
        (event_detail LIKE '%retirement%' AND event_detail LIKE '%living%')  OR 
        (event_detail LIKE '%senior%' AND event_detail LIKE '%residence%') OR 
        (event_detail LIKE '%senior%' AND event_detail LIKE '%living%') OR
        (event_detail LIKE '%senior%' AND event_detail LIKE '%home%') OR
        (event_detail LIKE '%retire%' AND event_detail LIKE '%home%')
        THEN 'Retirement'

        WHEN -- Starting a Family
        (event_detail LIKE '%baby%' AND event_detail LIKE '%food%') OR 
        (event_detail LIKE '%breast%' AND event_detail LIKE '%feeding%') OR 
        (event_detail LIKE '%marriage%') OR 
        (event_detail LIKE '%marr%' AND event_detail LIKE '%honeymoon%')
        THEN 'Starting a Family'

        WHEN -- Health Issues
        (event_detail LIKE '%symptom%' AND (event_detail LIKE '%clinic%' OR event_detail LIKE '%hospital%' OR event_detail LIKE '%doctor%')) OR 
        (event_detail LIKE '%sick%' AND (event_detail LIKE '%clinic%' OR event_detail LIKE '%hospital%' OR event_detail LIKE '%doctor%')) OR 
        (event_detail LIKE '%health%' AND (event_detail LIKE '%clinic%' OR event_detail LIKE '%hospital%' OR event_detail LIKE '%doctor%')) OR 
        (event_detail LIKE '%call%' AND (event_detail LIKE '%clinic%' OR event_detail LIKE '%hospital%' OR event_detail LIKE '%doctor%')) OR 
        (event_detail LIKE '%schedule%' AND (event_detail LIKE '%clinic%' OR event_detail LIKE '%hospital%' OR event_detail LIKE '%doctor%')) OR 
        (event_detail LIKE '%visit%' AND (event_detail LIKE '%clinic%' OR event_detail LIKE '%hospital%' OR event_detail LIKE '%doctor%')) OR 
        (event_detail LIKE '%appointment%' AND (event_detail LIKE '%clinic%' OR event_detail LIKE '%hospital%' OR event_detail LIKE '%doctor%'))
        THEN 'Health Issues'

        WHEN -- Home Purchase
        (event_detail LIKE '%mortgage%') OR 
        (event_detail LIKE '%real%' AND event_detail LIKE '%estate%') OR 
        (event_detail LIKE '%own%' AND(event_detail LIKE '%home%' OR event_detail LIKE '%condo%' OR event_detail LIKE '%estate%' OR event_detail LIKE '%apartment%' OR event_detail LIKE '%house%')) OR 
        (event_detail LIKE '%finance%' AND(event_detail LIKE '%home%' OR event_detail LIKE '%condo%' OR event_detail LIKE '%estate%' OR event_detail LIKE '%apartment%' OR event_detail LIKE '%house%')) OR 
        (event_detail LIKE '%purchase%' AND(event_detail LIKE '%home%' OR event_detail LIKE '%condo%' OR event_detail LIKE '%estate%' OR event_detail LIKE '%apartment%' OR event_detail LIKE '%house%')) OR 
        (event_detail LIKE '%buy%' AND(event_detail LIKE '%home%' OR event_detail LIKE '%condo%' OR event_detail LIKE '%estate%' OR event_detail LIKE '%apartment%' OR event_detail LIKE '%house%')) OR 
        (event_detail LIKE '%mortgage%' AND(event_detail LIKE '%home%' OR event_detail LIKE '%condo%' OR event_detail LIKE '%estate%' OR event_detail LIKE '%apartment%' OR event_detail LIKE '%house%'))
        THEN 'Purchase of Home'

        ELSE ''
        END) join_field_b,
        COUNT(DISTINCT guid) AS unique_users
    FROM spectrum_comscore.clickstream_ca
    GROUP BY 1
),

total_output AS (
    SELECT 
    total_intenders.join_field_b,
    total_intenders.unique_users AS total_intenders,
    total_converters.unique_users AS total_converters,
    total_genpop.unique_users AS total_genpop
FROM total_genpop
LEFT JOIN total_intenders
    ON total_genpop.join_field_b = total_intenders.join_field_b
LEFT JOIN total_converters
    ON total_genpop.join_field_b = total_converters.join_field_b
),


-- *********************************************************************************************
--  INDEX REFERENCE COLUMNS
-- *********************************************************************************************

ref_genpop AS (
    SELECT COUNT(DISTINCT guid) AS unique_users
    FROM spectrum_comscore.clickstream_ca
    WHERE (date_part(year, calendar_date) >= (SELECT value FROM year_lower_bound) AND date_part(year, calendar_date) <= (SELECT value FROM year_upper_bound))
),

ref_intenders AS (
    SELECT COUNT(DISTINCT guid) AS unique_users
    FROM unique_intender_data
    WHERE (date_part(year, calendar_date) >= (SELECT value FROM year_lower_bound) AND date_part(year, calendar_date) <= (SELECT value FROM year_upper_bound))
)

-- *********************************************************************************************
--  OUTPUT
-- *********************************************************************************************

SELECT
    a.join_field_b AS segment_trigger,
    a.total_intenders AS total_intenders,
    a.total_converters AS total_converters,
    a.total_genpop AS total_genpop,
    b.unique_users AS ref_genpop,
    c.unique_users AS ref_intenders
FROM total_output AS a
CROSS JOIN ref_genpop AS b
CROSS JOIN ref_intenders AS c

LIMIT 10000;


    /*
     -- *** CONVERTER *** --
     AND
     (
     -- (event_detail LIKE '%shopping-cart%')                                   OR
     -- (event_detail LIKE '%/cart%')                                           OR
     -- (event_detail LIKE '%checkout%')                                        OR
     -- (event_detail LIKE '%shop%' AND event_detail LIKE '%cart%')             OR
     -- (event_detail LIKE '%cart%' AND event_detail LIKE '%shop%')             OR
     
     (event_detail LIKE '%history%' AND event_detail LIKE '%order%')         OR
     (event_detail LIKE '%order%' AND event_detail LIKE '%history%')         OR
     (event_detail LIKE '%recent%' AND event_detail LIKE '%order%')          OR
     (event_detail LIKE '%order%' AND event_detail LIKE '%recent%')          OR
     (event_detail LIKE '%account%' AND event_detail LIKE '%order%')         OR 
     (event_detail LIKE '%order%' AND event_detail LIKE '%account%')         
     )
     */