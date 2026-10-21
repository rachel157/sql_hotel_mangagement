SELECT
    d.invoice_detail_id,
    i.invoice_id,
    i.booking_id,
    d.service_detail_id,
    s.service_name,
    d.use_date,
    d.quantity,
    s.service_price,
    d.voucher_id,

    s.service_price * d.quantity
        AS estimated_service_revenue

FROM {{ ref('stg_invoice_details') }} AS d

LEFT JOIN {{ ref('stg_invoices') }} AS i
    ON d.invoice_id = i.invoice_id

LEFT JOIN {{ ref('stg_service_details') }} AS s
    ON d.service_detail_id = s.service_detail_id