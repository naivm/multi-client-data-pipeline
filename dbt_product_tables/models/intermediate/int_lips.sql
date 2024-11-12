with source as (
      select * from {{ source('raw', 'LIPS') }}
),
lips as (
    select *


    from source
)
select
    mandt                         ,--AS client,
    matnr                         ,--AS material_number,
    aufnr                         ,--AS order_number,
    erdat                         ,--AS date_record_creation,
    vbeln                         ,--AS sales_document,
    posnr                         ,--AS document_sd_number,




from lips
