
-- Staging model: Order Reviews

WITH source AS (
    SELECT *
    FROM {{ source('olist_raw', 'olist_order_reviews_dataset') }}
),

cleaned AS (
    SELECT
        CAST(review_id AS STRING) AS review_id,
        CAST(order_id AS STRING) AS order_id,
        SAFE_CAST(review_score AS INT64) AS review_score,
        NULLIF(TRIM(review_comment_title), '') AS review_comment_title,
        NULLIF(TRIM(review_comment_message), '') AS review_comment_message,
        SAFE_CAST(review_creation_date AS TIMESTAMP)
            AS review_creation_date,
        SAFE_CAST(review_answer_timestamp AS TIMESTAMP)
            AS review_answer_timestamp
    FROM source
)

SELECT *
FROM cleaned
