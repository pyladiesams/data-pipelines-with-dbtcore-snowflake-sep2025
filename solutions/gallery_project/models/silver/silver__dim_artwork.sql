with artwork_inventory as (

    select
        artwork_id,
        title,
        artist_id,
        category_id,
        year_created,
        inventory_status,
        acquisition_date,
        retail_price
    from {{ ref('bronze__vw_artwork_inventory') }}

),

artwork_categories as (

    select
        category_id,
        category_name
    from {{ ref('artwork_categories') }}

),

artists as (

    select
        artist_id,
        artist_name,
        artist_tier
    from {{ ref('bronze__vw_artist_profiles') }}

),

final as (

    select
        inv.artwork_id,
        inv.title,
        inv.artist_id,
        art.artist_name,
        art.artist_tier,
        inv.category_id,
        cat.category_name,
        inv.year_created,
        inv.retail_price,
        inv.inventory_status,
        inv.acquisition_date
    
    from artwork_inventory as inv
    left join artists as art 
        on inv.artist_id = art.artist_id
    left join artwork_categories as cat 
        on inv.category_id = cat.category_id

)

select * from final