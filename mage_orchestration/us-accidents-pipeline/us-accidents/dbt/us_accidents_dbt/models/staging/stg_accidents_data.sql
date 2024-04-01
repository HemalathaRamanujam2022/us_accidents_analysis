{{
    config(
        materialized='view'
    )
}}

select
    -- identifiers
    {{ dbt_utils.generate_surrogate_key(['ID', 'Start_Time']) }} as surrogate_accident_id,
    ID as id,
    Source as source,
    coalesce({{ dbt.safe_cast("Severity", api.Column.translate_type("integer")) }},0) as severity,
    {{ get_severity_codes_description("Severity") }} as severity_description,
    cast(Start_Lat as numeric) as start_lat,
    cast(Start_Lng as numeric) as start_lng,
    cast(End_Lat as numeric) as end_lat,
    cast(End_Lng as numeric) as end_lng,
    cast(Distance_miles as numeric) as distance_miles,
    Description as description,
    Street as street,
    City as city,
    County as county,
    State as state,
    Zipcode as zipcode,
    Country as country,
    Timezone as timezone,
    Airport_Code as airport_code,
    cast(Temperature_F as numeric) as temperature_f,
    cast(Wind_chill_F as numeric) as wind_chill_f,
    cast(Humidity_perc as numeric) as humidity_perc,
    cast(Pressure_inches as numeric) as pressure_inches,
    cast(Visibility_miles as numeric) as visibility_miles,
    Wind_Direction as wind_direction,
    cast(Wind_Speed_mph as numeric) as wind_speed_mph,
    cast(Precipitation_inches as numeric) as precipitation_inches,
    Weather_Condition as weather_condition,
    cast(Amenity as boolean) as amenity,
    cast(Bump as boolean) as bump,
    cast(Crossing as boolean) as crossing,
    cast(Give_Way as boolean) as give_way,
    cast(Junction as boolean) as junction,
    cast(No_Exit as boolean) as no_exit,
    cast(Railway as boolean) as railway,
    cast(Roundabout as boolean) as roundabout,
    cast(Station as boolean) as station,
    cast(Stop as boolean) as stop,
    cast(Traffic_Calming as boolean) as traffic_calming,
    cast(Traffic_Signal as boolean) as traffic_signal,
    cast(Turning_Loop as boolean) as turning_loop,
    Sunrise_Sunset as sunrise_sunset,
    Civil_Twilight as civil_twilight,
    Nautical_Twilight as nautical_twilight,
    Astronomical_Twilight as astronomical_twilight,
    cast(Start_Date as date) as start_date,
    cast(End_Date as date) as end_date,
    -- timestamps
    cast(Start_Time as timestamp) as start_time,
    cast(End_Time as timestamp) as end_time,
    cast(Weather_Timestamp as timestamp) as weather_timestamp
from {{ source('staging','accidents_data') }} 

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}