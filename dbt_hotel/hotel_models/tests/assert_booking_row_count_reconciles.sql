WITH source_count AS (
    SELECT COUNT(*) AS row_count
    FROM {{ source('hotel', 'bookings') }}
),

staging_count AS (
    SELECT COUNT(*) AS row_count
    FROM {{ ref('stg_bookings') }}
),

mart_count AS (
    SELECT COUNT(*) AS row_count
    FROM {{ ref('mart_booking_value') }}
)

SELECT
    source_count.row_count AS source_rows,
    staging_count.row_count AS staging_rows,
    mart_count.row_count AS mart_rows
FROM source_count
CROSS JOIN staging_count
CROSS JOIN mart_count
WHERE source_count.row_count <> staging_count.row_count
   OR staging_count.row_count <> mart_count.row_count
