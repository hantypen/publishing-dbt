{{ config(
    materialized = 'table',
    dist = 'even',
    schema='public',
) }}


with added_and_edited as (

    select * from {{ ref('stg_appointment_added_event') }}
    union all
    select * from {{ ref('stg_appointment_edited_event') }}
),

find_dublicates as (
select 
    *,
    row_number() over (partition by appointment_id order by ingested_at_timestamp desc) as rnk
from added_and_edited)

select * from find_dublicates
where rnk = 1


