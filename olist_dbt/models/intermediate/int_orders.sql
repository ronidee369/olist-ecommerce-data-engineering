
-- Intermediate model: Orders
-- Combining orders with customer information

WITH orders AS (
    SELECT *
    FROM {{ ref('stg_orders') }}
),

customers AS (
    SELECT *
    FROM {{ ref('stg_customers') }}
),

joined AS (
    SELECT
        orders.order_id,
        orders.customer_id,
        customers.customer_unique_id,
        customers.customer_city,
        customers.customer_state,

        orders.order_status,
        orders.order_purchase_timestamp,
        orders.order_approved_at,
        orders.order_delivered_carrier_date,
        orders.order_delivered_customer_date,
        orders.order_estimated_delivery_date

    FROM orders

    LEFT JOIN customers
        ON orders.customer_id = customers.customer_id
)

SELECT *
FROM joined
