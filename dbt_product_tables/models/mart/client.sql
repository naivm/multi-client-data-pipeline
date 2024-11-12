select
    mandt                         AS client,
    kunnr                         AS customer_id,
    uwaer                         AS sales_currency,
    land1                         AS client_country,
    ort01                         AS client_city,
    ktokd                         AS client_group,

from {{ref('int_kna1')}}
