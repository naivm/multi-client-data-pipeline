with source as (
      select * from {{ source('raw', 'VBRK') }}
),
vbrk as (
    select *


    from source
)
select
    mandt                         ,--AS client,
    vbeln                         ,--AS sales_document,
    erdat                         ,--AS date_record_creation,
    waerk                         ,--AS document_sd_currency,
    netwr                         ,--AS order_item_net_value_document_currency,
    knumv                         ,--AS condition_document_number,


from vbrk
