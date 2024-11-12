with source as (
      select * from {{ source('raw', 'VBAP') }}
),
vbap as (
    select *


    from source
)
select
    mandt                         ,--AS client,
    vbeln                         ,--AS sales_document,
    erdat                         ,--AS date_record_creation,
    waerk                         ,--AS document_sd_currency,
    matnr                         ,--AS material_number,
    kwmeng                        ,--AS order_quantity_sales_unit_cumulative,
    netwr                         ,--AS order_item_net_value_document_currency,
    aufnr                         ,--AS order_number,
    posnr                         ,--AS document_sd_number
    werks                         ,--AS plant


from vbap
