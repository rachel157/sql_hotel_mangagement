select *
from {{ref('stg_bookings')}}
where date_start is not null
    and date_end is not null
    and date_start > date_end