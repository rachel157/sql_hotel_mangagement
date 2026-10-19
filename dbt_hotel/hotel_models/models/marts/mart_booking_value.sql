select
    b.booking_id,
    b.customer_id,
    b.room_id,
    b.date_start,
    b.date_end,
    r.room_price,
    greatest(
        0,
        date_end::date - date_start::date
    ) as number_of_nights,
    r.room_price * greatest(
        0,
        date_end::date - date_start::date
    ) as estimated_room_revenue,
    b.deposits
from {{ ref('stg_bookings') }} as b
left join {{ ref('stg_rooms') }} as r
on b.room_id = r.room_id
