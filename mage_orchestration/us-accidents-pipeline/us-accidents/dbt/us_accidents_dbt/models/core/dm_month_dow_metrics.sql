-- # of accidents by month of the year, day of the week, time window and weather_condition_grouped

{{ config(
        materialized = "table",
        cluster_by=["month_name"]
    )
}}

select month_name,
       day_of_week,
       time_window,
       weather_condition_grouped,
       count(*) as accident_count
from  {{ ref('fact_accidents') }}
group by 1,2,3,4