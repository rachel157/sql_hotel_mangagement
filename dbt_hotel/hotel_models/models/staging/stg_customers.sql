
SELECT
    id AS customer_id,
    fullname,
    phone,
    email,
    dob,
    customer_type
FROM {{ source('hotel', 'customers') }}
