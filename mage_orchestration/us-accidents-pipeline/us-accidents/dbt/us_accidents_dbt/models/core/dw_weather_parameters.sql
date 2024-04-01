-- # of accidents by weather parameters

{{ config(
        materialized = "table",
        cluster_by=["severity"]
    )
}}

select surrogate_accident_id,
       state_name,
       state,
       severity,
       timezone,
       temperature_f,    
       wind_chill_f
       humidity_perc,
       pressure_inches,
       visibility_miles,
       wind_direction,
       wind_speed_mph,
       precipitation_inches,
       weather_condition,
       weather_condition_grouped
from  {{ ref('fact_accidents') }}