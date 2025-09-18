select 
* 
from {{ source('gallery_data', 'customer_data') }}