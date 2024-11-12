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
    lvorm                         ,--AS delete_flag
    mtart                         ,--AS material_type
    mbrsh                         ,--AS industry_sector
    brand_id                      ,--AS brand_id


from mara
