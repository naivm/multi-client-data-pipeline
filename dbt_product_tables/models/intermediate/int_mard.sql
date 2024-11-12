with source as (
      select * from {{ source('raw', 'MARD') }}
),
mard as (
    select *


    from source
)
select
    mandt                         ,--AS client,
    matnr                         ,--AS material_number,
    werks                         ,--AS plant,
    labst                         ,--AS on_hand_quantity,



from mard
