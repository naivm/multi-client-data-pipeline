with source as (
      select * from {{ source('raw', 'EKPO') }}
),
ekpo as (
    select *


    from source
)
select
    mandt                         ,--AS client,
    matnr                         ,--AS material_number,
    menge                         ,--AS on_order_quantity,
    elikz                         ,--AS open_orders,
    erekz                         ,--AS final_invoice
    loekz                         ,--AS marked_deletion
    wepos                         ,--AS goods_receipt_check1
    weunb                         ,--AS goods_receipt_check2

from ekpo
