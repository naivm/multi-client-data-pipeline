with transaction_b as (
  select DISTINCT
    customer_id
  from
    {{ ref('transaction_clientB')}} as tran_b
)

select
    uwaer                         AS sales_currency,
    land1                         AS customer_country,
    ort01                         AS customer_city,
    ktokd                         AS customer_group,
from {{ref('int_kna1')}} as kna1
  right join transaction_b
    on kna1.kunnr = transaction_b.customer_id
        WHERE
            land1 is not NULL
