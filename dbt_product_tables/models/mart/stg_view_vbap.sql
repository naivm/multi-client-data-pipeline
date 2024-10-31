with source as (
      select * from {{ source('raw', 'vbap') }}
),
vbap as (
    select *


    from source
)
select
    mandt                         AS client
    vbeln                         AS sales_document
    erdat                         AS date_record_creation
    waerk                         AS document_sd_currency
    mantr                         AS material_number
    kwmeng                        AS order_quantity_sales_unit_cumulative
    netwr                         AS order_item_net_value_document_currency

from vbap
