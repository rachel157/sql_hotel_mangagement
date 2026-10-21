SELECT *
FROM {{ ref('mart_booking_value') }}
WHERE estimated_room_revenue < 0