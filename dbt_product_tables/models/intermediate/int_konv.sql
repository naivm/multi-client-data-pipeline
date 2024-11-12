

with source as (
      select * from {{ source('raw', 'KONV') }}
),
konv as (
    select *


    from source
)
select
    mandt                         ,--AS client,
    knumv                         ,--AS condition_document_number,
    kawrt                         ,--AS condition_type,
    kbetr                         ,--AS condition_amount_percentage,
    kschl                         ,--AS condition_sale

from konv
