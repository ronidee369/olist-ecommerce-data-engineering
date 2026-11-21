
-- Staging model: Sellers

WITH source AS (
    SELECT *
    FROM {{ source('olist_raw', 'olist_sellers_dataset') }}
),

cleaned AS (
    SELECT
        CAST(seller_id AS STRING) AS seller_id,
        LPAD(
            CAST(seller_zip_code_prefix AS STRING),
            5,
            '0'
        ) AS seller_zip_code_prefix,
        LOWER(TRIM(seller_city)) AS seller_city,
        UPPER(TRIM(seller_state)) AS seller_state
    FROM source
)

SELECT *
FROM cleaned
