{{ config(
    materialized = 'table',
    dist = 'even',
    schema='staging',
) }}
select
    appointment_id,
    first_name,
    last_name,
    email,
    appointment_date::date as appointment_date,
    appointment_time_start::time as appointment_time_start,
    appointment_time_end::time as appointment_time_end,
    appointment_type,
    calendar_name,
    appointment_created_at::timestamp as appointment_created_at,
    timestamp 'epoch' + cast(ingested_at AS bigint) * interval '1 second' as ingested_at_timestamp
from {{ source('acuity_scheduling', 'appointment_added_event') }}
