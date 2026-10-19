select
    id as booking_id,
    customer_id,
    room_id,
    date_booking,
    date_start,
    date_end,
    deposits,
    employee_id,
    vouchers_id
from {{ source('hotel', 'bookings') }}