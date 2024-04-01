-- Dimension table with state names and abbreviation
{{ config(materialized='table') }}

select 
    State as state_name,
    Abbreviation as abbreviation
from {{ ref('us_states_lookup') }}