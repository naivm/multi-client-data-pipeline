with source as (
      select * from {{ source('raw', 'KNA1') }}
),
kna1 as (
    select *


    from source
)
select
    mandt                         ,--AS client,
    kunnr                         ,--AS sales_to_party,
    uwaer                         ,--AS sales_currency,
    land1                         ,--AS client_country,
    ort01                         ,--AS client_city,
    ktokd                         ,--AS client_group,

from kna1
