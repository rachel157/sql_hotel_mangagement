select * 
from {{ref('mart_monthly_revenue')}}
where revenue_month < 0