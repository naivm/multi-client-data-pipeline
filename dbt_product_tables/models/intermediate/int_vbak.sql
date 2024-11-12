with source as (
      select * from {{ source('raw', 'VBAK') }}
),
vbak as (
    select *


    from source
)
select
    mandt                         ,--AS client,
    vbeln                         ,--AS sales_document,
    erdat                         ,--AS date_record_creation,
    waerk                         ,--AS document_sd_currency,
    auart                         ,--AS sales_document_type,
    aufnr                         ,--AS order_number,
    kunnr                         ,--AS sales_to_party,
    netwr                         ,--AS order_item_net_value_document_currency,
    knumv                         ,--AS condition_document_number,
    audat                         ,--AS sales_date



from vbak
