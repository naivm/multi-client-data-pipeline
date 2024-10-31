with source as (
      select * from {{ source('raw', 'vbak') }}
),
vbak as (
    select *


    from source
)
select
    mandt                         AS client
    vbeln                         AS sales_document
    erdat                         AS date_record_creation
    waerk                         AS document_sd_currency
    auart                         AS sales_document_type
    kunnr                         AS sales_to_party
    netwr                         AS order_item_net_value_document_currency
    waerk                         AS document_sd_currency
    knumv                         AS condition_document_number


from vbap
