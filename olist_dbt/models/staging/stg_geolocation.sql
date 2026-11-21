
-- Staging model: Geolocation

WITH source AS (
    SELECT *
    FROM {{ source('olist_raw', 'olist_geolocation_dataset') }}
),

cleaned AS (
    SELECT
        SAFE_CAST(geolocation_zip_code_prefix AS STRING)
            AS geolocation_zip_code_prefix,
        SAFE_CAST(geolocation_lat AS FLOAT64)
            AS geolocation_lat,
        SAFE_CAST(geolocation_lng AS FLOAT64)
            AS geolocation_lng,
        LOWER(TRIM(geolocation_city))
            AS geolocation_city,
        UPPER(TRIM(geolocation_state))
            AS geolocation_state
    FROM source
)

SELECT *
FROM cleaned
