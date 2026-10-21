SELECT
    id AS service_detail_id,
    name_service AS service_name,
    price AS service_price,
    service_code,
    remaining_inventory,
    unit,
    servicetype_id
FROM {{ source('hotel', 'service_details') }}