
-- Mart: Fact Orders
-- Grain: One row per order

WITH orders AS (
    SELECT *
    FROM {{ ref('int_orders') }}
),

order_items AS (
    SELECT
        order_id,
        COUNT(*) AS total_items,
        SUM(price) AS total_product_value,
        SUM(freight_value) AS total_freight_value,
        SUM(total_item_value) AS total_order_items_value
    FROM {{ ref('int_order_items') }}
    GROUP BY order_id
),

payments AS (
    SELECT
        order_id,
        COUNT(*) AS total_payments,
        SUM(payment_value) AS total_payment_value
    FROM {{ ref('int_payments') }}
    GROUP BY order_id
),

reviews AS (
    SELECT
        order_id,
        COUNT(review_id) AS total_reviews,
        AVG(review_score) AS average_review_score
    FROM {{ ref('int_reviews') }}
    GROUP BY order_id
)

SELECT
    orders.order_id,
    orders.customer_id,
    orders.customer_unique_id,
    orders.customer_city,
    orders.customer_state,
    orders.order_status,

    orders.order_purchase_timestamp,
    orders.order_approved_at,
    orders.order_delivered_carrier_date,
    orders.order_delivered_customer_date,
    orders.order_estimated_delivery_date,

    order_items.total_items,
    order_items.total_product_value,
    order_items.total_freight_value,
    order_items.total_order_items_value,

    payments.total_payments,
    payments.total_payment_value,

    reviews.total_reviews,
    reviews.average_review_score,

    TIMESTAMP_DIFF(
        orders.order_delivered_customer_date,
        orders.order_purchase_timestamp,
        DAY
    ) AS delivery_days

FROM orders

LEFT JOIN order_items
    ON orders.order_id = order_items.order_id

LEFT JOIN payments
    ON orders.order_id = payments.order_id

LEFT JOIN reviews
    ON orders.order_id = reviews.order_id
