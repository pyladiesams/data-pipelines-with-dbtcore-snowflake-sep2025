select 
* 
from {{ source('gallery_data', 'artwork_inventory') }}