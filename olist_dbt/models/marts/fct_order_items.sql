
-- Mart: Fact Order Items
-- Grain: One row per order item

WITH order_items AS (
    SELECT *
    FROM {{ ref('int_order_items') }}
),

orders AS (
    SELECT
        order_id,
        customer_id,
        customer_unique_id,
        order_status,
        order_purchase_timestamp,
        order_delivered_customer_date
    FROM {{ ref('int_orders') }}
)

SELECT
    order_items.order_id,
    order_items.order_item_id,

    orders.customer_id,
    orders.customer_unique_id,

    order_items.product_id,
    order_items.seller_id,

    order_items.product_category_name,
    order_items.seller_city,
    order_items.seller_state,

    orders.order_status,
    orders.order_purchase_timestamp,
    orders.order_delivered_customer_date,

    order_items.shipping_limit_date,

    order_items.price,
    order_items.freight_value,
    order_items.total_item_value,

    order_items.product_weight_g,
    order_items.product_length_cm,
    order_items.product_height_cm,
    order_items.product_width_cm

FROM order_items

LEFT JOIN orders
    ON order_items.order_id = orders.order_id
