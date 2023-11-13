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
from added_and_edited),

cancelled as (
    select appointment_id, true as cancelled_flag
    from {{ ref('stg_appointment_deleted_event') }}
)

select {{ dbt_utils.star(from=ref('stg_appointment_added_event'), relation_alias='find_dublicates') }},
        cancelled.cancelled_flag

 from find_dublicates

left join cancelled
on cancelled.appointment_id = find_dublicates.appointment_id
where rnk = 1


