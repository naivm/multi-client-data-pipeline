with source as (
      select * from {{ source('raw', 'MAKT') }}
),
makt as (
    select *


    from source
)
select
    mandt                         ,--AS client,
    matnr                         ,--AS material_number,
    maktx                         ,--AS industry_sector
    spras                         ,--AS language_key


from makt
