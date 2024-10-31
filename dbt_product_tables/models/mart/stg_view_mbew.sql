with source as (
      select * from {{ source('raw', 'mbew') }}
),
mbew as (
    select *


    from source
)
select
    mandt                         AS client
    mantr                         AS material_number
    stprs                         AS price_standard


from mbew
