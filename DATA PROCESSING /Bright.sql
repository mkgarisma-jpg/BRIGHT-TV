-- the whole table --
select * 
from `brightv`.`bright`.`bright_tv_dataset_profiles` 
limit 10;

-- duplicates --
select UserID,
     COUNT (*) AS duplicate_count
from `brightv`.`bright`.`bright_tv_dataset_profiles`
group by UserID
HAVING COUNT(*) > 1;

-- size of the data --
select COUNT (*) AS number_of_rows,
       COUNT (DISTINCT UserID) AS number_subs
from `brightv`.`bright`.`bright_tv_dataset_profiles`;

-- rows where UserID IS NULL --
select COUNT (*) AS cnt
from `brightv`.`bright`.`bright_tv_dataset_profiles`
where UserID IS NULL;

-- GENDER CHECKS
select DISTINCT gender 
from `brightv`.`bright`.`bright_tv_dataset_profiles`;   

SELECT COUNT (*)
FROM `brightv`.`bright`.`bright_tv_dataset_profiles`
WHERE gender = ' ';

select COUNT (*) AS num_rows
FROM `brightv`.`bright`.`bright_tv_dataset_profiles`
WHERE Race IS NULL;

select COUNT (DISTINCT UserID) AS subs, 
CASE 
    WHEN gender = ' ' THEN 'None'
    ELSE gender 
    END AS gender
FROM `brightv`.`bright`.`bright_tv_dataset_profiles`
GROUP BY gender;


-- Race Checks

select COUNT (*) AS num_rows
FROM `brightv`.`bright`.`bright_tv_dataset_profiles`
WHERE Race IS NULL;

select DISTINCT Race 
from `brightv`.`bright`.`bright_tv_dataset_profiles`;

select DISTINCT 
    CASE 
    WHEN Race = 'other' THEN 'None'
    WHEN Race = ' ' THEN 'None'
    ELSE Race 
    END AS Race
FROM `brightv`.`bright`.`bright_tv_dataset_profiles`;


-- Province Checks
select DISTINCT Province 
from `brightv`.`bright`.`bright_tv_dataset_profiles`;

select DISTINCT 
    CASE 
    WHEN Province = ' ' THEN 'Uncategorized'
    ELSE Province 
    END AS Region
FROM `brightv`.`bright`.`bright_tv_dataset_profiles`;

-- Age Checks
select MIN(Age) AS min_age,
       MAX(Age) AS max_age
FROM `brightv`.`bright`.`bright_tv_dataset_profiles`;
    
select COUNT (*) AS cnt 
FROM `brightv`.`bright`.`bright_tv_dataset_profiles`
WHERE age IS NULL;

WITH user_profiles AS( 
select UserID,

CASE 
    WHEN Province= ' ' THEN 'Uncategorized'
    WHEN Province = 'None' THEN 'Uncategorized'
ELSE Province
END AS Region,

age,
CASE 
     WHEN age = 0 THEN 'Infants'
     WHEN age BETWEEN 1 AND 12 THEN 'Kids'
     WHEN age BETWEEN 13 AND 19 THEN 'Teenager'
     WHEN age BETWEEN 20 AND 35 THEN 'Youth'
     WHEN age BETWEEN 36 AND 50 THEN 'Adult'
     WHEN age BETWEEN 51 AND 65 THEN 'Elder'
     WHEN age > 65 THEN 'Pensioner'
     END AS age_groups,

     CASE 
         WHEN (email IS NOT NULL) OR (email= ' ') OR (email NOT IN ('None')) THEN 1
         ELSE 0
         END AS email_flag,

     CASE 
         WHEN 'Social Media Handle' IS NOT NULL OR 'Social Media Handle' = ' ' OR 'Social Media Handle' NOT IN ('None') THEN 1
         ELSE 0
         END AS social_media_flag,

     CASE 
         WHEN Race='other' THEN 'None'
         WHEN Race = ' ' THEN 'None'
         ELSE Race 
         END AS Race,

    CASE 
        WHEN gender = ' ' THEN 'None'
        ELSE gender 
        END AS gender
FROM `brightv`.`bright`.`bright_tv_dataset_profiles`),
viewership AS (

        SELECT 
                COALESCE(UserID0, userid4) AS user_id,
                HOUR (RecordDate2) AS hour_of_day,
                TO_CHAR(RecordDate2, 'yyyyMM') AS month_id,
                TO_DATE(RecordDate2) AS watch_date,
                --TIME(RecordDate2) AS watch_time,
                TO_CHAR(RecordDate2, 'DD') AS day_of_week,
                DAYNAME(RecordDate2) AS day_name,

                CASE 
                    WHEN day_name IN ('Sat', 'Sun') THEN 'weekend'
                    ELSE 'weekday'
                    END AS day_classification,

                   MONTHNAME(RecordDate2) AS month_name, 

         CASE 
           WHEN Channel2 IN ('SawSee','SawSee') THEN 'SawSee' 
           WHEN Channel2 IN ('SuperSport Live Events','Live on SuperSport', 'SuperSport Live Events', 'DStv Events 1') THEN 'Live Events'
           ELSE Channel2 
           END AS Tv_Channel,

           date_format(RecordDate2, 'HH:mm:ss') AS watch_time,
           date_format(`Duration 2`, 'HH:mm:ss') AS duration

        FROM `brightv`.`bright`.`bright_tv_dataset_viewership`)
SELECT A.*,
        B.*
FROM viewership AS A
LEFT JOIN user_profiles AS B
ON A.user_id=B.UserID
;








