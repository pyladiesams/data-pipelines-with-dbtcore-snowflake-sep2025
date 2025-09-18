-- Accepted payment menthods in sales_transactions

with all_values as (

    select
        payment_method as value_field,
        count(*) as n_records

    from DEV_BRONZE.CRM_DATA_{{YOUR USERNAME}}.vw_sales_transactions
    group by payment_method

)

select *
from all_values
where value_field not in (
    'Cash','Credit Card','Debit Card','Wire Transfer'
);

-- Unique transaction_id

select
    transaction_id as unique_field,
    count(*) as n_records

from DEV_BRONZE.CRM_DATA_{{YOUR USERNAME}}.vw_sales_transactions
where transaction_id is not null
group by transaction_id
having count(*) > 1;

--  Accepted values for artist tiers

with all_values as (

    select
        artist_tier as value_field,
        count(*) as n_records

    from DEV_BRONZE.CRM_DATA_{{YOUR USERNAME}}.vw_artist_profiles
    group by artist_tier

)

select *
from all_values
where value_field not in (
    'Emerging','Mid-Career','Established','Guest'
);


-- ====================================

-- Which artists had a duplicated transaction?

select
    transaction_id as unique_field,
    artist_id,
    count(*) as n_records

from DEV_SILVER.FACTS_{{YOUR USERNAME}}.FACT_DAILY_SALES
where transaction_id is not null
group by transaction_id, artist_id
having count(*) > 1;