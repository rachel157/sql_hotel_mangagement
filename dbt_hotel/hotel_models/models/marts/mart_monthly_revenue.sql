-- Doanh thu dich vu va doanh thu phong theo thang
with doanh_thu_phong as (
    select 
        date_trunc('month', b.date_start)::date as month,
        sum(coalesce(b.estimated_room_revenue, 0)) as monthly_total_room_revenue,
        0::numeric as monthly_total_service_revenue
    from {{ref('mart_booking_value')}} as b
    where b.date_start is not null
    group by 1
),
    doanh_thu_dv as (
        select 
            date_trunc('month', d.use_date)::date as month,
            sum(coalesce(d.estimated_service_revenue, 0)) as monthly_total_service_revenue,
            0::numeric as monthly_total_room_revenue
        from {{ref('mart_service_revenue')}} as d
        where d.use_date is not null
        group by 1
    ),
    -- ghep doanh thu phong va doanh thu dich vu theo thang
    combined as (
        select * from doanh_thu_phong
        union all --ghep 2 bang theo chieu doc
        select * from doanh_thu_dv
    )

    select
        month,
        sum(monthly_total_room_revenue) as monthly_total_room_revenue,
        sum(monthly_total_service_revenue) as monthly_total_service_revenue,
        sum(monthly_total_room_revenue + monthly_total_service_revenue) as revenue_month
    from combined
    group by 1  







