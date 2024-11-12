
WITH item_costs AS (
    SELECT
        VBELN AS transaction_id,
        ROUND(SUM(NETWR),2) AS total_costs
    FROM
        {{ ref('int_vbrp') }}
    GROUP BY
        transaction_id
),material_info AS (
    SELECT
        LPAD(CAST(mara.MATNR AS STRING), 18, '0') AS product_id,
        mara.MATKL AS product_category,
        -- Classify client type based on product category (MATKL) in MARA
        CASE
            WHEN MARA.MATKL IN ('11', '15', '17', '301', '801', '802', '807', '900',
                                '1502', '1503', '1506', '1508', '1510', '1511', '1703', '1710',
                                '50000000', '51000000', 'CONDIMENT', 'COOKING', 'CP10', 'CP30',
                                'DETERGENT', 'R1111', 'R1112', 'R1113', 'R1114', 'R1121', 'R1122',
                                'R1133') THEN 'Client A'
            WHEN MARA.MATKL IN ('7', '12', '14', '25', '26', '50', '103', '105', '200',
                                '202', '205', '207') THEN 'Client B'
            ELSE 'Other'
        END AS client_type
    FROM
        {{ ref('int_mara') }} AS mara
),transaction_data AS (
    SELECT
        -- Record Type based on AUART (Document Type in VBAK)
        vbak.AUART AS record_type,        -- Transaction ID from Sales Document Number in VBAK, padded to 10 digits
        LPAD(CAST(vbak.VBELN AS STRING), 10, '0') AS transaction_id,        -- Customer ID from Sold-to Party in VBAK
        CAST(vbak.KUNNR AS STRING) AS customer_id,        -- Transaction Date from Order Date in VBAK
        vbak.AUDAT AS date,        -- Product ID from Material Number in VBAP
        CAST(vbap.MATNR AS STRING) AS product_id,        -- Ordered Volume from Quantity in VBAP
        vbap.KWMENG AS volume,        -- Store ID from Plant in VBAP (if applicable)
        vbap.WERKS AS store_id,        -- Sales Gross from Billing Header in VBRK
        vbrk.NETWR AS sales_gross,        -- Costs from Net Value in VBRP
        -- vbrp.NETWR AS costs,
        COALESCE(item_costs.total_costs, 0) AS costs,        -- Delivery Costs from Freight Field in LIPS (if applicable)
        konv.KBETR AS delivery_costs,        -- Calculate Sales Net as Sales Gross minus Delivery Costs
        (vbrk.NETWR - COALESCE(konv.KBETR, 0)) AS sales_net,        -- Client's product information
        material_info.product_category AS product_category,
        material_info.client_type AS client_type,    FROM
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
)SELECT * FROM transaction_data
