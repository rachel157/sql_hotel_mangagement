SELECT *
FROM {{ ref('mart_service_revenue') }}
WHERE estimated_service_revenue < 0