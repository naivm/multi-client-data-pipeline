
WITH item_costs AS (
    SELECT
        VBELN AS transaction_id,
        ROUND(SUM(NETWR),2) AS total_costs
    FROM
        {{ ref('int_vbrp') }}
    GROUP BY
        transaction_id
),
material_info AS (
    SELECT
        LPAD(CAST(mara.MATNR AS STRING), 18, '0') AS product_id,
        cast(mara.MATKL as STRING) AS product_category,
        -- Classify client type based on product category (MATKL) in MARA
        CASE
            WHEN CONCAT('abc', mara.MATKL) IN ('abc002', 'abc00207', 'abc00103') THEN 'Client A'
            WHEN CONCAT('abc', mara.MATKL) IN ('abc001', 'abc004') THEN 'Client B'
            ELSE 'Other'
        END AS client_type
    FROM
        {{ ref('int_mara') }} AS mara
),
transaction_data AS (
    SELECT
        vbak.AUART AS record_type,
        LPAD(CAST(vbak.VBELN AS STRING), 10, '0') AS transaction_id,
        CAST(vbak.KUNNR AS STRING) AS customer_id,
        vbak.AUDAT AS date,
        CAST(vbap.MATNR AS STRING) AS product_id,
        vbap.KWMENG AS volume,
        vbap.WERKS AS store_id,
        vbrk.NETWR AS sales_gross,
        COALESCE(item_costs.total_costs, 0) AS costs,
        konv.KBETR AS delivery_costs,
        (vbrk.NETWR - COALESCE(konv.KBETR, 0)) AS sales_net,
        material_info.product_category AS product_category
    FROM
        {{ ref('int_vbak') }} AS vbak
        LEFT JOIN {{ ref('int_vbap') }} AS vbap
            ON LPAD(CAST(vbak.VBELN AS STRING), 10, '0') = LPAD(CAST(vbap.VBELN AS STRING), 10, '0')
        LEFT JOIN {{ ref('int_vbrk') }} AS vbrk
            ON LPAD(CAST(vbak.VBELN AS STRING), 10, '0') = LPAD(SUBSTR(CAST(vbrk.VBELN AS STRING), 2), 10, '0')
        LEFT JOIN item_costs
            ON LPAD(CAST(vbak.VBELN AS STRING), 10, '0') = LPAD(SUBSTR(CAST(item_costs.transaction_id AS STRING), 2), 10, '0')
        LEFT JOIN {{ ref('int_konv') }} AS konv
            ON vbrk.KNUMV = konv.KNUMV
            AND konv.KSCHL = 'NAVS'
        LEFT JOIN material_info
            ON LPAD(CAST(vbap.MATNR AS STRING), 18, '0') = material_info.product_id
        WHERE
            material_info.client_type = 'Client B'
)
SELECT DISTINCT
    *
FROM
    transaction_data
