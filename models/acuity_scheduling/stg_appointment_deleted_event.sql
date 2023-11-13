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
    appointment_date::date,
    appointment_time_start::time,
    appointment_time_end::time,
    appointment_type,
    calendar_name,
    appointment_created_at::timestamp,
    timestamp 'epoch' + cast(ingested_at AS bigint) * interval '1 second' as ingested_at_timestamp
from {{ source('acuity_scheduling', 'appointment_deleted_event') }}
