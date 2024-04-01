-- Main fact table that has all the data extracted from the Kaggle API
{{
    config(
        materialized = 'table',
        partition_by={
            "field": "start_time",
            "data_type": "timestamp",
        }, 
        cluster_by=["state", "severity"]
    )
}}

WITH accidents as 
(SELECT  surrogate_accident_id,
    id,
    source,
    severity,
    severity_description,
    start_time,
    end_time,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    distance_miles,
    description,
    street,
    city,
    county,
    state,
    st.state_name as state_name,
    zipcode,
    country,
    timezone,
    airport_code,
    weather_timestamp,
    temperature_f,
    wind_chill_f,
    humidity_perc,
    pressure_inches,
    visibility_miles,
    wind_direction,
    wind_speed_mph,
    precipitation_inches,
    weather_condition,
    amenity,
    bump,
    crossing,
    give_way,
    junction,
    no_exit,
    railway,
    roundabout,
    station,
    stop,
    traffic_calming,
    traffic_signal,
    turning_loop,
    sunrise_sunset,
    civil_twilight,
    nautical_twilight, 
    astronomical_twilight , 
    start_date,
    end_date,
    EXTRACT(YEAR FROM start_time) as accident_year,
    EXTRACT(MONTH FROM start_time) as accident_month,
    EXTRACT(DAY FROM start_time) as accident_day,
    FORMAT_DATETIME("%B", DATETIME(start_time)) as month_name,
    EXTRACT(DAYOFWEEK FROM start_time) as day_of_week,
    EXTRACT(HOUR FROM start_time) as accident_hour,
    CEIL(ROUND((datetime_diff(end_time, start_time, MINUTE) / 60), 2)) as traffic_delay_hours
from {{ ref('stg_accidents_data') }} as acc
inner join  {{ ref('dim_states') }} as st
on acc.state = st.abbreviation
)
select
    acc.*,
    CASE 
    WHEN day_of_week = 1 THEN 'Sunday'
    WHEN day_of_week = 2 THEN 'Monday'
    WHEN day_of_week = 3 THEN 'Tuesday'
    WHEN day_of_week = 4 THEN 'Wednesday'
    WHEN day_of_week = 5 THEN 'Thursday'
    WHEN day_of_week = 6 THEN 'Friday'
    WHEN day_of_week = 7 THEN 'Saturday'
  END week_day, 
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
    case 
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
       else 'Others' end as weather_condition_grouped
from accidents acc