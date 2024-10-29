
{{
  config(
    materialized='table',
  )
}}


select * from {{ source('products', 'makt') }}
