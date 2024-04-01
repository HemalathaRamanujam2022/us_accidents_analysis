-- # of accidents by state, city, zipcode

{{ config(
        materialized = "table",
        cluster_by=["state","city"]
    )
}}

select state,   
       state_name,
       severity,
       accident_year,
       city,
       SUBSTR(LTRIM(zipcode),1,5) as zipcode,
       count(*) as accident_count
from  {{ ref('fact_accidents') }}
group by 1,2,3,4,5,6