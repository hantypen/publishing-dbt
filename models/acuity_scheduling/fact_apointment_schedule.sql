{{ config(
    materialized = 'table',
    dist = 'even',
    schema='public',
) }}

-- geting togetger all data changes on all appointments
with added_and_edited as (

    select * from {{ ref('stg_appointment_added_event') }}
    union all
    select * from {{ ref('stg_appointment_edited_event') }}
),

-- ranking rows by appointment_id to get all appointment_id versions and identify most recent update
find_dublicates as (
select 
    *,
    row_number() over (partition by appointment_id order by ingested_at_timestamp desc) as rnk
from added_and_edited),

-- get all cancelled appointment_ids
cancelled as (
    select appointment_id, true as cancelled_flag
    from {{ ref('stg_appointment_deleted_event') }}
)

--final query
select {{ dbt_utils.star(from=ref('stg_appointment_added_event'), relation_alias='find_dublicates') }},
        coalesce(cancelled.cancelled_flag, false) as cancelled_flag,
        datediff(minute,appointment_time_start,appointment_time_end) as appointment_lenght_minutes

from find_dublicates

left join cancelled
on cancelled.appointment_id = find_dublicates.appointment_id

--filter out historical values
where rnk = 1


