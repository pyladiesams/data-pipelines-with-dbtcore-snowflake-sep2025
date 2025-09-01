select 
* 
from {{ source('gallery_data', 'sales_transactions') }}

-- Deduplication statement

qualify row_number() over (partition dbt by transaction_id order by sale_date desc) = 1