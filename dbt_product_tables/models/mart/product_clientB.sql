WITH material_info AS (
    SELECT
        LPAD(CAST(mara.MATNR AS STRING), 18, '0') AS product_ids,
        mara.lvorm     AS product_status,
        mara.mtart     AS material_type,
        mara.mbrsh     AS industry_sector,
        mara.brand_id  AS brand_id,
        cast(mara.MATKL as STRING) AS product_category,
        -- Classify client type based on product category (MATKL) in MARA
        CASE
            WHEN CONCAT('abc', mara.MATKL) IN ('abc002', 'abc00207', 'abc00103') THEN 'Client A'
            WHEN CONCAT('abc', mara.MATKL) IN ('abc001', 'abc004') THEN 'Client B'
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

select DISTINCT
    material_info.product_category,
    material_info.product_status,
    material_info.material_type,
    material_info.industry_sector,
    material_info.brand_id,
    material_info.client_type,
from
    material_info
left JOIN porduct_info
on
    material_info.product_ids = porduct_info.product_id
WHERE
    material_info.client_type = 'Client B'
