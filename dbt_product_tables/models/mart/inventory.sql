
WITH material_info AS (
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
),on_hand AS (
    SELECT
        LPAD(CAST(mard.MATNR AS STRING), 18, '0') AS product_id,  -- Standardizing to 18-character length with leading zeros
        mard.LABST AS on_hand_quantity
    FROM
        {{ ref('int_mard') }} AS mard
),on_order AS (
    SELECT
        LPAD(CAST(ekpo.MATNR AS STRING), 18, '0') AS product_id,  -- Standardizing to 18-character length with leading zeros
        SUM(ekpo.MENGE) AS on_order_quantity
    FROM
        {{ ref('int_ekpo') }} AS ekpo
    WHERE
        (ekpo.ELIKZ IS NULL OR ekpo.ELIKZ = '')   -- Delivery not completed
    OR (ekpo.EREKZ IS NULL OR ekpo.EREKZ = '')  -- Final invoice not posted
    OR (ekpo.LOEKZ IS NULL OR ekpo.LOEKZ = '')  -- Not marked for deletion
    OR (ekpo.WEPOS = 'X' OR ekpo.WEUNB = 'X')  -- Goods receipt expected
    GROUP BY
        LPAD(CAST(ekpo.MATNR AS STRING), 18, '0')
)SELECT
    on_hand.product_id,
    on_hand.on_hand_quantity,
    COALESCE(on_order.on_order_quantity, 0) AS on_order_quantity,
    material_info.product_category AS product_category,
    material_info.client_type AS client_type,
FROM
    on_hand
LEFT JOIN on_order ON on_hand.product_id = on_order.product_id
LEFT JOIN material_info ON on_hand.product_id = material_info.product_id
