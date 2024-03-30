
/*
All the following queries are to be run on GCP Big Query Editor.
The queries are a way of exploring the data loaded from Kaggle
*/

-- # of accidents by severity , state
select severity, state, count(*) number_of_accidents
from `mage-demo-412904.us_accidents_2016_2023.accidents_data` 
group by 1,2
order by 3 desc;

-- # of accidents by year (year 2023 is partial and has data only until March 2023)
select extract(year from start_date) as year_accident, count(*) number_of_accidents
from `mage-demo-412904.us_accidents_2016_2023.accidents_data` 
group by year_accident
order by 2 desc;

-- Years that have only data for few months
select extract(YEAR from start_date) as year_accident, count(distinct extract(MONTH from start_date)) 
from `mage-demo-412904.us_accidents_2016_2023.accidents_data` 
group by 1
having count(distinct extract(MONTH from start_date)) < 12
order by 1


-- Years that have fewer than 365, 366 days (could be either missing data or no 
-- accidents recorded on those days)
select extract(YEAR from start_date), count(distinct start_date) 
from `mage-demo-412904.us_accidents_2016_2023.accidents_data` 
group by 1
having count(distinct start_date)  not in  (365, 366)
order by 1

-- # of accidents by severity 
select severity, count(*)
from `mage-demo-412904.us_accidents_2016_2023.accidents_data` 
group by 1
order by 2 desc

-- City, State with most number of accidents
select city, state, count(*)
from `mage-demo-412904.us_accidents_2016_2023.accidents_data` 
group by 1, 2
order by 3 desc

-- Check if there are any duplicate records based on accident ID
select ID, count(*)
from `mage-demo-412904.us_accidents_2016_2023.accidents_data`
group by 1
having count(*) > 1

-- Most dangerous highway an state intersection of the highway
select street, state, count(*)
from `mage-demo-412904.us_accidents_2016_2023.accidents_data` 
group by 1, 2
order by 3 desc

-- Timezone with maximum number of accidents
select timezone, count(*)
from `mage-demo-412904.us_accidents_2016_2023.accidents_data` 
group by 1
order by 2 desc

-- Accidents by weather condition
select case 
       when(lower(Weather_Condition) like '%fair%' or lower(Weather_Condition) like '%clear%') then 'Fair / Clear'
       when(lower(Weather_Condition) like '%cloud%' or lower(Weather_Condition) like '%overcast%') then 'Cloudy'
       when(lower(Weather_Condition) like '%rain%'  or lower(Weather_Condition) like '%drizzle%' or lower(Weather_Condition) like '%shower%') then 'Rain / Drizzle / Shower'
       when(lower(Weather_Condition) like '%wind%'  or lower(Weather_Condition) like '%pellet%'  or lower(Weather_Condition) like '%hail%') then 'Wind / Pellets / Hail'
       when(lower(Weather_Condition) like '%snow%' or lower(Weather_Condition) like '%ice%' or lower(Weather_Condition) like '%sleet%') then 'Snow / Ice / Sleet'
       when(lower(Weather_Condition) like '%sand%' or lower(Weather_Condition) like '%dust%' or lower(Weather_Condition) like '%ash%') then 'Sand / Dust / Ash'
       when(lower(Weather_Condition) like '%smoke%' or lower(Weather_Condition) like '%haze%') then 'Smoke / Haze'
       when(lower(Weather_Condition) like '%thunder%' or lower(Weather_Condition) like '%storm%') then 'Thunderstorms / Storms'
       when(lower(Weather_Condition) like '%fog%' or lower(Weather_Condition) like '%mist%') then 'Fog / Mist'
       when Weather_Condition is null then 'Data not available'
       else 'Others' end as Weather_Condition,
       count(*)
from `mage-demo-412904.us_accidents_2016_2023.accidents_data` 
group by 1
order by 2 desc


-- Time elapsed in the journey before the accident
select end_time, start_time, datetime_diff(end_time, start_time, HOUR) Full_Hours_Elapsed,
datetime_diff(end_time, start_time, MINUTE) Minutes_Elapsed,
ROUND((datetime_diff(end_time, start_time, MINUTE) / 60), 2) Total_Hours_Elapsed,
CEIL(ROUND((datetime_diff(end_time, start_time, MINUTE) / 60), 2)) as Accident_Hours_From_Start
from `mage-demo-412904.us_accidents_2016_2023.accidents_data`
where end_time is not null
limit 100

-- Most accidents happened within certain hours from the start of journey
-- The minutes are adjusted to the top of the hour
select 
CEIL(ROUND((datetime_diff(end_time, start_time, MINUTE) / 60), 2)) as Accident_Hours_From_Start,
count(*) 
from `mage-demo-412904.us_accidents_2016_2023.accidents_data`
where end_time is not null
group by 1
order by 2 desc

-- The weekday with the majority of the accidents
WITH DOW as
(select EXTRACT(DAYOFWEEK FROM start_time) as day_of_week
, count(*) as accident_count
from `mage-demo-412904.us_accidents_2016_2023.accidents_data`
group by 1
order by 2 desc)
select day_of_week,
CASE 
    WHEN day_of_week = 1 THEN 'Sunday'
    WHEN day_of_week = 2 THEN 'Monday'
    WHEN day_of_week = 3 THEN 'Tuesday'
    WHEN day_of_week = 4 THEN 'Wednesday'
    WHEN day_of_week = 5 THEN 'Thursday'
    WHEN day_of_week = 6 THEN 'Friday'
    WHEN day_of_week = 7 THEN 'Saturday'
  END Weekday, accident_count
from dow

-- Hour of the day when accidents happen the most
WITH accident_hours AS (
  SELECT
  Start_Time,
    extract(HOUR from Start_Time) as accident_hour
  FROM `mage-demo-412904.us_accidents_2016_2023.accidents_data`
) 
SELECT
      CASE
      WHEN accident_hour >= 0 AND accident_hour <= 3 THEN '0:00 AM - 2:59 AM'
      WHEN accident_hour > 3 AND accident_hour < 6 THEN '3:00 AM - 5:59 AM'
      WHEN accident_hour > 6 AND accident_hour < 9 THEN '6:00 AM - 8:59 AM'
      WHEN accident_hour > 9 AND accident_hour < 12 THEN '9:00 AM - 11:59 AM'
      WHEN accident_hour > 12 AND accident_hour < 15 THEN '12:00 PM - 2:59 PM'
      WHEN accident_hour > 15 AND accident_hour < 18 THEN '3:00 PM - 5:59 PM'
      WHEN accident_hour > 18 AND accident_hour < 21 THEN '6:00 PM - 8:59 PM'
      ELSE '9 PM - 11:59 PM'
    END AS time_window,
    count(*) as accident_count 
  FROM
  accident_hours
  group by 1
  order by 2 desc 






