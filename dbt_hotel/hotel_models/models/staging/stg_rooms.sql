
SELECT
    id AS room_id,
    room_name,
    price AS room_price,
    roomtype_id,
    room_status
FROM {{ source('hotel', 'rooms') }}
