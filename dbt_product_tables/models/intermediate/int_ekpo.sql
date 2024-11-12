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



from ekpo
