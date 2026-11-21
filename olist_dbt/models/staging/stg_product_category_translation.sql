
-- Staging model: Product Category Translation

WITH source AS (
    SELECT *
    FROM {{ source('olist_raw', 'product_category_name_translation') }}
),

cleaned AS (
    SELECT
        LOWER(TRIM(string_field_0))
            AS product_category_name,
        LOWER(TRIM(string_field_1))
            AS product_category_name_english
    FROM source
)

SELECT *
FROM cleaned
