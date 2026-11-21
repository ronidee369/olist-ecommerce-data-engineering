
-- Intermediate model: Reviews
-- Combining review information with order information

WITH reviews AS (
    SELECT *
    FROM {{ ref('stg_order_reviews') }}
),

orders AS (
    SELECT
        order_id,
        customer_id,
        order_status,
        order_purchase_timestamp,
        order_delivered_customer_date
    FROM {{ ref('int_orders') }}
),

joined AS (
    SELECT
        reviews.review_id,
        reviews.order_id,
        orders.customer_id,
        orders.order_status,
        orders.order_purchase_timestamp,
        orders.order_delivered_customer_date,
        reviews.review_score,
        reviews.review_comment_title,
        reviews.review_comment_message,
        reviews.review_creation_date,
        reviews.review_answer_timestamp

    FROM reviews

    LEFT JOIN orders
        ON reviews.order_id = orders.order_id
)

SELECT *
FROM joined
