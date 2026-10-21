SELECT
    id AS invoice_detail_id,
    invoices_id AS invoice_id,
    servicedetails_id AS service_detail_id,
    quantity,
    use_date,
    vouchers_id AS voucher_id
FROM {{ source('hotel', 'invoice_details') }}