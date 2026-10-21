SELECT
    id AS invoice_id,
    booking_id,
    issue_date,
    employee_id,
    payment_id
FROM {{ source('hotel', 'invoices') }}