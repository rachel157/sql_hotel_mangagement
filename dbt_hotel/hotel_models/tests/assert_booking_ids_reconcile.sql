
WITH source_ids AS (
    SELECT id AS booking_id
    FROM {{ source('hotel', 'bookings') }}
),

staging_ids AS (
    SELECT booking_id
    FROM {{ ref('stg_bookings') }}
),

mart_ids AS (
    SELECT booking_id
    FROM {{ ref('mart_booking_value') }}
),

source_missing_in_staging AS (
    SELECT
        'source_missing_in_staging' AS issue,
        s.booking_id
    FROM source_ids AS s
    LEFT JOIN staging_ids AS st
        ON s.booking_id = st.booking_id
    WHERE st.booking_id IS NULL
),

staging_extra_vs_source AS (
    SELECT
        'staging_extra_vs_source' AS issue,
        st.booking_id
    FROM staging_ids AS st
    LEFT JOIN source_ids AS s
        ON st.booking_id = s.booking_id
    WHERE s.booking_id IS NULL
),

staging_missing_in_mart AS (
    SELECT
        'staging_missing_in_mart' AS issue,
        st.booking_id
    FROM staging_ids AS st
    LEFT JOIN mart_ids AS m
        ON st.booking_id = m.booking_id
    WHERE m.booking_id IS NULL
),

mart_extra_vs_staging AS (
    SELECT
        'mart_extra_vs_staging' AS issue,
        m.booking_id
    FROM mart_ids AS m
    LEFT JOIN staging_ids AS st
        ON m.booking_id = st.booking_id
    WHERE st.booking_id IS NULL
)

SELECT * FROM source_missing_in_staging
UNION ALL
SELECT * FROM staging_extra_vs_source
UNION ALL
SELECT * FROM staging_missing_in_mart
UNION ALL
SELECT * FROM mart_extra_vs_staging
