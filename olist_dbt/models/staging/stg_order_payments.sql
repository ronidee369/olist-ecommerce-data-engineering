
-- Staging model: Order Payments

WITH source AS (
    SELECT *
    FROM {{ source('olist_raw', 'olist_order_payments_dataset') }}
),

cleaned AS (
    SELECT
        CAST(order_id AS STRING) AS order_id,
        SAFE_CAST(payment_sequential AS INT64)
            AS payment_sequential,
        LOWER(TRIM(payment_type)) AS payment_type,
        SAFE_CAST(payment_installments AS INT64)
            AS payment_installments,
        SAFE_CAST(payment_value AS NUMERIC) AS payment_value
    FROM source
)

SELECT *
FROM cleaned
