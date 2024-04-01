-- Measures based on state, street and presence of amenities

{{ config(
        materialized = "table",
        cluster_by=["state_name", "street"]
    )
}}

select state_name,
       street,
       SUM(CASE WHEN amenity = true THEN 1 ELSE 0 END) as amenity_count,
       SUM(CASE WHEN bump = true THEN 1 ELSE 0 END) as bump,
       SUM(CASE WHEN give_way = true THEN 1 ELSE 0 END) as give_way,
       SUM(CASE WHEN junction = true THEN 1 ELSE 0 END) as junction,
       SUM(CASE WHEN no_exit = true THEN 1 ELSE 0 END) as no_exit,
       SUM(CASE WHEN railway = true THEN 1 ELSE 0 END) as railway,
       SUM(CASE WHEN roundabout = true THEN 1 ELSE 0 END) as roundabout,
       SUM(CASE WHEN station = true THEN 1 ELSE 0 END) as station,
       SUM(CASE WHEN stop = true THEN 1 ELSE 0 END) as stop,
       SUM(CASE WHEN traffic_calming = true THEN 1 ELSE 0 END) as traffic_calming,
       SUM(CASE WHEN traffic_signal = true THEN 1 ELSE 0 END) as traffic_signal,
       SUM(CASE WHEN turning_loop = true THEN 1 ELSE 0 END) as turning_loop,
       count(*) as accident_count
from  {{ ref('fact_accidents') }}
group by 1,2