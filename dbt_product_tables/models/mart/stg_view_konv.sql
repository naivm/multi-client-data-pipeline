

with source as (
      select * from {{ source('raw', 'konv') }}
),
konv as (
    select *


    from source
)
select
    mandt                         AS client
    knumv                         AS condition_document_number
    kawrt                         AS condition_type
    kbetr                         AS condition_amount_percentage
    kunnr                         AS customer_number

from konv
