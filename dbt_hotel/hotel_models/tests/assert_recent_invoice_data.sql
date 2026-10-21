SELECT
    MAX(issue_date) AS latest_invoice_date
FROM {{ source('hotel', 'invoices') }}
HAVING MAX(issue_date) < CURRENT_DATE - INTERVAL '30 days'