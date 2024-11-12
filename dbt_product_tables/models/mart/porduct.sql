WITH material_info AS (
    SELECT
        LPAD(CAST(mara.MATNR AS STRING), 18, '0') AS product_id,
        mara.MATKL     AS product_category,
        mara.lvorm     AS product_status,
        mara.mtart     AS material_type,
        mara.mbrsh     AS industry_sector,
        mara.brand_id  AS brand_id,
        -- Classify client type based on product category (MATKL) in MARA
        CASE
            WHEN mara.MATKL IN ('11', '15', '17', '301', '801', '802', '807', '900',
                                '1502', '1503', '1506', '1508', '1510', '1511', '1703', '1710',
                                '50000000', '51000000', 'CONDIMENT', 'COOKING', 'CP10', 'CP30',
                                'DETERGENT', 'R1111', 'R1112', 'R1113', 'R1114', 'R1121', 'R1122',
                                'R1133') THEN 'Client A'
            WHEN mara.MATKL IN ('7', '12', '14', '25', '26', '50', '103', '105', '200',
                                '202', '205', '207') THEN 'Client B'
            ELSE 'Other'
        END AS client_type
    FROM
        {{ ref('int_mara') }} AS mara
),porduct_info AS (
    SELECT
        LPAD(CAST(makt.MATNR AS STRING), 18, '0') AS product_id,  -- Standardizing to 18-character length with leading zeros
        makt.MAKTX AS material_description,

    FROM
        {{ ref('int_makt') }} AS makt
)

select
    *
from
    material_info
left JOIN porduct_info
on
    material_info.product_id = porduct_info.product_id
