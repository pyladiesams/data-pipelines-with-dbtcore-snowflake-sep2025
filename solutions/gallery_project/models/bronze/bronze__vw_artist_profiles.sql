select 
* 
from {{ source('gallery_data', 'artist_profiles') }}