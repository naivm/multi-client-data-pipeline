with source as (
      select * from {{ source('raw', 'VBRP') }}
),
vbrp as (
    select *


    from source
)
select
    mandt                         ,--AS client,
    matnr                         ,--AS material_number,
    aufnr                         ,--AS order_number,
    erdat                         ,--AS date_record_creation,
    vbeln                         ,--AS sales_document,
    netwr                         ,--AS order_item_net_value_document_currency,
    posnr                         ,--AS document_sd_number




from vbrp
