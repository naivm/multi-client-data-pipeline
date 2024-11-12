with source as (
      select * from {{ source('raw', 'MARA') }}
),
mara as (
    select *


    from source
)
select
    mandt                         ,--AS client,
    matnr                         ,--AS material_number,
    matkl                         ,--AS material_group,
    kunnr                         ,--AS sales_to_party,




from mara
