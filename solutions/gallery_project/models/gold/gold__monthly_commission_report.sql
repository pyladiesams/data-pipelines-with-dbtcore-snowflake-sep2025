with sales as (

    select * from {{ ref('silver__fact_daily_sales') }}

),

artists as (

    select * from {{ ref('silver__dim_artist') }}

),

final as (

    select
        date_trunc('month', sales.sale_date)::date as report_month,
        artists.artist_id,
        artists.artist_name,
        artists.artist_tier,
        artists.commission_rate,
        
        sum(sales.sale_price) as total_sales_amount,
        
        sum(sales.sale_price) * artists.commission_rate as total_commission_amount,
        count(distinct sales.artwork_id) as number_of_artworks_sold
    
    from sales
    left join artists
        on sales.artist_id = artists.artist_id

    group by 1, 2, 3, 4, 5

)

select * from final