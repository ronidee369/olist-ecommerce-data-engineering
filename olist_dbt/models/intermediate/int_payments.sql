
-- Intermediate model: Payments
-- Combining payment information with orders

WITH payments AS (
    SELECT *
    FROM {{ ref('stg_order_payments') }}
),

orders AS (
    SELECT
        order_id,
        customer_id,
        order_status,
        order_purchase_timestamp
    FROM {{ ref('int_orders') }}
),

joined AS (
    SELECT
        payments.order_id,
        orders.customer_id,
        orders.order_status,
        orders.order_purchase_timestamp,

        payments.payment_sequential,
        payments.payment_type,
        payments.payment_installments,
        payments.payment_value

    FROM payments

    LEFT JOIN orders
        ON payments.order_id = orders.order_id
)

SELECT *
FROM joined
