
-- Staging model: Customers
-- Source: BigQuery raw Olist customers

WITH source AS (

    SELECT *
    FROM {{ source('olist_raw', 'olist_customers_dataset') }}

),

cleaned AS (

    SELECT
        CAST(customer_id AS STRING) AS customer_id,

        CAST(customer_unique_id AS STRING) AS customer_unique_id,

        LPAD(
            CAST(customer_zip_code_prefix AS STRING),
            5,
            '0'
        ) AS customer_zip_code_prefix,

        LOWER(TRIM(customer_city)) AS customer_city,

        UPPER(TRIM(customer_state)) AS customer_state

    FROM source

)

SELECT *
FROM cleaned
